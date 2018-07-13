From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 08/10] libmultipath: remove _filter_* blacklist
	functions
Date: Fri, 13 Jul 2018 14:39:13 -0500
Message-ID: <1531510755-16046-9-git-send-email-bmarzins@redhat.com>
References: <1531510755-16046-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1531510755-16046-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The one point of these functions was for _filter_path(), and that wasn't
improved by using them. Since filter_path() only printed one message at
the end, you could have situations where the wwid was blacklisted, but
the blacklist message included the vendor/product instead. Also, the
protocol and property messages were printed twice, and if the device was
on multiple whitelists, only the last one is printed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/blacklist.c | 168 +++++++++++++++++++----------------------------
 libmultipath/blacklist.h |   2 +-
 libmultipath/configure.c |   2 +-
 libmultipath/discovery.c |   2 +-
 4 files changed, 71 insertions(+), 103 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index fdd36f7..318ec03 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -294,161 +294,129 @@ log_filter (const char *dev, char *vendor, char *product, char *wwid,
 }
 
 int
-_filter_device (vector blist, vector elist, char * vendor, char * product)
+filter_device (vector blist, vector elist, char * vendor, char * product,
+	       char * dev)
 {
-	if (!vendor || !product)
-		return 0;
-	if (_blacklist_exceptions_device(elist, vendor, product))
-		return MATCH_DEVICE_BLIST_EXCEPT;
-	if (_blacklist_device(blist, vendor, product))
-		return MATCH_DEVICE_BLIST;
-	return 0;
-}
+	int r = MATCH_NOTHING;
 
-int
-filter_device (vector blist, vector elist, char * vendor, char * product)
-{
-	int r = _filter_device(blist, elist, vendor, product);
-	log_filter(NULL, vendor, product, NULL, NULL, NULL, r);
-	return r;
-}
+	if (vendor && product) {
+		if (_blacklist_exceptions_device(elist, vendor, product))
+			r = MATCH_DEVICE_BLIST_EXCEPT;
+		else if (_blacklist_device(blist, vendor, product))
+			r = MATCH_DEVICE_BLIST;
+	}
 
-int
-_filter_devnode (vector blist, vector elist, char * dev)
-{
-	if (!dev)
-		return 0;
-	if (_blacklist_exceptions(elist, dev))
-		return MATCH_DEVNODE_BLIST_EXCEPT;
-	if (_blacklist(blist, dev))
-		return MATCH_DEVNODE_BLIST;
-	return 0;
+	log_filter(dev, vendor, product, NULL, NULL, NULL, r);
+	return r;
 }
 
 int
 filter_devnode (vector blist, vector elist, char * dev)
 {
-	int r = _filter_devnode(blist, elist, dev);
+	int r = MATCH_NOTHING;
+
+	if (dev) {
+		if (_blacklist_exceptions(elist, dev))
+			r = MATCH_DEVNODE_BLIST_EXCEPT;
+		else if (_blacklist(blist, dev))
+			r = MATCH_DEVNODE_BLIST;
+	}
+
 	log_filter(dev, NULL, NULL, NULL, NULL, NULL, r);
 	return r;
 }
 
 int
-_filter_wwid (vector blist, vector elist, char * wwid)
-{
-	if (!wwid)
-		return 0;
-	if (_blacklist_exceptions(elist, wwid))
-		return MATCH_WWID_BLIST_EXCEPT;
-	if (_blacklist(blist, wwid))
-		return MATCH_WWID_BLIST;
-	return 0;
-}
-
-int
 filter_wwid (vector blist, vector elist, char * wwid, char * dev)
 {
-	int r = _filter_wwid(blist, elist, wwid);
+	int r = MATCH_NOTHING;
+
+	if (wwid) {
+		if (_blacklist_exceptions(elist, wwid))
+			r = MATCH_WWID_BLIST_EXCEPT;
+		else if (_blacklist(blist, wwid))
+			r = MATCH_WWID_BLIST;
+	}
+
 	log_filter(dev, NULL, NULL, wwid, NULL, NULL, r);
 	return r;
 }
 
-static int
-_filter_protocol (vector blist, vector elist, const char * protocol_str)
-{
-	if (_blacklist_exceptions(elist, protocol_str))
-		return MATCH_PROTOCOL_BLIST_EXCEPT;
-	if (_blacklist(blist, protocol_str))
-		return MATCH_PROTOCOL_BLIST;
-	return 0;
-}
-
 int
 filter_protocol(vector blist, vector elist, struct path * pp)
 {
 	char buf[PROTOCOL_BUF_SIZE];
-	int r;
+	int r = MATCH_NOTHING;
+
+	if (pp) {
+		snprint_path_protocol(buf, sizeof(buf), pp);
+
+		if (_blacklist_exceptions(elist, buf))
+			r = MATCH_PROTOCOL_BLIST_EXCEPT;
+		else if (_blacklist(blist, buf))
+			r = MATCH_PROTOCOL_BLIST;
+	}
 
-	snprint_path_protocol(buf, sizeof(buf), pp);
-	r = _filter_protocol(blist, elist, buf);
 	log_filter(pp->dev, NULL, NULL, NULL, NULL, buf, r);
 	return r;
 }
 
 int
-_filter_path (struct config * conf, struct path * pp)
+filter_path (struct config * conf, struct path * pp)
 {
 	int r;
 
 	r = filter_property(conf, pp->udev);
 	if (r > 0)
 		return r;
-	r = _filter_devnode(conf->blist_devnode, conf->elist_devnode,pp->dev);
+	r = filter_devnode(conf->blist_devnode, conf->elist_devnode, pp->dev);
 	if (r > 0)
 		return r;
-	r = _filter_device(conf->blist_device, conf->elist_device,
-			   pp->vendor_id, pp->product_id);
+	r = filter_device(conf->blist_device, conf->elist_device,
+			   pp->vendor_id, pp->product_id, pp->dev);
 	if (r > 0)
 		return r;
 	r = filter_protocol(conf->blist_protocol, conf->elist_protocol, pp);
 	if (r > 0)
 		return r;
-	r = _filter_wwid(conf->blist_wwid, conf->elist_wwid, pp->wwid);
+	r = filter_wwid(conf->blist_wwid, conf->elist_wwid, pp->wwid, pp->dev);
 	return r;
 }
 
 int
-filter_path (struct config * conf, struct path * pp)
-{
-	int r=_filter_path(conf, pp);
-	log_filter(pp->dev, pp->vendor_id, pp->product_id, pp->wwid, NULL,
-		   NULL, r);
-	return r;
-}
-
-int
-_filter_property (struct config *conf, const char *env)
-{
-	if (_blacklist_exceptions(conf->elist_property, env))
-		return MATCH_PROPERTY_BLIST_EXCEPT;
-	if (_blacklist(conf->blist_property, env))
-		return MATCH_PROPERTY_BLIST;
-
-	return 0;
-}
-
-int
 filter_property(struct config * conf, struct udev_device * udev)
 {
 	const char *devname = udev_device_get_sysname(udev);
 	struct udev_list_entry *list_entry;
-	int r;
-
-	if (!udev)
-		return 0;
-
-	udev_list_entry_foreach(list_entry,
+	const char *env = NULL;
+	int r = MATCH_NOTHING;
+
+	if (udev) {
+		/*
+		 * This is the inverse of the 'normal' matching;
+		 * the environment variable _has_ to match.
+		 */
+		r = MATCH_PROPERTY_BLIST_MISSING;
+		udev_list_entry_foreach(list_entry,
 				udev_device_get_properties_list_entry(udev)) {
-		const char *env;
-
-		env = udev_list_entry_get_name(list_entry);
-		if (!env)
-			continue;
 
-		r = _filter_property(conf, env);
-		if (r) {
-			log_filter(devname, NULL, NULL, NULL, env, NULL, r);
-			return r;
+			env = udev_list_entry_get_name(list_entry);
+			if (!env)
+				continue;
+			if (_blacklist_exceptions(conf->elist_property, env)) {
+				r = MATCH_PROPERTY_BLIST_EXCEPT;
+				break;
+			}
+			if (_blacklist(conf->blist_property, env)) {
+				r = MATCH_PROPERTY_BLIST;
+				break;
+			}
+			env = NULL;
 		}
 	}
 
-	/*
-	 * This is the inverse of the 'normal' matching;
-	 * the environment variable _has_ to match.
-	 */
-	log_filter(devname, NULL, NULL, NULL, NULL, NULL,
-		   MATCH_PROPERTY_BLIST_MISSING);
-	return MATCH_PROPERTY_BLIST_MISSING;
+	log_filter(devname, NULL, NULL, NULL, env, NULL, r);
+	return r;
 }
 
 static void free_ble(struct blentry *ble)
diff --git a/libmultipath/blacklist.h b/libmultipath/blacklist.h
index f7beef2..18903b6 100644
--- a/libmultipath/blacklist.h
+++ b/libmultipath/blacklist.h
@@ -35,7 +35,7 @@ int setup_default_blist (struct config *);
 int alloc_ble_device (vector);
 int filter_devnode (vector, vector, char *);
 int filter_wwid (vector, vector, char *, char *);
-int filter_device (vector, vector, char *, char *);
+int filter_device (vector, vector, char *, char *, char *);
 int filter_path (struct config *, struct path *);
 int filter_property(struct config *, struct udev_device *);
 int filter_protocol(vector, vector, struct path *);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 5c54f9b..09c3dcf 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1030,7 +1030,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 			invalid = 1;
 		pthread_cleanup_pop(1);
 		if (invalid) {
-			orphan_path(pp1, "wwid blacklisted");
+			orphan_path(pp1, "blacklisted");
 			continue;
 		}
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e58a3fa..0b1855d 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1887,7 +1887,7 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 
 	if (mask & DI_BLACKLIST && mask & DI_SYSFS) {
 		if (filter_device(conf->blist_device, conf->elist_device,
-				  pp->vendor_id, pp->product_id) > 0 ||
+				  pp->vendor_id, pp->product_id, pp->dev) > 0 ||
 		    filter_protocol(conf->blist_protocol, conf->elist_protocol,
 				    pp) > 0)
 			return PATHINFO_SKIPPED;
-- 
2.7.4
