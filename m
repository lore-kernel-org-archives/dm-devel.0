From: NeilBrown <neilb@suse.de>
Subject: [PATCH libdmraid-events 2/3] Fix some issues with use of
	snprintf
Date: Fri, 11 Dec 2009 14:22:57 +1100
Message-ID: <20091211032408.285980198@suse.de>
References: <20091211032255.766079509@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=snprint.fixes
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

Several times, the buf len argument passed to snprintf is a
'sizeof' something which is only vaguely related to the size of the buffer,
and in some cases is definitely larger than the buffer.
Also snprintf does not guarantee to produce a nul terminated string if
an overflow occurs.

So pass more appropriate buffer lengths and ensure result is nul
terminated.
Also make 'dm_num' large enough to hold more than a single digit.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 libdmraid-events.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- libdmraid-events.orig/libdmraid-events.c
+++ libdmraid-events/libdmraid-events.c
@@ -303,6 +303,7 @@ static char *_match_port(const char *vol
 			for(i = 0; i < curr->num_sata_drives; i++) 
 				if(curr->raid_mem[i].port_num>=0){
 				snprintf(port, 4, "%d", curr->raid_mem[i].port_num);
+				port[4] = 0;
 				memcpy(buf+strlen(buf), curr->raid_mem[i].dev_name, strlen(curr->raid_mem[i].dev_name));
 				memcpy(buf+strlen(buf), "=", 1);
 				memcpy(buf+strlen(buf), port, strlen(port));
@@ -378,7 +379,7 @@ static char *_get_dev_names(const char *
 	int num = 0;
 	FILE *fd;
 	char sys_path[BUF_SIZE];
-	char dm_num[2];
+	char dm_num[5];
 	char dm_mm[MAJOR_MINOR];
 	char f_mm[MAJOR_MINOR];
 	struct dm_task *dmt;
@@ -406,8 +407,10 @@ static char *_get_dev_names(const char *
 	memset(sys_path, 0, BUF_SIZE);
 	memcpy(sys_path, SYS_DM_PATH, strlen(SYS_DM_PATH));
 	memset(dm_mm, 0, MAJOR_MINOR);
-	snprintf(dm_mm, sizeof(info.major)+sizeof(info.minor), "%d:%d", info.major, info.minor);
-	snprintf(dm_num, sizeof(num = 0), "%d", num);
+	snprintf(dm_mm, MAJOR_MINOR-1, "%d:%d", info.major, info.minor);
+	num = 0;
+	snprintf(dm_num, sizeof(dm_num), "%d", num);
+
 			
 	while(!access(strncat(sys_path, dm_num, strlen(dm_num)), F_OK)) {
 				
@@ -423,7 +426,8 @@ static char *_get_dev_names(const char *
 			/* Reset string for next iteration */
 			memset(sys_path+strlen(SYS_DM_PATH), 0, 1);
 			num++;
-			snprintf(dm_num, sizeof(num), "%d", num);					
+			snprintf(dm_num, sizeof(dm_num), "%d", num);
+			dm_num[sizeof(dm_num)-1] = 0;
 			fclose(fd);
 			continue;
 		}
