From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: Remove trailing whitespaces
Date: Fri, 17 Mar 2017 01:35:03 +0100
Message-ID: <20170317003503.4166-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libdmmp/docs/kernel-doc    |  2 +-
 libmultipath/uevent.c      | 12 ++++++------
 multipath/multipath.conf.5 |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/libdmmp/docs/kernel-doc b/libdmmp/docs/kernel-doc
index 030fc63..8f5b546 100644
--- a/libdmmp/docs/kernel-doc
+++ b/libdmmp/docs/kernel-doc
@@ -414,7 +414,7 @@ my $doc_com = '\s*\*\s*';
 my $doc_com_body = '\s*\* ?';
 my $doc_decl = $doc_com . '(\w+)';
 # @params and a strictly limited set of supported section names
-my $doc_sect = $doc_com . 
+my $doc_sect = $doc_com .
     '\s*(\@[.\w]+|\@\.\.\.|description|context|returns?|notes?|examples?)\s*:(.*)';
 my $doc_content = $doc_com_body . '(.*)';
 my $doc_block = $doc_com . 'DOC:\s*(.*)?';
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 367e129..4fbd1df 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -113,7 +113,7 @@ uevent_get_wwid(struct uevent *uev)
 
 	conf = get_multipath_config();
 	uid_attribute = parse_uid_attribute_by_attrs(conf->uid_attrs, uev->kernel);
-	put_multipath_config(conf);	
+	put_multipath_config(conf);
 
 	if (!uid_attribute)
 		return;
@@ -138,7 +138,7 @@ uevent_need_merge(void)
 	conf = get_multipath_config();
 	if (conf->uid_attrs)
 		need_merge = true;
-	put_multipath_config(conf);	
+	put_multipath_config(conf);
 
 	return need_merge;
 }
@@ -173,12 +173,12 @@ uevent_can_discard(struct uevent *uev)
 	if (uevent_can_discard_by_devpath(uev->devpath))
 		return true;
 
-	/* 
+	/*
 	 * do not filter dm devices by devnode
 	 */
 	if (!strncmp(uev->kernel, "dm-", 3))
 		return false;
-	/* 
+	/*
 	 * filter paths devices by devnode
 	 */
 	conf = get_multipath_config();
@@ -309,12 +309,12 @@ uevent_filter(struct uevent *later, struct list_head *tmpq)
 
 	list_for_some_entry_reverse_safe(earlier, tmp, &later->node, tmpq, node) {
 		/*
-		 * filter unnessary earlier uevents 
+		 * filter unnessary earlier uevents
 		 * by the later uevent
 		 */
 		if (uevent_can_filter(earlier, later)) {
 			condlog(2, "uevent: %s-%s has filtered by uevent: %s-%s",
-				earlier->kernel, earlier->action, 
+				earlier->kernel, earlier->action,
 				later->kernel, later->action);
 
 			list_del_init(&earlier->node);
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index efeead5..24decf7 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -208,7 +208,7 @@ The default is: \fBfailover\fR
 .
 .TP
 .B uid_attrs
-The udev attribute providing a unique path identifier for corresponding 
+The udev attribute providing a unique path identifier for corresponding
 type of path devices. If this field is configured and matched with type
 of device, it would override any other methods providing for device
 unique identifier in config file, and it would activate merging uevents
-- 
2.12.0
