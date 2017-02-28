From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 30/33] tur: Add pthread_testcancel()
Date: Tue, 28 Feb 2017 17:23:26 +0100
Message-ID: <20170228162329.14517-31-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
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

From: Hannes Reinecke <hare@suse.de>

When the ioctl returns we need to check if a cancellation has
been requested; otherwise we'd be re-setting the state and
overwrite any pending values.


Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/checkers/tur.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index d9a9e67d..b4a5cb2f 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -268,6 +268,7 @@ static void *tur_thread(void *ctx)
 	pthread_mutex_unlock(&ct->lock);
 
 	state = tur_check(ct->fd, ct->timeout, copy_msg_to_tcc, ct->message);
+	pthread_testcancel();
 
 	/* TUR checker done */
 	pthread_mutex_lock(&ct->lock);
-- 
2.11.0
