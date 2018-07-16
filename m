From: Yuval Turgeman <yturgema@redhat.com>
Subject: [PATCH] kpartx: compare image filenames with backing
	files
Date: Mon, 16 Jul 2018 15:52:13 +0300
Message-ID: <20180716125213.16767-1-yturgema@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

When running `kpartx -d`, find_loop_by_file tries to compare the image's
realpath with the output from loopinfo.lo_name, which may hold only the
basename of the image, making kpartx exit without finding the loopdev
for the image.

In case the original comparison fails, this patch will check the image's
realpath with the loop device's backing_file so that find_loop_by_file
will return the correct value.

Signed-off-by: Yuval Turgeman <yturgema@redhat.com>
---
 kpartx/lopart.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 69c1eda1..9b652554 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -69,6 +69,8 @@ char *find_loop_by_file(const char *filename)
 	struct loop_info loopinfo;
 	const char VIRT_BLOCK[] = "/sys/devices/virtual/block";
 	char path[PATH_MAX];
+	char bf_path[PATH_MAX];
+	char backing_file[PATH_MAX];
 
 	dir = opendir(VIRT_BLOCK);
 	if (!dir)
@@ -122,6 +124,34 @@ char *find_loop_by_file(const char *filename)
 			found = realpath(path, NULL);
 			break;
 		}
+
+		/*
+		 * filename is a realpath, while loopinfo.lo_name may hold just the
+		 * basename.  If that's the case, try to match filename against the
+		 * backing_file entry for this loop entry
+		 */
+		if (snprintf(bf_path, PATH_MAX, "%s/%s/loop/backing_file", VIRT_BLOCK,
+					 dent->d_name) >= PATH_MAX)
+			continue;
+
+		fd = open(bf_path, O_RDONLY);
+		if (fd < 0)
+			continue;
+
+		bytes_read = read(fd, backing_file, sizeof(backing_file) - 1);
+		if (bytes_read <= 0) {
+			close(fd);
+			continue;
+		}
+
+		close(fd);
+
+		backing_file[bytes_read-1] = '\0';
+
+		if (0 == strcmp(filename, backing_file)) {
+			found = realpath(path, NULL);
+			break;
+		}
 	}
 	closedir(dir);
 	return found;
-- 
2.17.1
