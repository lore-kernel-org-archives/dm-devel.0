From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 19/72] libmultipath: remove_wwids(): fix possible
	leaks
Date: Sat, 12 Oct 2019 21:28:00 +0000
Message-ID: <20191012212703.12989-20-martin.wilck@suse.com>
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

... of fd and memory.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/wwids.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index f69ed6f5..d02a7072 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -195,7 +195,8 @@ do_remove_wwid(int fd, char *str) {
 
 int
 remove_wwid(char *wwid) {
-	int fd, len, can_write;
+	long fd;
+	int len, can_write;
 	char *str;
 	int ret = -1;
 	struct config *conf;
@@ -207,8 +208,10 @@ remove_wwid(char *wwid) {
 			strerror(errno));
 		return -1;
 	}
+	pthread_cleanup_push(free, str);
 	if (snprintf(str, len, "/%s/\n", wwid) >= len) {
 		condlog(0, "string overflow trying to remove wwid");
+		ret = -1;
 		goto out;
 	}
 	condlog(3, "removing line '%s' from wwids file", str);
@@ -216,18 +219,22 @@ remove_wwid(char *wwid) {
 	pthread_cleanup_push(put_multipath_config, conf);
 	fd = open_file(conf->wwids_file, &can_write, WWIDS_FILE_HEADER);
 	pthread_cleanup_pop(1);
-	if (fd < 0)
+
+	if (fd < 0) {
+		ret = -1;
 		goto out;
-	if (!can_write) {
-		condlog(0, "cannot remove wwid. wwids file is read-only");
-		goto out_file;
 	}
-	ret = do_remove_wwid(fd, str);
 
-out_file:
-	close(fd);
+	pthread_cleanup_push(close_fd, (void*)fd);
+	if (!can_write) {
+		ret = -1;
+		condlog(0, "cannot remove wwid. wwids file is read-only");
+	} else
+		ret = do_remove_wwid(fd, str);
+	pthread_cleanup_pop(1);
 out:
-	free(str);
+	/* free(str) */
+	pthread_cleanup_pop(1);
 	return ret;
 }
 
-- 
2.23.0
