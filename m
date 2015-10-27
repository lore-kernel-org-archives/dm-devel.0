From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 3/6] dm-delay: Capitalize error message
	consistently
Date: Wed, 28 Oct 2015 04:38:57 +0900
Message-ID: <1445974740-8362-3-git-send-email-kusumi.tomohiro@gmail.com>
References: <1445974740-8362-1-git-send-email-kusumi.tomohiro@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1445974740-8362-1-git-send-email-kusumi.tomohiro@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, mpatocka@redhat.com
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Other ti->error's are all capitalized.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 drivers/md/dm-delay.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 772b720..b4c356a 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -133,7 +133,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	int ret;
 
 	if (argc != 3 && argc != 6) {
-		ti->error = "requires exactly 3 or 6 arguments";
+		ti->error = "Requires exactly 3 or 6 arguments";
 		return -EINVAL;
 	}
 
-- 
1.7.1
