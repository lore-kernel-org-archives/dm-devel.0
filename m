From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 09/15] libmultipath/checkers/tur: Terminate a
 statement with a semicolon
Date: Tue, 4 Oct 2016 10:40:13 -0700
Message-ID: <643c7858-58ed-1c2a-0463-cafbaef962bb@sandisk.com>
References: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch does not affect any functionality but helps editors to
auto-indent the code below that statement correctly.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers/tur.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 67933cb..3f97f2a 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -215,7 +215,7 @@ static void *tur_thread(void *ctx)
 
 	ct->message[0] = '\0';
 	/* This thread can be canceled, so setup clean up */
-	tur_thread_cleanup_push(ct)
+	tur_thread_cleanup_push(ct);
 
 	/* TUR checker start up */
 	pthread_mutex_lock(&ct->lock);
-- 
2.10.0
