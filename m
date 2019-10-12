From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 20/72] libmultipath: _init_foreign(): fix
	possible memory leak
Date: Sat, 12 Oct 2019 21:28:02 +0000
Message-ID: <20191012212703.12989-21-martin.wilck@suse.com>
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

free_pre() wasn't called if scandir() failed. Fix it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index 4b34e141..9ef8ad19 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -148,7 +148,7 @@ static int _init_foreign(const char *multipath_dir, const char *enable)
 			(void)regerror(r, enable_re, errbuf, sizeof(errbuf));
 			condlog (2, "%s: error compiling enable_foreign = \"%s\": \"%s\"",
 				 __func__, str, errbuf);
-			free_pre(&enable_re);
+			goto out_free_pre;
 		}
 	}
 
@@ -157,13 +157,13 @@ static int _init_foreign(const char *multipath_dir, const char *enable)
 	if (r == 0) {
 		condlog(3, "%s: no foreign multipath libraries found",
 			__func__);
-		return 0;
+		goto out_free_pre;
 	} else if (r < 0) {
-		r = errno;
-		condlog(1, "%s: error %d scanning foreign multipath libraries",
-			__func__, r);
+		r = -errno;
+		condlog(1, "%s: error scanning foreign multipath libraries: %m",
+			__func__);
 		_cleanup_foreign();
-		return -r;
+		goto out_free_pre;
 	}
 
 	sr.di = di;
@@ -249,9 +249,11 @@ static int _init_foreign(const char *multipath_dir, const char *enable)
 	dl_err:
 		free_foreign(fgn);
 	}
+	r = 0;
 	pthread_cleanup_pop(1); /* free_scandir_result */
+out_free_pre:
 	pthread_cleanup_pop(1); /* free_pre */
-	return 0;
+	return r;
 }
 
 int init_foreign(const char *multipath_dir, const char *enable)
-- 
2.23.0
