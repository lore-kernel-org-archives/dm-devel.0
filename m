From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 7/7] Remove a superfluous "extern" keyword
Date: Wed, 17 May 2017 08:43:09 -0700
Message-ID: <20170517154309.17787-8-bart.vanassche@sandisk.com>
References: <20170517154309.17787-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517154309.17787-1-bart.vanassche@sandisk.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Since it is not necessary to use the "extern" keyword in front of
a function definition, remove that keyword.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/propsel.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 09fe7282..3c057237 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -744,8 +744,7 @@ out:
 	return 0;
 }
 
-extern int
-select_max_sectors_kb (struct config *conf, struct multipath * mp)
+int select_max_sectors_kb(struct config *conf, struct multipath * mp)
 {
 	char *origin;
 
-- 
2.12.2
