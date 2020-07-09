From: mwilck@suse.com
Subject: [PATCH 13/35] libmultipath: constify blacklist code
Date: Thu,  9 Jul 2020 12:15:58 +0200
Message-ID: <20200709101620.6786-14-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/blacklist.c | 34 +++++++++++++++++++---------------
 libmultipath/blacklist.h | 17 +++++++++++------
 2 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index db58ccc..4964e70 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -121,7 +121,7 @@ int set_ble_device(vector blist, char * vendor, char * product, int origin)
 }
 
 static int
-match_reglist (vector blist, const char * str)
+match_reglist (const struct _vector *blist, const char *str)
 {
 	int i;
 	struct blentry * ble;
@@ -134,8 +134,8 @@ match_reglist (vector blist, const char * str)
 }
 
 static int
-match_reglist_device (const struct _vector *blist, const char * vendor,
-		    const char * product)
+match_reglist_device (const struct _vector *blist, const char *vendor,
+		      const char * product)
 {
 	int i;
 	struct blentry_device * ble;
@@ -155,8 +155,8 @@ match_reglist_device (const struct _vector *blist, const char * vendor,
 }
 
 static int
-find_blacklist_device (const struct _vector *blist, const char * vendor,
-		       const char * product)
+find_blacklist_device (const struct _vector *blist, const char *vendor,
+		       const char *product)
 {
 	int i;
 	struct blentry_device * ble;
@@ -231,8 +231,9 @@ setup_default_blist (struct config * conf)
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
@@ -277,8 +278,8 @@ log_filter (const char *dev, char *vendor, char *product, char *wwid,
 }
 
 int
-filter_device (vector blist, vector elist, char * vendor, char * product,
-	       char * dev)
+filter_device (const struct _vector *blist, const struct _vector *elist,
+	       const char *vendor, const char * product, const char *dev)
 {
 	int r = MATCH_NOTHING;
 
@@ -294,7 +295,8 @@ filter_device (vector blist, vector elist, char * vendor, char * product,
 }
 
 int
-filter_devnode (vector blist, vector elist, char * dev)
+filter_devnode (const struct _vector *blist, const struct _vector *elist,
+		const char *dev)
 {
 	int r = MATCH_NOTHING;
 
@@ -310,7 +312,8 @@ filter_devnode (vector blist, vector elist, char * dev)
 }
 
 int
-filter_wwid (vector blist, vector elist, char * wwid, char * dev)
+filter_wwid (const struct _vector *blist, const struct _vector *elist,
+	     const char *wwid, const char *dev)
 {
 	int r = MATCH_NOTHING;
 
@@ -326,7 +329,8 @@ filter_wwid (vector blist, vector elist, char * wwid, char * dev)
 }
 
 int
-filter_protocol(vector blist, vector elist, struct path * pp)
+filter_protocol(const struct _vector *blist, const struct _vector *elist,
+		const struct path *pp)
 {
 	char buf[PROTOCOL_BUF_SIZE];
 	int r = MATCH_NOTHING;
@@ -345,7 +349,7 @@ filter_protocol(vector blist, vector elist, struct path * pp)
 }
 
 int
-filter_path (struct config * conf, struct path * pp)
+filter_path (const struct config *conf, const struct path *pp)
 {
 	int r;
 
@@ -367,8 +371,8 @@ filter_path (struct config * conf, struct path * pp)
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
index 4305857..ed079f3 100644
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
 int store_ble (vector, char *, int);
 int set_ble_device (vector, char *, char *, int);
 void free_blacklist (vector);
-- 
2.26.2
