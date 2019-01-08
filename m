From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/3] multipath: fix gcc 4.8 uninitialized
	variable warning
Date: Tue,  8 Jan 2019 12:32:45 +0100
Message-ID: <20190108113246.5903-3-mwilck@suse.com>
References: <20190108113246.5903-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190108113246.5903-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

gcc 4.8 complained about "err" not being initialized. Fix, and
simplify.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index a25e1b4f..5abb1181 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -410,7 +410,7 @@ static int find_multipaths_check_timeout(const struct path *pp, long tmo,
 	struct timespec now, ftimes[2], tdiff;
 	struct stat st;
 	long fd;
-	int r, err, retries = 0;
+	int r, retries = 0;
 
 	clock_gettime(CLOCK_REALTIME, &now);
 
@@ -430,8 +430,6 @@ retry:
 	if (fd != -1) {
 		pthread_cleanup_push(close_fd, (void *)fd);
 		r = fstat(fd, &st);
-		if (r != 0)
-			err = errno;
 		pthread_cleanup_pop(1);
 
 	} else if (tmo > 0) {
@@ -460,15 +458,12 @@ retry:
 				path, strerror(errno));
 		}
 		r = fstat(fd, &st);
-		if (r != 0)
-			err = errno;
 		pthread_cleanup_pop(1);
 	} else
 		return FIND_MULTIPATHS_NEVER;
 
 	if (r != 0) {
-		condlog(1, "%s: error in fstat for %s: %s", __func__,
-			path, strerror(err));
+		condlog(1, "%s: error in fstat for %s: %m", __func__, path);
 		return FIND_MULTIPATHS_ERROR;
 	}
 
-- 
2.19.2
