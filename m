From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] hwtable: set 'none' as default checker for
	NVMe
Date: Fri, 15 Sep 2017 08:30:30 +0200
Message-ID: <1505457030-119611-5-git-send-email-hare@suse.de>
References: <1505457030-119611-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505457030-119611-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

We shouldn't be using the directio checker for NVMe, as this might
cause spurious path failures under high load.
As the 'state' attribute provides reliable information about the link
status it's sufficient to just check this and don't call any
path checkers.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 9e14ec1..9ac09ff 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1113,7 +1113,7 @@ static struct hwentry default_hw[] = {
 		.vendor        = "NVME",
 		.product       = ".*",
 		.uid_attribute = "ID_WWN",
-		.checker_name  = DIRECTIO,
+		.checker_name  = NONE,
 		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
 	},
 	/*
-- 
1.8.5.6
