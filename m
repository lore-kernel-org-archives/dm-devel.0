From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/4] multipath-tools: replace GROUP_BY_SERIAL
	with MULTIBUS for IBM 3542 and 2105
Date: Thu, 18 Aug 2016 19:58:14 +0200
Message-ID: <1471543096-11441-2-git-send-email-xose.vazquez@gmail.com>
References: <1471543096-11441-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471543096-11441-1-git-send-email-xose.vazquez@gmail.com>
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

It doesn't make any sense to have, by default, GROUP_BY_SERIAL in real hardware.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index aa3ea9b..72b5e1d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -443,7 +443,7 @@ static struct hwentry default_hw[] = {
 		/* DS4200 / FAStT200 */
 		.vendor        = "IBM",
 		.product       = "^3542",
-		.pgpolicy      = GROUP_BY_SERIAL,
+		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
@@ -451,7 +451,7 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^2105",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.pgpolicy      = GROUP_BY_SERIAL,
+		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-- 
2.7.4
