From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/4] multipath-tools: change the default path
	checker from directio to tur
Date: Thu, 23 Jun 2016 15:42:17 +0200
Message-ID: <1466689340-5590-2-git-send-email-xose.vazquez@gmail.com>
References: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Matthias Rudolph <matthias.rudolph@hds.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Yacine Kheddache <yacine@alyseo.com>, device-mapper development <dm-devel@redhat.com>, "Brian King,
	IBM" <brking@linux.vnet.ibm.com>, Srinivasan Ramani <srinivas.ramani@oracle.com>, Sean Stewart <sean.stewart@netapp.com>, Shyam Sundar <g.shyamsundar@yahoo.co.in>, "Bart Brooks,
	Pivot3" <bartb@pivot3.com>, "Edward Goggin, EMC" <egoggin@emc.com>
List-Id: dm-devel.ids

change DEFAULT_CHECKER to TUR

Cc: Shyam Sundar <g.shyamsundar@yahoo.co.in>
Cc: Edward Goggin, EMC <egoggin@emc.com>
Cc: Matthias Rudolph <matthias.rudolph@hds.com>
Cc: Brian King, IBM <brking@linux.vnet.ibm.com>
Cc: Yacine Kheddache <yacine@alyseo.com>
Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>
Cc: Bart Brooks, Pivot3 <bartb@pivot3.com>
Cc: Martin George <marting@netapp.com>
Cc: Sean Stewart <sean.stewart@netapp.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/checkers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index a935b3f..374c826 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -85,7 +85,7 @@ enum path_check_state {
 #define READSECTOR0  "readsector0"
 #define CCISS_TUR    "cciss_tur"
 
-#define DEFAULT_CHECKER DIRECTIO
+#define DEFAULT_CHECKER TUR
 
 #define ASYNC_TIMEOUT_SEC	30
 
-- 
2.5.5
