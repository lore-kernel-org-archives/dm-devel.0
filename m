From: tang.junhui@zte.com.cn
Subject: [PATCH 01/12] libmultipath: add wwid for "struct uevent"
	to record wwid of uevent
Date: Tue, 27 Dec 2016 16:03:18 +0800
Message-ID: <1482825809-9528-2-git-send-email-tang.junhui@zte.com.cn>
References: <1482825809-9528-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1482825809-9528-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, hare@suse.de, bmarzins@redhat.com, mwilck@suse.com, bart.vanassche@sandisk.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn, tang.wenjun3@zte.com.cn
List-Id: dm-devel.ids

From: tang.junhui <tang.junhui@zte.com.cn>

Add "char *wwid" to point WWID of uevent. This member identifies
the LUN ID which the path belongs to, and it is used for merging
uevents. WWID possibly did not exist in uevent yet, so ->wwid
would be NULL, those uevents would not be merged, but be proccessed
as old way.

Change-Id: Ie6b076363b3735dc7de10184b27fa799b499af0e
Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/uevent.c | 2 ++
 libmultipath/uevent.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 7edcce1..ef1bafe 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -424,6 +424,8 @@ struct uevent *uevent_from_udev_device(struct udev_device *dev)
 			uev->devpath = uev->envp[i] + 8;
 		if (strcmp(name, "ACTION") == 0)
 			uev->action = uev->envp[i] + 7;
+		if (strcmp(name, "ID_SERIAL") == 0)
+			uev->wwid = uev->envp[i] + 10;
 		i++;
 		if (i == HOTPLUG_NUM_ENVP - 1)
 			break;
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 9d22dcd..7bfccef 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -22,6 +22,7 @@ struct uevent {
 	char *devpath;
 	char *action;
 	char *kernel;
+	char *wwid;
 	unsigned long seqnum;
 	char *envp[HOTPLUG_NUM_ENVP];
 };
-- 
2.8.1.windows.1
