<cfcomponent displayname="location" output="false" extends="Base">
    
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get locations" >
        
        <cftry>
            <cfset local.stLocationData = StructNew() />
            <cfset init() />
            
            <cfquery name="getLocations" datasource="#this.sDatasourceName#">
                SELECT l.locationId, l.location, l.address1, l.address2, l.city, l.stateId, l.zipcode, 
                CONCAT(CONCAT(l.address1,", ",l.city, " ", s.state)) as fullAddress,
                CONCAT(CONCAT("(", SUBSTRING(l.phone1,1,3), ") "), SUBSTRING(l.phone1,4,3), CONCAT("-", SUBSTRING(l.phone1,7,4))) as formattedPhone,
                l.countryId, l.email1, l.phone1, l.phone2, l.website  
                FROM Location l INNER JOIN State s ON l.stateId = s.stateId
            </cfquery>
   
            <cfset local.stLocationData = QueryToStruct(getLocations) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stLocationData />
    </cffunction>
    
    <cffunction name="create" access="remote" output="false"  hint="I am a function that create locations" >
        
        <cftry>
            <cfset local.stLocationData = CheckJsonBody( getHttpRequestData().content ).stLocation />
            <cfset init() />
            
            <cfquery name="insertLocation" datasource="#this.sDatasourceName#">
                INSERT INTO Location
                (location, address1, address2, city, stateId, countryId, zipcode, email1, phone1, website)
                values
                (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.location#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.address1#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.address2#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.city#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stLocationData.stateId#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stLocationData.countryId#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.zipcode#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.email1#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.phone1#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.website#" />)
            </cfquery>
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
            
        <cfreturn local.stLocationData />
    </cffunction>
    
    <cffunction name="update" access="remote" output="false"  hint="I am a function that update location" >
        
        <cftry>
            <cfset local.stLocationData = CheckJsonBody( getHttpRequestData().content ).stLocation />
            <cfset init() />
            
            <cfquery name="updateLocation" datasource="#this.sDatasourceName#">
                UPDATE Location
                SET location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.location#" />,
                    address1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.address1#" />,
                    address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.address2#" />,
                    stateId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stLocationData.stateId#" />,
                    countryId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stLocationData.countryId#" />,
                    city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.city#" />,
                    zipcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.zipcode#" />,
                    email1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.email1#" />,
                    phone1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.phone1#" />,
                    website = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.website#" />
                WHERE locationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stLocationData.locationId#" />
            </cfquery>
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
            
        <cfreturn local.stLocationData />
    </cffunction>
        
    <cffunction name="delete" access="remote" output="false"  hint="I am a function that delete/archive location" >
        
        <cftry>
            <cfset local.stLocationData = CheckJsonBody( getHttpRequestData().content ).stLocation />
            <cfset init() />
            
            <cfquery name="deleteLocation" datasource="#this.sDatasourceName#">
                DELETE Location
                WHERE locationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stLocationData.locationId#" />
            </cfquery>
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
            
        <cfreturn local.stLocationData />
    </cffunction>
       
</cfcomponent>