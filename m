From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 37/39] libmultipath: add spin_lock in tur.c
Date: Thu, 16 Jun 2016 11:47:43 +0200
Message-ID: <1466070465-1021-38-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

When failing to start the pthread we still should be taking
the spin lock; there might be other threads pending.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/checkers/tur.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index bd7372d..2edc8ad 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -331,9 +331,11 @@ libcheck_check (struct checker * c)
 		setup_thread_attr(&attr, 32 * 1024, 1);
 		r = pthread_create(&ct->thread, &attr, tur_thread, ct);
 		if (r) {
+			pthread_spin_lock(&ct->hldr_lock);
+			ct->holders--;
+			pthread_spin_unlock(&ct->hldr_lock);
 			pthread_mutex_unlock(&ct->lock);
 			ct->thread = 0;
-			ct->holders--;
 			condlog(3, "%d:%d: failed to start tur thread, using"
 				" sync mode", TUR_DEVT(ct));
 			return tur_check(c->fd, c->timeout, c->message);
-- 
2.6.6
