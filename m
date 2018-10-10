From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 6/6] libmultipath: timeout on unresponsive tur
	thread
Date: Wed, 10 Oct 2018 13:01:13 -0500
Message-ID: <1539194473-6243-7-git-send-email-bmarzins@redhat.com>
References: <1539194473-6243-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539194473-6243-1-git-send-email-bmarzins@redhat.com>
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

If the tur checker thread has been cancelled but isn't responding,
timeout instead of doing a sync check.  This will keep one bad
device from impacting all of multipathd.

Fixes: 455242d ("libmultipath: fix tur checker timeout")
Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 86c0cdc..b2a2170 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -305,10 +305,10 @@ int libcheck_check(struct checker * c)
 	} else {
 		if (uatomic_read(&ct->holders) > 1) {
 			/* The thread has been cancelled but hasn't
-			 * quilt. Fail back to synchronous mode */
-			condlog(3, "%d:%d : tur checker failing back to sync",
+			 * quit. exit with timeout. */
+			condlog(3, "%d:%d : tur thread not responding",
 				major(ct->devt), minor(ct->devt));
-			return tur_check(c->fd, c->timeout, c->message);
+			return PATH_TIMEOUT;
 		}
 		/* Start new TUR checker */
 		pthread_mutex_lock(&ct->lock);
-- 
2.7.4
