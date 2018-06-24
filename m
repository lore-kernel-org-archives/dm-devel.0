From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 06/10] libmpathpersist: fix byte swapping for
	big endian systems
Date: Sun, 24 Jun 2018 21:09:40 +0200
Message-ID: <20180624190944.27158-7-mwilck@suse.com>
References: <20180624190944.27158-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180624190944.27158-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The functions "mpath_reverse_uintXY_byteorder"  were apparently meant to
convert BE integers to native. This leads to wrong results on big-endian
systems. Make these functions use the get_unaligned_beXY API, and rename.

Also, remove the unused endianness test in mpath_pr_ioctl.c.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist.c  |  8 ++---
 libmpathpersist/mpath_pr_ioctl.c | 54 +++++++++-----------------------
 2 files changed, 16 insertions(+), 46 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 6e9e67f9..435ef4b6 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -20,6 +20,7 @@
 #include <ctype.h>
 #include "propsel.h"
 #include "util.h"
+#include "unaligned.h"
 
 #include "mpath_persist.h"
 #include "mpathpr.h"
@@ -560,12 +561,7 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 		}
 		if (!rollback && (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)){
 			rollback = 1;
-			sa_key = 0;
-			for (i = 0; i < 8; ++i){
-				if (i > 0)
-					sa_key <<= 8;
-				sa_key |= paramp->sa_key[i];
-			}
+			sa_key = get_unaligned_be64(&paramp->sa_key[0]);
 			status = MPATH_PR_RESERV_CONFLICT ;
 		}
 		if (!rollback && (status == MPATH_PR_SUCCESS)){
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 347f21b2..8416a3bf 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -31,8 +31,8 @@ void dumpHex(const char* str, int len, int no_ascii);
 int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
 		unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
 uint32_t  format_transportids(struct prout_param_descriptor *paramp);
-void mpath_reverse_uint32_byteorder(uint32_t *num);
-void mpath_reverse_uint16_byteorder(uint16_t *num);
+void convert_be32_to_cpu(uint32_t *num);
+void convert_be16_to_cpu(uint16_t *num);
 void decode_transport_id(struct prin_fulldescr *fdesc, unsigned char * p, int length);
 int get_prin_length(int rq_servact);
 int mpath_isLittleEndian(void);
@@ -183,23 +183,23 @@ uint32_t  format_transportids(struct prout_param_descriptor *paramp)
 
 void mpath_format_readkeys( struct prin_resp *pr_buff, int len, int noisy)
 {
-	mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.prgeneration);
-	mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.additional_length);
+	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readkeys.prgeneration);
+	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readkeys.additional_length);
 }
 
 void mpath_format_readresv(struct prin_resp *pr_buff, int len, int noisy)
 {
 
-	mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.prgeneration);
-	mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readkeys.additional_length);
+	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readkeys.prgeneration);
+	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readkeys.additional_length);
 
 	return;
 }
 
 void mpath_format_reportcapabilities(struct prin_resp *pr_buff, int len, int noisy)
 {
-	mpath_reverse_uint16_byteorder(&pr_buff->prin_descriptor.prin_readcap.length);
-	mpath_reverse_uint16_byteorder(&pr_buff->prin_descriptor.prin_readcap.pr_type_mask);
+	convert_be16_to_cpu(&pr_buff->prin_descriptor.prin_readcap.length);
+	convert_be16_to_cpu(&pr_buff->prin_descriptor.prin_readcap.pr_type_mask);
 
 	return;
 }
@@ -213,8 +213,8 @@ void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy)
 	uint32_t additional_length;
 
 
-	mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readfd.prgeneration);
-	mpath_reverse_uint32_byteorder(&pr_buff->prin_descriptor.prin_readfd.number_of_descriptor);
+	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readfd.prgeneration);
+	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readfd.number_of_descriptor);
 
 	if (pr_buff->prin_descriptor.prin_readfd.number_of_descriptor == 0)
 	{
@@ -469,40 +469,14 @@ int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr,
 	return MPATH_PR_SUCCESS;
 }
 
-int mpath_isLittleEndian(void)
+void convert_be16_to_cpu(uint16_t *num)
 {
-	int num = 1;
-	if(*(char *)&num == 1)
-	{
-		condlog(4, "Little-Endian");
-	}
-	else
-	{
-		condlog(4, "Big-Endian");
-	}
-	return 0;
-}
-
-void mpath_reverse_uint16_byteorder(uint16_t *num)
-{
-	uint16_t byte0, byte1;
-
-	byte0 = (*num & 0x000000FF) >>  0 ;
-	byte1 = (*num & 0x0000FF00) >>  8 ;
-
-	*num = ((byte0 << 8) | (byte1 << 0));
+	*num = get_unaligned_be16(num);
 }
 
-void mpath_reverse_uint32_byteorder(uint32_t *num)
+void convert_be32_to_cpu(uint32_t *num)
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
