<cfcomponent displayname="inventory" output="false" extends="Base">
    
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get inventory" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset local.stRequestData = StructNew() />
            <cfset local.stInventoryRequests = StructNew() />
            <cfset init() />
            
            <cfquery name="getInventory"  datasource="#this.sDatasourceName#">
                SELECT max(ir.inventoryRequestId) as inventoryRequestId
                FROM InventoryRequest ir
                WHERE ir.createddate = (SELECT MAX(createddate)
                FROM InventoryRequest ir2
                WHERE ir2.locationId = ir.locationId 
                AND ir2.locationId = <cfqueryparam value="#local.stData.stUserData.locationId#" cfsqltype="cf_sql_integer" />)
            </cfquery>
            
            <cfset local.stRequestData.stInventoryRequest = QueryToStruct(getInventory) />
            
            <cfquery name="getInventoryRequest" datasource="#this.sDatasourceName#">
                SELECT p.packetId, s.subjectName, l.levelName, CONCAT(l.levelName, " ", p.packetName) AS Packet, 
                p.packetName, COALESCE(i.numOfPackets,0) as existingQuantity, COALESCE(r.quantity,0) AS requestedQuantity
                FROM WeekPacket p INNER JOIN SubjectLevel l ON p.levelId = l.levelId
                INNER JOIN Subject s ON l.subjectId = s.subjectId
                LEFT JOIN Inventory i ON i.packetId = p.packetId  
                AND i.locationId = <cfqueryparam value="#local.stData.stUserData.locationId#" cfsqltype="cf_sql_integer" />
                LEFT JOIN requestdetails r ON r.packetId = p.packetId 
                AND r.inventoryRequestId = (SELECT max(ir.inventoryRequestId) FROM inventoryRequest ir 
                WHERE ir.createddate = (SELECT MAX(createddate)
                FROM InventoryRequest ir2
                WHERE ir2.locationId = ir.locationId 
                AND ir2.locationId = <cfqueryparam value="#local.stData.stUserData.locationId#" cfsqltype="cf_sql_integer" />))
                ORDER BY  s.subjectId, l.levelId, p.packetId
            </cfquery>
            
            <cfset local.stRequestData.stInventoryData = QueryToStruct(getInventoryRequest) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stRequestData />
    </cffunction>
            
    <cffunction name="generate" access="remote" output="false" returnformat="json" hint="I am a function that generates inventory request" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset local.stRequestData = StructNew() />
            <cfset init() />
            
            <!---
            <cfquery name="getInventory" datasource="#this.sDatasourceName#">
                SELECT p.packetId, s.subjectName, l.levelName, CONCAT(l.levelName, " ", p.packetName) as Packet, 
                0 as numOfPackets 
                FROM WeekPacket p inner join SubjectLevel l on p.levelId = l.levelId
                inner join subject s on l.subjectId = s.subjectId
                WHERE 1 = 1 order by s.subjectId, l.levelId, p.packetId
            </cfquery>
            
            <cfset local.stInventoryData = getInventory />
            --->
            
            <!---<cfset local.periodInWeeks = DateDiff("ww",local.stData.stRequestData.fromDate, local.stData.stRequestData.toDate)+1 />--->
            <cfset local.periodInWeeks = 8 />
            
            <cfset requestQuery = queryNew("Subject, Level, Packet, Booklet, Quantity", "varchar, varchar, varchar, varchar, integer") />
            
            <!--- get active students --->
            <cfquery name="getStudents" datasource="#this.sDatasourceName#">
                SELECT s.studentId,
                case when s.math = 0 then 'false' else 'true' end as math,
                case when s.english = 0 then 'false' else 'true' end as english,
                case when s.abacus = 0 then 'false' else 'true' end as abacus,
                case when s.gk = 0 then 'false' else 'true' end as gk,
                s.mathPacketId, p1.packetName as mathPacket, s.englishPacketId, p2.packetName as englishPacket,
                s.abacusPacketId, p3.packetName as abacusPacket, s.gkPacketId, p4.packetName as gkPacket,
                p1.levelId as mathLevelId, p2.levelId as englishLevelId, p3.LevelId as abacusLevelId, p4.levelId as gkLevelId
                FROM student s LEFT JOIN WeekPacket p1 ON p1.packetId = s.mathPacketId
                LEFT JOIN SubjectLevel l1 ON l1.levelId = p1.levelId
                LEFT JOIN WeekPacket p2 ON p2.packetId = s.englishPacketId
                LEFT JOIN SubjectLevel l2 ON l2.levelId = p2.levelId
                LEFT JOIN WeekPacket p3 ON p3.packetId = s.abacusPacketId
                LEFT JOIN SubjectLevel l3 ON l3.levelId = p3.levelId
                LEFT JOIN WeekPacket p4 ON p4.packetId = s.gkPacketId
                LEFT JOIN SubjectLevel l4 ON l4.levelId = p4.levelId
                WHERE 1 = 1
                AND s.locationId = <cfqueryparam value="#local.stData.stUserData.locationId#" cfsqltype="cf_sql_integer" />
                AND s.active = <cfqueryparam value="1" cfsqltype="cf_sql_integer" />
            </cfquery>
            <!--- get booklets --->
            <cfquery name="getBooklets" datasource="#this.sDatasourceName#">
                SELECT bookletId, booklet FROM Booklet
            </cfquery>
            
            <cfset local.lBooklet = ValueList(getBooklets.booklet) />
            <!--- get math levels --->
            <cfquery name="getMathLevels" datasource="#this.sDatasourceName#">
                SELECT l.levelId, l.levelName 
                FROM subjectLevel l INNER JOIN subject s ON s.subjectId = l.subjectId
                WHERE subjectName = 'Math'
            </cfquery>
            
            <cfset local.lMathLevel = ValueList(getMathLevels.levelId) />
    
            
            <!--- get english levels --->
            <cfquery name="getEnglishLevels" datasource="#this.sDatasourceName#">
                SELECT l.levelId, l.levelName 
                FROM subjectLevel l INNER JOIN subject s ON s.subjectId = l.subjectId
                WHERE subjectName = 'English'
            </cfquery>
            
            <cfset local.lEnglishLevel = ValueList(getEnglishLevels.levelId) />
            
            <!--- get abacus levels --->
            <cfquery name="getAbacusLevels" datasource="#this.sDatasourceName#">
                SELECT l.levelId, l.levelName 
                FROM subjectLevel l INNER JOIN subject s ON s.subjectId = l.subjectId
                WHERE subjectName = 'Abacus'
            </cfquery>
            
            <cfset local.lAbacusLevel = ValueList(getAbacusLevels.levelId) />
            
            <!--- get gk levels --->
            <cfquery name="getGKLevels" datasource="#this.sDatasourceName#">
                SELECT l.levelId, l.levelName 
                FROM subjectLevel l INNER JOIN subject s ON s.subjectId = l.subjectId
                WHERE subjectName = 'GK'
            </cfquery>
            
            <cfset local.lGKLevel = ValueList(getGKLevels.levelId) />
            <!--- loop around students --->
            <cfloop query="getStudents">
                <cfif math eq 'true'>
                    <cfset local.currentPacket = listFindNoCase(local.lBooklet, mathPacket) />
                    <cfset local.from = local.currentPacket+1 />
                    <cfset local.to = local.currentPacket+local.periodInWeeks />
                    
                    <cfset local.currentLevel = listFindNoCase(local.lMathLevel, mathLevelId) />
                    
                    <cfif local.currentLevel eq listLen(local.lMathLevel)>
                        <cfset local.nextLevel = 0 />
                    <cfelse>
                        <cfset local.nextLevel = local.currentLevel + 1 />
                    </cfif>
                    
                    <cfset local.counter = 0 />
                    <cfset local.levelChange = 'false' />
                    <cfif local.currentPacket neq 26>
                        <cfloop from="#local.from#" to="#local.to#" index="x">
                            <cfset local.counter = local.counter+1 />
                            <cfset local.booklet = listGetAt(local.lBooklet, x) />
 
                            <cfquery name="getPacket" datasource="#this.sDatasourceName#">
                                SELECT w.packetId, w.levelId, w.PacketName, l.levelName, concat(l.levelName, "-", w.packetName) as Level
                                FROM WeekPacket w INNER JOIN subjectLevel l ON l.levelId = w.levelId
                                WHERE w.PacketName = '#local.booklet#' AND l.levelId = #mathLevelId#
                            </cfquery>
                            
                            <!---
                            <cf_QofQ>
                                UPDATE local.stInventoryData
                                SET numOfPackets = numOfPackets + 1
                                WHERE packetId = getPacket.packetId
                            </cf_QofQ>--->
                           
                            <cfset newRow = QueryAddRow(requestQuery) />

                            <cfset temp = QuerySetCell(requestQuery, "Subject", "Math") />
                            <cfset temp = QuerySetCell(requestQuery, "Level", "#getPacket.levelId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Packet", "#getPacket.packetId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Booklet", "#getPacket.level#") />
                            <cfset temp = QuerySetCell(requestQuery, "Quantity", 1) />
                           
                            <cfif local.booklet eq "Z">
                                <cfset local.levelChange = "true" />
                                <cfset local.from = 1 />
                                <cfset local.to = local.periodInWeeks-local.counter /> 
                                <cfbreak>
                            </cfif>
                        </cfloop>
                    <cfelse>
                        <cfset local.levelChange = "true" />
                        <cfset local.from = 1 />
                        <cfset local.to = local.periodInWeeks-local.counter />  
                    </cfif>
                   
                    <cfif local.levelChange eq "true" and local.to gte 1  and local.nextLevel neq 0>
                        <cfset local.level = listGetAt(local.lMathLevel, local.nextLevel) />
                        
                        <cfloop from="#local.from#" to="#local.to#" index="x">
                            <cfset local.booklet = listGetAt(local.lBooklet, x) />

                            <cfquery name="getPacket" datasource="#this.sDatasourceName#">
                                SELECT w.packetId, w.levelId, w.PacketName, l.levelName, concat(l.levelName, "-", w.packetName) as Level
                                FROM WeekPacket w INNER JOIN subjectLevel l ON l.levelId = w.levelId
                                WHERE w.PacketName = '#local.booklet#' AND l.levelId = '#local.level#'
                            </cfquery>
                            
                            <cfset newRow = QueryAddRow(requestQuery) />

                            <cfset temp = QuerySetCell(requestQuery, "Subject", "Math") />
                            <cfset temp = QuerySetCell(requestQuery, "Level", "#getPacket.levelId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Packet", "#getPacket.packetId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Booklet", "#getPacket.level#") />
                            <cfset temp = QuerySetCell(requestQuery, "Quantity", 1) />
                            
                            <!---
                            <cf_QofQ>
                                UPDATE local.stInventoryData
                                SET numOfPackets = numOfPackets + 1
                                WHERE packetId = getPacket.packetId
                            </cf_QofQ>
                            --->
                        </cfloop>
                    </cfif>
                    
                    
                </cfif>           
               
                <cfif english eq 'true'>
                    <cfset local.currentPacket = listFindNoCase(local.lBooklet, englishPacket) />
                    <cfset local.from = local.currentPacket+1 />
                    <cfset local.to = local.currentPacket+local.periodInWeeks />
                    <cfset local.counter = 0 />
                    <cfset local.levelChange = 'false' />
                    
                    <cfset local.currentLevel = listFindNoCase(local.lEnglishLevel, englishLevelId) />
                    <cfif local.currentLevel eq listLen(local.lEnglishLevel)>
                        <cfset local.nextLevel = 0 />
                    <cfelse>
                        <cfset local.nextLevel = local.currentLevel + 1 />
                    </cfif>
                    
                    
                    <cfif local.currentPacket neq 26>
                        <cfloop from="#local.from#" to="#local.to#" index="x">
                            <cfset local.counter = local.counter+1 />
                            <cfset local.booklet = listGetAt(local.lBooklet, x) />
                            
                            <cfquery name="getPacket" datasource="#this.sDatasourceName#">
                                SELECT w.packetId, w.levelId, w.PacketName, l.levelName, concat(l.levelName, "-", w.packetName) as Level
                                FROM WeekPacket w INNER JOIN subjectLevel l ON l.levelId = w.levelId
                                WHERE w.PacketName = '#local.booklet#' AND l.levelId = #englishLevelId#
                            </cfquery>

                            <cfset newRow = QueryAddRow(requestQuery) />

                            <cfset temp = QuerySetCell(requestQuery, "Subject", "English") />
                            <cfset temp = QuerySetCell(requestQuery, "Level", "#getPacket.levelId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Packet", "#getPacket.packetId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Booklet", "#getPacket.level#") />
                            <cfset temp = QuerySetCell(requestQuery, "Quantity", 1) />
                            
                            <cfif local.booklet eq "Z">
                                <cfset local.levelChange = 'true' />
                                <cfset local.from = 1 />
                                <cfset local.to = local.periodInWeeks-local.counter />
                                <cfbreak>
                            </cfif>
                        </cfloop>
                    <cfelse>
                        <cfset local.levelChange = 'true' />
                        <cfset local.from = 1 />
                        <cfset local.to = local.periodInWeeks-local.counter />  
                    </cfif>
                          
                    <cfif local.levelChange eq "true" and local.to gte 1 and local.nextLevel neq 0>
                        
                        <cfset local.level = listGetAt(local.lEnglishLevel, local.nextLevel) />

                        <cfloop from="#local.from#" to="#local.to#" index="x">
                            <cfset local.booklet = listGetAt(local.lBooklet, x) />

                            <cfquery name="getPacket" datasource="#this.sDatasourceName#">
                                SELECT w.packetId, w.levelId, w.PacketName, l.levelName, concat(l.levelName, "-", w.packetName) as Level
                                FROM WeekPacket w INNER JOIN subjectLevel l ON l.levelId = w.levelId
                                WHERE w.PacketName = '#local.booklet#' AND l.levelId = '#local.level#'
                            </cfquery>

                            <cfset newRow = QueryAddRow(requestQuery) />

                            <cfset temp = QuerySetCell(requestQuery, "Subject", "English") />
                            <cfset temp = QuerySetCell(requestQuery, "Level", "#getPacket.levelId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Packet", "#getPacket.packetId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Booklet", "#getPacket.level#") />
                            <cfset temp = QuerySetCell(requestQuery, "Quantity", 1) />
                        </cfloop>
                        
                    </cfif>
                    
                </cfif>
                
                <cfif abacus eq 'true'>
                    <cfset local.currentPacket = listFind(local.lBooklet, abacusPacket) />
                    <cfset local.from = local.currentPacket+1 />
                    <cfset local.to = local.currentPacket+local.periodInWeeks />
                    <cfset local.counter = 0 />
                    <cfset local.levelChange = 'false' />
                    
                    <cfset local.currentLevel = listFindNoCase(local.lAbacusLevel, abacusLevelId) />
                    
                    <cfif local.currentLevel eq listLen(local.lAbacusLevel)>
                        <cfset local.nextLevel = 0 />
                    <cfelse>
                        <cfset local.nextLevel = local.currentLevel + 1 />
                    </cfif>
                        
                    <cfif local.currentPacket neq 26>
                        <cfloop from="#local.from#" to="#local.to#" index="x">
                            <cfset local.counter = local.counter+1 />
                            <cfset local.booklet = listGetAt(local.lBooklet, x) />
                            
                            <cfquery name="getPacket" datasource="#this.sDatasourceName#">
                                SELECT w.packetId, w.levelId, w.PacketName, l.levelName, concat(l.levelName, "-", w.packetName) as Level
                                FROM WeekPacket w INNER JOIN subjectLevel l ON l.levelId = w.levelId
                                WHERE w.PacketName = '#local.booklet#' AND l.levelId = #abacusLevelId#
                            </cfquery>

                            <cfset newRow = QueryAddRow(requestQuery) />

                            <cfset temp = QuerySetCell(requestQuery, "Subject", "Abacus") />
                            <cfset temp = QuerySetCell(requestQuery, "Level", "#getPacket.levelId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Packet", "#getPacket.packetId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Booklet", "#getPacket.level#") />
                            <cfset temp = QuerySetCell(requestQuery, "Quantity", 1) />
                            
                            <cfif local.booklet eq "Z">
                                <cfset local.levelChange = 'true' />
                                <cfset local.from = 1 />
                                <cfset local.to = local.periodInWeeks-local.counter />
                                <cfbreak>
                            </cfif>
                        </cfloop>
                    <cfelse>
                        <cfset local.levelChange = 'true' />
                        <cfset local.from = 1 />
                        <cfset local.to = local.periodInWeeks-local.counter />  
                    </cfif>
                    <cfif local.levelChange eq "true" and local.to gte 1 and local.nextLevel neq 0>
                        <cfloop from="#local.from#" to="#local.to#" index="x">
                            <cfset local.booklet = listGetAt(local.lBooklet, x) />

                            <cfquery name="getPacket" datasource="#this.sDatasourceName#">
                                SELECT w.packetId, w.levelId, w.PacketName, l.levelName, concat(l.levelName, "-", w.packetName) as Level
                                FROM WeekPacket w INNER JOIN subjectLevel l ON l.levelId = w.levelId
                                WHERE w.PacketName = '#local.booklet#' AND l.levelId = #abacusLevelId#
                            </cfquery>

                            <cfset newRow = QueryAddRow(requestQuery) />

                            <cfset temp = QuerySetCell(requestQuery, "Subject", "Abacus") />
                            <cfset temp = QuerySetCell(requestQuery, "Level", "#getPacket.levelId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Packet", "#getPacket.packetId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Booklet", "#getPacket.level#") />
                            <cfset temp = QuerySetCell(requestQuery, "Quantity", 1) />
                        </cfloop>
                    </cfif>
                    
                </cfif>
                
                <cfif gk eq 'true'>
                    <cfset local.currentPacket = listFind(local.lBooklet, gkPacket) />
                    <cfset local.from = local.currentPacket+1 />
                    <cfset local.to = local.currentPacket+local.periodInWeeks />
                    <cfset local.counter = 0 />
                    <cfset local.levelChange = 'false' />
                    <cfset local.currentLevel = listFindNoCase(local.lGKLevel, gkLevelId) />
                    
                    <cfif local.currentLevel eq listLen(local.lGKLevel)>
                        <cfset local.nextLevel = 0 />
                    <cfelse>
                        <cfset local.nextLevel = local.currentLevel + 1 />
                    </cfif>
                    
                    <cfif local.currentPacket neq 26>
                        <cfloop from="#local.from#" to="#local.to#" index="x">
                            <cfset local.counter = local.counter+1 />
                            <cfset local.booklet = listGetAt(local.lBooklet, x) />
                            
                            <cfquery name="getPacket" datasource="#this.sDatasourceName#">
                                SELECT w.packetId, w.levelId, w.PacketName, l.levelName, concat(l.levelName, "-", w.packetName) as Level
                                FROM WeekPacket w INNER JOIN subjectLevel l ON l.levelId = w.levelId
                                WHERE w.PacketName = '#local.booklet#' AND l.levelId = #gkLevelId#
                            </cfquery>

                            <cfset newRow = QueryAddRow(requestQuery) />

                            <cfset temp = QuerySetCell(requestQuery, "Subject", "GK") />
                            <cfset temp = QuerySetCell(requestQuery, "Level", "#getPacket.levelId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Packet", "#getPacket.packetId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Booklet", "#getPacket.level#") />
                            <cfset temp = QuerySetCell(requestQuery, "Quantity", 1) />
                            
                            <cfif local.booklet eq "Z">
                                <cfset local.levelChange = 'true' />
                                <cfset local.from = 1 />
                                <cfset local.to = local.periodInWeeks-local.counter />
                                <cfbreak>
                            </cfif>
                        </cfloop>
                    <cfelse>
                        <cfset local.levelChange = 'true' />
                        <cfset local.from = 1 />
                        <cfset local.to = local.periodInWeeks-local.counter />  
                    </cfif>
                    <cfif local.levelChange eq "true" and local.to gte 1 and local.nextLevel neq 0>
                        <cfloop from="#local.from#" to="#local.to#" index="x">
                            <cfset local.booklet = listGetAt(local.lBooklet, x) />

                            <cfquery name="getPacket" datasource="#this.sDatasourceName#">
                                SELECT w.packetId, w.levelId, w.PacketName, l.levelName, concat(l.levelName, "-", w.packetName) as Level
                                FROM WeekPacket w INNER JOIN subjectLevel l ON l.levelId = w.levelId
                                WHERE w.PacketName = '#local.booklet#' AND l.levelId = #gkLevelId#
                            </cfquery>

                            <cfset newRow = QueryAddRow(requestQuery) />

                            <cfset temp = QuerySetCell(requestQuery, "Subject", "GK") />
                            <cfset temp = QuerySetCell(requestQuery, "Level", "#getPacket.levelId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Packet", "#getPacket.packetId#") />
                            <cfset temp = QuerySetCell(requestQuery, "Booklet", "#getPacket.level#") />
                            <cfset temp = QuerySetCell(requestQuery, "Quantity", 1) />
                        </cfloop>
                    </cfif>
                    
                </cfif>
                
            </cfloop>

            <cfquery dbtype="query" name="groupedRequestQuery"> 
                SELECT Subject, Packet, Booklet, Sum(Quantity) as quantity
                FROM requestQuery
                group by Subject, Packet, Booklet
                order by Subject, Booklet
            </cfquery>
                        
            <cfquery name="insertInventoryRequest" datasource="#this.sDatasourceName#" result="insertResult">
                INSERT INTO InventoryRequest (locationId, createdBy, createdDate, updatedBy, updatedDate)
                VALUES
                (#local.stData.stUserData.locationId#, #local.stData.stUserData.userId#, CURRENT_DATE(),
                #local.stData.stUserData.userId#, CURRENT_DATE())
            </cfquery>
                        
            <cfset local.inventoryRequestId = insertResult["GENERATEDKEY"] />
                
            <cfoutput query="groupedRequestQuery">
                <cfquery name="insertInventoryRequest" datasource="#this.sDatasourceName#" result="insertResult">
                    INSERT INTO RequestDetails (packetId, inventoryRequestId, quantity)
                    VALUES
                    (#packet#, #local.inventoryRequestId#, #quantity#)
                </cfquery>             
            </cfoutput>
            
            <!---
            <cfquery name="getInventory" datasource="#this.sDatasourceName#">
                SELECT r.packetId, r.quantity as requestedQuantity,  s.subjectName, l.levelName, CONCAT(l.levelName, " ", p.packetName) as Packet, 
                ir.inventoryRequestId, CASE WHEN i.numOfPackets IS NULL THEN 0 ELSE i.numOfPackets END as numOfPackets 
                FROM RequestDetails r inner join InventoryRequest ir ON ir.inventoryRequestId = ir.inventoryRequestId
                INNER JOIN WeekPacket p ON r.packetId = p.packetId
                INNER JOIN SubjectLevel l ON p.levelId = l.levelId
                INNER JOIN subject s ON l.subjectId = s.subjectId
                LEFT JOIN Inventory i ON i.packetId = p.packetId
                WHERE 1 = 1
                AND ir.inventoryRequestId = #local.inventoryRequestId#
            </cfquery>
                        
            <cfset local.stInventoryData = QueryToStruct(getInventory) />

            --->
                        
            <cfquery name="getInventory"  datasource="#this.sDatasourceName#">
                SELECT max(ir.inventoryRequestId) as inventoryRequestId
                FROM InventoryRequest ir
                WHERE ir.createddate = (SELECT MAX(createddate)
                FROM InventoryRequest ir2
                WHERE ir2.locationId = ir.locationId 
                AND ir2.locationId = <cfqueryparam value="#local.stData.stUserData.locationId#" cfsqltype="cf_sql_integer" />)
            </cfquery>
            
            <cfset local.stRequestData.stInventoryRequest = QueryToStruct(getInventory) />
            
            <cfquery name="getInventoryRequest" datasource="#this.sDatasourceName#">
                SELECT p.packetId, s.subjectName, l.levelName, CONCAT(l.levelName, " ", p.packetName) AS Packet, 
                p.packetName, COALESCE(i.numOfPackets,0) as existingQuantity, COALESCE(r.quantity,0) AS requestedQuantity
                FROM WeekPacket p INNER JOIN SubjectLevel l ON p.levelId = l.levelId
                INNER JOIN Subject s ON l.subjectId = s.subjectId
                LEFT JOIN Inventory i ON i.packetId = p.packetId  
                AND i.locationId = <cfqueryparam value="#local.stData.stUserData.locationId#" cfsqltype="cf_sql_integer" />
                LEFT JOIN requestdetails r ON r.packetId = p.packetId 
                AND r.inventoryRequestId = (SELECT max(ir.inventoryRequestId) FROM inventoryRequest ir 
                WHERE ir.createddate = (SELECT MAX(createddate)
                FROM InventoryRequest ir2
                WHERE ir2.locationId = ir.locationId 
                AND ir2.locationId = <cfqueryparam value="#local.stData.stUserData.locationId#" cfsqltype="cf_sql_integer" />))
                ORDER BY  s.subjectId, l.levelId, p.packetId
            </cfquery>
            
            <cfset local.stRequestData.stInventoryData = QueryToStruct(getInventoryRequest) />
            
            <cfcatch type="any">
                <cfdump var="#local#" />
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stRequestData />
    </cffunction>
                
    <cffunction name="createExcel" access="remote" output="false" returnformat="plain" hint="I am a function that creates excel sheet of generated
    inventory request" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset local.stRequestData = StructNew() />
            <cfset init() />
            
            <cfquery name="getInventory" datasource="#this.sDatasourceName#">
                SELECT p.packetId, s.subjectName, l.levelName, CONCAT(l.levelName, " ", p.packetName) as Packet, 
                r.quantity, ir.inventoryRequestId 
                FROM WeekPacket p INNER JOIN SubjectLevel l ON p.levelId = l.levelId
                INNER JOIN subject s ON l.subjectId = s.subjectId
                INNER JOIN requestDetails r ON r.packetId = p.packetId
                INNER JOIN inventoryRequest ir ON r.inventoryRequestId = ir.inventoryRequestId
                WHERE 1 = 1
                AND ir.inventoryRequestId = <cfqueryparam value="#local.stData.inventoryRequestId#" cfsqltype="cf_sql_integer" />
            </cfquery>
            
            <cfset local.theDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "excels/"  />
            <cfset local.fileName = "inventoryRequest_" & dateFormat(now(), 'mm-dd-yyyy') & ".xls" />
            <cfset local.theFile = local.theDir & local.fileName />
                
            <cfspreadsheet  
                action="write" 
                filename = "#local.theFile#"
                overwrite = "true"  
                query = "getInventory">
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
            </cfcatch>
        </cftry>
        <cfreturn local.fileName />
    </cffunction>
            
    <cffunction name="sendMail" access="remote" output="false" returnformat="json" hint="I am a function that sends email" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset local.stRequestData = StructNew() />
            <cfset init() />
            
            <cfquery name="getInventory" datasource="#this.sDatasourceName#">
                SELECT p.packetId, s.subjectName, l.levelName, CONCAT(l.levelName, " ", p.packetName) as Packet, 
                r.quantity, ir.inventoryRequestId 
                FROM WeekPacket p INNER JOIN SubjectLevel l ON p.levelId = l.levelId
                INNER JOIN subject s ON l.subjectId = s.subjectId
                INNER JOIN requestDetails r ON r.packetId = p.packetId
                INNER JOIN inventoryRequest ir ON r.inventoryRequestId = ir.inventoryRequestId
                WHERE 1 = 1
                AND ir.inventoryRequestId = <cfqueryparam value="#local.stData.inventoryRequestId#" cfsqltype="cf_sql_integer" />
            </cfquery>
            
            <cfset theDir = GetDirectoryFromPath(GetCurrentTemplatePath()) />
            <cfset fileName = "inventoryRequest_" & dateFormat(now(), 'mm-dd-yyyy') & ".xls" />
            <cfset theFile = theDir & fileName />
            
            <cfspreadsheet  
                action="write" 
                filename = "#theFile#"
                overwrite = "true"  
                query = "getInventory">
            
            <cfmail to="#local.stData.stEmail.To#" from="#local.stData.stEmail.From#" cc="#local.stData.stEmail.cc#"
                    subject="#local.stData.stEmail.Subject#" mimeattach="#theFile#">
                Attached request has been for material<br/><br/>
                
                #local.stData.stEmail.Message#<br/>
                
            </cfmail>
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stInventoryData />
    </cffunction>
      
</cfcomponent>