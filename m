From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 44/72] libmultipath: trivial changes for
	-Wsign-compare
Date: Sat, 12 Oct 2019 21:28:32 +0000
Message-ID: <20191012212703.12989-45-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

All these are obious fixes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c                  |  2 +-
 libmultipath/devmapper.c              |  3 ++-
 libmultipath/discovery.c              | 17 ++++++++++-------
 libmultipath/file.c                   |  3 ++-
 libmultipath/foreign.c                |  2 +-
 libmultipath/parser.c                 |  2 +-
 libmultipath/prioritizers/alua_rtpg.c |  2 +-
 libmultipath/prioritizers/ana.c       |  7 ++++---
 libmultipath/structs.c                |  4 ++--
 libmultipath/structs.h                |  3 ++-
 libmultipath/sysfs.c                  |  6 +++---
 libmultipath/time-util.c              |  6 +++---
 libmultipath/uevent.c                 |  3 ++-
 libmultipath/util.c                   |  4 ++--
 libmultipath/util.h                   |  4 +++-
 libmultipath/uxsock.c                 |  3 ++-
 libmultipath/wwids.c                  |  4 ++--
 multipathd/main.c                     |  6 ++++--
 multipathd/pidfile.c                  |  2 +-
 19 files changed, 48 insertions(+), 35 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 0fc9e542..14401cae 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -256,7 +256,7 @@ allocate_binding(int fd, const char *wwid, int id, const char *prefix)
 			strerror(errno));
 		return NULL;
 	}
-	if (write(fd, buf, strlen(buf)) != strlen(buf)){
+	if (write(fd, buf, strlen(buf)) != (ssize_t)strlen(buf)){
 		condlog(0, "Cannot write binding to bindings file : %s",
 			strerror(errno));
 		/* clear partial write */
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index f478ac2d..4bff37d0 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1561,7 +1561,8 @@ int dm_reassign(const char *mapname)
 	struct dm_task *dmt;
 	struct dm_info info;
 	char dev_t[32], dm_dep[32];
-	int r = 0, i;
+	int r = 0;
+	unsigned int i;
 
 	if (dm_dev_t(mapname, &dev_t[0], 32)) {
 		condlog(3, "%s: failed to get device number", mapname);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 5fbc2ac7..c6c57430 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -224,7 +224,7 @@ out:
 ssize_t									\
 sysfs_get_##fname (struct udev_device * udev, char * buff, size_t len)	\
 {									\
-	int l;							\
+	size_t l;							\
 	const char * attr;						\
 	const char * devname;						\
 									\
@@ -945,7 +945,10 @@ get_geometry(struct path *pp)
 static int
 parse_vpd_pg80(const unsigned char *in, char *out, size_t out_len)
 {
-	int len = get_unaligned_be16(&in[2]);
+	size_t len = get_unaligned_be16(&in[2]);
+
+	if (out_len == 0)
+		return 0;
 
 	/*
 	 * Strip leading and trailing whitespace
@@ -958,8 +961,8 @@ parse_vpd_pg80(const unsigned char *in, char *out, size_t out_len)
 	}
 
 	if (len >= out_len) {
-		condlog(2, "vpd pg80 overflow, %d/%d bytes required",
-			len + 1, (int)out_len);
+		condlog(2, "vpd pg80 overflow, %lu/%lu bytes required",
+			len + 1, out_len);
 		len = out_len - 1;
 	}
 	if (len > 0) {
@@ -1725,7 +1728,7 @@ get_prio (struct path * pp)
  * Returns a pointer to the position where "end" was moved to.
  */
 static char
-*skip_zeroes_backward(char* start, int *len, char *end)
+*skip_zeroes_backward(char* start, size_t *len, char *end)
 {
 	char *p = end;
 
@@ -1751,10 +1754,10 @@ static char
  * Otherwise, returns 0.
  */
 static int
-fix_broken_nvme_wwid(struct path *pp, const char *value, int size)
+fix_broken_nvme_wwid(struct path *pp, const char *value, size_t size)
 {
 	static const char _nvme[] = "nvme.";
-	int len, i;
+	size_t len, i;
 	char mangled[256];
 	char *p;
 
diff --git a/libmultipath/file.c b/libmultipath/file.c
index 5cb06e1f..72f1d246 100644
--- a/libmultipath/file.c
+++ b/libmultipath/file.c
@@ -157,7 +157,8 @@ open_file(const char *file, int *can_write, const char *header)
 		if (*can_write == 0)
 			goto fail;
 		/* If file is empty, write the header */
-		size_t len = strlen(header);
+		int len = strlen(header);
+
 		if (write(fd, header, len) != len) {
 			condlog(0,
 				"Cannot write header to file %s : %s", file,
diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index f05db162..0159a83a 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -172,7 +172,7 @@ static int _init_foreign(const char *multipath_dir, const char *enable)
 	for (i = 0; i < r; i++) {
 		const char *msg, *fn, *c;
 		struct foreign *fgn;
-		int len, namesz;
+		size_t len, namesz;
 
 		fn = di[i]->d_name;
 
diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index e00c5fff..d478b177 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -124,7 +124,7 @@ find_keyword(vector keywords, vector v, char * name)
 {
 	struct keyword *keyword;
 	int i;
-	int len;
+	size_t len;
 
 	if (!name || !keywords)
 		return NULL;
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 271a019d..bbf5aac0 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -371,7 +371,7 @@ get_asymmetric_access_state(const struct path *pp, unsigned int tpg,
 	struct rtpg_data *	tpgd;
 	struct rtpg_tpg_dscr *	dscr;
 	int			rc;
-	int			buflen;
+	unsigned int		buflen;
 	uint64_t		scsi_buflen;
 	int fd = pp->fd;
 
diff --git a/libmultipath/prioritizers/ana.c b/libmultipath/prioritizers/ana.c
index 9f7adfa5..b5c7873d 100644
--- a/libmultipath/prioritizers/ana.c
+++ b/libmultipath/prioritizers/ana.c
@@ -62,7 +62,7 @@ static const char *anas_string[] = {
 static const char *aas_print_string(int rc)
 {
 	rc &= 0xff;
-	if (rc >= 0 && rc < ARRAY_SIZE(anas_string) &&
+	if (rc >= 0 && rc < (int)ARRAY_SIZE(anas_string) &&
 	    anas_string[rc] != NULL)
 		return anas_string[rc];
 
@@ -78,7 +78,8 @@ static int get_ana_state(__u32 nsid, __u32 anagrpid, void *ana_log,
 	size_t offset = sizeof(struct nvme_ana_rsp_hdr);
 	__u32 nr_nsids;
 	size_t nsid_buf_size;
-	int i, j;
+	int i;
+	unsigned int j;
 
 	for (i = 0; i < le16_to_cpu(hdr->ngrps); i++) {
 		ana_desc = base + offset;
@@ -225,7 +226,7 @@ int getprio(struct path *pp, __attribute__((unused)) char *args,
 	default:
 		break;
 	}
-	if (rc < 0 && -rc < ARRAY_SIZE(ana_errmsg))
+	if (rc < 0 && -rc < (int)ARRAY_SIZE(ana_errmsg))
 		condlog(2, "%s: ANA error: %s", pp->dev, ana_errmsg[-rc]);
 	else
 		condlog(1, "%s: invalid ANA rc code %d", pp->dev, rc);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index bf7fdd73..f420ee5c 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -350,7 +350,7 @@ store_adaptergroup(vector adapters, struct adapter_group * agp)
 }
 
 struct multipath *
-find_mp_by_minor (const struct _vector *mpvec, int minor)
+find_mp_by_minor (const struct _vector *mpvec, unsigned int minor)
 {
 	int i;
 	struct multipath * mpp;
@@ -388,7 +388,7 @@ struct multipath *
 find_mp_by_alias (const struct _vector *mpvec, const char * alias)
 {
 	int i;
-	int len;
+	size_t len;
 	struct multipath * mpp;
 
 	if (!mpvec)
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index a3adf906..3665b89a 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -440,7 +440,8 @@ int add_pathgroup(struct multipath*, struct pathgroup *);
 struct multipath * find_mp_by_alias (const struct _vector *mp, const char *alias);
 struct multipath * find_mp_by_wwid (const struct _vector *mp, const char *wwid);
 struct multipath * find_mp_by_str (const struct _vector *mp, const char *wwid);
-struct multipath * find_mp_by_minor (const struct _vector *mp, int minor);
+struct multipath * find_mp_by_minor (const struct _vector *mp,
+				     unsigned int minor);
 
 struct path * find_path_by_devt (const struct _vector *pathvec, const char *devt);
 struct path * find_path_by_dev (const struct _vector *pathvec, const char *dev);
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 65904d7b..923b529b 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -88,7 +88,7 @@ ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 		condlog(4, "read from %s failed: %s", devpath, strerror(errno));
 		size = -errno;
 		value[0] = '\0';
-	} else if (size == value_len) {
+	} else if (size == (ssize_t)value_len) {
 		value[size - 1] = '\0';
 		condlog(4, "overflow while reading from %s", devpath);
 		size = 0;
@@ -146,7 +146,7 @@ ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
 	if (size < 0) {
 		condlog(4, "read from %s failed: %s", devpath, strerror(errno));
 		size = -errno;
-	} else if (size == value_len) {
+	} else if (size == (ssize_t)value_len) {
 		condlog(4, "overflow while reading from %s", devpath);
 		size = 0;
 	}
@@ -200,7 +200,7 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 	if (size < 0) {
 		condlog(4, "write to %s failed: %s", devpath, strerror(errno));
 		size = -errno;
-	} else if (size < value_len) {
+	} else if (size < (ssize_t)value_len) {
 		condlog(4, "tried to write %ld to %s. Wrote %ld",
 			(long)value_len, devpath, (long)size);
 		size = 0;
diff --git a/libmultipath/time-util.c b/libmultipath/time-util.c
index a3739a2d..55f366cc 100644
--- a/libmultipath/time-util.c
+++ b/libmultipath/time-util.c
@@ -32,11 +32,11 @@ void pthread_cond_init_mono(pthread_cond_t *cond)
 void normalize_timespec(struct timespec *ts)
 {
 	while (ts->tv_nsec < 0) {
-		ts->tv_nsec += 1000UL * 1000 * 1000;
+		ts->tv_nsec += 1000L * 1000 * 1000;
 		ts->tv_sec--;
 	}
-	while (ts->tv_nsec >= 1000UL * 1000 * 1000) {
-		ts->tv_nsec -= 1000UL * 1000 * 1000;
+	while (ts->tv_nsec >= 1000L * 1000 * 1000) {
+		ts->tv_nsec -= 1000L * 1000 * 1000;
 		ts->tv_sec++;
 	}
 }
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index f128ced2..d38e8a7f 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -108,7 +108,8 @@ uevq_cleanup(struct list_head *tmpq)
 static const char* uevent_get_env_var(const struct uevent *uev,
 				      const char *attr)
 {
-	int i, len;
+	int i;
+	size_t len;
 	const char *p = NULL;
 
 	if (attr == NULL)
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 28cbf4b9..ccc0de29 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -44,7 +44,7 @@ basenamecpy (const char *src, char *dst, size_t size)
 	p = basename(src);
 
 	for (e = p + strlen(p) - 1; e >= p && isspace(*e); --e) ;
-	if (e < p || e - p > size - 2)
+	if (e < p || (size_t)(e - p) > size - 2)
 		return 0;
 
 	strlcpy(dst, p, e - p + 2);
@@ -428,7 +428,7 @@ int safe_write(int fd, const void *buf, size_t count)
 	return 0;
 }
 
-void set_max_fds(int max_fds)
+void set_max_fds(rlim_t max_fds)
 {
 	struct rlimit fd_limit;
 
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 693991c1..913ab7c2 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -2,6 +2,8 @@
 #define _UTIL_H
 
 #include <sys/types.h>
+/* for rlim_t */
+#include <sys/resource.h>
 #include <inttypes.h>
 #include <stdbool.h>
 
@@ -21,7 +23,7 @@ int get_linux_version_code(void);
 int parse_prkey(char *ptr, uint64_t *prkey);
 int parse_prkey_flags(char *ptr, uint64_t *prkey, uint8_t *flags);
 int safe_write(int fd, const void *buf, size_t count);
-void set_max_fds(int max_fds);
+void set_max_fds(rlim_t max_fds);
 
 #define KERNEL_VERSION(maj, min, ptc) ((((maj) * 256) + (min)) * 256 + (ptc))
 #define ARRAY_SIZE(x) (sizeof(x)/sizeof((x)[0]))
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index 9b4e9784..6adeedfc 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -40,7 +40,8 @@ static int _recv_packet(int fd, char **buf, unsigned int timeout,
  */
 int ux_socket_listen(const char *name)
 {
-	int fd, len;
+	int fd;
+	size_t len;
 #ifdef USE_SYSTEMD
 	int num;
 #endif
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index d02a7072..291db8f5 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -74,7 +74,7 @@ write_out_wwid(int fd, char *wwid) {
 			strerror(errno));
 		return -1;
 	}
-	if (write(fd, buf, strlen(buf)) != strlen(buf)) {
+	if (write(fd, buf, strlen(buf)) != (ssize_t)strlen(buf)) {
 		condlog(0, "cannot write wwid to wwids file : %s",
 			strerror(errno));
 		if (ftruncate(fd, offset))
@@ -117,7 +117,7 @@ replace_wwids(vector mp)
 		goto out_file;
 	}
 	len = strlen(WWIDS_FILE_HEADER);
-	if (write(fd, WWIDS_FILE_HEADER, len) != len) {
+	if (write(fd, WWIDS_FILE_HEADER, len) != (ssize_t)len) {
 		condlog(0, "Can't write wwid file header : %s",
 			strerror(errno));
 		/* cleanup partially written header */
diff --git a/multipathd/main.c b/multipathd/main.c
index e55f2795..26d5aa9c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1949,8 +1949,9 @@ static int check_path_reinstate_state(struct path * pp) {
 	 * so that the cutomer can rectify the issue within this time. After
 	 * the completion of san_path_err_recovery_time it should
 	 * automatically reinstate the path
+	 * (note: we know that san_path_err_threshold > 0 here).
 	 */
-	if (pp->path_failures > pp->mpp->san_path_err_threshold) {
+	if (pp->path_failures > (unsigned int)pp->mpp->san_path_err_threshold) {
 		condlog(2, "%s : hit error threshold. Delaying path reinstatement", pp->dev);
 		pp->dis_reinstate_time = curr_time.tv_sec;
 		pp->disable_reinstate = 1;
@@ -3247,7 +3248,8 @@ main (int argc, char *argv[])
 void *  mpath_pr_event_handler_fn (void * pathp )
 {
 	struct multipath * mpp;
-	int i, ret, isFound;
+	unsigned int i;
+	int ret, isFound;
 	struct path * pp = (struct path *)pathp;
 	struct prout_param_descriptor *param;
 	struct prin_resp *resp;
diff --git a/multipathd/pidfile.c b/multipathd/pidfile.c
index 47d18e2c..cc0fbec1 100644
--- a/multipathd/pidfile.c
+++ b/multipathd/pidfile.c
@@ -42,7 +42,7 @@ int pidfile_create(const char *pidFile, pid_t pid)
 	}
 	memset(buf, 0, sizeof(buf));
 	snprintf(buf, sizeof(buf)-1, "%u", pid);
-	if (write(fd, buf, strlen(buf)) != strlen(buf)) {
+	if (write(fd, buf, strlen(buf)) != (ssize_t)strlen(buf)) {
 		condlog(0, "Cannot write pid to pidfile [%s], error was [%s]",
 			pidFile, strerror(errno));
 		goto fail;
-- 
2.23.0
