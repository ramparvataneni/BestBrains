<cfcomponent displayname="country" output="false" extends="Base">
    
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get countries" >
        
        <cftry>
            <cfset init() />
            
            <cfquery name="getCountries" datasource="#this.sDatasourceName#">
                SELECT countryId, countryCode, country  
                FROM Country
            </cfquery>
   
            <cfset local.stCountryData = QueryToStruct(getCountries) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stCountryData />
    </cffunction>

</cfcomponent>