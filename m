From: "web999@bluehatlinux.com" <web999@bluehatlinux.com>
Subject: user_friendly_filter feature submission
Date: Wed, 18 Jun 2008 15:44:38 -0400
Message-ID: <485965A6.606@bluehatlinux.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Attached is my submission for a feature update to the linux multipath. I 
am trying to add a feature that allows dynamic user friendly names. I 
feel this will make multipath, cluster friendly, in addition to making 
multipath more malleable.
Right now the user has two dynamic options either use a wwid like 
120030a80045bc60000007de800000293 that will be the same on all nodes of 
a cluster or a name like mpathX where X might deviate on different nodes 
of a cluster.
In practice the best practice is to static name all lun names in 
/etc/multipath.conf on all nodes. On large clusters with small LUNS this 
can easily run into thousands of lines per node.
I propose a feature that allows the user to supply a sed script that 
will auto name the LUNS so for example...
    user_friendly_names     yes
120030a80045bc60000007de800000292  -> /dev/mpath/mpath0
120030a80045bc60000007de800000293  -> /dev/mpath/mpath1
while...
On a HP XP12000 class SAN the last 4 digits correspond to CU and LUN
    user_friendly_names     yes
    user_friendly_filter    "/bin/sed 
s|^.\{29\}\(.\{2\}\)\(.\{2\}\)|lun_\1_\2|"
120030a80045bc60000007de800000292  -> /dev/mpath/lun_02_92
120030a80045bc60000007de800000293  -> /dev/mpath/lun_02_93

so for example with one line a Admin allows a DBA to see what lun 
corresponds to what disk array.
Ex....
lun_01_01
lun_01_02
are all on one "parity group"
lun_02_01
lun_02_02
are on another.
If this patch is succesful I would considering working on a module 
system so that every SAN has a unique naming scheme.
By default a XP12000 would automatically name its luns
XP_123_01_02
where 123 is a unique identifier for the san
while plugin in a EMC might give a name like
EMC_123_0001
But in any case the names will be the same on all nodes as long as the 
filter is consistent.

Attached is a diff against redhat's source code 
multipath-tools-0.4.7.rhel5.10 as that is the only code base I have 
available for testing.

If a different format is needed please let me know.

David Davidson
web999.at.bluehatlinux.com

diff -U 3 -H -d -r -N -x .cproject -x .project -- 
root/workspace/multipath-tools-0.4.7/Multipath-usage.txt 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/Multipath-usage.txt
--- root/workspace/multipath-tools-0.4.7/Multipath-usage.txt   
 2008-06-12 19:01:25.000000000 -0400
+++ 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/Multipath-usage.txt   
 2006-06-06 14:32:43.000000000 -0400
@@ -164,8 +164,7 @@
 
     NOTE: While the alias in guaranteed to be unique on a node, it
           is not guaranteed to be the same on all nodes using the
-          multipath device. Also, it may change. Setting 
user_friendly_filter
-          will make the device the same if properly set.
+          multipath device. Also, it may change.
 
 WWID:
     The WWID (World Wide Identifier) is an identifier for the
Binary files root/workspace/multipath-tools-0.4.7/cciss_id/cciss_id and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/cciss_id/cciss_id 
differ
Binary files root/workspace/multipath-tools-0.4.7/cciss_id/cciss_id.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/cciss_id/cciss_id.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/kpartx/bsd.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/kpartx/bsd.o differ
Binary files root/workspace/multipath-tools-0.4.7/kpartx/crc32.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/kpartx/crc32.o differ
Binary files root/workspace/multipath-tools-0.4.7/kpartx/dasd.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/kpartx/dasd.o differ
Binary files root/workspace/multipath-tools-0.4.7/kpartx/devmapper.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/kpartx/devmapper.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/kpartx/dos.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/kpartx/dos.o differ
Binary files root/workspace/multipath-tools-0.4.7/kpartx/gpt.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/kpartx/gpt.o differ
Binary files root/workspace/multipath-tools-0.4.7/kpartx/kpartx and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/kpartx/kpartx differ
Binary files root/workspace/multipath-tools-0.4.7/kpartx/kpartx.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/kpartx/kpartx.o differ
Binary files root/workspace/multipath-tools-0.4.7/kpartx/kpartx.static 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/kpartx/kpartx.static 
differ
Binary files root/workspace/multipath-tools-0.4.7/kpartx/lopart.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/kpartx/lopart.o differ
Binary files root/workspace/multipath-tools-0.4.7/kpartx/mac.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/kpartx/mac.o differ
Binary files root/workspace/multipath-tools-0.4.7/kpartx/solaris.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/kpartx/solaris.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/kpartx/unixware.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/kpartx/unixware.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/kpartx/xstrncpy.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/kpartx/xstrncpy.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/libcheckers/cciss_tur.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libcheckers/cciss_tur.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libcheckers/checkers.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libcheckers/checkers.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libcheckers/directio.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libcheckers/directio.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/libcheckers/emc_clariion.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libcheckers/emc_clariion.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libcheckers/hp_sw.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libcheckers/hp_sw.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/libcheckers/libcheckers-glibc.a and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libcheckers/libcheckers-glibc.a 
differ
Binary files root/workspace/multipath-tools-0.4.7/libcheckers/rdac.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libcheckers/rdac.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/libcheckers/readsector0.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libcheckers/readsector0.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libcheckers/tur.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libcheckers/tur.o 
differ
diff -U 3 -H -d -r -N -x .cproject -x .project -- 
root/workspace/multipath-tools-0.4.7/libmultipath/alias.c 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/alias.c
--- root/workspace/multipath-tools-0.4.7/libmultipath/alias.c   
 2008-06-12 18:47:41.000000000 -0400
+++ 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/alias.c   
 2007-06-11 19:24:09.000000000 -0400
@@ -1,7 +1,6 @@
 /*
  * Copyright (c) 2005 Christophe Varoqui
  * Copyright (c) 2005 Benjamin Marzinski, Redhat
- * Copyright (c) 2008 David Davidson
  */
 #include <stdlib.h>
 #include <sys/types.h>
@@ -17,8 +16,6 @@
 #include "debug.h"
 #include "uxsock.h"
 #include "alias.h"
-#include "callout.h"
-
 
 
 /*
@@ -182,21 +179,9 @@
     return -1;
 }
 
-/*if this wwid is in the binding file set it to alias otherwise
-     * return the last used X in mpathX.*/
 
-/* By:        Unknown
- * Modified:David Davidson    - 06/12/2008
- * Purpose:    Scans the binding file. If the specified wwid is in it 
set *map_alias
- *             to the alias. Otherwise leave *map_alias Null and return 
the last
- *             used X in mpathX.
- * Input:    filtered_name - the filter that is going to be used in 
deciding a name.
- *             map_wwid - the wwid to use.
- * Output:    map_alias - Only if this wwid was in the binding file.
- *             returns the last used X by a mpathX.
- */
 static int
-lookup_binding(FILE *f, char *map_wwid, char **map_alias,char 
*filtered_name)
+lookup_binding(FILE *f, char *map_wwid, char **map_alias)
 {
     char buf[LINE_MAX];
     unsigned int line_nr = 0;
@@ -208,7 +193,6 @@
         char *c, *alias, *wwid;
         int curr_id;
 
-        /*skip all header info*/
         line_nr++;
         c = strpbrk(buf, "#\n\r");
         if (c)
@@ -216,13 +200,8 @@
         alias = strtok(buf, " \t");
         if (!alias) /* blank line */
             continue;
-        
-        /* Keep track of the highest used X in mpathX incase this is a 
simple
-         * userfreindly name*/
-        if((strcmp(filtered_name,"mpath") == 0)
-                && ((sscanf(alias, "mpath%d", &curr_id) == 1) && 
(curr_id >= id))) {
+        if (sscanf(alias, "mpath%d", &curr_id) == 1 && curr_id >= id)
             id = curr_id + 1;
-        }
         wwid = strtok(NULL, " \t");
         if (!wwid){
             condlog(3,
@@ -230,7 +209,6 @@
                 line_nr);
             continue;
         }
-        /*if the wwid was found return the associated alias.*/
         if (strcmp(wwid, map_wwid) == 0){
             condlog(3, "Found matching wwid [%s] in bindings file."
                 "\nSetting alias to %s", wwid, alias);
@@ -288,17 +266,8 @@
     return id;
 }    
 
-/* By:        Unknown
- * Modified    David Davidson    - 06/12/2008
- * Purpose:    
- * Input:    *wwid - the wwid to reserve.
- *             *filtered_name - the alias to use.
- *             id    - the last use X in mpathX, only relevent if 
filtered_name is mpath
- * Output:    returns the user friendly alias.
- */
-
 static char *
-allocate_binding(int fd, char *wwid, int id,char *filtered_name)
+allocate_binding(int fd, char *wwid, int id)
 {
     char buf[LINE_MAX];
     off_t offset;
@@ -309,12 +278,7 @@
         return NULL;
     }
     
-    /* digit appended only if alias is mpath, all other aliases must be 
unique*/
-    if (strcmp(filtered_name,"mpath") == 0){
-        snprintf(buf, LINE_MAX, "mpath%d %s\n", id, wwid);
-    } else {
-        snprintf(buf, LINE_MAX, "%s %s\n", filtered_name, wwid);
-    }
+    snprintf(buf, LINE_MAX, "mpath%d %s\n", id, wwid);
     buf[LINE_MAX - 1] = '\0';
 
     offset = lseek(fd, 0, SEEK_END);
@@ -342,29 +306,14 @@
     return alias;
 }        
 
-/* By:        Unknown
- * Modified    David Davidson    - 06/12/2008
- * Purpose:    Format a user friendly alias for a specified wwid.
- *             Will check and see if the wwid was already allocated
- *             in the binding file and if so use that above all else.
- *             If not wwid will asign alias depending on whether a filter
- *             is set and will add the new alias to the binding file.
- * Input:    *wwid - the wwid to base the name on.
- *             *filter - the user_friendly_filter otherwise NULL.
- *             *file    - path of binding file.
- * Output:    returns the user friendly alias.
- */
 char *
-get_user_friendly_alias(char *wwid, char *file,char *filter)
+get_user_friendly_alias(char *wwid, char *file)
 {
-    char upstream[256];
-    char out[256];
     char *alias;
     int fd, scan_fd, id;
     FILE *f;
     int can_write;
 
-    /* Open the binding file and run all checks. */
     if (!wwid || *wwid == '\0') {
         condlog(3, "Cannot find binding for empty WWID");
         return NULL;
@@ -390,34 +339,18 @@
         close(fd);
         return NULL;
     }
-    
-    /* Decide what kind of name is going to be used either a filtered 
output
-     * or mpathX if no filter was set.*/
-    if(filter != NULL){
-        strcpy(upstream, "/bin/echo ");
-        strcat(upstream,wwid);
-        execute_piped_program(upstream, 255, filter, 255, out);    
-    }else{
-        strcpy(out, "mpath");
-    }    
-    
-    
-    /* check for wwid */
-    id = lookup_binding(f, wwid, &alias, out);
-    
-    /* If there was a problem, returning NULL will set the alias to the 
wwid*/
+
+    id = lookup_binding(f, wwid, &alias);
     if (id < 0) {
         fclose(f);
         close(scan_fd);
         close(fd);
         return NULL;
-    }    
-    
-    /* if wwid wasn't in the binding file write the new one*/
-    if (!alias && can_write){        
-        alias = allocate_binding(fd, wwid, id,out);        
     }
-    
+
+    if (!alias && can_write)
+        alias = allocate_binding(fd, wwid, id);
+
     fclose(f);
     close(scan_fd);
     close(fd);
diff -U 3 -H -d -r -N -x .cproject -x .project -- 
root/workspace/multipath-tools-0.4.7/libmultipath/alias.h 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/alias.h
--- root/workspace/multipath-tools-0.4.7/libmultipath/alias.h   
 2008-06-03 16:45:13.000000000 -0400
+++ 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/alias.h   
 2006-06-06 14:32:43.000000000 -0400
@@ -8,6 +8,5 @@
 "# alias wwid\n" \
 "#\n"
 
-char *get_user_friendly_alias(char *wwid, char *file,char *filter);
+char *get_user_friendly_alias(char *wwid, char *file);
 char *get_user_friendly_wwid(char *alias, char *file);
-
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/alias.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/alias.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/libmultipath/blacklist.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/blacklist.o 
differ
diff -U 3 -H -d -r -N -x .cproject -x .project -- 
root/workspace/multipath-tools-0.4.7/libmultipath/callout.c 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/callout.c
--- root/workspace/multipath-tools-0.4.7/libmultipath/callout.c   
 2008-06-12 18:48:54.000000000 -0400
+++ 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/callout.c   
 2006-06-06 14:32:43.000000000 -0400
@@ -3,7 +3,6 @@
  *
  * Copyrights of the source file apply
  * Copyright (c) 2004 Christophe Varoqui
- * Copyright (c) 2008 David Davidson
  */
 #include <stdio.h>
 #include <sys/stat.h>
@@ -19,7 +18,6 @@
 #include "vector.h"
 #include "structs.h"
 #include "debug.h"
-#include "callout.h"
 
 #define PROGRAM_SIZE    100
 #define FIELD_PROGRAM
@@ -30,167 +28,94 @@
     strncpy(to, from, sizeof(to)-1); \
 } while (0)
 
-/* By:            Christophe Varoqui        
- * Modified:    David Davidson    - 06/12/2008
- * Purpose:        To execute a program at the system shell.
- * Input:        *path containing the command to be executed
- * Output:        *value containing the output of the command.
- *                 0 for success -1 if unsuccessful
- */
-int execute_program(char *path, char *value, int len){
-    // just pass it to the downstream of the pipe
-    return execute_piped_program(NULL, 0, path, len, value);    
-}
-
-/* By:            David Davidson    - 06/12/2008
- * Purpose:        To execute a program at the system shell.
- *                 We create a double piped set of child proccesses
- *                 that pass data one to aother and then returns the
- *                 final data to us.  
- * Input:        *upstr_cmd and *downstr_cmd containing both commands
- *                 so "echo hi | cat" would have *upstr_cmd set to echo hi
- *                 and *downstr_cmd set to cat
- * Output:        *value containing the output of the command.
- *                 0 for success -1 if unsuccessful
- *          ----
- *          |P1|
- *          ----
- *              \
- *               ---------
- *                       |
- *   1|pipe1|0   1|pipe2|0
- *    \      \   |      
- *      \     |  |
- *    ----    ----
- *    |P2|    |P3|
- *    ----    ----
- */
-int execute_piped_program(char *upstr_cmd, int upstr_len, char 
*downstr_cmd, int downstr_len, char *value) {
+int execute_program(char *path, char *value, int len)
+{
     int retval;
+    int count;
     int status;
-    char *upstr_argv[PROGRAM_SIZE];
-    char *downstr_argv[PROGRAM_SIZE];
-    int pipefd1[2];
-    int pipefd2[2];
+    int fds[2];
+    pid_t pid;
+    char *pos;
+    char arg[PROGRAM_SIZE];
+    char *argv[sizeof(arg) / 2];
+    int i;
 
-    //create both pipes
-    //pipe 1 used to pass output of upstream to down stream
-    if (pipe(pipefd1) == -1) {
-        perror("Error in pipe");
-        exit(1);
-    }
-    //pipe 2 returns the down stream to the calling program....us
-    if (pipe(pipefd2) == -1) {
-        perror("Error in pipe");
-        exit(1);
-    }
-    
-    
-    // Create the downstream process and connect its standard input to 
the pipe
-    if (fork() == 0) {
-        format_command(downstr_argv, downstr_cmd);
-        dup2(pipefd1[0], 0);
-        close(pipefd1[1]);
-        dup2(pipefd2[1], 1);
-        close(pipefd2[0]);        
-        execv(downstr_argv[0], downstr_argv);
-        perror("Error in downstream");//should never get here. If we do 
error.
-        return -1;
+    i = 0;
+
+    if (strchr(path, ' ')) {
+        strfieldcpy(arg, path);
+        pos = arg;
+        while (pos != NULL) {
+            if (pos[0] == '\'') {
+                /* don't separate if in apostrophes */
+                pos++;
+                argv[i] = strsep(&pos, "\'");
+                while (pos[0] == ' ')
+                    pos++;
+            } else {
+                argv[i] = strsep(&pos, " ");
+            }
+            i++;
+        }
+    } else {
+        argv[i++] = path;
     }
-    
-    // Create the upstream process and connect its standard output to 
the pipe
-    // Downstream must be used. Upstream is optional.
-    if ((upstr_len !=0) && (fork() == 0)) {
-        format_command(upstr_argv, upstr_cmd);
-        dup2(pipefd1[1], 1);
-        close(pipefd1[0]);
-        close(pipefd2[0]);
-        close(pipefd2[1]);
-        execv(upstr_argv[0], upstr_argv);//should never get here. If we 
do error.        
-        perror("Error in upstream");
+    argv[i] =  NULL;
+
+    retval = pipe(fds);
+
+    if (retval != 0)
         return -1;
-    }        
-    
-    //close the unused stream.
-    close(pipefd2[1]);
-    close(pipefd1[0]);
-    close(pipefd1[1]);
-    wait(&status);
-    
-    retval = return_output(value,255,pipefd2[0]);
-    
-    if (!WIFEXITED(status) || (WEXITSTATUS(status) != 0))
-                retval = -1;
-    return retval;
-}
 
-/* By:        Christophe Varoqui        
- * Modified:David Davidson    - 06/12/2008
- * Purpose:    Copies the data from a pipes out put to a
- *             character array that can be returned..
- * Input:    a pipe from calling procces accessed using read
- * Output:    *value containing the output of the command.
- *             0 for success -1 if unsuccessful
- */
-int return_output(char *value, int len,int fds){
-    int retval;
-    int count;
-    int i;
-            retval = 0;
-            i = 0;
-            while (1) {
-                count = read(fds, value + i, len - i-1);
-                if (count <= 0)
-                    break;
 
-                i += count;
-                if (i >= len-1) {
-                    retval = -1;
-                    break;
-                }
-            }
-            
-            
+    pid = fork();
 
-            if (count < 0)
-                retval = -1;
+    switch(pid) {
+    case 0:
+        /* child */
+        close(STDOUT_FILENO);
 
-            if (i > 0 && value[i-1] == '\n')
-                i--;
-            value[i] = '\0';
-    
-            return retval;
-}
+        /* dup write side of pipe to STDOUT */
+        dup(fds[1]);
 
-/* By:        Christophe Varoqui        
- * Modified:David Davidson    - 06/12/2008
- * Purpose:    formats a string passed as path in to a array
- *             that can be used by the execv() function.
- * Input:    *path containing stirng to run (ex "/bin/echo hi")
- * Output:    * argv[] containing aray of args (ex "'/bin/echo' 'hi'")
- */
-void format_command(char * argv[], char *path){    
-    int i;
+        retval = execv(argv[0], argv);
 
-    i = 0;
-    if (strchr(path, ' ')) {        
-        while (path != NULL) {
-            if (path[0] == '\'') {
-                // don't separate if in apostrophes
-                path++;
-                argv[i] = strsep(&path, "\'");
-                while (path[0] == ' ')
-                    path++;
-            } else {
-                argv[i] = strsep(&path, " ");
+        exit(-1);
+    case -1:
+        return -1;
+    default:
+        /* parent reads from fds[0] */
+        close(fds[1]);
+        retval = 0;
+        i = 0;
+        while (1) {
+            count = read(fds[0], value + i, len - i-1);
+            if (count <= 0)
+                break;
+
+            i += count;
+            if (i >= len-1) {
+                retval = -1;
+                break;
             }
-            i++;
         }
-    } else {
-        argv[i++] = path;
+
+        if (count < 0)
+            retval = -1;
+
+        if (i > 0 && value[i-1] == '\n')
+            i--;
+        value[i] = '\0';
+
+        wait(&status);
+        close(fds[0]);
+
+        if (!WIFEXITED(status) || (WEXITSTATUS(status) != 0))
+            retval = -1;
     }
-    argv[i] = NULL;
+    return retval;
 }
+
 extern int
 apply_format (char * string, char * cmd, struct path * pp)
 {
diff -U 3 -H -d -r -N -x .cproject -x .project -- 
root/workspace/multipath-tools-0.4.7/libmultipath/callout.h 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/callout.h
--- root/workspace/multipath-tools-0.4.7/libmultipath/callout.h   
 2008-06-12 17:12:14.000000000 -0400
+++ 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/callout.h   
 2006-06-06 14:32:43.000000000 -0400
@@ -2,9 +2,6 @@
 #define _CALLOUT_H
 
 int execute_program(char *, char *, int);
-int execute_piped_program(char *, int , char *, int , char *);
-void format_command(char **, char * );
-int return_output(char *, int, int);
-int apply_format(char *, char *, struct path *);
+int apply_format (char *, char *, struct path *);
 
 #endif /* _CALLOUT_H */
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/callout.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/callout.o 
differ
diff -U 3 -H -d -r -N -x .cproject -x .project -- 
root/workspace/multipath-tools-0.4.7/libmultipath/config.h 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/config.h
--- root/workspace/multipath-tools-0.4.7/libmultipath/config.h   
 2008-05-29 15:15:08.000000000 -0400
+++ 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/config.h   
 2008-01-14 20:34:36.000000000 -0500
@@ -73,7 +73,6 @@
     char * features;
     char * hwhandler;
     char * bindings_file;
-    char * name_filter;
 
     vector keywords;
     vector mptable;
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/config.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/config.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/libmultipath/configure.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/configure.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/debug.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/debug.o 
differ
diff -U 3 -H -d -r -N -x .cproject -x .project -- 
root/workspace/multipath-tools-0.4.7/libmultipath/defaults.h 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/defaults.h
--- root/workspace/multipath-tools-0.4.7/libmultipath/defaults.h   
 2008-06-12 16:22:26.000000000 -0400
+++ 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/defaults.h   
 2006-06-06 14:32:43.000000000 -0400
@@ -1,5 +1,4 @@
 #define DEFAULT_GETUID        "/sbin/scsi_id -g -u -s /block/%n"
-#define DEFAULT_NAME_FILTER    "/bin/cat"
 #define DEFAULT_UDEVDIR        "/dev"
 #define DEFAULT_SELECTOR    "round-robin 0"
 #define DEFAULT_FEATURES    "0"
Binary files 
root/workspace/multipath-tools-0.4.7/libmultipath/defaults.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/defaults.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/libmultipath/devmapper.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/devmapper.o 
differ
diff -U 3 -H -d -r -N -x .cproject -x .project -- 
root/workspace/multipath-tools-0.4.7/libmultipath/dict.c 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/dict.c
--- root/workspace/multipath-tools-0.4.7/libmultipath/dict.c   
 2008-06-12 18:49:37.000000000 -0400
+++ 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/dict.c   
 2008-01-14 20:34:36.000000000 -0500
@@ -3,7 +3,6 @@
  * Copyright (c) 2004, 2005, 2006  Christophe Varoqui
  * Copyright (c) 2005 Benjamin Marzinski, Redhat
  * Copyright (c) 2005 Kiyoshi Ueda, NEC
- * Copyright (c) 2008 David Davidson
  */
 #include <checkers.h>
 
@@ -268,23 +267,6 @@
     FREE(buff);
     return 0;
 }
-/* By:        David Davidson    - 06/12/2008
- * Purpose:    To set the global config structures member name_filter to
- *             a command line specified by the user_friendly_filter token
- *             in the config file (/etc/multipath.conf)
- * Output:    0 if successful 1 if unsuccessful.    
- */
-
-static int
-names_filter(vector strvec)
-{
-    conf->name_filter = set_value(strvec);
-
-        if (!conf->name_filter)
-            return 1;
-        
-        return push_callout(conf->name_filter);    
-}
 
 static int
 bindings_file_handler(vector strvec)
@@ -1550,24 +1532,6 @@
     return snprintf(buff, len, "yes");
 }
 
-/* By:        David Davidson    - 06/12/2008
- * Purpose:    To check whether the user specified a value for 
user_friendly_filter
- *             in the config file.
- * Output:    0 if no value was specified or value equals the one 
specified in default.h
- *             char * buff containing the value otherwise.
- */
-static int
-snprint_def_names_filter (char * buff, int len, void * data)
-{
-    if (!conf->name_filter)
-            return 0;
-    
-    if ((strlen(conf->name_filter) == strlen( DEFAULT_NAME_FILTER )) &&
-            (strcmp(conf->name_filter, DEFAULT_NAME_FILTER) != 0))
-            return 0;
-    
-    return snprintf(buff, len, "%s", conf->name_filter);
-}
 static int
 snprint_def_bindings_file (char * buff, int len, void * data)
 {
@@ -1625,7 +1589,6 @@
     install_keyword("no_path_retry", &def_no_path_retry_handler, 
&snprint_def_no_path_retry);
     install_keyword("pg_timeout", &def_pg_timeout_handler, 
&snprint_def_pg_timeout);
     install_keyword("user_friendly_names", &names_handler, 
&snprint_def_user_friendly_names);
-    install_keyword("user_friendly_filter", &names_filter, 
&snprint_def_names_filter);
     install_keyword("bindings_file", &bindings_file_handler, 
&snprint_def_bindings_file);
     __deprecated install_keyword("default_selector", 
&def_selector_handler, NULL);
     __deprecated install_keyword("default_path_grouping_policy", 
&def_pgpolicy_handler, NULL);
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/dict.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/dict.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/libmultipath/discovery.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/discovery.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/libmultipath/dmparser.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/dmparser.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/hwtable.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/hwtable.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/libmultipath/libmultipath-glibc.a 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/libmultipath-glibc.a 
differ
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/lock.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/lock.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/log.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/log.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/libmultipath/log_pthread.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/log_pthread.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/memory.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/memory.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/parser.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/parser.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/libmultipath/pgpolicies.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/pgpolicies.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/print.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/print.o 
differ
diff -U 3 -H -d -r -N -x .cproject -x .project -- 
root/workspace/multipath-tools-0.4.7/libmultipath/propsel.c 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/propsel.c
--- root/workspace/multipath-tools-0.4.7/libmultipath/propsel.c   
 2008-06-12 18:48:08.000000000 -0400
+++ 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/propsel.c   
 2006-08-02 17:37:22.000000000 -0400
@@ -2,7 +2,6 @@
  * Copyright (c) 2004, 2005 Christophe Varoqui
  * Copyright (c) 2005 Benjamin Marzinski, Redhat
  * Copyright (c) 2005 Kiyoshi Ueda, NEC
- * Copyright (c) 2008 David Davidson
  */
 #include <stdio.h>
 
@@ -156,16 +155,6 @@
     return 0;
 }
 
-/* By:        Unknown
- * Modified:David Davidson    - 06/12/2008
- * Purpose:    Sets the proper alias for this path depending on specified
- *             naming instructions. If no naming option is set returns 
the wwid.
- *             as the alias.
- * Output:    Will set mp->alias depending on what is set in config file
- *             user_friendly_names:     will set the name to mpathXX
- *             user_friendly_filter:     will set it to the output of 
the cmd
- *             default:                the original wwid
- */
 extern int
 select_alias (struct multipath * mp)
 {
@@ -173,13 +162,9 @@
         mp->alias = mp->mpe->alias;
     else {
         mp->alias = NULL;
-        if(conf->name_filter){
-            mp->alias = get_user_friendly_alias(mp->wwid,
-                    conf->bindings_file,conf->name_filter);
-        } else if (conf->user_friendly_names) {
+        if (conf->user_friendly_names)
             mp->alias = get_user_friendly_alias(mp->wwid,
-                    conf->bindings_file,NULL);
-        }
+                    conf->bindings_file);
         if (mp->alias == NULL){
             char *alias;
             if ((alias = MALLOC(WWID_SIZE)) != NULL){
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/propsel.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/propsel.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/regex.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/regex.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/structs.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/structs.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/libmultipath/structs_vec.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/structs_vec.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/libmultipath/switchgroup.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/switchgroup.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/uevent.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/uevent.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/util.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/util.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/uxsock.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/uxsock.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/vector.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/vector.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/libmultipath/waiter.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/libmultipath/waiter.o 
differ
diff -U 3 -H -d -r -N -x .cproject -x .project -- 
root/workspace/multipath-tools-0.4.7/multipath/main.c 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipath/main.c
--- root/workspace/multipath-tools-0.4.7/multipath/main.c    2008-06-11 
18:18:02.000000000 -0400
+++ 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipath/main.c   
 2007-11-09 19:01:59.000000000 -0500
@@ -307,7 +307,7 @@
     extern char *optarg;
     extern int optind;
     int i, r = 1;
-    
+
     if (getuid() != 0) {
         fprintf(stderr, "need to be root\n");
         exit(1);
Binary files root/workspace/multipath-tools-0.4.7/multipath/main.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipath/main.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/multipath/mpath_ctl 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipath/mpath_ctl 
differ
Binary files root/workspace/multipath-tools-0.4.7/multipath/multipath 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipath/multipath 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/multipath/multipath.static and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipath/multipath.static 
differ
diff -U 3 -H -d -r -N -x .cproject -x .project -- 
root/workspace/multipath-tools-0.4.7/multipath.conf.annotated 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipath.conf.annotated
--- root/workspace/multipath-tools-0.4.7/multipath.conf.annotated   
 2008-06-12 18:58:56.000000000 -0400
+++ 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipath.conf.annotated   
 2008-01-14 20:34:36.000000000 -0500
@@ -133,17 +133,6 @@
 #    # values  : yes|no
 #    # default : no
 #    user_friendly_names no
-#    
-#    # name    : user_friendly_filter
-#    # scope   : multipath
-#    # desc    : If set to a command will use that command to format the
-#   #             user friendly name. Overrides user_friendly_names. 
Duplicates
-#    #            will retain their old names. Overridden by wwids that 
were
-#   #             previously used in binding file. Use full in clusters 
where
-#    #            user wants to ensure that every user friendly name is 
the same for
-#    #            every node.
-#    # default :  "/bin/sed s|^.\{29\}\(.\{2\}\)\(.\{2\}\)|lun_\1_\2|"
-#    user_friendly_filter "/bin/sed 
s|^.\{29\}\(.\{2\}\)\(.\{2\}\)|lun_\1_\2|"
 #
 #    #
 #    # name    : bindings_file
Binary files root/workspace/multipath-tools-0.4.7/multipathd/cli.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipathd/cli.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/multipathd/cli_handlers.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipathd/cli_handlers.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/multipathd/copy.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipathd/copy.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/multipathd/main.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipathd/main.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/multipathd/multipathd 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipathd/multipathd 
differ
Binary files root/workspace/multipath-tools-0.4.7/multipathd/pidfile.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipathd/pidfile.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/multipathd/uxclnt.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipathd/uxclnt.o 
differ
Binary files root/workspace/multipath-tools-0.4.7/multipathd/uxlsnr.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/multipathd/uxlsnr.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_alua/main.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_alua/main.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_alua/mpath_prio_alua 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_alua/mpath_prio_alua 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_alua/mpath_prio_alua.static 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_alua/mpath_prio_alua.static 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_alua/rtpg.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_alua/rtpg.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_emc/mpath_prio_emc 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_emc/mpath_prio_emc 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_emc/mpath_prio_emc.static 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_emc/mpath_prio_emc.static 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_emc/pp_emc.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_emc/pp_emc.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_hds_modular/mpath_prio_hds_modular 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_hds_modular/mpath_prio_hds_modular 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_hds_modular/mpath_prio_hds_modular.static 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_hds_modular/mpath_prio_hds_modular.static 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_hds_modular/pp_hds_modular.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_hds_modular/pp_hds_modular.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_netapp/mpath_prio_ontap 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_netapp/mpath_prio_ontap 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_netapp/mpath_prio_ontap.static 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_netapp/mpath_prio_ontap.static 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_netapp/pp_netapp.o 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_netapp/pp_netapp.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_rdac/mpath_prio_rdac 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_rdac/mpath_prio_rdac 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_rdac/mpath_prio_rdac.static 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_rdac/mpath_prio_rdac.static 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_rdac/pp_rdac.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_rdac/pp_rdac.o 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_tpc/mpath_prio_tpc 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_tpc/mpath_prio_tpc 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_tpc/mpath_prio_tpc.static 
and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_tpc/mpath_prio_tpc.static 
differ
Binary files 
root/workspace/multipath-tools-0.4.7/path_priority/pp_tpc/pp_tpc.o and 
usr/src/redhat/SOURCES/multipath-tools-0.4.7.rhel5.10/path_priority/pp_tpc/pp_tpc.o 
differ
