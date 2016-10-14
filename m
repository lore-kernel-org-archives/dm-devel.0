From: tang.wenjun3@zte.com.cn
Subject: [PATCH 16/94] multipath-tools: replace spaces with a
	regex in IBM/"3303 NVDISK"
Date: Fri, 14 Oct 2016 09:55:58 +0800
Message-ID: <1476410236-9368-16-git-send-email-tang.wenjun3@zte.com.cn>
References: <1476410236-9368-1-git-send-email-tang.wenjun3@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1476410236-9368-1-git-send-email-tang.wenjun3@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 10144149@zte.com.cn
Cc: Brian King <brking@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

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
index 9a4ab6e..9366829 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -529,8 +529,9 @@ static struct hwentry default_hw[] = {
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
2.8.1.windows.1
