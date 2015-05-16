<cfcomponent displayname="grade" output="false" extends="Base">
    
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get grades" >
        
        
        <cftry>
            <cfset local.stGradeData = StructNew() />
            <cfset init() />
            
            <cfquery name="getGrades" datasource="#this.sDatasourceName#">
                SELECT gradeId, gradeName, description
                FROM Grade
            </cfquery>

            <cfset local.stGradeData = QueryToStruct(getGrades) />
    
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
                
        <cfreturn local.stGradeData />
    </cffunction>
</cfcomponent>