<cfcomponent displayname="subject" output="false" extends="Base">
    
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get subjects" >
        
        
        <cftry>
            <cfset local.stSubjectData = StructNew() />
            <cfset init() />
            
            <cfquery name="getSubjects" datasource="#this.sDatasourceName#">
                SELECT subjectId, subjectName, description
                FROM Subject
            </cfquery>

            <cfset local.stSubjectData = QueryToStruct(getSubjects) />
    
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
                
        <cfreturn local.stSubjectData />
    </cffunction>
            
    <!---
    <cffunction name="create" access="remote" output="true"  hint="I am a function that create subject" >
        
        <cftry>
            <cfset local.stSubjectData = CheckJsonBody( getHttpRequestData().content ).stSubject />
            <cfset init() />
            
            <cfquery name="insertSubject" datasource="#this.sDatasourceName#">
                INSERT INTO Subject
                (subjectName, description)
                values
                (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stSubjectData.subjectName#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stSubjectData.description#" />)
            </cfquery>
                      
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stSubjectData />
    </cffunction>
    
    <cffunction name="update" access="remote" output="false"  hint="I am a function that update subject" >
        
        <cftry>
            <cfset local.stSubjectData = CheckJsonBody( getHttpRequestData().content ).stSubject />
            <cfset init() />
            
            <cfquery name="updateSubject" datasource="#this.sDatasourceName#">
                UPDATE Subject
                SET subjectName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stSubjectData.subjectName#" />,
                    description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stSubjectData.description#" />
                WHERE subjectId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stSubjectData.subjectId#" />
            </cfquery>
              
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stSubjectData />
    </cffunction>
        
    <cffunction name="delete" access="remote" output="false"  hint="I am a function that delete/archive subject" >
        
        <cftry>
            <cfset local.stSubjectData = CheckJsonBody( getHttpRequestData().content ).stSubject />
            <cfset init() />
            
            <cfquery name="deleteSubject" datasource="#this.sDatasourceName#">
                DELETE FROM Subject
                WHERE subjectId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stSubjectData.subjectId#" />
            </cfquery>
                 
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stSubjectData />
    </cffunction>--->
       
</cfcomponent>