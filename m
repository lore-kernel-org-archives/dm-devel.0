From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 07/10] libmultipath: add "protocol" blacklist
	option.
Date: Fri, 13 Jul 2018 14:39:12 -0500
Message-ID: <1531510755-16046-8-git-send-email-bmarzins@redhat.com>
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

Multiple users have requested an easy way to setup blacklists that do
things such as blacklisting all non FC and iSCSI devices. Currently
there is no easy way to do this, without knowing in advance what the
devices are.  Looking into the udev property values, I didn't see a
consistent set of values that would worked for all the different types
of requests like this (which would have allowed us to solve this by
extending the "property" blacklist option to allow comparing values,
instead of just keywords).

Instead I've opted to allow multipath to blacklist/whitelist devices
by the protocol strings printed by "multipathd: add new protocol path
wildcard". This check happens after multipath checks the "device"
keyword, and before it checks wwid. This gives users an easily
understandible method to set up these types of blacklists, without
needing to know the exact arrays being used.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/blacklist.c   | 51 ++++++++++++++++++++++++++++++++++++++--------
 libmultipath/blacklist.h   |  3 +++
 libmultipath/config.c      | 15 ++++++++++++++
 libmultipath/config.h      |  2 ++
 libmultipath/dict.c        | 14 +++++++++++--
 libmultipath/discovery.c   |  5 +++--
 libmultipath/print.c       | 31 ++++++++++++++++++++++++++++
 multipath/multipath.conf.5 | 16 +++++++++++++--
 8 files changed, 123 insertions(+), 14 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 361c603..fdd36f7 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -12,6 +12,8 @@
 #include "structs.h"
 #include "config.h"
 #include "blacklist.h"
+#include "structs_vec.h"
+#include "print.h"
 
 int store_ble(vector blist, char * str, int origin)
 {
@@ -240,12 +242,14 @@ setup_default_blist (struct config * conf)
 		condlog(3, "%s: %s %s %s", dev, (M), wwid, (S));	\
 	else if (env)							\
 		condlog(3, "%s: %s %s %s", dev, (M), env, (S));		\
+	else if (protocol)						\
+		condlog(3, "%s: %s %s %s", dev, (M), protocol, (S));	\
 	else								\
 		condlog(3, "%s: %s %s", dev, (M), (S))
 
 void
 log_filter (const char *dev, char *vendor, char *product, char *wwid,
-	    const char *env, int r)
+	    const char *env, const char *protocol, int r)
 {
 	/*
 	 * Try to sort from most likely to least.
@@ -265,6 +269,9 @@ log_filter (const char *dev, char *vendor, char *product, char *wwid,
 	case MATCH_PROPERTY_BLIST:
 		LOG_BLIST("udev property", "blacklisted");
 		break;
+	case MATCH_PROTOCOL_BLIST:
+		LOG_BLIST("protocol", "blacklisted");
+		break;
 	case MATCH_DEVICE_BLIST_EXCEPT:
 		LOG_BLIST("vendor/product", "whitelisted");
 		break;
@@ -280,6 +287,9 @@ log_filter (const char *dev, char *vendor, char *product, char *wwid,
 	case MATCH_PROPERTY_BLIST_MISSING:
 		LOG_BLIST("blacklisted,", "udev property missing");
 		break;
+	case MATCH_PROTOCOL_BLIST_EXCEPT:
+		LOG_BLIST("protocol", "whitelisted");
+		break;
 	}
 }
 
@@ -299,7 +309,7 @@ int
 filter_device (vector blist, vector elist, char * vendor, char * product)
 {
 	int r = _filter_device(blist, elist, vendor, product);
-	log_filter(NULL, vendor, product, NULL, NULL, r);
+	log_filter(NULL, vendor, product, NULL, NULL, NULL, r);
 	return r;
 }
 
@@ -319,7 +329,7 @@ int
 filter_devnode (vector blist, vector elist, char * dev)
 {
 	int r = _filter_devnode(blist, elist, dev);
-	log_filter(dev, NULL, NULL, NULL, NULL, r);
+	log_filter(dev, NULL, NULL, NULL, NULL, NULL, r);
 	return r;
 }
 
@@ -339,7 +349,29 @@ int
 filter_wwid (vector blist, vector elist, char * wwid, char * dev)
 {
 	int r = _filter_wwid(blist, elist, wwid);
-	log_filter(dev, NULL, NULL, wwid, NULL, r);
+	log_filter(dev, NULL, NULL, wwid, NULL, NULL, r);
+	return r;
+}
+
+static int
+_filter_protocol (vector blist, vector elist, const char * protocol_str)
+{
+	if (_blacklist_exceptions(elist, protocol_str))
+		return MATCH_PROTOCOL_BLIST_EXCEPT;
+	if (_blacklist(blist, protocol_str))
+		return MATCH_PROTOCOL_BLIST;
+	return 0;
+}
+
+int
+filter_protocol(vector blist, vector elist, struct path * pp)
+{
+	char buf[PROTOCOL_BUF_SIZE];
+	int r;
+
+	snprint_path_protocol(buf, sizeof(buf), pp);
+	r = _filter_protocol(blist, elist, buf);
+	log_filter(pp->dev, NULL, NULL, NULL, NULL, buf, r);
 	return r;
 }
 
@@ -351,7 +383,6 @@ _filter_path (struct config * conf, struct path * pp)
 	r = filter_property(conf, pp->udev);
 	if (r > 0)
 		return r;
-
 	r = _filter_devnode(conf->blist_devnode, conf->elist_devnode,pp->dev);
 	if (r > 0)
 		return r;
@@ -359,6 +390,9 @@ _filter_path (struct config * conf, struct path * pp)
 			   pp->vendor_id, pp->product_id);
 	if (r > 0)
 		return r;
+	r = filter_protocol(conf->blist_protocol, conf->elist_protocol, pp);
+	if (r > 0)
+		return r;
 	r = _filter_wwid(conf->blist_wwid, conf->elist_wwid, pp->wwid);
 	return r;
 }
@@ -367,7 +401,8 @@ int
 filter_path (struct config * conf, struct path * pp)
 {
 	int r=_filter_path(conf, pp);
-	log_filter(pp->dev, pp->vendor_id, pp->product_id, pp->wwid, NULL, r);
+	log_filter(pp->dev, pp->vendor_id, pp->product_id, pp->wwid, NULL,
+		   NULL, r);
 	return r;
 }
 
@@ -402,7 +437,7 @@ filter_property(struct config * conf, struct udev_device * udev)
 
 		r = _filter_property(conf, env);
 		if (r) {
-			log_filter(devname, NULL, NULL, NULL, env, r);
+			log_filter(devname, NULL, NULL, NULL, env, NULL, r);
 			return r;
 		}
 	}
@@ -411,7 +446,7 @@ filter_property(struct config * conf, struct udev_device * udev)
 	 * This is the inverse of the 'normal' matching;
 	 * the environment variable _has_ to match.
 	 */
-	log_filter(devname, NULL, NULL, NULL, NULL,
+	log_filter(devname, NULL, NULL, NULL, NULL, NULL,
 		   MATCH_PROPERTY_BLIST_MISSING);
 	return MATCH_PROPERTY_BLIST_MISSING;
 }
diff --git a/libmultipath/blacklist.h b/libmultipath/blacklist.h
index 0b028d4..f7beef2 100644
--- a/libmultipath/blacklist.h
+++ b/libmultipath/blacklist.h
@@ -10,10 +10,12 @@
 #define MATCH_DEVNODE_BLIST  3
 #define MATCH_PROPERTY_BLIST 4
 #define MATCH_PROPERTY_BLIST_MISSING 5
+#define MATCH_PROTOCOL_BLIST 6
 #define MATCH_WWID_BLIST_EXCEPT     -MATCH_WWID_BLIST
 #define MATCH_DEVICE_BLIST_EXCEPT   -MATCH_DEVICE_BLIST
 #define MATCH_DEVNODE_BLIST_EXCEPT  -MATCH_DEVNODE_BLIST
 #define MATCH_PROPERTY_BLIST_EXCEPT -MATCH_PROPERTY_BLIST
+#define MATCH_PROTOCOL_BLIST_EXCEPT -MATCH_PROTOCOL_BLIST
 
 struct blentry {
 	char * str;
@@ -36,6 +38,7 @@ int filter_wwid (vector, vector, char *, char *);
 int filter_device (vector, vector, char *, char *);
 int filter_path (struct config *, struct path *);
 int filter_property(struct config *, struct udev_device *);
+int filter_protocol(vector, vector, struct path *);
 int store_ble (vector, char *, int);
 int set_ble_device (vector, char *, char *, int);
 void free_blacklist (vector);
diff --git a/libmultipath/config.c b/libmultipath/config.c
index afa309d..0aef186 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -623,11 +623,13 @@ free_config (struct config * conf)
 	free_blacklist(conf->blist_devnode);
 	free_blacklist(conf->blist_wwid);
 	free_blacklist(conf->blist_property);
+	free_blacklist(conf->blist_protocol);
 	free_blacklist_device(conf->blist_device);
 
 	free_blacklist(conf->elist_devnode);
 	free_blacklist(conf->elist_wwid);
 	free_blacklist(conf->elist_property);
+	free_blacklist(conf->elist_protocol);
 	free_blacklist_device(conf->elist_device);
 
 	free_mptable(conf->mptable);
@@ -780,6 +782,12 @@ load_config (char * file)
 		if (!conf->blist_property)
 			goto out;
 	}
+	if (conf->blist_protocol == NULL) {
+		conf->blist_protocol = vector_alloc();
+
+		if (!conf->blist_protocol)
+			goto out;
+	}
 
 	if (conf->elist_devnode == NULL) {
 		conf->elist_devnode = vector_alloc();
@@ -807,6 +815,13 @@ load_config (char * file)
 		if (!conf->elist_property)
 			goto out;
 	}
+	if (conf->elist_protocol == NULL) {
+		conf->elist_protocol = vector_alloc();
+
+		if (!conf->elist_protocol)
+			goto out;
+	}
+
 	if (setup_default_blist(conf))
 		goto out;
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 6bd42f0..7d0cd9a 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -210,10 +210,12 @@ struct config {
 	vector blist_wwid;
 	vector blist_device;
 	vector blist_property;
+	vector blist_protocol;
 	vector elist_devnode;
 	vector elist_wwid;
 	vector elist_device;
 	vector elist_property;
+	vector elist_protocol;
 };
 
 extern struct udev * udev;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 15e7582..32524d5 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1291,9 +1291,12 @@ blacklist_handler(struct config *conf, vector strvec)
 		conf->blist_device = vector_alloc();
 	if (!conf->blist_property)
 		conf->blist_property = vector_alloc();
+	if (!conf->blist_protocol)
+		conf->blist_protocol = vector_alloc();
 
 	if (!conf->blist_devnode || !conf->blist_wwid ||
-	    !conf->blist_device || !conf->blist_property)
+	    !conf->blist_device || !conf->blist_property ||
+	    !conf->blist_protocol)
 		return 1;
 
 	return 0;
@@ -1310,9 +1313,12 @@ blacklist_exceptions_handler(struct config *conf, vector strvec)
 		conf->elist_device = vector_alloc();
 	if (!conf->elist_property)
 		conf->elist_property = vector_alloc();
+	if (!conf->elist_protocol)
+		conf->elist_protocol = vector_alloc();
 
 	if (!conf->elist_devnode || !conf->elist_wwid ||
-	    !conf->elist_device || !conf->elist_property)
+	    !conf->elist_device || !conf->elist_property ||
+	    !conf->elist_protocol)
 		return 1;
 
 	return 0;
@@ -1356,6 +1362,8 @@ declare_ble_handler(blist_wwid)
 declare_ble_handler(elist_wwid)
 declare_ble_handler(blist_property)
 declare_ble_handler(elist_property)
+declare_ble_handler(blist_protocol)
+declare_ble_handler(elist_protocol)
 
 static int
 snprint_def_uxsock_timeout(struct config *conf, char * buff, int len,
@@ -1627,6 +1635,7 @@ init_keywords(vector keywords)
 	install_keyword_multi("devnode", &ble_blist_devnode_handler, &snprint_ble_simple);
 	install_keyword_multi("wwid", &ble_blist_wwid_handler, &snprint_ble_simple);
 	install_keyword_multi("property", &ble_blist_property_handler, &snprint_ble_simple);
+	install_keyword_multi("protocol", &ble_blist_protocol_handler, &snprint_ble_simple);
 	install_keyword_multi("device", &ble_device_handler, NULL);
 	install_sublevel();
 	install_keyword("vendor", &ble_blist_device_vendor_handler, &snprint_bled_vendor);
@@ -1636,6 +1645,7 @@ init_keywords(vector keywords)
 	install_keyword_multi("devnode", &ble_elist_devnode_handler, &snprint_ble_simple);
 	install_keyword_multi("wwid", &ble_elist_wwid_handler, &snprint_ble_simple);
 	install_keyword_multi("property", &ble_elist_property_handler, &snprint_ble_simple);
+	install_keyword_multi("protocol", &ble_elist_protocol_handler, &snprint_ble_simple);
 	install_keyword_multi("device", &ble_except_device_handler, NULL);
 	install_sublevel();
 	install_keyword("vendor", &ble_elist_device_vendor_handler, &snprint_bled_vendor);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 573d98b..e58a3fa 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1887,9 +1887,10 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 
 	if (mask & DI_BLACKLIST && mask & DI_SYSFS) {
 		if (filter_device(conf->blist_device, conf->elist_device,
-				  pp->vendor_id, pp->product_id) > 0) {
+				  pp->vendor_id, pp->product_id) > 0 ||
+		    filter_protocol(conf->blist_protocol, conf->elist_protocol,
+				    pp) > 0)
 			return PATHINFO_SKIPPED;
-		}
 	}
 
 	path_state = path_offline(pp);
diff --git a/libmultipath/print.c b/libmultipath/print.c
index ecfcb48..9da6a77 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1688,6 +1688,19 @@ int snprint_blacklist_report(struct config *conf, char *buff, int len)
 
 	if ((len - fwd - threshold) <= 0)
 		return len;
+	fwd += snprintf(buff + fwd, len - fwd, "protocol rules:\n"
+					       "- blacklist:\n");
+	if (!snprint_blacklist_group(buff, len, &fwd, &conf->blist_protocol))
+		return len;
+
+	if ((len - fwd - threshold) <= 0)
+		return len;
+	fwd += snprintf(buff + fwd, len - fwd, "- exceptions:\n");
+	if (snprint_blacklist_group(buff, len, &fwd, &conf->elist_protocol) == 0)
+		return len;
+
+	if ((len - fwd - threshold) <= 0)
+		return len;
 	fwd += snprintf(buff + fwd, len - fwd, "wwid rules:\n"
 					       "- blacklist:\n");
 	if (snprint_blacklist_group(buff, len, &fwd, &conf->blist_wwid) == 0)
@@ -1761,6 +1774,15 @@ static int snprint_blacklist(const struct config *conf, char *buff, int len)
 		if (fwd >= len)
 			return len;
 	}
+	vector_foreach_slot (conf->blist_protocol, ble, i) {
+		kw = find_keyword(conf->keywords, rootkw->sub, "protocol");
+		if (!kw)
+			return 0;
+		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
+				       kw, ble);
+		if (fwd >= len)
+			return len;
+	}
 	rootkw = find_keyword(conf->keywords, rootkw->sub, "device");
 	if (!rootkw)
 		return 0;
@@ -1838,6 +1860,15 @@ static int snprint_blacklist_except(const struct config *conf,
 		if (fwd >= len)
 			return len;
 	}
+	vector_foreach_slot (conf->elist_protocol, ele, i) {
+		kw = find_keyword(conf->keywords, rootkw->sub, "protocol");
+		if (!kw)
+			return 0;
+		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
+				       kw, ele);
+		if (fwd >= len)
+			return len;
+	}
 	rootkw = find_keyword(conf->keywords, rootkw->sub, "device");
 	if (!rootkw)
 		return 0;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index fb863fd..6333366 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1205,9 +1205,21 @@ The default \fIblacklist exception\fR is: \fB(SCSI_IDENT_|ID_WWN)\fR, causing
 well-behaved SCSI devices and devices that provide a WWN (World Wide Number)
 to be included, and all others to be excluded.
 .RE
+.TP
+.B protocol
+Regular expression for the protocol of a device to be excluded/included.
+.RS
+.PP
+The protocol strings that multipath recognizes are \fIscsi:fcp\fR,
+\fIscsi:spi\fR, \fIscsi:ssa\fR, \fIscsi:sbp\fR, \fIscsi:srp\fR,
+\fIscsi:iscsi\fR, \fIscsi:sas\fR, \fIscsi:adt\fR, \fIscsi:ata\fR,
+\fIscsi:unspec\fR, \fIccw\fR, \fIcciss\fR, \fInvme\fR, and \fIundef\fR.
+The protocol that a path is using can be viewed by running
+\fBmultipathd show paths format "%d %P"\fR
+.RE
 .LP
-For every device, these 4 blacklist criteria are evaluated in the the order
-"property, dev\%node, device, wwid". If a device turns out to be
+For every device, these 5 blacklist criteria are evaluated in the the order
+"property, dev\%node, device, protocol, wwid". If a device turns out to be
 blacklisted by any criterion, it's excluded from handling by multipathd, and
 the later criteria aren't evaluated any more. For each
 criterion, the whitelist takes precedence over the blacklist if a device
-- 
2.7.4
