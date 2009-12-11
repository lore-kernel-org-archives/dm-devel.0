From: NeilBrown <neilb@suse.de>
Subject: [PATCH libdmraid-events 1/3] Add some missing closedir
	calls.
Date: Fri, 11 Dec 2009 14:22:56 +1100
Message-ID: <20091211032402.781887148@suse.de>
References: <20091211032255.766079509@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=closedir-fixes
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

Two times opendir is called without a matching
closedir - so add those calls.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 libdmraid-events.c |    2 ++
 1 file changed, 2 insertions(+)

--- libdmraid-events.orig/libdmraid-events.c
+++ libdmraid-events/libdmraid-events.c
@@ -172,6 +172,7 @@ static int _repopulate(const char* devic
 						memcpy(test_path+strlen(sys_path), strchr(disk+1, '/')+1, strlen(strchr(disk+1, '/')+1));
 						if((dir = opendir(test_path)))
 						{
+							closedir(dir);
 							/* test path is for this raid volume */
 							memcpy(test_path+strlen(test_path), "/dev", 4);
 							if(!(fd = fopen(test_path, "r"))) {
@@ -959,6 +960,7 @@ int register_device(const char *device, 
 					if(!(dir = opendir(test_path)))
 						continue;
 					else {
+						closedir(dir);
 						/* test path is for this raid volume */
 						memcpy(rv_next->raid_mem[m].dev_name, scsi_dev, strlen(scsi_dev));
 						memset(rv_next->raid_mem[m].dev_name+strlen(scsi_dev), 0, 1);
