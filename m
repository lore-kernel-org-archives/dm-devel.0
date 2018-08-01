From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 16/32] libmultipath: fix tur checker timeout
Date: Wed,  1 Aug 2018 15:57:02 -0500
Message-ID: <1533157038-3924-17-git-send-email-bmarzins@redhat.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
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

The code previously was timing out mode if ct->thread was 0 but
ct->running wasn't. This combination never happens.  The idea was to
timeout if for some reason the path checker tried to kill the thread,
but it didn't die.  The correct thing to check for this is ct->holders.
ct->holders will always be at least one when libcheck_check() is called,
since libcheck_free() won't get called until the device is no longer
being checked. So, if ct->holders is 2, that means that the tur thread
is has not shut down yet.

Also, instead of returning PATH_TIMEOUT whenever the thread hasn't died,
it should only time out if the thread didn't successfully get a value,
which means the previous state was already PATH_TIMEOUT.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index bf8486d..275541f 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -355,12 +355,15 @@ int libcheck_check(struct checker * c)
 		}
 		pthread_mutex_unlock(&ct->lock);
 	} else {
-		if (uatomic_read(&ct->running) != 0) {
-			/* pthread cancel failed. continue in sync mode */
-			pthread_mutex_unlock(&ct->lock);
-			condlog(3, "%s: tur thread not responding",
-				tur_devt(devt, sizeof(devt), ct));
-			return PATH_TIMEOUT;
+		if (uatomic_read(&ct->holders) > 1) {
+			/* pthread cancel failed. If it didn't get the path
+			   state already, timeout */
+			if (ct->state == PATH_PENDING) {
+				pthread_mutex_unlock(&ct->lock);
+				condlog(3, "%s: tur thread not responding",
+					tur_devt(devt, sizeof(devt), ct));
+				return PATH_TIMEOUT;
+			}
 		}
 		/* Start new TUR checker */
 		ct->state = PATH_UNCHECKED;
-- 
2.7.4
