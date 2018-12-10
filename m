From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 06/24] libmultipath: avoid frequent messages
	from filter_property()
Date: Mon, 10 Dec 2018 10:49:41 +0100
Message-ID: <20181210094959.11338-7-mwilck@suse.com>
References: <20181210094959.11338-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181210094959.11338-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Unlike the other filter functions, filter_property() is called
on every pathinfo() call, and prints a message with -v3 every
time. Avoid that by using a lower log priority for the call
from pathinfo().

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/blacklist.c | 54 ++++++++++++++++++++--------------------
 libmultipath/blacklist.h |  2 +-
 libmultipath/configure.c |  6 ++---
 libmultipath/discovery.c |  2 +-
 tests/blacklist.c        |  7 +++---
 5 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 318ec03f..709895e2 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -232,24 +232,24 @@ setup_default_blist (struct config * conf)
 	return 0;
 }
 
-#define LOG_BLIST(M,S)							\
+#define LOG_BLIST(M, S, lvl)						\
 	if (vendor && product)						\
-		condlog(3, "%s: (%s:%s) %s %s",				\
+		condlog(lvl, "%s: (%s:%s) %s %s",			\
 			dev, vendor, product, (M), (S));		\
 	else if (wwid && !dev)						\
-		condlog(3, "%s: %s %s", wwid, (M), (S));		\
+		condlog(lvl, "%s: %s %s", wwid, (M), (S));		\
 	else if (wwid)							\
-		condlog(3, "%s: %s %s %s", dev, (M), wwid, (S));	\
+		condlog(lvl, "%s: %s %s %s", dev, (M), wwid, (S));	\
 	else if (env)							\
-		condlog(3, "%s: %s %s %s", dev, (M), env, (S));		\
+		condlog(lvl, "%s: %s %s %s", dev, (M), env, (S));	\
 	else if (protocol)						\
-		condlog(3, "%s: %s %s %s", dev, (M), protocol, (S));	\
+		condlog(lvl, "%s: %s %s %s", dev, (M), protocol, (S));	\
 	else								\
-		condlog(3, "%s: %s %s", dev, (M), (S))
+		condlog(lvl, "%s: %s %s", dev, (M), (S))
 
-void
+static void
 log_filter (const char *dev, char *vendor, char *product, char *wwid,
-	    const char *env, const char *protocol, int r)
+	    const char *env, const char *protocol, int r, int lvl)
 {
 	/*
 	 * Try to sort from most likely to least.
@@ -258,37 +258,37 @@ log_filter (const char *dev, char *vendor, char *product, char *wwid,
 	case MATCH_NOTHING:
 		break;
 	case MATCH_DEVICE_BLIST:
-		LOG_BLIST("vendor/product", "blacklisted");
+		LOG_BLIST("vendor/product", "blacklisted", lvl);
 		break;
 	case MATCH_WWID_BLIST:
-		LOG_BLIST("wwid", "blacklisted");
+		LOG_BLIST("wwid", "blacklisted", lvl);
 		break;
 	case MATCH_DEVNODE_BLIST:
-		LOG_BLIST("device node name", "blacklisted");
+		LOG_BLIST("device node name", "blacklisted", lvl);
 		break;
 	case MATCH_PROPERTY_BLIST:
-		LOG_BLIST("udev property", "blacklisted");
+		LOG_BLIST("udev property", "blacklisted", lvl);
 		break;
 	case MATCH_PROTOCOL_BLIST:
-		LOG_BLIST("protocol", "blacklisted");
+		LOG_BLIST("protocol", "blacklisted", lvl);
 		break;
 	case MATCH_DEVICE_BLIST_EXCEPT:
-		LOG_BLIST("vendor/product", "whitelisted");
+		LOG_BLIST("vendor/product", "whitelisted", lvl);
 		break;
 	case MATCH_WWID_BLIST_EXCEPT:
-		LOG_BLIST("wwid", "whitelisted");
+		LOG_BLIST("wwid", "whitelisted", lvl);
 		break;
 	case MATCH_DEVNODE_BLIST_EXCEPT:
-		LOG_BLIST("device node name", "whitelisted");
+		LOG_BLIST("device node name", "whitelisted", lvl);
 		break;
 	case MATCH_PROPERTY_BLIST_EXCEPT:
-		LOG_BLIST("udev property", "whitelisted");
+		LOG_BLIST("udev property", "whitelisted", lvl);
 		break;
 	case MATCH_PROPERTY_BLIST_MISSING:
-		LOG_BLIST("blacklisted,", "udev property missing");
+		LOG_BLIST("blacklisted,", "udev property missing", lvl);
 		break;
 	case MATCH_PROTOCOL_BLIST_EXCEPT:
-		LOG_BLIST("protocol", "whitelisted");
+		LOG_BLIST("protocol", "whitelisted", lvl);
 		break;
 	}
 }
@@ -306,7 +306,7 @@ filter_device (vector blist, vector elist, char * vendor, char * product,
 			r = MATCH_DEVICE_BLIST;
 	}
 
-	log_filter(dev, vendor, product, NULL, NULL, NULL, r);
+	log_filter(dev, vendor, product, NULL, NULL, NULL, r, 3);
 	return r;
 }
 
@@ -322,7 +322,7 @@ filter_devnode (vector blist, vector elist, char * dev)
 			r = MATCH_DEVNODE_BLIST;
 	}
 
-	log_filter(dev, NULL, NULL, NULL, NULL, NULL, r);
+	log_filter(dev, NULL, NULL, NULL, NULL, NULL, r, 3);
 	return r;
 }
 
@@ -338,7 +338,7 @@ filter_wwid (vector blist, vector elist, char * wwid, char * dev)
 			r = MATCH_WWID_BLIST;
 	}
 
-	log_filter(dev, NULL, NULL, wwid, NULL, NULL, r);
+	log_filter(dev, NULL, NULL, wwid, NULL, NULL, r, 3);
 	return r;
 }
 
@@ -357,7 +357,7 @@ filter_protocol(vector blist, vector elist, struct path * pp)
 			r = MATCH_PROTOCOL_BLIST;
 	}
 
-	log_filter(pp->dev, NULL, NULL, NULL, NULL, buf, r);
+	log_filter(pp->dev, NULL, NULL, NULL, NULL, buf, r, 3);
 	return r;
 }
 
@@ -366,7 +366,7 @@ filter_path (struct config * conf, struct path * pp)
 {
 	int r;
 
-	r = filter_property(conf, pp->udev);
+	r = filter_property(conf, pp->udev, 3);
 	if (r > 0)
 		return r;
 	r = filter_devnode(conf->blist_devnode, conf->elist_devnode, pp->dev);
@@ -384,7 +384,7 @@ filter_path (struct config * conf, struct path * pp)
 }
 
 int
-filter_property(struct config * conf, struct udev_device * udev)
+filter_property(struct config *conf, struct udev_device *udev, int lvl)
 {
 	const char *devname = udev_device_get_sysname(udev);
 	struct udev_list_entry *list_entry;
@@ -415,7 +415,7 @@ filter_property(struct config * conf, struct udev_device * udev)
 		}
 	}
 
-	log_filter(devname, NULL, NULL, NULL, env, NULL, r);
+	log_filter(devname, NULL, NULL, NULL, env, NULL, r, lvl);
 	return r;
 }
 
diff --git a/libmultipath/blacklist.h b/libmultipath/blacklist.h
index 18903b6b..4c8ec99e 100644
--- a/libmultipath/blacklist.h
+++ b/libmultipath/blacklist.h
@@ -37,7 +37,7 @@ int filter_devnode (vector, vector, char *);
 int filter_wwid (vector, vector, char *, char *);
 int filter_device (vector, vector, char *, char *, char *);
 int filter_path (struct config *, struct path *);
-int filter_property(struct config *, struct udev_device *);
+int filter_property(struct config *, struct udev_device *, int);
 int filter_protocol(vector, vector, struct path *);
 int store_ble (vector, char *, int);
 int set_ble_device (vector, char *, char *, int);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index ed3e30f5..406cd4c9 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1289,7 +1289,7 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		conf = get_multipath_config();
 		pthread_cleanup_push(put_multipath_config, conf);
 		if (pp->udev && pp->uid_attribute &&
-		    filter_property(conf, pp->udev) > 0)
+		    filter_property(conf, pp->udev, 3) > 0)
 			invalid = 1;
 		pthread_cleanup_pop(1);
 		if (invalid)
@@ -1329,7 +1329,7 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		conf = get_multipath_config();
 		pthread_cleanup_push(put_multipath_config, conf);
 		if (pp->udev && pp->uid_attribute &&
-		    filter_property(conf, pp->udev) > 0)
+		    filter_property(conf, pp->udev, 3) > 0)
 			invalid = 1;
 		pthread_cleanup_pop(1);
 		if (invalid)
@@ -1358,7 +1358,7 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		conf = get_multipath_config();
 		pthread_cleanup_push(put_multipath_config, conf);
 		if (pp->udev && pp->uid_attribute &&
-		    filter_property(conf, pp->udev) > 0)
+		    filter_property(conf, pp->udev, 3) > 0)
 			invalid = 1;
 		pthread_cleanup_pop(1);
 		if (invalid)
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3ad33492..1c87277f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1869,7 +1869,7 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 			return PATHINFO_SKIPPED;
 		}
 		if (is_claimed_by_foreign(pp->udev) ||
-			 filter_property(conf, pp->udev) > 0)
+		    filter_property(conf, pp->udev, 4) > 0)
 			return PATHINFO_SKIPPED;
 	}
 
diff --git a/tests/blacklist.c b/tests/blacklist.c
index a55c1c07..54d568f5 100644
--- a/tests/blacklist.c
+++ b/tests/blacklist.c
@@ -267,7 +267,8 @@ static void test_property_blacklist(void **state)
 	static struct udev_device udev = { "sdb", { "ID_FOO", "ID_WWN", "ID_BAR", NULL } };
 	conf.blist_property = blist_property_wwn;
 	expect_condlog(3, "sdb: udev property ID_WWN blacklisted\n");
-	assert_int_equal(filter_property(&conf, &udev), MATCH_PROPERTY_BLIST);
+	assert_int_equal(filter_property(&conf, &udev, 3),
+			 MATCH_PROPERTY_BLIST);
 }
 
 /* the property check works different in that you check all the property
@@ -280,7 +281,7 @@ static void test_property_whitelist(void **state)
 	static struct udev_device udev = { "sdb", { "ID_FOO", "ID_WWN", "ID_BAR", NULL } };
 	conf.elist_property = blist_property_wwn;
 	expect_condlog(3, "sdb: udev property ID_WWN whitelisted\n");
-	assert_int_equal(filter_property(&conf, &udev),
+	assert_int_equal(filter_property(&conf, &udev, 3),
 			 MATCH_PROPERTY_BLIST_EXCEPT);
 }
 
@@ -289,7 +290,7 @@ static void test_property_missing(void **state)
 	static struct udev_device udev = { "sdb", { "ID_FOO", "ID_BAZ", "ID_BAR", NULL } };
 	conf.blist_property = blist_property_wwn;
 	expect_condlog(3, "sdb: blacklisted, udev property missing\n");
-	assert_int_equal(filter_property(&conf, &udev),
+	assert_int_equal(filter_property(&conf, &udev, 3),
 			 MATCH_PROPERTY_BLIST_MISSING);
 }
 
-- 
2.19.2
