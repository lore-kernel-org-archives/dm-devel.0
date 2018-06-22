From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 4/6] libmpathpersist: fix byte swapping for big
	endian systems
Date: Sat, 23 Jun 2018 01:15:14 +0200
Message-ID: <20180622231516.18806-4-mwilck@suse.com>
References: <20180622231516.18806-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180622231516.18806-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Eli Qiao <taget@linux.vnet.ibm.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This code was obviously intended to convert big-endian data
from PRIN to CPU endianness. It doesn't work on big endian systems.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist.c  |  7 +------
 libmpathpersist/mpath_pr_ioctl.c | 16 ++--------------
 2 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 907a17c9..12dad7a7 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -543,12 +543,7 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 		}
 		if (!rollback && (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)){
 			rollback = 1;
-			sa_key = 0;
-			for (i = 0; i < 8; ++i){
-				if (i > 0)
-					sa_key <<= 8;
-				sa_key |= paramp->sa_key[i];
-			}
+			sa_key = be64_to_cpu(*(uint64_t *)&paramp->sa_key[0]);
 			status = MPATH_PR_RESERV_CONFLICT ;
 		}
 		if (!rollback && (status == MPATH_PR_SUCCESS)){
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 347f21b2..76271ff1 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -485,24 +485,12 @@ int mpath_isLittleEndian(void)
 
 void mpath_reverse_uint16_byteorder(uint16_t *num)
 {
-	uint16_t byte0, byte1;
-
-	byte0 = (*num & 0x000000FF) >>  0 ;
-	byte1 = (*num & 0x0000FF00) >>  8 ;
-
-	*num = ((byte0 << 8) | (byte1 << 0));
+	*num = get_unaligned_be16(num);
 }
 
 void mpath_reverse_uint32_byteorder(uint32_t *num)
 {
-	uint32_t byte0, byte1, byte2, byte3;
-
-	byte0 = (*num & 0x000000FF) >>  0 ;
-	byte1 = (*num & 0x0000FF00) >>  8 ;
-	byte2 = (*num & 0x00FF0000) >> 16 ;
-	byte3 = (*num & 0xFF000000) >> 24 ;
-
-	*num = ((byte0 << 24) | (byte1 << 16) | (byte2 << 8) | (byte3 << 0));
+	*num = get_unaligned_be32(num);
 }
 
 void
-- 
2.17.1
