
<cfcomponent displayname="loginUser" output="false" extends="Base" >

<cffunction name="ValidateLogin" access="remote" output="false" returnformat="JSON"  hint="I am a CFC that validates user against predefined list and ldap" >

       <cfset local.requestBody = toString( getHttpRequestData().content ) />
		<cfif isJSON( local.requestBody )>

			    <cfset local.userStruct = DeserializeJSON(local.requestBody)>

				<!---Defining the structure for holding the return data--->
				<cfset local.UserData = Structnew()/>


				<!---Calling the function for initilization--->
				<cfset init()/>


				    <!---Calling the function for LDAP--->
				    <cfobject name="NTSecurity" component="NTSecurityV5">
					<cfinvoke component="#NTSecurity#" method="ldapLookup" returnvariable="local.getUsers"
							SessionTimeout="1000"
							DataSourceSharedData="SharedData"
							ClientName="#local.userStruct.username#"
							ClientPassword="#local.userStruct.password#"
							<!---ClientName="rrajan"
							ClientPassword="Zzva!tb9"
							clientName     = "LDAPReader-is"
                            ClientPassword = "Tuesday" --->
							ClientDomainName="#this.sDomainName#">


				    <!--- if records exists then allow to login --->
				   	<cfif local.getUsers.recordcount>

					   		<CFQUERY NAME="local.GetUserdata" datasource="#this.SSHAREDDATASOURCENAME#">
							 select * from [dbo].[TBL_Exception_User]
								where [User_name] = <cfqueryparam
				                value="#local.getUsers.GIVENNAME#"
				                cfsqltype="cf_sql_varchar"
								null=	"#Len( local.getUsers.GIVENNAME ) eq 0#"	>
							</CFQUERY>


					<cfif (local.getUsers.extensionAttribute5 NEQ '')  or (local.GetUserdata.recordcount) >

	                 	    <!---Setting the can login flag--->
							<cfset local.UserData.Applicant_ID = 0>
							<!---<cfset local.UserData.employeenumber= local.getUsers.extensionAttribute5>--->
							<cfset local.UserData.employeenumber= 100>
						 	<cfset local.UserData.firstname = local.getUsers.givenname>
						 	<cfset local.UserData.MiddleInitial = local.getUsers.initials>
						 	<cfset local.UserData.lastname = local.getUsers.sn>
						 	<cfset local.UserData.username = local.userStruct.username >
							<cfset local.UserData.TITLE = local.getUsers.TITLE >
							<cfset local.UserData.WorkEmail = local.getUsers.mail>
							<cfset local.UserData.WorkTelephoneA1 = LEFT(local.getUsers.telephonenumber,3)>
							<cfset local.UserData.WorkTelephoneB1 = Mid(local.getUsers.telephonenumber,5,3)>
							<cfset local.UserData.WorkTelephoneC1 = Right(local.getUsers.telephonenumber,4)>
							<cfset local.UserData.bCanLogin = 1/>
          					<cfset local.Records = CheckRecord(local.UserData.employeenumber)/>

							<cfif local.Records eq 0 >
							  <cfset local.UserData.showEntry = 1/>
								  <cfset local.UserData.YEARSPRESENT.YEARSPRESENTNAME = 0 />
								  <cfset local.UserData.YEARSPRESENT.YEARSPRESENTID = 0 />
								  <cfset local.UserData.years.yearsName = 0 />
	    						  <cfset local.UserData.years.yearsId = 0 />
								  <cfset local.UserData.SelectedSchool.SCHOOLROW = 1/>
								  <cfset local.UserData.SelectedSchool1.SCHOOLROW = 1/>
								  <cfset local.UserData.SelectedSchool2.SCHOOLROW = 1/>
					    <cfelse>
							  <cfset local.UserData.showEntry = 0/>
								  <cfset local.UserData = getRecords(local.UserData)/>
						</cfif>

					<cfelse>
						    <!---Setting the can login flag--->
						   <cfset local.UserData.bCanLogin = 0/>

					</cfif>
					</cfif>


				<!---Setting the return data--->
				<cfset returnData = SerializeJSON(local.UserData)/>
				<cfcontent type="application/json; charset=utf-8">
			    <cfset	WriteOutput( returnData ) />
				<cfabort/>

		</cfif>


</cffunction>


<cffunction name="CheckRecord" access="private" output="false" hint="I will check the person already has a record in out system" >
<cfargument name="employeenumber"  required="true">


		<!---Calling the function for initilization--->
				<cfset init()/>

<cfquery name="getProjectCount" datasource="#this.SSHAREDDATASOURCENAME#">
	select count(*) as records from [dbo].[TBL_APPLICANT]
	where [EmployeeNumber] = #arguments.employeenumber#
</cfquery>


<cfreturn getProjectCount.records/>

</cffunction>



<cffunction name="getRecords" access="private" output="false" hint="I will retrieve records for the user" >
<cfargument name="UserData"  required="true">


		<!---Calling the function for initilization--->
				<cfset init()/>

<cfquery name="getUserDetails" datasource="#this.SSHAREDDATASOURCENAME#">
	select top 1 *  from [dbo].[TBL_APPLICANT]
	where [EmployeeNumber] = #arguments.UserData.employeenumber#
</cfquery>

<cfset arguments.UserData.Userid = getUserDetails.EmpID />
<cfset arguments.UserData.firstname = getUserDetails.TeacherName />
<cfset arguments.UserData.LastName = getUserDetails.LastName />
<cfset arguments.UserData.MiddleInitial = getUserDetails.MiddleInitial />
<cfset arguments.UserData.WorkEMail = getUserDetails.WorkEMail />
<cfset arguments.UserData.teachAtSchools = getUserDetails.teachAtSchools />
<cfset arguments.UserData.School1 = getUserDetails.School1 />

<cfquery name="local.getSchool" datasource="#this.SSHAREDDATASOURCENAME#">
					SELECT schoolname
					FROM qry_school
					where schoolid = '#getUserDetails.School1#'
					ORDER BY SchoolName
				</cfquery>
<cfset arguments.UserData.SelectedSchool.SCHOOLNAME = local.getSchool.schoolname/>



<cfquery name="local.getSchoolInfo" datasource="#this.SSHAREDDATASOURCENAME#" >
		select [schoolID] from [dbo].[qry_school]
		order by schoolID asc
	</cfquery>

	<cfloop query="#local.getSchoolInfo#">
		<cfif local.getSchoolInfo.schoolID eq getUserDetails.School1>
			<cfset arguments.UserData.SelectedSchool.SCHOOLROW = local.getSchoolInfo.currentRow/>
		</cfif>
	</cfloop>


<cfset arguments.UserData.School2 = getUserDetails.School2 />

<cfquery name="local.getSchool1" datasource="#this.SSHAREDDATASOURCENAME#">
					SELECT schoolname
					FROM qry_school
					where schoolid = '#getUserDetails.School2#'
					ORDER BY SchoolName
				</cfquery>
<cfset arguments.UserData.SelectedSchool1.SCHOOLNAME = local.getSchool1.schoolname/>


<cfloop query="#local.getSchoolInfo#">
		<cfif local.getSchoolInfo.schoolID eq getUserDetails.School2>
			<cfset arguments.UserData.SelectedSchool1.SCHOOLROW = local.getSchoolInfo.currentRow/>
		</cfif>
	</cfloop>

<cfset arguments.UserData.School3 = getUserDetails.School3 />

<cfquery name="local.getSchool2" datasource="#this.SSHAREDDATASOURCENAME#">
					SELECT schoolname
					FROM qry_school
					where schoolid = '#getUserDetails.School3#'
					ORDER BY SchoolName
				</cfquery>
<cfset arguments.UserData.SelectedSchool2.SCHOOLNAME = local.getSchool2.schoolname/>

<cfloop query="#local.getSchoolInfo#">
		<cfif local.getSchoolInfo.schoolID eq getUserDetails.School3>
			<cfset arguments.UserData.SelectedSchool2.SCHOOLROW = local.getSchoolInfo.currentRow/>
		</cfif>
	</cfloop>



<cfset arguments.UserData.Assignment1 = getUserDetails.curriculum1 />
<cfset arguments.UserData.Assignment2 = getUserDetails.curriculum2 />
<cfset arguments.UserData.Assignment3 = getUserDetails.curriculum3 />
<cfset arguments.UserData.yearsPresent1 = getUserDetails.YearsPresentAssignment />
 <cfif arguments.UserData.yearsPresent1 eq 21>
 	   <cfset arguments.UserData.YEARSPRESENT.YEARSPRESENTNAME = '20 +' />
		<cfset arguments.UserData.YEARSPRESENT.YEARSPRESENTID = 21 />
 <cfelse>
 	  <cfset arguments.UserData.YEARSPRESENT.YEARSPRESENTNAME = arguments.UserData.yearsPresent1 />
	   <cfset arguments.UserData.YEARSPRESENT.YEARSPRESENTID = arguments.UserData.yearsPresent1 />
 </cfif>
<cfset arguments.UserData.Years1 = getUserDetails.YearsTotal />

 <cfif arguments.UserData.Years1 eq 21>
 	   <cfset arguments.UserData.years.yearsName = '20 +' />
	   <cfset arguments.UserData.years.yearsId = 21/>
 <cfelse>
 	  <cfset arguments.UserData.years.yearsName = arguments.UserData.Years1 />
	    <cfset arguments.UserData.years.yearsId = arguments.UserData.Years1 />
 </cfif>

<cfset arguments.UserData.CurrDevExp = getUserDetails.CurrDevExp />
<cfset arguments.UserData.CourseTought = getUserDetails.CourseTought />
<cfset arguments.UserData.SkillsEXP = getUserDetails.SpecialSkillExp />

<cfreturn arguments.UserData/>

</cffunction>

</cfcomponent>
