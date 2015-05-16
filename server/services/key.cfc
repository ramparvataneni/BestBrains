<cfcomponent displayname="key" output="false" extends="Base">
    
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get keys" >
        
        <cftry>
            <cfset local.stKeyData = StructNew() />
            <cfset init() />
            
            <cfquery name="getKeys" datasource="#this.sDatasourceName#">
                SELECT k.keyId, k.questions, k.answer, k.explanation, d.dayId, d.day,
                p.packetId, p.packetName, l.levelId, l.levelName, s.subjectId, s.subjectName
                FROM Key k INNERJOIN DayPacket d ON k.dayId = d.dayId
                INNER JOIN WeekPacket p ON p.packetId = d.packetId
                INNER JOIN SubjectLevel l ON l.levelId = p.levelId
                INNER JOIN Subject s ON s.subjectId = l.subjectId 
            </cfquery>
   
            <cfset local.stKeyData = QueryToStruct(getKeys) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stKeyData />
    </cffunction>
    
    <cffunction name="create" access="remote" output="false"  hint="I am a function that create locations" >
        
        <cftry>
            <cfset local.stLocationData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset init() />
            
            <cfquery name="insertLocation" datasource="#this.sDatasourceName#">
                INSERT INTO Location
                (location, address1, address2, city, stateId, countryId, zipcode, email1, phone1, phone2, website)
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
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.phone2#" />,
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
            <cfset local.stLocationData = CheckJsonBody( getHttpRequestData().content ) />
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
                    email2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLocationData.email2#" />,
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
            <cfset local.stLocationData = CheckJsonBody( getHttpRequestData().content ) />
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