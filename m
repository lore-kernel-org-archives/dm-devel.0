From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: remove hwhandler when it's alua
Date: Thu,  6 Oct 2016 20:50:21 +0200
Message-ID: <20161006185021.3625-1-xose.vazquez@gmail.com>
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

Autodetected.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 367aa0a..1fc2f24 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -46,7 +46,6 @@ static struct hwentry default_hw[] = {
 		.product       = "VV",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.hwhandler     = "1 alua",
 		.prio_name     = PRIO_ALUA,
 		.no_path_retry = 18,
 	},
@@ -124,7 +123,6 @@ static struct hwentry default_hw[] = {
 		/* SAN Virtualization Services Platform */
 		.vendor        = "HP",
 		.product       = "HSVX700",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 12,
@@ -504,7 +502,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^IPR",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
@@ -546,7 +543,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "AIX",
 		.product       = "NVDISK",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
@@ -654,7 +650,6 @@ static struct hwentry default_hw[] = {
 		/* M-Series */
 		.vendor        = "NEC",
 		.product       = "DISK ARRAY",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
@@ -780,7 +775,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor	       = "(Intel|INTEL)",
 		.product       = "Multi-Flex",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
@@ -792,7 +786,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor	       = "(LIO-ORG|SUSE)",
 		.product       = "RBD",
-		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 12,
-- 
2.10.1
