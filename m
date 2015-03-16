From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/78] Fixup wwid blacklist printing
Date: Mon, 16 Mar 2015 13:36:03 +0100
Message-ID: <1426509425-15978-17-git-send-email-hare@suse.de>
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

When a wwid is blacklisted the log message looks like
'(null): wwid XXX blacklisted'.
Fix it up by printing either the corresponding device or
avoid printing the '(null)' entry if no corresponding
device is given.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/blacklist.c  | 6 ++++--
 libmultipath/blacklist.h  | 2 +-
 libmultipath/configure.c  | 2 +-
 libmultipath/discovery.c  | 2 +-
 multipathd/cli_handlers.c | 2 +-
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 30c5031..2400eda 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -228,6 +228,8 @@ setup_default_blist (struct config * conf)
 	if (vendor && product)						\
 		condlog(3, "%s: (%s:%s) %s %s",				\
 			dev, vendor, product, (M), (S));		\
+	else if (wwid && !dev)						\
+		condlog(3, "%s: %s %s", wwid, (M), (S));		\
 	else if (wwid)							\
 		condlog(3, "%s: %s %s %s", dev, (M), wwid, (S));	\
 	else if (env)							\
@@ -328,10 +330,10 @@ _filter_wwid (vector blist, vector elist, char * wwid)
 }
 
 int
-filter_wwid (vector blist, vector elist, char * wwid)
+filter_wwid (vector blist, vector elist, char * wwid, char * dev)
 {
 	int r = _filter_wwid(blist, elist, wwid);
-	log_filter(NULL, NULL, NULL, wwid, NULL, r);
+	log_filter(dev, NULL, NULL, wwid, NULL, r);
 	return r;
 }
 
diff --git a/libmultipath/blacklist.h b/libmultipath/blacklist.h
index 0e90e9a..24a5fa5 100644
--- a/libmultipath/blacklist.h
+++ b/libmultipath/blacklist.h
@@ -32,7 +32,7 @@ struct blentry_device {
 int setup_default_blist (struct config *);
 int alloc_ble_device (vector);
 int filter_devnode (vector, vector, char *);
-int filter_wwid (vector, vector, char *);
+int filter_wwid (vector, vector, char *, char *);
 int filter_device (vector, vector, char *, char *);
 int filter_path (struct config *, struct path *);
 int filter_property(struct config *, struct udev_device *);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 9012258..c9f16c7 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1025,7 +1025,7 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 check:
 		if (refwwid && strlen(refwwid)) {
 			if (filter_wwid(conf->blist_wwid, conf->elist_wwid,
-					refwwid) > 0)
+					refwwid, NULL) > 0)
 			return 2;
 		}
 	}
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 948fa49..6d6a508 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1232,7 +1232,7 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	if (mask & DI_BLACKLIST && mask & DI_WWID) {
 		if (!strlen(pp->wwid) ||
 		    filter_wwid(conf->blist_wwid, conf->elist_wwid,
-				pp->wwid) > 0) {
+				pp->wwid, pp->dev) > 0) {
 			return PATHINFO_SKIPPED;
 		}
 	}
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 0ce1408..43372d3 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -494,7 +494,7 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 	param = convert_dev(param, 0);
 	condlog(2, "%s: add map (operator)", param);
 
-	if (filter_wwid(conf->blist_wwid, conf->elist_wwid, param) > 0) {
+	if (filter_wwid(conf->blist_wwid, conf->elist_wwid, param, NULL) > 0) {
 		*reply = strdup("blacklisted\n");
 		*len = strlen(*reply) + 1;
 		condlog(2, "%s: map blacklisted", param);
-- 
1.8.4.5
