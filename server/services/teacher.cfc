<cfcomponent displayname="teacher" output="false" extends="Base">
    
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get teachers" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset local.stTeacherData = StructNew() />
            <cfset init() />
            
            <cfquery name="getTeachers" datasource="#this.sDatasourceName#">
                SELECT t.teacherId, t.firstName, t.lastName, CONCAT(t.firstname, " ", t.lastname) as FullName, 
                t.address1, t.address2, t.city, t.stateId, t.zipcode, t.email, t.phone,
                CONCAT(CONCAT("(", SUBSTRING(t.phone,1,3), ") "), SUBSTRING(t.phone,4,3), CONCAT("-", SUBSTRING(t.phone,7,4))) as formattedPhone,
                l.locationID, l.location
                FROM teacher t INNER JOIN location l ON t.locationId = l.locationId
                WHERE 1 = 1
                <cfif local.stData.stUserData.locationId neq "" and local.stData.stUserData.locationId neq 0 and not local.stData.stUserData.allLocations>
                    AND t.locationId = <cfqueryparam value="#local.stData.stUserData.locationId#" cfsqltype="cf_sql_integer" />
                </cfif>
            </cfquery>
            
            <cfset local.stTeacherData = QueryToStruct(getTeachers) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stTeacherData />
    </cffunction>
    
    <cffunction name="create" access="remote" output="false"  returnformat="json" hint="I am a function that create teachers" >
        
        <cftry>
            <cfset local.stTeacherData = CheckJsonBody( getHttpRequestData().content ).stTeacher />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            <cfset init() />
            
            <cfquery name="insertTeacher" datasource="#this.sDatasourceName#">
                INSERT INTO Teacher
                (firstName, lastName, address1, address2, city, stateId, zipcode, email, phone, locationId)
                values
                (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.firstName#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.lastName#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.address1#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.address2#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.city#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stTeacherData.stateId#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.zipcode#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.email#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.phone#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stTeacherData.locationId#" />)
            </cfquery>
            
            <cfset local.stTeacherData =  read(local.stUserData) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
            
        <cfreturn local.stTeacherData />
    </cffunction>
    
    <cffunction name="update" access="remote" output="false" returnformat="json" hint="I am a function that update teachers" >
        
        <cftry>
            <cfset local.stTeacherData = CheckJsonBody( getHttpRequestData().content ).stTeacher />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            <cfset init() />
            
            <cfquery name="updateTeacher" datasource="#this.sDatasourceName#">
                UPDATE Teacher
                SET locationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stTeacherData.locationId#" />,
                    firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.firstName#" />,
                    lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.lastName#" />,
                    address1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.address1#" />,
                    address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.address2#" />,
                    stateId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stTeacherData.stateId#" />,
                    city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.city#" />,
                    zipcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.zipcode#" />,
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.email#" />,
                    phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stTeacherData.phone#" />
                WHERE teacherId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stTeacherData.teacherId#" />
            </cfquery>
            
            <cfset local.stTeacherData =  read(local.stUserData) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
            
        <cfreturn local.stTeacherData />
    </cffunction>
        
    <cffunction name="delete" access="remote" output="false" returnformat="json" hint="I am a function that delete/archive teacher" >
        
        <cftry>
            <cfset local.stTeacherData = CheckJsonBody( getHttpRequestData().content ).stTeacher />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            <cfset init() />
            
            <cfquery name="deleteTeacher" datasource="#this.sDatasourceName#">
                DELETE Teacher
                WHERE teacherId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stTeacherData.teacherId#" />
            </cfquery>
            
            <cfset local.stTeacherData =  read(local.stUserData) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
            
        <cfreturn local.stTeacherData />
    </cffunction>
       
</cfcomponent>