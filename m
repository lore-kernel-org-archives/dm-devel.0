From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 34/78] Check for valid DM_DEVICE_INFO before
	proceeding
Date: Mon, 16 Mar 2015 13:36:21 +0100
Message-ID: <1426509425-15978-35-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Calling 'DM_DEVICE_INFO' might succeed but the returned context
might refer to an invalid device. So one needs to check the 'exists'
field to avoid this.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 5e68aeb..1901052 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -615,6 +615,9 @@ dm_get_opencount (const char * mapname)
 	if (!dm_task_get_info(dmt, &info))
 		goto out;
 
+	if (!info.exists)
+		goto out;
+
 	r = info.open_count;
 out:
 	dm_task_destroy(dmt);
@@ -640,6 +643,9 @@ dm_get_major (char * mapname)
 	if (!dm_task_get_info(dmt, &info))
 		goto out;
 
+	if (!info.exists)
+		goto out;
+
 	r = info.major;
 out:
 	dm_task_destroy(dmt);
@@ -665,6 +671,9 @@ dm_get_minor (char * mapname)
 	if (!dm_task_get_info(dmt, &info))
 		goto out;
 
+	if (!info.exists)
+		goto out;
+
 	r = info.minor;
 out:
 	dm_task_destroy(dmt);
-- 
1.8.4.5
