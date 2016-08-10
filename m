From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 04/15] multipath-tools: replace spaces with a
	regex in IBM/"3303 NVDISK"
Date: Wed, 10 Aug 2016 18:20:27 +0200
Message-ID: <1470846038-6590-4-git-send-email-xose.vazquez@gmail.com>
References: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Brian King <brking@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Replace six spaces with any number of them.
Exact regex is "3303[ ]{6,6}NVDISK", but it looks too overloaded.

Tested with a regex checker from:
http://eli.thegreenplace.net/2012/11/14/some-notes-on-posix-regular-expressions

Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index ba87ed2..e0c33dc 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -537,8 +537,9 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
 	{
+		/* 3303 NVDISK */
 		.vendor        = "IBM",
-		.product       = "3303      NVDISK",
+		.product       = "3303[ ]+NVDISK",
 		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
-- 
2.7.4
