From: mwilck@suse.com
Subject: [PATCH v2 01/21] multipathd: allow shutdown during
	configure()
Date: Thu, 24 Sep 2020 15:36:56 +0200
Message-ID: <20200924133716.14120-2-mwilck@suse.com>
References: <20200924133716.14120-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133716.14120-1-mwilck@suse.com>
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
Cc: Chongyun Wu <wu.chongyun@h3c.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

reconfigure() can be a long-running operation; both initial path
discovery and initial map setup can take a long time. Allow
the main program to indicate that the process should be
interrupted if a shutdown signal was received.

We take advantage of the dynamic linker's symbol lookup ordering
here. The default implementation of should_exit never returns
true, but callers (like multipathd) can override it.

Cc: Chongyun Wu <wu.chongyun@h3c.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c |  6 ++++++
 libmultipath/discovery.c |  3 +++
 libmultipath/util.c      |  5 +++++
 libmultipath/util.h      |  1 +
 multipathd/main.c        | 17 +++++++++++++++++
 5 files changed, 32 insertions(+)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index d7afc91..1c8aac0 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1173,6 +1173,12 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 
 	vector_foreach_slot (pathvec, pp1, k) {
 		int invalid;
+
+		if (should_exit()) {
+			ret = CP_FAIL;
+			goto out;
+		}
+
 		/* skip this path for some reason */
 
 		/* 1. if path has no unique id or wwid blacklisted */
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 2f301ac..8519ff1 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -200,6 +200,9 @@ path_discovery (vector pathvec, int flag)
 		const char *devtype;
 		const char *devpath;
 
+		if (should_exit())
+			break;
+
 		devpath = udev_list_entry_get_name(entry);
 		condlog(4, "Discover device %s", devpath);
 		udevice = udev_device_new_from_syspath(udev, devpath);
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 1dad90f..66cd721 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -430,3 +430,8 @@ void _log_bitfield_overflow(const char *f, unsigned int bit, unsigned int len)
 {
 	condlog(0, "%s: bitfield overflow: %u >= %u", f, bit, len);
 }
+
+int should_exit(void)
+{
+	return 0;
+}
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 0f0f6cb..c1ae878 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -27,6 +27,7 @@ int parse_prkey(const char *ptr, uint64_t *prkey);
 int parse_prkey_flags(const char *ptr, uint64_t *prkey, uint8_t *flags);
 int safe_write(int fd, const void *buf, size_t count);
 void set_max_fds(rlim_t max_fds);
+int should_exit(void);
 
 #define KERNEL_VERSION(maj, min, ptc) ((((maj) * 256) + (min)) * 256 + (ptc))
 #define ARRAY_SIZE(x) (sizeof(x)/sizeof((x)[0]))
diff --git a/multipathd/main.c b/multipathd/main.c
index eedc6c1..fa53e96 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -141,6 +141,11 @@ static inline enum daemon_status get_running_state(void)
 	return st;
 }
 
+int should_exit(void)
+{
+	return get_running_state() == DAEMON_SHUTDOWN;
+}
+
 /*
  * global copy of vecs for use in sig handlers
  */
@@ -2570,6 +2575,9 @@ configure (struct vectors * vecs)
 		goto fail;
 	}
 
+	if (should_exit())
+		goto fail;
+
 	conf = get_multipath_config();
 	pthread_cleanup_push(put_multipath_config, conf);
 	vector_foreach_slot (vecs->pathvec, pp, i){
@@ -2586,6 +2594,9 @@ configure (struct vectors * vecs)
 		goto fail;
 	}
 
+	if (should_exit())
+		goto fail;
+
 	/*
 	 * create new set of maps & push changed ones into dm
 	 * In the first call, use FORCE_RELOAD_WEAK to avoid making
@@ -2600,6 +2611,9 @@ configure (struct vectors * vecs)
 		goto fail;
 	}
 
+	if (should_exit())
+		goto fail;
+
 	/*
 	 * may need to remove some maps which are no longer relevant
 	 * e.g., due to blacklist changes in conf file
@@ -2611,6 +2625,9 @@ configure (struct vectors * vecs)
 
 	dm_lib_release();
 
+	if (should_exit())
+		goto fail;
+
 	sync_maps_state(mpvec);
 	vector_foreach_slot(mpvec, mpp, i){
 		if (remember_wwid(mpp->wwid) == 1)
-- 
2.28.0
