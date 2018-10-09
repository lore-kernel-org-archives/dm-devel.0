From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 01/19] libmultipath: fix tur checker timeout
Date: Tue,  9 Oct 2018 18:02:58 -0500
Message-ID: <1539126196-28926-2-git-send-email-bmarzins@redhat.com>
References: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

The code previously was timing out mode if ct->thread was 0 but
ct->running wasn't. This combination never happens.  The idea was to
timeout if for some reason the path checker tried to cancel the thread,
but it didn't die.  The correct thing to check for this is ct->holders.
ct->holders will always be at least one when libcheck_check() is called,
since libcheck_free() won't get called until the device is no longer
being checked. So, if ct->holders is 2, that means that the tur thread
is has not shut down yet.

Also, instead of timing out, the tur checker will switch to synchronous
mode.  The chance of this code path happening is very low.  I simply
exists because the old thread must not interfere with a new thread
starting up. But if something does go very wrong, and a thread does get
stuck, this solution will keep the checker from just ignoring the device
forever.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index bf8486d..3c5e236 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -355,12 +355,13 @@ int libcheck_check(struct checker * c)
 		}
 		pthread_mutex_unlock(&ct->lock);
 	} else {
-		if (uatomic_read(&ct->running) != 0) {
-			/* pthread cancel failed. continue in sync mode */
+		if (uatomic_read(&ct->holders) > 1) {
+			/* The thread has been cancelled but hasn't
+			 * quilt. Fail back to synchronous mode */
 			pthread_mutex_unlock(&ct->lock);
-			condlog(3, "%s: tur thread not responding",
+			condlog(3, "%s: tur checker failing back to sync",
 				tur_devt(devt, sizeof(devt), ct));
-			return PATH_TIMEOUT;
+			return tur_check(c->fd, c->timeout, copy_msg_to_checker, c);
 		}
 		/* Start new TUR checker */
 		ct->state = PATH_UNCHECKED;
-- 
2.7.4
