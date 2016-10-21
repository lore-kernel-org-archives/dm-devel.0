From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 09/15] libmultipath/checkers/rbd: Use unsigned
 int for one-bit bitfields
Date: Fri, 21 Oct 2016 11:44:31 -0700
Message-ID: <3fea16e1-1c74-4e43-a108-329e7d03d858@sandisk.com>
References: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
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

Avoid that this bitfield is sign-extended. Detected by sparse.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index f60914e..745e240 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -46,7 +46,7 @@ struct rbd_checker_context {
 	char *username;
 	int remapped;
 	int blacklisted;
-	int lock_on_read:1;
+	unsigned lock_on_read:1;
 
 	rados_t cluster;
 
-- 
2.10.1
