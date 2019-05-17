From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 1/4] libmultipath: handle clock_gettime failures
	in tur checker
Date: Fri, 17 May 2019 11:14:07 -0500
Message-ID: <1558109650-21179-2-git-send-email-bmarzins@redhat.com>
References: <1558109650-21179-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1558109650-21179-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If clock_gettime() fails, and multipathd can't figure out when it should
time out, it should just default to assuming that it has already timed
out. Found by coverity.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 6b08dbbb..717353ef 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -290,7 +290,12 @@ static void *tur_thread(void *ctx)
 
 static void tur_timeout(struct timespec *tsp)
 {
-	clock_gettime(CLOCK_MONOTONIC, tsp);
+	if (clock_gettime(CLOCK_MONOTONIC, tsp) != 0) {
+		/* can't get time. clear tsp to not wait */
+		tsp->tv_sec = 0;
+		tsp->tv_nsec = 0;
+		return;
+	}
 	tsp->tv_nsec += 1000 * 1000; /* 1 millisecond */
 	normalize_timespec(tsp);
 }
@@ -300,8 +305,12 @@ static void tur_set_async_timeout(struct checker *c)
 	struct tur_checker_context *ct = c->context;
 	struct timespec now;
 
-	clock_gettime(CLOCK_MONOTONIC, &now);
-	ct->time = now.tv_sec + c->timeout;
+	if (clock_gettime(CLOCK_MONOTONIC, &now) != 0)
+		/* can't get time. clear time to always timeout on
+		 * next path check */
+		ct->time = 0;
+	else
+		ct->time = now.tv_sec + c->timeout;
 }
 
 static int tur_check_async_timeout(struct checker *c)
@@ -309,7 +318,9 @@ static int tur_check_async_timeout(struct checker *c)
 	struct tur_checker_context *ct = c->context;
 	struct timespec now;
 
-	clock_gettime(CLOCK_MONOTONIC, &now);
+	if (clock_gettime(CLOCK_MONOTONIC, &now) != 0)
+		/* can't get time. assume we've timed out */
+		return 1;
 	return (now.tv_sec > ct->time);
 }
 
-- 
2.17.2
