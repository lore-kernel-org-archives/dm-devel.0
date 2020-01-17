From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 02/15] libmultipath: fix leak in foreign code
Date: Thu, 16 Jan 2020 20:18:07 -0600
Message-ID: <1579227500-17196-3-git-send-email-bmarzins@redhat.com>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

If scandir fails or finds no foreign libraries, enable_re needs to be
freed before exitting.

Fixes: 8d03eda4 'multipath.conf: add "enable_foreign" parameter'
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/foreign.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index 4b34e141..68e9a9b8 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -129,7 +129,7 @@ static int _init_foreign(const char *multipath_dir, const char *enable)
 	char pathbuf[PATH_MAX];
 	struct dirent **di;
 	struct scandir_result sr;
-	int r, i;
+	int r, i, ret = 0;
 	regex_t *enable_re = NULL;
 
 	foreigns = vector_alloc();
@@ -157,13 +157,15 @@ static int _init_foreign(const char *multipath_dir, const char *enable)
 	if (r == 0) {
 		condlog(3, "%s: no foreign multipath libraries found",
 			__func__);
-		return 0;
+		ret = 0;
+		goto out;
 	} else if (r < 0) {
 		r = errno;
 		condlog(1, "%s: error %d scanning foreign multipath libraries",
 			__func__, r);
 		_cleanup_foreign();
-		return -r;
+		ret = -r;
+		goto out;
 	}
 
 	sr.di = di;
@@ -250,8 +252,9 @@ static int _init_foreign(const char *multipath_dir, const char *enable)
 		free_foreign(fgn);
 	}
 	pthread_cleanup_pop(1); /* free_scandir_result */
+out:
 	pthread_cleanup_pop(1); /* free_pre */
-	return 0;
+	return ret;
 }
 
 int init_foreign(const char *multipath_dir, const char *enable)
-- 
2.17.2
