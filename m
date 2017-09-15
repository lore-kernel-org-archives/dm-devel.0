From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/5] libmultipath: change reservation_key to a
	uint64_t
Date: Fri, 15 Sep 2017 17:25:33 -0500
Message-ID: <1505514336-27839-4-git-send-email-bmarzins@redhat.com>
References: <1505514336-27839-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505514336-27839-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The reservation key is currently being stored as any array of 8 unsigned
chars.  This is exactly the same in-memory representation as a big
endian 64 bit integer. However, the code for dealing with a big endian
64 bit integer is much simpler, so switch to use that instead.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c | 23 +++++++----------------
 libmultipath/byteorder.h        | 36 ++++++++++++++++++++++++++++++++++++
 libmultipath/config.c           |  3 ---
 libmultipath/config.h           |  6 ++++--
 libmultipath/dict.c             | 31 ++++---------------------------
 libmultipath/propsel.c          |  6 +++---
 libmultipath/structs.h          |  5 ++++-
 multipathd/main.c               | 23 +++++------------------
 8 files changed, 63 insertions(+), 70 deletions(-)
 create mode 100644 libmultipath/byteorder.h

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index aab6d95..960d50d 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -776,7 +776,7 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	}
 
 	if (mpp->reservation_key ){
-		memcpy (pamp->key, mpp->reservation_key, 8);
+		memcpy (pamp->key, &mpp->reservation_key, 8);
 		condlog (3, "%s: reservation key set.", mpp->wwid);
 	}
 
@@ -794,7 +794,7 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	for (i = 0; i < num; i++){
 		if (mpp->reservation_key &&
 			memcmp(pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key,
-			       mpp->reservation_key, 8)){
+			       &mpp->reservation_key, 8)){
 			/*register with tarnsport id*/
 			memset(pamp, 0, length);
 			pamp->trnptid_list[0] = pptr;
@@ -828,7 +828,7 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 
 	if (found){
 		memset (pamp, 0, length);
-		memcpy (pamp->sa_key, mpp->reservation_key, 8);
+		memcpy (pamp->sa_key, &mpp->reservation_key, 8);
 		memset (pamp->key, 0, 8);
 		status = mpath_prout_reg(mpp, MPATH_PROUT_REG_SA, rq_scope, rq_type, pamp, noisy);
 	}
@@ -873,9 +873,7 @@ int update_map_pr(struct multipath *mpp)
 {
 	int noisy=0;
 	struct prin_resp *resp;
-	int i,j, ret, isFound;
-	unsigned char *keyp;
-	uint64_t prkey;
+	int i, ret, isFound;
 
 	if (!mpp->reservation_key)
 	{
@@ -906,15 +904,8 @@ int update_map_pr(struct multipath *mpp)
 		return MPATH_PR_SUCCESS;
 	}
 
-	prkey = 0;
-	keyp = mpp->reservation_key;
-	for (j = 0; j < 8; ++j) {
-		if (j > 0)
-			prkey <<= 8;
-		prkey |= *keyp;
-		++keyp;
-	}
-	condlog(2, "%s: Multipath  reservation_key: 0x%" PRIx64 " ", mpp->alias, prkey);
+	condlog(2, "%s: Multipath  reservation_key: 0x%" PRIx64 " ", mpp->alias,
+		be64_to_cpu(mpp->reservation_key));
 
 	isFound =0;
 	for (i = 0; i < resp->prin_descriptor.prin_readkeys.additional_length/8; i++ )
@@ -922,7 +913,7 @@ int update_map_pr(struct multipath *mpp)
 		condlog(2, "%s: PR IN READKEYS[%d]  reservation key:", mpp->alias, i);
 		dumpHex((char *)&resp->prin_descriptor.prin_readkeys.key_list[i*8], 8 , 1);
 
-		if (!memcmp(mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i*8], 8))
+		if (!memcmp(&mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i*8], 8))
 		{
 			condlog(2, "%s: reservation key found in pr in readkeys response", mpp->alias);
 			isFound =1;
diff --git a/libmultipath/byteorder.h b/libmultipath/byteorder.h
new file mode 100644
index 0000000..5ddb661
--- /dev/null
+++ b/libmultipath/byteorder.h
@@ -0,0 +1,36 @@
+#ifndef BYTEORDER_H_INCLUDED
+#define BYTEORDER_H_INCLUDED
+
+#ifdef __linux__
+#  include <endian.h>
+#  include <byteswap.h>
+#else
+#  error unsupported
+#endif
+
+#if BYTE_ORDER == LITTLE_ENDIAN
+#  define le16_to_cpu(x) (x)
+#  define be16_to_cpu(x) bswap_16(x)
+#  define le32_to_cpu(x) (x)
+#  define le64_to_cpu(x) (x)
+#  define be32_to_cpu(x) bswap_32(x)
+#  define be64_to_cpu(x) bswap_64(x)
+#elif BYTE_ORDER == BIG_ENDIAN
+#  define le16_to_cpu(x) bswap_16(x)
+#  define be16_to_cpu(x) (x)
+#  define le32_to_cpu(x) bswap_32(x)
+#  define le64_to_cpu(x) bswap_64(x)
+#  define be32_to_cpu(x) (x)
+#  define be64_to_cpu(x) (x)
+#else
+#  error unsupported
+#endif
+
+#define cpu_to_le16(x) le16_to_cpu(x)
+#define cpu_to_be16(x) be16_to_cpu(x)
+#define cpu_to_le32(x) le32_to_cpu(x)
+#define cpu_to_be32(x) be32_to_cpu(x)
+#define cpu_to_le64(x) le64_to_cpu(x)
+#define cpu_to_be64(x) be64_to_cpu(x)
+
+#endif				/* BYTEORDER_H_INCLUDED */
diff --git a/libmultipath/config.c b/libmultipath/config.c
index b21a3aa..dba4bc4 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -532,9 +532,6 @@ free_config (struct config * conf)
 	if (conf->config_dir)
 		FREE(conf->config_dir);
 
-	if (conf->reservation_key)
-		FREE(conf->reservation_key);
-
 	free_blacklist(conf->blist_devnode);
 	free_blacklist(conf->blist_wwid);
 	free_blacklist(conf->blist_property);
diff --git a/libmultipath/config.h b/libmultipath/config.h
index ffc69b5..c504570 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -4,6 +4,8 @@
 #include <sys/types.h>
 #include <stdint.h>
 #include <urcu.h>
+#include <inttypes.h>
+#include "byteorder.h"
 
 #define ORIGIN_DEFAULT 0
 #define ORIGIN_CONFIG  1
@@ -90,7 +92,7 @@ struct mpentry {
 
 	char * prio_name;
 	char * prio_args;
-	unsigned char * reservation_key;
+	uint64_t  reservation_key; /* stored in big-endian format */
 	int pgpolicy;
 	int pgfailback;
 	int rr_weight;
@@ -183,7 +185,7 @@ struct config {
 	char * alias_prefix;
 	char * partition_delim;
 	char * config_dir;
-	unsigned char * reservation_key;
+	uint64_t  reservation_key; /* stored in big-endian format */
 
 	vector keywords;
 	vector mptable;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 680b2c5..f37348b 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -962,9 +962,8 @@ snprint_def_log_checker_err (struct config *conf, char * buff, int len, void * d
 static int
 set_reservation_key(vector strvec, void *ptr)
 {
-	unsigned char **uchar_ptr = (unsigned char **)ptr;
+	uint64_t *be64_ptr = (uint64_t *)ptr;
 	char *buff;
-	int j;
 	uint64_t prkey;
 
 	buff = set_value(strvec);
@@ -976,16 +975,7 @@ set_reservation_key(vector strvec, void *ptr)
 		return 1;
 	}
 
-	if (!*uchar_ptr)
-		*uchar_ptr = (unsigned char *) malloc(8);
-
-	memset(*uchar_ptr, 0, 8);
-
-	for (j = 7; j >= 0; --j) {
-		(*uchar_ptr)[j] = (prkey & 0xff);
-		prkey >>= 8;
-	}
-
+	*be64_ptr = cpu_to_be64(prkey);
 	FREE(buff);
 	return 0;
 }
@@ -993,21 +983,8 @@ set_reservation_key(vector strvec, void *ptr)
 int
 print_reservation_key(char * buff, int len, void * ptr)
 {
-	unsigned char **uchar_ptr = (unsigned char **)ptr;
-	int i;
-	unsigned char *keyp;
-	uint64_t prkey = 0;
-
-	if (!*uchar_ptr)
-		return 0;
-	keyp = (unsigned char *)(*uchar_ptr);
-	for (i = 0; i < 8; i++) {
-		if (i > 0)
-			prkey <<= 8;
-		prkey |= *keyp;
-		keyp++;
-	}
-	return snprintf(buff, len, "0x%" PRIx64, prkey);
+	uint64_t *be64_ptr = (uint64_t *)ptr;
+	return snprintf(buff, len, "0x%" PRIx64, be64_to_cpu(*be64_ptr));
 }
 
 declare_def_handler(reservation_key, set_reservation_key)
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 175fbe1..b55b75b 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -609,14 +609,14 @@ out:
 
 int select_reservation_key(struct config *conf, struct multipath *mp)
 {
-	char *origin, buff[12];
+	char *origin, buff[PRKEY_SIZE];
 
 	mp_set_mpe(reservation_key);
 	mp_set_conf(reservation_key);
-	mp->reservation_key = NULL;
+	mp->reservation_key = 0;
 	return 0;
 out:
-	print_reservation_key(buff, 12, &mp->reservation_key);
+	print_reservation_key(buff, PRKEY_SIZE, &mp->reservation_key);
 	condlog(3, "%s: reservation_key = %s %s", mp->alias, buff, origin);
 	return 0;
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 8ea984d..a32fe12 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -2,8 +2,10 @@
 #define _STRUCTS_H
 
 #include <sys/types.h>
+#include <inttypes.h>
 
 #include "prio.h"
+#include "byteorder.h"
 
 #define WWID_SIZE		128
 #define SERIAL_SIZE		65
@@ -17,6 +19,7 @@
 #define NAME_SIZE		512
 #define HOST_NAME_LEN		16
 #define SLOT_NAME_SIZE		40
+#define PRKEY_SIZE		19
 
 #define SCSI_VENDOR_SIZE	9
 #define SCSI_PRODUCT_SIZE	17
@@ -306,7 +309,7 @@ struct multipath {
 	void * mpcontext;
 
 	/* persistent management data*/
-	unsigned char * reservation_key;
+	uint64_t  reservation_key; /* stored in big-endian format */
 	unsigned char prflag;
 };
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 4be2c57..580d67c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2786,10 +2786,8 @@ main (int argc, char *argv[])
 void *  mpath_pr_event_handler_fn (void * pathp )
 {
 	struct multipath * mpp;
-	int i,j, ret, isFound;
+	int i, ret, isFound;
 	struct path * pp = (struct path *)pathp;
-	unsigned char *keyp;
-	uint64_t prkey;
 	struct prout_param_descriptor *param;
 	struct prin_resp *resp;
 
@@ -2817,22 +2815,15 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 		ret = MPATH_PR_SUCCESS;
 		goto out;
 	}
-	prkey = 0;
-	keyp = (unsigned char *)mpp->reservation_key;
-	for (j = 0; j < 8; ++j) {
-		if (j > 0)
-			prkey <<= 8;
-		prkey |= *keyp;
-		++keyp;
-	}
-	condlog(2, "Multipath  reservation_key: 0x%" PRIx64 " ", prkey);
+	condlog(2, "Multipath  reservation_key: 0x%" PRIx64 " ",
+		be64_to_cpu(mpp->reservation_key));
 
 	isFound =0;
 	for (i = 0; i < resp->prin_descriptor.prin_readkeys.additional_length/8; i++ )
 	{
 		condlog(2, "PR IN READKEYS[%d]  reservation key:",i);
 		dumpHex((char *)&resp->prin_descriptor.prin_readkeys.key_list[i*8], 8 , -1);
-		if (!memcmp(mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i*8], 8))
+		if (!memcmp(&mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i*8], 8))
 		{
 			condlog(2, "%s: pr key found in prin readkeys response", mpp->alias);
 			isFound =1;
@@ -2849,11 +2840,7 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 
 	param= malloc(sizeof(struct prout_param_descriptor));
 	memset(param, 0 , sizeof(struct prout_param_descriptor));
-
-	for (j = 7; j >= 0; --j) {
-		param->sa_key[j] = (prkey & 0xff);
-		prkey >>= 8;
-	}
+	memcpy(param->sa_key, &mpp->reservation_key, 8);
 	param->num_transportid = 0;
 
 	condlog(3, "device %s:%s", pp->dev, pp->mpp->wwid);
-- 
2.7.4
