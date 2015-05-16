<cfcomponent displayname="state" output="false" extends="Base">
    
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get states" >
        
        <cftry>
            <cfset init() />
            
            <cfquery name="getStates" datasource="#this.sDatasourceName#">
                SELECT stateId, state, stateName  
                FROM State
            </cfquery>
   
            <cfset local.stStateData = QueryToStruct(getStates) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stStateData />
    </cffunction>

</cfcomponent>