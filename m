From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: fix indent and replace spaces
	with tab
Date: Sat,  5 Nov 2016 11:50:46 +0100
Message-ID: <20161105105046.2388-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/checkers.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index fedc330..1d225de 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -112,8 +112,8 @@ struct checker {
 						multipath-wide. Use MALLOC if
 						you want to stuff data in. */
 	int (*check)(struct checker *);
-	void (*repair)(struct checker *);     /* called if check returns
-					        PATH_DOWN to bring path into
+	void (*repair)(struct checker *);    /* called if check returns
+						PATH_DOWN to bring path into
 						usable state */
 	int (*init)(struct checker *);       /* to allocate the context */
 	void (*free)(struct checker *);      /* to free the context */
-- 
2.10.2
