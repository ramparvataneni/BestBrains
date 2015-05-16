<cfcomponent displayname="class" output="false" extends="Base">
    
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get classs" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset local.stClassData = StructNew() />
            <cfset init() />
            
            <cfquery name="getClasses" datasource="#this.sDatasourceName#">
                SELECT c.classId, t.teacherId, CONCAT(t.firstname, " ", t.lastname) as Teacher, c.day, c.startTime, 
                c.startAmPm, c.endTime, c.endAmPm, c.roomNumber, c.locationId,
                CONCAT(CONCAT(t.firstname, " ", t.lastname), " - ", 
                CONCAT(CONCAT(CONCAT(c.day, " ", c.startTime), " ", c.startAmPm), "-", CONCAT(c.endTime, " ", c.endAmPm))) as class,
                CONCAT(CONCAT(c.startTime, " ", c.startAmPm), "-", CONCAT(c.endTime, " ", c.endAmPm)) as classTime,
                cs.subjectId as classsubjectId, s.subjectName as classSubject
                FROM class c INNER JOIN teacher t ON c.teacherId = t.teacherId
                LEFT JOIN ClassSubject cs ON c.classId = cs.classId
                LEFT JOIN Subject s ON s.subjectId = cs.subjectId
                WHERE 1 = 1
                <cfif local.stData.stUserData.locationId neq "" and local.stData.stUserData.locationId neq 0 and not local.stData.stUserData.allLocations>
                    AND c.locationId = <cfqueryparam value="#local.stData.stUserData.locationId#" cfsqltype="cf_sql_integer" />
                </cfif>
                order by c.day, c.startTime, c.classId
            </cfquery>
            
            <!---<cfset local.stClass = queryNew(classId, teacherId, teacher, day, startTime, startAmPm, endTime, fullName, studentId, class, classTime,
                   classSubject1, classSubject2, subject1, subject2, endAmPm, roomNumber, locatioinId, classSubject) />--->
            <cfset local.ClassArray = ArrayNew( 1 ) />
            
            <cfoutput query="getClasses" group="classId">
                <cfset temp = ArrayAppend( local.ClassArray, StructNew() )/>
                <cfset local.ClassArrayIndex = ArrayLen( local.ClassArray ) />
                
                <!---
                <cfset local.currentDate = dateFormat(now(), "mm/dd/yyyy") />
                
                
                <cfset currentDay = dayOfWeekAsString(local.currentDate) />
                <cfif day eq currenDay>
                    <cfset local.classDate = local.currentDate />
                <cfelse>
                    <cfif day eq "Monday">
                        <cfset local.classDate = dateAdd("d", 9 - dayOfWeek(local.currentDate), local.currentDate)>
                    <cfelseif day eq "Tuesday">
                        <cfset local.classDate = dateAdd("d", 10 - dayOfWeek(local.currentDate), local.currentDate)>
                    <cfelseif day eq "Wednesday">
                        <cfset local.classDate = dateAdd("d", 11 - dayOfWeek(local.currentDate), local.currentDate)>
                    <cfelseif day eq "Thursday">
                        <cfset local.classDate = dateAdd("d", 9 - dayOfWeek(local.currentDate), local.currentDate)>
                    <cfelseif day eq "Friday">
                        <cfset local.classDate = dateAdd("d", 9 - dayOfWeek(local.currentDate), local.currentDate)>
                    <cfelseif day eq "Saturday">
                        <cfset local.classDate = dateAdd("d", 9 - dayOfWeek(local.currentDate), local.currentDate)>
                    <cfelseif day eq "Sunday">
                        <cfset local.classDate = dateAdd("d", 9 - dayOfWeek(local.currentDate), local.currentDate)>
                    </cfif>
                    
                </cfif>
                --->
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'CLASSID' ] = classId />
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'TEACHERID' ] = teacherId />
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'TEACHER' ] = teacher />
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'DAY' ] = day />
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'STARTTIME' ] = startTime />
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'STARTAMPM' ] = startAmPm />
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'ENDTIME' ] = endTime />
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'ENDAMPM' ] = endAmPm />
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'CLASS' ] = class />
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'CLASSDATE' ] = dateFormat(now(), "mm/dd/yyyy") />
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'CLASSTIME' ] = classTime />
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'ROOMNUMBER' ] = roomNumber />
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'LOCATIONID' ] = locationID />
                
                
                <cfset local.SubjectArray = ArrayNew( 1 ) />
                <cfset local.allSubjects = "" />
                <cfoutput>
                    <cfset temp = ArrayAppend( local.SubjectArray, StructNew() )/>
                    <cfset local.SubjectArrayIndex = ArrayLen( local.SubjectArray ) />
                    
                    <cfset local.allSubjects = listAppend(local.allSubjects, CLASSSUBJECT) />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'CLASSSUBJECTID' ] = CLASSSUBJECTID />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'CLASSSUBJECT' ] = CLASSSUBJECT />
                </cfoutput>
                <cfif arrayLen(local.SubjectArray) eq 1>
                    <cfset temp = ArrayAppend( local.SubjectArray, StructNew() )/>
                    <cfset local.SubjectArrayIndex = ArrayLen( local.SubjectArray ) />
                    
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'CLASSSUBJECTID' ] = 0 />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'CLASSSUBJECT' ] = "" />
                </cfif>
                
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'ALLSUBJECTS' ] = local.allSubjects />
                
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'Subjects' ] = local.SubjectArray />
                
                <!---
                <cfset local.StudentArray = ArrayNew( 1 ) />
                
                <cfoutput>
                    <cfset temp = ArrayAppend( LOCAL.StudentArray, StructNew() )/>
                    <cfset local.StudentArrayIndex = ArrayLen( local.StudentArray ) />
                    
                    <cfset local.StudentArray[ local.StudentArrayIndex ][ 'STUDENTID' ] = studentId />
                    <cfset local.StudentArray[ local.StudentArrayIndex ][ 'FULLNAME' ] = fullName />
                    <cfset local.StudentArray[ local.StudentArrayIndex ][ 'SUBJECT1PACKET' ] = subject1Packet />
                    <cfset local.StudentArray[ local.StudentArrayIndex ][ 'SUBJECT2PACKET' ] = subject2Packet />
                </cfoutput>
                
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'Students' ] = local.StudentArray />          
                --->
            </cfoutput>
            
            <cfset local.stClassData = local.ClassArray />
            <!---<cfset local.stClassData = QueryToStruct(getClasses) />--->
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stClassData />
    </cffunction>
            
    <cffunction name="getStudentData" access="remote" output="false" returnformat="json" hint="I am a function that get students" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset local.stStudent = StructNew() />
            <cfset init() />
            
            <cfquery name="getStudents" datasource="#this.sDatasourceName#">
                SELECT st.studentId, st.lastName, st.firstName, CONCAT(st.firstName, " ", st.lastName) as fullName,
                sc.classId, ss.subjectId, ss.packetId, p.midTerm, p.packetName, l.levelId, s.subjectName, 
                CONCAT(l.levelName, " ", p.packetName) AS Packet
                FROM Class c
                INNER JOIN StudentClass sc ON sc.classId = c.classId
                INNER JOIN Student st ON st.studentId = sc.studentId
				INNER JOIN StudentSubject ss ON st.studentId = ss.studentId
                INNER JOIN ClassSubject cs ON cs.classId = c.classId AND cs.subjectId = ss.subjectId
                INNER JOIN WeekPacket p ON ss.packetId = p.packetId
                INNER JOIN SubjectLevel l ON p.levelId = l.levelId
                INNER JOIN Subject s ON s.subjectId = l.subjectId
                WHERE 1 = 1
                AND c.classId = <cfqueryparam value="#local.stData.classId#" cfsqltype="cf_sql_integer" />
                ORDER BY st.studentId
            </cfquery>
            
            <cfset local.studentArray = ArrayNew( 1 ) />
            
            <cfoutput query="getStudents" group="studentId">
                <cfset temp = ArrayAppend( local.studentArray, StructNew() )/>
                <cfset local.studentArrayIndex = ArrayLen( local.studentArray ) />
                
                <cfset local.studentArray[ local.studentArrayIndex ][ 'fullName' ] = fullName />
                <cfset local.studentArray[ local.studentArrayIndex ][ 'lastName' ] = lastName />
                <cfset local.studentArray[ local.studentArrayIndex ][ 'firstName' ] = firstName />
                <cfset local.studentArray[ local.studentArrayIndex ][ 'studentId' ] = studentId />
                <cfset local.studentArray[ local.studentArrayIndex ][ 'attendance' ] = false />
                           
                <cfset local.SubjectArray = ArrayNew( 1 ) />

                <cfoutput>
                    <cfset temp = ArrayAppend( local.SubjectArray, StructNew() )/>
                    <cfset local.SubjectArrayIndex = ArrayLen( local.SubjectArray ) />

                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'subjectId' ] = subjectId />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'levelId' ] = levelId />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'packetId' ] = packetId />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'packet' ] = packet />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'packetName' ] = packetName/>
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'subjectName' ] = subjectName />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'promote' ] = false />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'changeLevelId' ] = levelId />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'changePacketId' ] = packetId />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'comments' ] = "" />
                    <cfif midTerm eq 1>
                        <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'midterm' ] = true />
                    <cfelse>
                        <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'midterm' ] = false />
                    </cfif>
                </cfoutput>
                
                <cfset local.studentArray[ local.studentArrayIndex ][ 'Subjects' ] = local.SubjectArray />
                
                <!---
                <cfset local.StudentArray = ArrayNew( 1 ) />
                
                <cfoutput>
                    <cfset temp = ArrayAppend( LOCAL.StudentArray, StructNew() )/>
                    <cfset local.StudentArrayIndex = ArrayLen( local.StudentArray ) />
                    
                    <cfset local.StudentArray[ local.StudentArrayIndex ][ 'STUDENTID' ] = studentId />
                    <cfset local.StudentArray[ local.StudentArrayIndex ][ 'FULLNAME' ] = fullName />
                    <cfset local.StudentArray[ local.StudentArrayIndex ][ 'SUBJECT1PACKET' ] = subject1Packet />
                    <cfset local.StudentArray[ local.StudentArrayIndex ][ 'SUBJECT2PACKET' ] = subject2Packet />
                </cfoutput>
                
                <cfset local.ClassArray[ local.ClassArrayIndex ][ 'Students' ] = local.StudentArray />          
                --->
            </cfoutput>
            <cfset local.stStudent = local.studentArray />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stStudent />
    </cffunction>
            
    <cffunction name="saveClassData" access="remote" output="true" returnformat="json"  hint="I am a function that saves class data" >
        
        <cftry>
            <cfset local.stClassData = CheckJsonBody( getHttpRequestData().content ).stClass />
            <cfset local.userId = CheckJsonBody( getHttpRequestData().content ).userId />
            
            <cfset init() />
            
            <cfset local.currentDateTime = createODBCDateTime(now()) />
                  
            <cfquery name="insertClassHistory" datasource="#this.sDatasourceName#" result="insertResult">
                INSERT INTO ClassHistory
                (classId, classDate, teacherId, createdById, createdDate, updatedById, updatedDate)
                VALUES
                (<cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.classId#" />,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.stClassData.classDate#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.teacherId#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.userId#" />,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.currentDateTime#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.userId#" />,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.currentDateTime#" />)
            </cfquery>
            
            <cfset local.classHistoryId = insertResult["GENERATEDKEY"] />
            
            <cfloop from="1" to="#arrayLen(local.stClassData.stStudent)#" index="i">
                <cfquery name="insertStudentClassHistory" datasource="#this.sDatasourceName#" result="insertStudentHistory">
                    INSERT INTO StudentClassHistory
                    (classHistoryId, studentId, attendance, createdById, createdDate, updatedById, updatedDate)
                    VALUES
                    (<cfqueryparam cfsqltype="cf_sql_integer" value="#local.classHistoryId#" />,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.stStudent[i].studentId#" />,
                    <cfqueryparam cfsqltype="cf_sql_tinyint" value="#local.stClassData.stStudent[i].attendance#" />,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#local.userId#" />,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.currentDateTime#" />,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#local.userId#" />,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.currentDateTime#" />)
                </cfquery>
                
                <cfset local.studentClassHistoryId = insertStudentHistory["GENERATEDKEY"] />
                
                <!--- get booklets --->
                <cfquery name="getBooklets" datasource="#this.sDatasourceName#">
                    SELECT bookletId, booklet FROM Booklet
                </cfquery>

                <cfset local.lBooklet = ValueList(getBooklets.booklet) />
                
                <cfloop from="1" to="#arrayLen(local.stClassData.stStudent[i].subjects)#" index="j">
                    <cfif local.stClassData.stStudent[i].attendance eq true and local.stClassData.stStudent[i].subjects[j].promote eq true>
                        <cfif local.stClassData.stStudent[i].subjects[j].packetId eq local.stClassData.stStudent[i].subjects[j].changePacketId>
                            <!--- iterate next packet logic by packetId --->

                            <!--- get subject levels --->
                            <cfquery name="getSubjectLevels" datasource="#this.sDatasourceName#">
                                SELECT l.levelId, l.levelName 
                                FROM subjectLevel l INNER JOIN subject s ON s.subjectId = l.subjectId
                                WHERE s.subjectId = 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.stStudent[i].subjects[j].subjectId#" />
                            </cfquery>
                            <cfset local.lSubjectLevel = ValueList(getSubjectLevels.levelId) />

                            <cfset local.currentLevel = listFindNoCase(local.lSubjectLevel, local.stClassData.stStudent[i].subjects[j].levelId) />
                            <cfset local.nextLevel = local.currentLevel + 1 />
                            <cfset local.currentBooklet = listFindNoCase(local.lBooklet, local.stClassData.stStudent[i].subjects[j].packetName) />
                            <cfset local.next = local.currentBooklet+1 />

                            <cfif local.next gt 26>
                                <cfset local.nextLevelId = listGetAt(local.lSubjectLevel, local.nextLevel) />
                                <cfset local.nextBooklet = 1 />
                            <cfelse>
                                <cfset local.nextLevelId = local.stClassData.stStudent[i].subjects[j].levelId />
                                <cfset local.nextBooklet = listGetAt(local.lBooklet, local.next) />
                            </cfif>

                            <cfquery name="getPacket" datasource="#this.sDatasourceName#">
                                SELECT packetId
                                FROM WeekPacket
                                WHERE PacketName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.nextbooklet#" /> AND 
                                levelId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.nextLevelId#" />
                            </cfquery>
                            <cfset local.nextPacketId = getPacket.packetId />
                        <cfelse>
                            <cfset local.nextPacketId = local.stClassData.stStudent[i].subjects[j].changePacketId />
                        </cfif>

                        <cfquery name="updatePacket" datasource="#this.sDatasourceName#" result="insertResult">
                            UPDATE StudentSubject SET
                            packetId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.nextPacketId#" />
                            WHERE studentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.stStudent[i].studentId#" />
                            AND subjectId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.stStudent[i].subjects[j].subjectId#" />
                        </cfquery>

                        <cfquery name="insertSubjectHistory" datasource="#this.sDatasourceName#">
                            INSERT INTO StudentSubjectHistory
                            (studentClassHistoryId, subjectId, currentPacketId, nextPacketId, promote, comments, 
                            createdById, createdDate, updatedById, updatedDate)
                            VALUES
                            (<cfqueryparam cfsqltype="cf_sql_integer" value="#local.studentClassHistoryId#" />,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.stStudent[i].subjects[j].subjectId#" />,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.stStudent[i].subjects[j].packetId#" />,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#local.nextPacketId#" />,
                            <cfqueryparam cfsqltype="cf_sql_tinyint" value="#local.stClassData.stStudent[i].subjects[j].promote#" />,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.stStudent[i].subjects[j].comments#" />,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#local.userId#" />,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.currentDateTime#" />,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#local.userId#" />,
                            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.currentDateTime#" />)
                        </cfquery>

                    </cfif>
                </cfloop>
            </cfloop>
                      
            <cfcatch type="any">
                <cfdump var="#local#">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stClassData />
    </cffunction>
                
    <cffunction name="generateMaterialSheet" access="remote" output="false" returnformat="json" hint="I am a function to generate material sheet" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset local.stMaterialSheet = StructNew() />
            <cfset init() />
            
            <cfquery name="getStudents" datasource="#this.sDatasourceName#">
                SELECT st.studentId, st.lastName, st.firstName, CONCAT(st.firstName, " ", st.lastName) as fullName,
                sc.classId, ss.subjectId, ss.packetId, p.midTerm, p.packetName, l.levelId, s.subjectName,
                CONCAT(CONCAT(c.startTime, " ", c.startAmPm), "-", CONCAT(c.endTime, " ", c.endAmPm)) as classTime,
                CONCAT(t.firstname, " ", t.lastname) as Teacher,
                CONCAT(l.levelName, " ", p.packetName) AS Packet
                FROM Class c
                INNER JOIN StudentClass sc ON sc.classId = c.classId
                INNER JOIN Student st ON st.studentId = sc.studentId
				INNER JOIN StudentSubject ss ON st.studentId = ss.studentId
                INNER JOIN ClassSubject cs ON cs.classId = c.classId AND cs.subjectId = ss.subjectId
                INNER JOIN WeekPacket p ON ss.packetId = p.packetId
                INNER JOIN SubjectLevel l ON p.levelId = l.levelId
                INNER JOIN Subject s ON s.subjectId = l.subjectId
                INNER JOIN Teacher t ON c.teacherId = t.teacherId
                WHERE 1 = 1
                AND c.locationId = <cfqueryparam value="#local.stData.locationId#" cfsqltype="cf_sql_integer" />
                <cfif local.stData.week neq "">
                    AND c.day = <cfqueryparam value="#local.stData.week#" cfsqltype="cf_sql_varchar" />
                </cfif>        
                ORDER BY st.studentId
            </cfquery>
            
            <cfset local.materialArray = ArrayNew( 1 ) />
            
            <cfoutput query="getStudents" group="studentId">
                <cfset temp = ArrayAppend( local.materialArray, StructNew() )/>
                <cfset local.materialArrayIndex = ArrayLen( local.materialArray ) />
                
                <cfset local.materialArray[ local.materialArrayIndex ][ 'fullName' ] = fullName />
                <cfset local.materialArray[ local.materialArrayIndex ][ 'classTime' ] = classTime />
                <cfset local.materialArray[ local.materialArrayIndex ][ 'teacher' ] = teacher />
                           
                <cfset local.SubjectArray = ArrayNew( 1 ) />
                
                <cfset lSubjectList = "Math, English, Abacus, GK" />

                <cfoutput>
                    <cfset local.materialArray[ local.materialArrayIndex ][ subjectName ] = packet />
                    <!---
                    <cfset temp = ArrayAppend( local.SubjectArray, StructNew() )/>
                    <cfset local.SubjectArrayIndex = ArrayLen( local.SubjectArray ) />

                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'subjectId' ] = subjectId />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'levelId' ] = levelId />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'packetId' ] = packetId />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'packet' ] = packet />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'packetName' ] = packetName/>
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'subjectName' ] = subjectName />
                    <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'comments' ] = "" />
                    <cfif midTerm eq 1>
                        <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'midterm' ] = true />
                    <cfelse>
                        <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'midterm' ] = false />
                    </cfif>
                    --->
                </cfoutput>
                
                <!---<cfset local.materialArray[ local.materialArrayIndex ][ 'Subjects' ] = local.SubjectArray />--->

            </cfoutput>
            <cfset local.stMaterialSheet = local.materialArray />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stMaterialSheet />
    </cffunction>
                
    <cffunction name="createExcel" access="remote" output="false" returnformat="plain" hint="I am a function that creates excel sheet of generated
    material sheet" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ).stMaterialData />
            <cfset local.stRequestData = StructNew() />
            <cfset init() />
            
            <cfset local.theDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "excels/" />
            <cfset local.fileName = "material_" & dateFormat(now(), 'mm-dd-yyyy') & ".xls" />
            <cfset local.theFile = local.theDir & local.fileName />
            
            <cfset local.qstData = queryNew("fullName, Math, English, Abacus, classTime, Teacher", "varchar, varchar, varchar, varchar, varchar, varchar") />         
            <cfloop from="1" to="#arrayLen(local.stData)#" index="i">
                <cfset queryAddRow(local.qstData) />
                <cfloop collection="#local.stData[i]#" item="k">
                    <cfset querySetCell(local.qstData,k,local.stData[i][k]) />
                </cfloop>
            </cfloop>
            
            <cfspreadsheet  
                action="write" 
                filename = "#local.theFile#"
                overwrite = "true"
                query = "local.qstData">
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
            </cfcatch>
        </cftry>
        <cfreturn local.fileName />
    </cffunction>
    
    <cffunction name="create" access="remote" output="true" returnformat="json"  hint="I am a function that create class" >
        
        <cftry>
            <cfset local.stClassData = CheckJsonBody( getHttpRequestData().content ).stClass />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            
            <cfset init() />
            
            <cfquery name="insertClass" datasource="#this.sDatasourceName#" result="insertResult">
                INSERT INTO Class
                (teacherId, day, startTime, endTime, startAmPm, endAmPm, locationId, roomNumber)
                VALUES
                (<cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.teacherId#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.day#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.startTime#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.endTime#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.startAmPm#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.endAmPm#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.locationId#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.roomNumber#" />)
            </cfquery>
            <cfset local.classId = insertResult["GENERATEDKEY"] />
            
            <!--- insert class subjects --->
            <cfloop from="1" to="#arrayLen(local.stClassData.subjects)#" index="i">
                <cfif local.stClassData.subjects[i].classSubjectId neq 0 AND local.stClassData.subjects[i].classSubjectId neq "">
                    <cfquery name="insertClassSubjects" datasource="#this.sDatasourceName#">
                        INSERT INTO ClassSubject
                        (classId, subjectId)
                        VALUES
                        (<cfqueryparam cfsqltype="cf_sql_integer" value="#local.classId#" />,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.subjects[i].classSubjectId#" />)
                    </cfquery>
                </cfif>
            </cfloop>
            
            <cfset local.stClassData =  read(local.stUserData) />
                      
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stClassData />
    </cffunction>
    
    <cffunction name="update" access="remote" output="false" returnformat="json" hint="I am a function that update class" >
        
        <cftry>
            <cfset local.stClassData = CheckJsonBody( getHttpRequestData().content ).stClass />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            <cfset init() />
            
            <cfquery name="updateClass" datasource="#this.sDatasourceName#">
                UPDATE Class
                SET teacherId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.teacherId#" />,
                    day = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.day#" />,
                    startTime = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.startTime#" />,
                    endTime = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.endTime#" />,
                    startAmPm = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.startAmPm#" />,
                    endAmPm = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.endAmPm#" />,
                    locationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.locationId#" />,
                    roomNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.roomNumber#" />
                WHERE classId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.classId#" />
            </cfquery>
            
            <!--- update class subjects --->
            <cfquery name="getClass" datasource="#this.sDatasourceName#">
                SELECT subjectId
                FROM ClassSubject
                WHERE classId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.classId#" /> 
            </cfquery>
            
            <cfset local.lOldSubjects = valueList(getClass.subjectId) />
            <cfset local.lNewSubjects = "" />
            
            <cfloop from="1" to="#arrayLen(local.stClassData.subjects)#" index="i"> 
                <cfif local.stClassData.subjects[i].classSubjectId neq 0 AND local.stClassData.subjects[i].classSubjectId neq "">
                    <cfset local.lNewSubjects = listAppend(local.lNewSubjects, local.stClassData.subjects[i].classSubjectId) />
                    <cfif listFind(local.lOldSubjects, local.stClassData.subjects[i].classSubjectId)  gt 0>
                        
                    <cfelse>
                        <cfquery name="insertClassSubjects" datasource="#this.sDatasourceName#">
                            INSERT INTO ClassSubject
                            (classId, subjectId)
                            VALUES
                            (<cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.classId#" />,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.subjects[i].classSubjectId#" />)
                        </cfquery>
                    </cfif>
                </cfif>
            </cfloop>
                
            <cfif listLen(local.lNewSubjects) gt 0>
                <cfquery name="deleteSubject" datasource="#this.sDatasourceName#">
                    DELETE FROM ClassSubject
                    WHERE classId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.classId#" />
                    AND subjectID not in (<cfqueryparam value="#local.lNewSubjects#" cfsqltype="cf_sql_integer" list="true" />)
                </cfquery>      
            </cfif>
            
            <cfset local.stClassData =  read(local.stUserData) />
              
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stClassData />
    </cffunction>
        
    <cffunction name="delete" access="remote" output="false" returnformat="json" hint="I am a function that delete/archive class" >
        
        <cftry>
            <cfset local.stClassData = CheckJsonBody( getHttpRequestData().content ).stClass />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            <cfset init() />
            
            <cfquery name="deleteClass" datasource="#this.sDatasourceName#">
                DELETE FROM class
                WHERE classId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.classId#" />
            </cfquery>
            
            <cfset local.stClassData =  read(local.stUserData) />
                 
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stClassData />
    </cffunction>
    
    
    
</cfcomponent>