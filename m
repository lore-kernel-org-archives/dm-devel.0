From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 7/8] libmultipath: handle TUR threads that can't
	be cancelled
Date: Wed, 10 Oct 2018 22:05:05 +0200
Message-ID: <20181010200506.15796-8-mwilck@suse.com>
References: <20181010200506.15796-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181010200506.15796-1-mwilck@suse.com>
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

When the tur checker code determines that a hanging TUR thread
couldn't be cancelled, rather than simply returning, reallocate
the checker context and start a new thread. This will leak some
memory if the hanging thread never wakes up again, but well, in
that highly unlikely case we're leaking threads anyway.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/tur.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index a986a244..9ecca5bd 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -349,11 +349,29 @@ int libcheck_check(struct checker * c)
 		}
 	} else {
 		if (uatomic_read(&ct->holders) > 1) {
-			/* The thread has been cancelled but hasn't
-			 * quit. exit with timeout. */
+			int holders;
+
+			/*
+			 * The thread has been cancelled but hasn't quit.
+			 * We have to prevent it from interfering with the new
+			 * thread. We create a new context and leave the old
+			 * one with the stale thread, hoping it will clean up
+			 * eventually.
+			 */
 			condlog(3, "%d:%d : tur thread not responding",
 				major(ct->devt), minor(ct->devt));
-			return PATH_TIMEOUT;
+
+			/* libcheck_init will replace c->context */
+			libcheck_init(c);
+
+			holders = uatomic_sub_return(&ct->holders, 1);
+			if (!holders)
+				/* It did terminate, eventually */
+				cleanup_context(ct);
+
+			ct = c->context;
+			if (ct == NULL)
+				return PATH_UNCHECKED;
 		}
 		/* Start new TUR checker */
 		pthread_mutex_lock(&ct->lock);
-- 
2.19.0
