From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] libmultipath: sanitize fd handling
Date: Fri, 15 Sep 2017 08:15:12 +0200
Message-ID: <1505456112-117105-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

One should remember that '0' _is_ a valid fd, so we need to set
the fd to '-1' upon allocating the path structure and ensure we're
checking for a value _smaller_ than 0 to detect an invalid fd.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/checkers.c | 4 ++--
 libmultipath/print.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 05e024f8..c32f7274 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -146,7 +146,7 @@ struct checker * add_checker (char *multipath_dir, char * name)
 	if (!c->repair)
 		goto out;
 
-	c->fd = 0;
+	c->fd = -1;
 	c->sync = 1;
 	list_add(&c->node, &checkers);
 	return c;
@@ -237,7 +237,7 @@ int checker_check (struct checker * c)
 		MSG(c, "checker disabled");
 		return PATH_UNCHECKED;
 	}
-	if (c->fd <= 0) {
+	if (c->fd < 0) {
 		MSG(c, "no usable fd");
 		return PATH_WILD;
 	}
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 95dff90b..65a98247 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1677,7 +1677,7 @@ int snprint_status(char *buff, int len, struct vectors *vecs)
 	int monitored_count = 0;
 
 	vector_foreach_slot(vecs->pathvec, pp, i)
-		if (pp->fd != -1)
+		if (pp->fd >= 0)
 			monitored_count++;
 	fwd += snprintf(buff + fwd, len - fwd, "\npaths: %d\nbusy: %s\n",
 			monitored_count, is_uevent_busy()? "True" : "False");
-- 
2.12.0
