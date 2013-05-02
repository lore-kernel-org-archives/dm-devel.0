From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 10/16] add wwids file cleanup options
Date: Thu,  2 May 2013 16:46:31 -0500
Message-ID: <1367531197-8987-11-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This patch adds the "-w <device>" and "-W" options to multipath. They
allow users to either remove a specified device from the wwids file, or
reset the wwids file to only include the wwids for their current
multipath devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c |   3 +-
 libmultipath/wwids.c     | 130 +++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/wwids.h     |   2 +
 multipath/main.c         |  51 +++++++++++++++++--
 multipath/multipath.8    |   8 ++-
 5 files changed, 188 insertions(+), 6 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 826ea75..4d452a1 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -53,7 +53,8 @@ store_pathinfo (vector pathvec, vector hwtable, struct udev_device *udevice,
 		goto out;
 	}
 	pp->udev = udev_device_ref(udevice);
-	err = pathinfo(pp, hwtable, flag | DI_BLACKLIST);
+	err = pathinfo(pp, hwtable,
+		       (conf->dry_run == 3)? flag : (flag | DI_BLACKLIST));
 	if (err)
 		goto out;
 
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index abd23c5..91b07a7 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -82,6 +82,136 @@ write_out_wwid(int fd, char *wwid) {
 }
 
 int
+replace_wwids(vector mp)
+{
+	int i, fd, can_write;
+	struct multipath * mpp;
+	size_t len;
+	int ret = -1;
+
+	fd = open_file(conf->wwids_file, &can_write, WWIDS_FILE_HEADER);
+	if (fd < 0)
+		goto out;
+	if (!can_write) {
+		condlog(0, "cannot replace wwids. wwids file is read-only");
+		goto out_file;
+	}
+	if (ftruncate(fd, 0) < 0) {
+		condlog(0, "cannot truncate wwids file : %s", strerror(errno));
+		goto out_file;
+	}
+	len = strlen(WWIDS_FILE_HEADER);
+	if (write_all(fd, WWIDS_FILE_HEADER, len) != len) {
+		condlog(0, "Can't write wwid file header : %s",
+			strerror(errno));
+		/* cleanup partially written header */
+		if (ftruncate(fd, 0) < 0)
+			condlog(0, "Cannot truncate header : %s",
+				strerror(errno));
+		goto out_file;
+	}
+	if (!mp || !mp->allocated) {
+		ret = 0;
+		goto out_file;
+	}
+	vector_foreach_slot(mp, mpp, i) {
+		if (write_out_wwid(fd, mpp->wwid) < 0)
+			goto out_file;
+	}
+	ret = 0;
+out_file:
+	close(fd);
+out:
+	return ret;
+}
+
+int
+do_remove_wwid(int fd, char *str) {
+	char buf[4097];
+	char *ptr;
+	off_t start = 0;
+	int bytes;
+
+	while (1) {
+		if (lseek(fd, start, SEEK_SET) < 0) {
+			condlog(0, "wwid file read lseek failed : %s",
+				strerror(errno));
+			return -1;
+		}
+		bytes = read(fd, buf, 4096);
+		if (bytes < 0) {
+			if (errno == EINTR || errno == EAGAIN)
+				continue;
+			condlog(0, "failed to read from wwids file : %s",
+				strerror(errno));
+			return -1;
+		}
+		if (!bytes) /* didn't find wwid to remove */
+			return 1;
+		buf[bytes] = '\0';
+		ptr = strstr(buf, str);
+		if (ptr != NULL) {
+			condlog(3, "found '%s'", str);
+			if (lseek(fd, start + (ptr - buf), SEEK_SET) < 0) {
+				condlog(0, "write lseek failed : %s",
+						strerror(errno));
+				return -1;
+			}
+			while (1) {
+				if (write(fd, "#", 1) < 0) {
+					if (errno == EINTR || errno == EAGAIN)
+						continue;
+					condlog(0, "failed to write to wwids file : %s", strerror(errno));
+					return -1;
+				}
+				return 0;
+			}
+		}
+		ptr = strrchr(buf, '\n');
+		if (ptr == NULL) { /* shouldn't happen, assume it is EOF */
+			condlog(4, "couldn't find newline, assuming end of file");
+			return 1;
+		}
+		start = start + (ptr - buf) + 1;
+	}
+}
+
+
+int
+remove_wwid(char *wwid) {
+	int fd, len, can_write;
+	char *str;
+	int ret = -1;
+
+	len = strlen(wwid) + 4; /* two slashes the newline and a zero byte */
+	str = malloc(len);
+	if (str == NULL) {
+		condlog(0, "can't allocate memory to remove wwid : %s",
+			strerror(errno));
+		return -1;
+	}
+	if (snprintf(str, len, "/%s/\n", wwid) >= len) {
+		condlog(0, "string overflow trying to remove wwid");
+		goto out;
+	}
+	condlog(3, "removing line '%s' from wwids file", str);
+	fd = open_file(conf->wwids_file, &can_write, WWIDS_FILE_HEADER);
+	if (fd < 0)
+		goto out;
+	if (!can_write) {
+		condlog(0, "cannot remove wwid. wwids file is read-only");
+		goto out_file;
+	}
+	ret = do_remove_wwid(fd, str);
+
+out_file:
+	close(fd);
+out:
+	free(str);
+	return ret;
+}
+
+int
 check_wwids_file(char *wwid, int write_wwid)
 {
 	int fd, can_write, found, ret;
diff --git a/libmultipath/wwids.h b/libmultipath/wwids.h
index 1678f9d..f3b21fa 100644
--- a/libmultipath/wwids.h
+++ b/libmultipath/wwids.h
@@ -14,5 +14,7 @@
 
 int remember_wwid(char *wwid);
 int check_wwids_file(char *wwid, int write_wwid);
+int remove_wwid(char *wwid);
+int replace_wwids(vector mp);
 
 #endif /* _WWIDS_H */
diff --git a/multipath/main.c b/multipath/main.c
index 3038869..f1b3ec9 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -83,7 +83,7 @@ usage (char * progname)
 {
 	fprintf (stderr, VERSION_STRING);
 	fprintf (stderr, "Usage:\n");
-	fprintf (stderr, "  %s [-c] [-d] [-r] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n", progname);
+	fprintf (stderr, "  %s [-c|-w|-W] [-d] [-r] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n", progname);
 	fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [dev]\n", progname);
 	fprintf (stderr, "  %s -F [-v lvl]\n", progname);
 	fprintf (stderr, "  %s -t\n", progname);
@@ -104,6 +104,8 @@ usage (char * progname)
 		"  -B      treat the bindings file as read only\n" \
 		"  -p      policy failover|multibus|group_by_serial|group_by_prio\n" \
 		"  -b fil  bindings file location\n" \
+		"  -w      remove a device from the wwids file\n" \
+		"  -W      reset the wwids file include only the current devices\n" \
 		"  -p pol  force all maps to specified path grouping policy :\n" \
 		"          . failover            one path per priority group\n" \
 		"          . multibus            all paths in one priority group\n" \
@@ -212,7 +214,6 @@ get_dm_mpvec (vector curmp, vector pathvec, char * refwwid)
 
 		if (!conf->dry_run)
 			reinstate_paths(mpp);
-		remember_wwid(mpp->wwid);
 	}
 	return 0;
 }
@@ -262,7 +263,7 @@ configure (void)
 	/*
 	 * if we have a blacklisted device parameter, exit early
 	 */
-	if (dev && conf->dev_type == DEV_DEVNODE &&
+	if (dev && conf->dev_type == DEV_DEVNODE && conf->dry_run != 3 &&
 	    (filter_devnode(conf->blist_devnode,
 			    conf->elist_devnode, dev) > 0)) {
 		if (conf->dry_run == 2)
@@ -284,6 +285,17 @@ configure (void)
 				condlog(3, "scope is nul");
 			goto out;
 		}
+		if (conf->dry_run == 3) {
+			r = remove_wwid(refwwid);
+			if (r == 0)
+				printf("wwid '%s' removed\n", refwwid);
+			else if (r == 1) {
+				printf("wwid '%s' not in wwids file\n",
+					refwwid);
+				r = 0;
+			}
+			goto out;
+		}
 		condlog(3, "scope limited to %s", refwwid);
 		if (conf->dry_run == 2) {
 			if (check_wwids_file(refwwid, 0) == 0){
@@ -439,7 +451,7 @@ main (int argc, char *argv[])
 	if (load_config(DEFAULT_CONFIGFILE))
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":dchl::FfM:v:p:b:Brtq")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dchl::FfM:v:p:b:BrtqwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -504,6 +516,12 @@ main (int argc, char *argv[])
 		case 'h':
 			usage(argv[0]);
 			exit(0);
+		case 'w':
+			conf->dry_run = 3;
+			break;
+		case 'W':
+			conf->dry_run = 4;
+			break;
 		case ':':
 			fprintf(stderr, "Missing option argument\n");
 			usage(argv[0]);
@@ -555,6 +573,31 @@ main (int argc, char *argv[])
 		condlog(0, "the -c option requires a path to check");
 		goto out;
 	}
+	if (conf->dry_run == 3 && !conf->dev) {
+		condlog(0, "the -w option requires a device");
+		goto out;
+	}
+	if (conf->dry_run == 4) {
+		struct multipath * mpp;
+		int i;
+		vector curmp;
+
+		curmp = vector_alloc();
+		if (!curmp) {
+			condlog(0, "can't allocate memory for mp list");
+			goto out;
+		}
+		if (dm_get_maps(curmp) == 0)
+			r = replace_wwids(curmp);
+		if (r == 0)
+			printf("successfully reset wwids\n");
+		vector_foreach_slot_backwards(curmp, mpp, i) {
+			vector_del_slot(curmp, i);
+			free_multipath(mpp, KEEP_PATHS);
+		}
+		vector_free(curmp);
+		goto out;
+	}
 	if (conf->remove == FLUSH_ONE) {
 		if (conf->dev_type == DEV_DEVMAP) {
 			r = dm_suspend_and_flush_map(conf->dev);
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index afaa6c4..a2262ac 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -8,7 +8,7 @@ multipath \- Device mapper target autoconfig
 .RB [\| \-b\ \c
 .IR bindings_file \|]
 .RB [\| \-d \|]
-.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r \|]
+.RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \-w | \-W \|]
 .RB [\| \-p\ \c
 .BR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
 .RB [\| device \|]
@@ -68,6 +68,12 @@ check if a block device should be a path in a multipath device
 .B \-q
 allow device tables with queue_if_no_path when multipathd is not running
 .TP
+.B \-w
+remove the wwid for the specified device from the wwids file
+.TP
+.B \-W
+reset the wwids file to only include the current multipath devices
+.TP
 .BI \-p " policy"
 force new maps to use the specified policy:
 .RS 1.2i
-- 
1.8.2
