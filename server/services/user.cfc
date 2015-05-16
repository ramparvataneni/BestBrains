<cfcomponent displayname="loginUser" output="false" extends="Base">
    
    <cffunction name="ValidateLogin" access="remote" output="false" returnformat="json" hint="I am a CFC that validates user against the database" >
        
        <cftry>
            <cfset local.stUser = CheckJsonBody( getHttpRequestData().content ) />

            <cfset local.stUserData = StructNew() />
            <cfset init() />

            <cfquery name="validateUser" datasource="#this.sDatasourceName#">
                SELECT u.userId, u.firstName, u.lastName, u.userName, u.email, u.phone, u.cellphone, u.locationId, l.location, s.stateId
                FROM users u INNER JOIN Location l ON u.locationId = l.locationId
                INNER JOIN State s ON s.stateId = l.stateId
                WHERE u.userName = <cfqueryparam value="#local.stUser.username#" cfsqltype="cf_sql_varchar" />
                AND u.password = <cfqueryparam value="#local.stUser.password#" cfsqltype="cf_sql_varchar" />  
            </cfquery>

            <cfif validateUser.recordCount gt 0>
                <cfset local.stUserData.authentication = 'pass' />
                <cfset local.stUserData.firstName = validateUser.firstName />
                <cfset local.stUserData.lastName = validateUser.lastName />
                <cfset local.stUserData.userName = validateUser.userName />
                <cfset local.stUserData.userId = validateUser.userId />
                <cfset local.stUserData.stateId = validateUser.stateId />
                <cfset local.stUserData.locationId = validateUser.locationId />
                <cfset local.stUserData.location = validateUser.location />
                <cfset local.stUserData.email = validateUser.email />
                
                <cfquery name="getUserRole" datasource="#this.sDatasourceName#">
                    SELECT r.roleId, r.roleName 
                    FROM role r INNER JOIN users u on r.roleId = u.roleId
                    WHERE u.userId = <cfqueryparam value="#validateUser.userId#" cfsqltype="cf_sql_integer" />  
                </cfquery>
                
                <cfif getUserRole.recordCount gt 0>
                    <cfset local.stUserData.roleId = getUserRole.roleId />
                    <cfset local.stUserData.roleName = getUserRole.roleName />
                    
                    <cfset local.stUserData.isSystemAdmin = false />
                    <cfset local.stUserData.isLocationAdmin = false />
                    <cfset local.stUserData.isUserAdmin = false />
                    <cfset local.stUserData.isTeacherAdmin = false />
                    <cfset local.stUserData.isClassAdmin = false />
                    <cfset local.stUserData.isStudentAdmin = false />
                    <cfset local.stUserData.isPacketAdmin = false />
                    <cfset local.stUserData.isInventoryAdmin = false />
                    <cfset local.stUserData.allLocations = false />
                    <cfset local.stUserData.isKeyAdmin = false />
                    <cfset local.stUserData.isKeyReadOnly = false />
                    
                    <cfif getUserRole.roleName eq 'System Admin' OR getUserRole.roleName eq 'Super User'>
                        <cfset local.stUserData.isSystemAdmin = true />
                        <cfset local.stUserData.isLocationAdmin = true />
                        <cfset local.stUserData.isUserAdmin = true />
                        <cfset local.stUserData.isTeacherAdmin = true />
                        <cfset local.stUserData.isClassAdmin = true />
                        <cfset local.stUserData.isStudentAdmin = true />
                        <cfset local.stUserData.isPacketAdmin = true />
                        <cfset local.stUserData.isInventoryAdmin = true />
                        <cfset local.stUserData.allLocations = true />
                        <cfset local.stUserData.isKeyAdmin = true />
                        <cfset local.stUserData.isKeyReadOnly = true />
                    <cfelseif getUserRole.roleName eq "Key Admin">
                        <cfset local.stUserData.isKeyAdmin = true />
                        <cfset local.stUserData.isKeyReadOnly = true />
                    <cfelseif getUserRole.roleName eq "Key Reader">
                        <cfset local.stUserData.isKeyReadOnly = true />
                    <cfelseif getUserRole.roleName eq "Location Admin">
                        <cfset local.stUserData.isLocationAdmin = true />
                        <cfset local.stUserData.isUserAdmin = true />
                        <cfset local.stUserData.isTeacherAdmin = true />
                        <cfset local.stUserData.isClassAdmin = true />
                        <cfset local.stUserData.isStudentAdmin = true />
                        <cfset local.stUserData.isInventoryAdmin = true />
                    <cfelseif getUserRole.roleName eq "Location Manager">
                        <cfset local.stUserData.isTeacherAdmin = true />
                        <cfset local.stUserData.isClassAdmin = true />
                        <cfset local.stUserData.isStudentAdmin = true />
                    <cfelseif getUserRole.roleName eq "Teacher">
                        <cfset local.stUserData.isClassAdmin = true />
                        <cfset local.stUserData.isStudentAdmin = false />
                    </cfif>
                        
                <cfelse>
                    <cfset local.stUserData.authentication = 'User does not have priviliges assigned' />
                </cfif>
            
            <cfelse>
                <cfset local.stUserData.authentication = 'failed authentication' />
            </cfif>
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfset local.stUserData.authentication = 'failed' />    
            </cfcatch>
        </cftry>
            
        <cfreturn local.stUserData />

    </cffunction>
                        
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get users" >
        
        
        <cftry>
            <cfset local.stUserData = StructNew() />
            <cfset init() />
            
            <cfquery name="getUsers" datasource="#this.sDatasourceName#">
                SELECT u.*, l.locationId, l.location, r.roleId, r.roleName, CONCAT(u.firstName, " ", u.lastName) as fullName,
                CONCAT(CONCAT("(", SUBSTRING(u.phone,1,3), ") "), SUBSTRING(u.phone,4,3), CONCAT("-", SUBSTRING(u.phone,7,4))) as formattedPhone
                FROM Users u INNER JOIN Location l ON u.locationId = l.locationId
                INNER JOIN Role r ON u.roleId = r.roleId
            </cfquery>

            <cfset local.stUserData = QueryToStruct(getUsers) />
    
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
                
        <cfreturn local.stUserData />
    </cffunction>
            
    <cffunction name="create" access="remote" output="true" returnformat="json" hint="I am a function that create user" >
        
        <cftry>
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUser />
            <cfset init() />
            
            <cfquery name="insertUser" datasource="#this.sDatasourceName#">
                INSERT INTO Users
                (locationId, roleId, firstName, lastName, userName, password, email, phone, cellphone)
                values
                (<cfqueryparam cfsqltype="cf_sql_integer" value="#local.stUserData.locationId#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stUserData.roleId#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stUserData.firstName#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stUserData.lastName#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stUserData.userName#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stUserData.password#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stUserData.email#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stUserData.phone#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stUserData.cellphone#" />)
            </cfquery>
            
            <cfset local.stUserData = read() />
                      
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stUserData />
    </cffunction>
    
    <cffunction name="update" access="remote" output="false" returnformat="json" hint="I am a function that update user" >
        
        <cftry>
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUser />
            <cfset init() />
            
            <cfquery name="updateUser" datasource="#this.sDatasourceName#">
                UPDATE Users
                SET locationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stUserData.locationId#" />,
                    firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stUserData.firstName#" />,
                    lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stUserData.lastName#" />,
                    userName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stUserData.userName#" />,
                    password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stUserData.password#" />,
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stUserData.email#" />,
                    roleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stUserData.roleId#" />,
                    phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stUserData.phone#" />,
                    cellPhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stUserData.cellPhone#" />
                WHERE userId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stUserData.userId#" />
            </cfquery>
            
            <cfset local.stUserData = read() />
              
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stUserData />
    </cffunction>
        
    <cffunction name="delete" access="remote" output="false" returnformat="json" hint="I am a function that delete/archive class" >
        
        <cftry>
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUser />
            <cfset init() />
            
            <cfquery name="deleteUser" datasource="#this.sDatasourceName#">
                DELETE FROM users
                WHERE userId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stUserData.userId#" />
            </cfquery>
            
            <cfset local.stUserData = read() />
                 
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stUserData />
    </cffunction>
    
    
    
</cfcomponent>