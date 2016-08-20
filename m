From: Robert LeBlanc <robert@leblancnet.us>
Subject: [RFC] Some fixes to allow for more than 128 md devices.
Date: Fri, 19 Aug 2016 20:10:31 -0600
Message-ID: <1471659031-30688-2-git-send-email-robert@leblancnet.us>
References: <1471659031-30688-1-git-send-email-robert@leblancnet.us>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1471659031-30688-1-git-send-email-robert@leblancnet.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dm-devel@redhat.com, robert@leblancnet.us
List-Id: dm-devel.ids

---
 Manage.c |  5 +++--
 lib.c    |  2 +-
 mdadm.h  |  6 +++---
 util.c   | 25 +++++++++++++------------
 4 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/Manage.c b/Manage.c
index 30adc99..51d0eae 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1380,7 +1380,8 @@ int Manage_subdevs(char *devname, int fd,
 	for (dv = devlist; dv; dv = dv->next) {
 		unsigned long rdev = 0; /* device to add/remove etc */
 		int rv;
-		int mj,mn;
+		int mj;
+		unsigned long mn;
 
 		raid_slot = -1;
 		if (dv->disposition == 'c') {
@@ -1486,7 +1487,7 @@ int Manage_subdevs(char *devname, int fd,
 			if (sysfd >= 0) {
 				char dn[20];
 				if (sysfs_fd_get_str(sysfd, dn, 20) > 0 &&
-				    sscanf(dn, "%d:%d", &mj,&mn) == 2) {
+				    sscanf(dn, "%d:%lu", &mj,&mn) == 2) {
 					rdev = makedev(mj,mn);
 					found = 1;
 				}
diff --git a/lib.c b/lib.c
index 621edf3..e0df6fd 100644
--- a/lib.c
+++ b/lib.c
@@ -99,7 +99,7 @@ char *fd2kname(int fd)
 	return NULL;
 }
 
-char *devid2devnm(int devid)
+char *devid2devnm(unsigned long devid)
 {
 	char path[30];
 	char link[200];
diff --git a/mdadm.h b/mdadm.h
index d209488..7de6589 100755
--- a/mdadm.h
+++ b/mdadm.h
@@ -1348,7 +1348,7 @@ extern int check_partitions(int fd, char *dname,
 			    unsigned long long size);
 
 extern int get_mdp_major(void);
-extern int get_maj_min(char *dev, int *major, int *minor);
+extern int get_maj_min(char *dev, int *major, unsigned long *minor);
 extern int dev_open(char *dev, int flags);
 extern int open_dev(char *devnm);
 extern void reopen_mddev(int mdfd);
@@ -1438,8 +1438,8 @@ extern char *find_free_devnm(int use_partitions);
 
 extern void put_md_name(char *name);
 extern char *devid2kname(int devid);
-extern char *devid2devnm(int devid);
-extern int devnm2devid(char *devnm);
+extern char *devid2devnm(unsigned long devid);
+extern unsigned long devnm2devid(char *devnm);
 extern char *get_md_name(char *devnm);
 
 extern char DefaultConfFile[];
diff --git a/util.c b/util.c
index 2bcb81f..939cf52 100644
--- a/util.c
+++ b/util.c
@@ -928,7 +928,7 @@ int get_data_disks(int level, int layout, int raid_disks)
 	return data_disks;
 }
 
-int devnm2devid(char *devnm)
+unsigned long devnm2devid(char *devnm)
 {
 	/* First look in /sys/block/$DEVNM/dev for %d:%d
 	 * If that fails, try parsing out a number
@@ -936,7 +936,8 @@ int devnm2devid(char *devnm)
 	char path[100];
 	char *ep;
 	int fd;
-	int mjr,mnr;
+	int mjr;
+	unsigned long mnr;
 
 	sprintf(path, "/sys/block/%s/dev", devnm);
 	fd = open(path, O_RDONLY);
@@ -946,18 +947,18 @@ int devnm2devid(char *devnm)
 		close(fd);
 		if (n > 0)
 			buf[n] = 0;
-		if (n > 0 && sscanf(buf, "%d:%d\n", &mjr, &mnr) == 2)
+		if (n > 0 && sscanf(buf, "%d:%lu\n", &mjr, &mnr) == 2)
 			return makedev(mjr, mnr);
 	}
 	if (strncmp(devnm, "md_d", 4) == 0 &&
 	    isdigit(devnm[4]) &&
-	    (mnr = strtoul(devnm+4, &ep, 10)) >= 0 &&
+	    (mnr = strtoul(devnm+4, &ep, 10)) &&
 	    ep > devnm && *ep == 0)
 		return makedev(get_mdp_major(), mnr << MdpMinorShift);
 
 	if (strncmp(devnm, "md", 2) == 0 &&
 	    isdigit(devnm[2]) &&
-	    (mnr = strtoul(devnm+2, &ep, 10)) >= 0 &&
+	    (mnr = strtoul(devnm+2, &ep, 10)) &&
 	    ep > devnm && *ep == 0)
 		return makedev(MD_MAJOR, mnr);
 
@@ -1020,12 +1021,12 @@ void put_md_name(char *name)
 }
 #endif /* !defined(MDASSEMBLE) || defined(MDASSEMBLE) && defined(MDASSEMBLE_AUTO) */
 
-int get_maj_min(char *dev, int *major, int *minor)
+int get_maj_min(char *dev, int *major, unsigned long *minor)
 {
 	char *e;
 	*major = strtoul(dev, &e, 0);
 	return (e > dev && *e == ':' && e[1] &&
-		(*minor = strtoul(e+1, &e, 0)) >= 0 &&
+		(*minor = strtoul(e+1, &e, 0)) &&
 		*e == 0);
 }
 
@@ -1037,13 +1038,13 @@ int dev_open(char *dev, int flags)
 	int fd = -1;
 	char devname[32];
 	int major;
-	int minor;
+	unsigned long minor;
 
 	if (!dev) return -1;
 	flags |= O_DIRECT;
 
 	if (get_maj_min(dev, &major, &minor)) {
-		snprintf(devname, sizeof(devname), "/dev/.tmp.md.%d:%d:%d",
+		snprintf(devname, sizeof(devname), "/dev/.tmp.md.%d:%d:%lu",
 			 (int)getpid(), major, minor);
 		if (mknod(devname, S_IFBLK|0600, makedev(major, minor)) == 0) {
 			fd = open(devname, flags);
@@ -1051,7 +1052,7 @@ int dev_open(char *dev, int flags)
 		}
 		if (fd < 0) {
 			/* Try /tmp as /dev appear to be read-only */
-			snprintf(devname, sizeof(devname), "/tmp/.tmp.md.%d:%d:%d",
+			snprintf(devname, sizeof(devname), "/tmp/.tmp.md.%d:%d:%lu",
 				 (int)getpid(), major, minor);
 			if (mknod(devname, S_IFBLK|0600, makedev(major, minor)) == 0) {
 				fd = open(devname, flags);
@@ -1069,7 +1070,7 @@ int open_dev_flags(char *devnm, int flags)
 	char buf[20];
 
 	devid = devnm2devid(devnm);
-	sprintf(buf, "%d:%d", major(devid), minor(devid));
+	sprintf(buf, "%d:%lu", major(devid), (unsigned long)minor(devid));
 	return dev_open(buf, flags);
 }
 
@@ -1083,7 +1084,7 @@ int open_dev_excl(char *devnm)
 	char buf[20];
 	int i;
 	int flags = O_RDWR;
-	int devid = devnm2devid(devnm);
+	unsigned long devid = devnm2devid(devnm);
 	long delay = 1000;
 
 	sprintf(buf, "%d:%d", major(devid), minor(devid));
-- 
2.8.1

