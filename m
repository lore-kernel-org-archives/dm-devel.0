From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/3] libmultipath: replace PATH_TIMEOUT with
	PATH_DOWN
Date: Fri,  3 Oct 2014 19:11:21 -0500
Message-ID: <1412381483-15757-2-git-send-email-bmarzins@redhat.com>
References: <1412381483-15757-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1412381483-15757-1-git-send-email-bmarzins@redhat.com>
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

The way the code works, PATH_TIMEOUT is treated mostly like PATH_UP or
PATH_GHOST by check_path.  If the the path was previously failed,  it will
even reinstate the path. It will also trigger prio refreshing. It seems
that PATH_TIMEOUT should be at least as serious as PATH_PENDING, but the
way the code works, it's not.  In pathinfo, PATH_TIMEOUT gets changed
directly to PATH_DOWN, which makes sense.  But assuming that's the correct
thing to do, why have PATH_TIMEOUT at all?

The only thing that it does that seems helpful is that when you print out
the path, instead of it saying that the path is down, it says that the
path has timed out.  But if we are going to treat is like the path is
down, then I don't see this being too helpful.  And the way we are treating
PATH_TIMEOUT right now is definitely not right.

This patch just pulls out the PATH_TIMEOUT code and replaces it with
PATH_DOWN.  I'm not adverse to the PATH_TIMEOUT state existing if it worked
correctly, but I'm not sure what it's for.

Cc: "Hannes Reinecke <hare@suse.de>"
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c     | 1 -
 libmultipath/checkers.h     | 5 -----
 libmultipath/checkers/tur.c | 5 ++---
 libmultipath/discovery.c    | 2 --
 libmultipath/print.c        | 2 --
 5 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 4a4cd7c..d98b781 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -17,7 +17,6 @@ char *checker_state_names[] = {
       "shaky",
       "ghost",
       "pending",
-      "timeout",
       "removed",
 };
 
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index e62b52f..338b792 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -47,10 +47,6 @@
  * - Use: All async checkers
  * - Description: Indicates a check IO is in flight.
  *
- * PATH_TIMEOUT:
- * - Use: Only tur checker
- * - Description: Command timed out
- *
  * PATH REMOVED:
  * - Use: All checkers
  * - Description: Device has been removed from the system
@@ -63,7 +59,6 @@ enum path_check_state {
 	PATH_SHAKY,
 	PATH_GHOST,
 	PATH_PENDING,
-	PATH_TIMEOUT,
 	PATH_REMOVED,
 	PATH_MAX_STATE
 };
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index bd7372d..b0bff21 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -297,7 +297,7 @@ libcheck_check (struct checker * c)
 				pthread_cancel(ct->thread);
 				ct->running = 0;
 				MSG(c, MSG_TUR_TIMEOUT);
-				tur_status = PATH_TIMEOUT;
+				tur_status = PATH_DOWN;
 			} else {
 				condlog(3, "%d:%d: tur checker not finished",
 					TUR_DEVT(ct));
@@ -314,11 +314,10 @@ libcheck_check (struct checker * c)
 		pthread_mutex_unlock(&ct->lock);
 	} else {
 		if (ct->thread) {
-			/* pthread cancel failed. continue in sync mode */
 			pthread_mutex_unlock(&ct->lock);
 			condlog(3, "%d:%d: tur thread not responding",
 				TUR_DEVT(ct));
-			return PATH_TIMEOUT;
+			return PATH_DOWN;
 		}
 		/* Start new TUR checker */
 		ct->state = PATH_UNCHECKED;
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index af2aa20..b3232b2 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1218,8 +1218,6 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 			if (pp->state == PATH_UNCHECKED ||
 			    pp->state == PATH_WILD)
 				goto blank;
-			if (pp->state == PATH_TIMEOUT)
-				pp->state = PATH_DOWN;
 		} else {
 			condlog(3, "%s: path inaccessible", pp->dev);
 			pp->chkrstate = pp->state = path_state;
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 383eae4..9d204e8 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -338,8 +338,6 @@ snprint_chk_state (char * buff, size_t len, struct path * pp)
 		return snprintf(buff, len, "ghost");
 	case PATH_PENDING:
 		return snprintf(buff, len, "i/o pending");
-	case PATH_TIMEOUT:
-		return snprintf(buff, len, "i/o timeout");
 	default:
 		return snprintf(buff, len, "undef");
 	}
-- 
1.8.3.1
