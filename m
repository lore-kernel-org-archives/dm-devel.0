From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 8/8] dm init: Set file local variable static
Date: Wed, 15 Jul 2020 18:52:17 +0900
Message-ID: <20200715095217.441885-9-damien.lemoal@wdc.com>
References: <20200715095217.441885-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200715095217.441885-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

Declare dm_allowed_targets as static to avoid the warning:

drivers/md/dm-init.c:39:12: warning: symbol 'dm_allowed_targets' was
not declared. Should it be static?

when compiling with C=1.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index b869316d3722..b0c45c6ebe0b 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -36,7 +36,7 @@ struct dm_device {
 	struct list_head list;
 };
 
-const char * const dm_allowed_targets[] __initconst = {
+static const char * const dm_allowed_targets[] __initconst = {
 	"crypt",
 	"delay",
 	"linear",
-- 
2.26.2
