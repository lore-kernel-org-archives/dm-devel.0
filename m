From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/11] multipath: do not call tur in sync mode if
	pthread_cancel fails
Date: Fri, 13 Dec 2013 13:14:09 +0100
Message-ID: <1386936854-8399-7-git-send-email-hare@suse.de>
References: <1386936854-8399-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386936854-8399-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

When pthread_cancel fails the thread is stuck, most likely
during I/O submission. So it would be pointless to call the
tur checker in sync mode here, as this would be stuck, too.
Hence we should rather return 'PATH_TIMEOUT' and hope the
situation resolves itself over time.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/checkers/tur.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index b76dcec..bd7372d 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -298,7 +298,6 @@ libcheck_check (struct checker * c)
 				ct->running = 0;
 				MSG(c, MSG_TUR_TIMEOUT);
 				tur_status = PATH_TIMEOUT;
-				ct->state = PATH_UNCHECKED;
 			} else {
 				condlog(3, "%d:%d: tur checker not finished",
 					TUR_DEVT(ct));
@@ -317,9 +316,9 @@ libcheck_check (struct checker * c)
 		if (ct->thread) {
 			/* pthread cancel failed. continue in sync mode */
 			pthread_mutex_unlock(&ct->lock);
-			condlog(3, "%d:%d: tur thread not responding, "
-				"using sync mode", TUR_DEVT(ct));
-			return tur_check(c->fd, c->timeout, c->message);
+			condlog(3, "%d:%d: tur thread not responding",
+				TUR_DEVT(ct));
+			return PATH_TIMEOUT;
 		}
 		/* Start new TUR checker */
 		ct->state = PATH_UNCHECKED;
-- 
1.8.1.4
