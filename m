From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 05/17] libmultipath: fix tur checker timeout
	issue
Date: Wed,  8 Aug 2018 17:21:23 -0500
Message-ID: <1533766895-28605-6-git-send-email-bmarzins@redhat.com>
References: <1533766895-28605-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533766895-28605-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If the tur checker is run, and the tur_thread has timed out,
libcheck_check() doesn't actually check if the thread is still running.
This means that the thread could have already completed successfully,
but the tur checker would still return PATH_TIMEOUT, instead of the
value returned by the thread. This patch makes libcheck_check() actually
check if the thread completed, and if so, it returns the proper value.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 9f6ef51..4e2c7a8 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -276,12 +276,19 @@ int libcheck_check(struct checker * c)
 	if (ct->thread) {
 		if (tur_check_async_timeout(c)) {
 			int running = uatomic_xchg(&ct->running, 0);
-			if (running)
+			if (running) {
 				pthread_cancel(ct->thread);
-			condlog(3, "%s: tur checker timeout", ct->devt);
+				condlog(3, "%s: tur checker timeout", ct->devt);
+				MSG(c, MSG_TUR_TIMEOUT);
+				tur_status = PATH_TIMEOUT;
+			} else {
+				pthread_mutex_lock(&ct->lock);
+				tur_status = ct->state;
+				strlcpy(c->message, ct->message,
+					sizeof(c->message));
+				pthread_mutex_unlock(&ct->lock);
+			}
 			ct->thread = 0;
-			MSG(c, MSG_TUR_TIMEOUT);
-			tur_status = PATH_TIMEOUT;
 		} else if (uatomic_read(&ct->running) != 0) {
 			condlog(3, "%s: tur checker not finished", ct->devt);
 			tur_status = PATH_PENDING;
-- 
2.7.4
