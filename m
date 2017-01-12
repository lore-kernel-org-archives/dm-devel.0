From: tang.junhui@zte.com.cn
Subject: [PATCH 01/11] libmultipath: add merge_id in "struct
	uevent" for uevents merging
Date: Thu, 12 Jan 2017 13:52:17 +0800
Message-ID: <1484200347-11188-2-git-send-email-tang.junhui@zte.com.cn>
References: <1484200347-11188-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1484200347-11188-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, bmarzins@redhat.com, hare@suse.de, mwilck@suse.com, bart.vanassche@sandisk.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn, tang.wenjun3@zte.com.cn
List-Id: dm-devel.ids

From: tang.junhui <tang.junhui@zte.com.cn>

merge_id is used for uevents merging, it is expected to be same with wwid,
uevents with the same merge_id will be merged, and if it is same with
wwid, only the last uevent will call domap(). now we only merge uevents
with label ID_SERIAL or ID_UID in uevent, which usually comming from SCSI
or DASD device.

Change-Id: Ie6b076363b3735dc7de10184b27fa799b499af0e
Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/uevent.c | 16 ++++++++++++++++
 libmultipath/uevent.h |  1 +
 2 files changed, 17 insertions(+)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 7edcce1..5bde864 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -424,6 +424,22 @@ struct uevent *uevent_from_udev_device(struct udev_device *dev)
 			uev->devpath = uev->envp[i] + 8;
 		if (strcmp(name, "ACTION") == 0)
 			uev->action = uev->envp[i] + 7;
+
+		/*
+		 * merge_id used for uevents merging
+		 * it is expected to be same with wwid, 
+		 * uevents with the same merge_id
+		 * will be merged, and if it is same with wwid
+		 * only the last uevent will call domap()
+		 * now we only merge uevents with
+		 * label ID_SERIAL or ID_UID, which usually comming
+		 * from SCSI or DASD device
+		 */
+		if (strcmp(name, "ID_SERIAL") == 0)
+			uev->merge_id = uev->envp[i] + 10;
+		else if (strcmp(name, "ID_UID") == 0)	
+			uev->merge_id = uev->envp[i] + 7;
+
 		i++;
 		if (i == HOTPLUG_NUM_ENVP - 1)
 			break;
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 9d22dcd..3f83bab 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -22,6 +22,7 @@ struct uevent {
 	char *devpath;
 	char *action;
 	char *kernel;
+	char *merge_id;
 	unsigned long seqnum;
 	char *envp[HOTPLUG_NUM_ENVP];
 };
-- 
2.8.1.windows.1
