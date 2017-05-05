From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 10/10] kpartx: find_loop_by_file: use sysfs
Date: Sat,  6 May 2017 00:05:59 +0200
Message-ID: <20170505220559.7248-11-mwilck@suse.com>
References: <20170505220559.7248-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170505220559.7248-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Rather then searching through all of /dev, look up loop devices
in /sys/devices/virtual/block. This is cleaner and more robust
(/dev/loop$Xp$Y symlinks may confuse kpartx).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/lopart.c | 42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 44f0c277..0521d7dc 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -68,25 +68,46 @@ char *find_loop_by_file(const char *filename)
 {
 	DIR *dir;
 	struct dirent *dent;
-	char dev[64], *found = NULL;
+	char dev[64], *found = NULL, *p;
 	int fd;
 	struct stat statbuf;
 	struct loop_info loopinfo;
+	const char VIRT_BLOCK[] = "/sys/devices/virtual/block";
+	char path[PATH_MAX];
 
-	dir = opendir("/dev");
+	dir = opendir(VIRT_BLOCK);
 	if (!dir)
 		return NULL;
 
 	while ((dent = readdir(dir)) != NULL) {
 		if (strncmp(dent->d_name,"loop",4))
 			continue;
-		if (!strcmp(dent->d_name, "loop-control"))
-			continue;
-		sprintf(dev, "/dev/%s", dent->d_name);
 
-		fd = open (dev, O_RDONLY);
+		if (snprintf(path, PATH_MAX, "%s/%s/dev", VIRT_BLOCK,
+			     dent->d_name) >= PATH_MAX)
+			continue;
+
+		fd = open(path, O_RDONLY);
 		if (fd < 0)
-			break;
+			continue;
+
+		if (read(fd, dev, sizeof(dev)) <= 0) {
+			close(fd);
+			continue;
+		}
+
+		close(fd);
+
+		dev[sizeof(dev)-1] = '\0';
+		p = strchr(dev, '\n');
+		if (p != NULL)
+			*p = '\0';
+		if (snprintf(path, PATH_MAX, "/dev/block/%s", dev) >= PATH_MAX)
+			continue;
+
+		fd = open (path, O_RDONLY);
+		if (fd < 0)
+			continue;
 
 		if (fstat (fd, &statbuf) != 0 ||
 		    !S_ISBLK(statbuf.st_mode)) {
@@ -99,13 +120,12 @@ char *find_loop_by_file(const char *filename)
 			continue;
 		}
 
+		close (fd);
+
 		if (0 == strcmp(filename, loopinfo.lo_name)) {
-			close (fd);
-			found = xstrdup(dev);
+			found = realpath(path, NULL);
 			break;
 		}
-
-		close (fd);
 	}
 	closedir(dir);
 	return found;
-- 
2.12.2
