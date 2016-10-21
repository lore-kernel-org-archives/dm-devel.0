From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 06/15] libmultipath: Remove an unused function
Date: Fri, 21 Oct 2016 11:43:31 -0700
Message-ID: <1fcae43b-f64e-7001-ef0d-68ec0585c81d@sandisk.com>
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

The function snprint_config() is not used. Hence remove it.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/print.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 9aa41ad..09e4a2e 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1745,12 +1745,6 @@ snprint_devices (struct config *conf, char * buff, int len, struct vectors *vecs
 	return fwd;
 }
 
-extern int
-snprint_config (char * buff, int len)
-{
-	return 0;
-}
-
 /*
  * stdout printing helpers
  */
-- 
2.10.1
