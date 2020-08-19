From: mwilck@suse.com
Subject: [PATCH v3 13/35] libmultipath: constify blacklist code
Date: Wed, 19 Aug 2020 15:17:20 +0200
Message-ID: <20200819131720.13290-2-mwilck@suse.com>
References: <20200819131720.13290-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200819131720.13290-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Add "const" qualifiers where appropriate.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/blacklist.c | 34 +++++++++++++++++++---------------
 libmultipath/blacklist.h | 17 +++++++++++------
 2 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index e39a7f8..6c6a597 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -139,7 +139,7 @@ out:
 }
 
 static int
-match_reglist (vector blist, const char * str)
+match_reglist (const struct _vector *blist, const char *str)
 {
 	int i;
 	struct blentry * ble;
@@ -152,8 +152,8 @@ match_reglist (vector blist, const char * str)
 }
 
 static int
-match_reglist_device (const struct _vector *blist, const char * vendor,
-		    const char * product)
+match_reglist_device (const struct _vector *blist, const char *vendor,
+		      const char * product)
 {
 	int i;
 	struct blentry_device * ble;
@@ -173,8 +173,8 @@ match_reglist_device (const struct _vector *blist, const char * vendor,
 }
 
 static int
-find_blacklist_device (const struct _vector *blist, const char * vendor,
-		       const char * product)
+find_blacklist_device (const struct _vector *blist, const char *vendor,
+		       const char *product)
 {
 	int i;
 	struct blentry_device * ble;
@@ -240,8 +240,9 @@ setup_default_blist (struct config * conf)
 		condlog(lvl, "%s: %s %s", dev, (M), (S))
 
 static void
-log_filter (const char *dev, char *vendor, char *product, char *wwid,
-	    const char *env, const char *protocol, int r, int lvl)
+log_filter (const char *dev, const char *vendor, const char *product,
+	    const char *wwid, const char *env, const char *protocol,
+	    int r, int lvl)
 {
 	/*
 	 * Try to sort from most likely to least.
@@ -286,8 +287,8 @@ log_filter (const char *dev, char *vendor, char *product, char *wwid,
 }
 
 int
-filter_device (vector blist, vector elist, char * vendor, char * product,
-	       char * dev)
+filter_device (const struct _vector *blist, const struct _vector *elist,
+	       const char *vendor, const char * product, const char *dev)
 {
 	int r = MATCH_NOTHING;
 
@@ -303,7 +304,8 @@ filter_device (vector blist, vector elist, char * vendor, char * product,
 }
 
 int
-filter_devnode (vector blist, vector elist, char * dev)
+filter_devnode (const struct _vector *blist, const struct _vector *elist,
+		const char *dev)
 {
 	int r = MATCH_NOTHING;
 
@@ -319,7 +321,8 @@ filter_devnode (vector blist, vector elist, char * dev)
 }
 
 int
-filter_wwid (vector blist, vector elist, char * wwid, char * dev)
+filter_wwid (const struct _vector *blist, const struct _vector *elist,
+	     const char *wwid, const char *dev)
 {
 	int r = MATCH_NOTHING;
 
@@ -335,7 +338,8 @@ filter_wwid (vector blist, vector elist, char * wwid, char * dev)
 }
 
 int
-filter_protocol(vector blist, vector elist, struct path * pp)
+filter_protocol(const struct _vector *blist, const struct _vector *elist,
+		const struct path *pp)
 {
 	char buf[PROTOCOL_BUF_SIZE];
 	int r = MATCH_NOTHING;
@@ -354,7 +358,7 @@ filter_protocol(vector blist, vector elist, struct path * pp)
 }
 
 int
-filter_path (struct config * conf, struct path * pp)
+filter_path (const struct config *conf, const struct path *pp)
 {
 	int r;
 
@@ -376,8 +380,8 @@ filter_path (struct config * conf, struct path * pp)
 }
 
 int
-filter_property(struct config *conf, struct udev_device *udev, int lvl,
-		const char *uid_attribute)
+filter_property(const struct config *conf, struct udev_device *udev,
+		int lvl, const char *uid_attribute)
 {
 	const char *devname = udev_device_get_sysname(udev);
 	struct udev_list_entry *list_entry;
diff --git a/libmultipath/blacklist.h b/libmultipath/blacklist.h
index b08e097..dde5cea 100644
--- a/libmultipath/blacklist.h
+++ b/libmultipath/blacklist.h
@@ -36,12 +36,17 @@ struct blentry_device {
 
 int setup_default_blist (struct config *);
 int alloc_ble_device (vector);
-int filter_devnode (vector, vector, char *);
-int filter_wwid (vector, vector, char *, char *);
-int filter_device (vector, vector, char *, char *, char *);
-int filter_path (struct config *, struct path *);
-int filter_property(struct config *, struct udev_device *, int, const char*);
-int filter_protocol(vector, vector, struct path *);
+int filter_devnode (const struct _vector *, const struct _vector *,
+		    const char *);
+int filter_wwid (const struct _vector *, const struct _vector *,
+		 const char *, const char *);
+int filter_device (const struct _vector *, const struct _vector *,
+		   const char *, const char *, const char *);
+int filter_path (const struct config *, const struct path *);
+int filter_property(const struct config *, struct udev_device *,
+		    int, const char*);
+int filter_protocol(const struct _vector *, const struct _vector *,
+		    const struct path *);
 int store_ble (vector, const char *, int);
 int set_ble_device (vector, const char *, const char *, int);
 void free_blacklist (vector);
-- 
2.28.0
