From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 39/72] libmpathpersist: remove unused "noisy"
 argument in various functions
Date: Sat, 12 Oct 2019 21:28:25 +0000
Message-ID: <20191012212703.12989-40-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_pr_ioctl.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index cf528feb..209892f6 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -23,10 +23,8 @@
 #define MAXRETRY 5
 
 int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp *resp, int noisy);
-void mpath_format_readkeys(struct prin_resp *pr_buff, int len , int noisy);
-void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy);
 int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr,
-			      SenseData_t *Sensedata, int noisy);
+			      SenseData_t *Sensedata);
 void dumpHex(const char* str, int len, int no_ascii);
 int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
 		unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
@@ -115,7 +113,7 @@ retry :
 
 	condlog(4, "%s: Duration=%u (ms)", dev, io_hdr.duration);
 
-	status = mpath_translate_response(dev, io_hdr, &Sensedata, noisy);
+	status = mpath_translate_response(dev, io_hdr, &Sensedata);
 	condlog(3, "%s: status = %d", dev, status);
 
 	if (status == MPATH_PR_SENSE_UNIT_ATTENTION && (retry > 0))
@@ -181,13 +179,13 @@ uint32_t  format_transportids(struct prout_param_descriptor *paramp)
 	return buff_offset;
 }
 
-void mpath_format_readkeys( struct prin_resp *pr_buff, int len, int noisy)
+static void mpath_format_readkeys(struct prin_resp *pr_buff)
 {
 	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readkeys.prgeneration);
 	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readkeys.additional_length);
 }
 
-void mpath_format_readresv(struct prin_resp *pr_buff, int len, int noisy)
+static void mpath_format_readresv(struct prin_resp *pr_buff)
 {
 
 	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readkeys.prgeneration);
@@ -196,7 +194,7 @@ void mpath_format_readresv(struct prin_resp *pr_buff, int len, int noisy)
 	return;
 }
 
-void mpath_format_reportcapabilities(struct prin_resp *pr_buff, int len, int noisy)
+static void mpath_format_reportcapabilities(struct prin_resp *pr_buff)
 {
 	convert_be16_to_cpu(&pr_buff->prin_descriptor.prin_readcap.length);
 	convert_be16_to_cpu(&pr_buff->prin_descriptor.prin_readcap.pr_type_mask);
@@ -204,7 +202,7 @@ void mpath_format_reportcapabilities(struct prin_resp *pr_buff, int len, int noi
 	return;
 }
 
-void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy)
+static void mpath_format_readfullstatus(struct prin_resp *pr_buff)
 {
 	int num, k, tid_len_len=0;
 	uint32_t fdesc_count=0;
@@ -361,7 +359,7 @@ retry :
 	condlog(3, "%s: duration = %u (ms)", dev, io_hdr.duration);
 	condlog(4, "%s: persistent reservation in: requested %d bytes but got %d bytes)", dev, mx_resp_len, got);
 
-	status = mpath_translate_response(dev, io_hdr, &Sensedata, noisy);
+	status = mpath_translate_response(dev, io_hdr, &Sensedata);
 
 	if (status == MPATH_PR_SENSE_UNIT_ATTENTION && (retry > 0))
 	{
@@ -389,16 +387,16 @@ retry :
 	switch (rq_servact)
 	{
 		case MPATH_PRIN_RKEY_SA :
-			mpath_format_readkeys(resp, got, noisy);
+			mpath_format_readkeys(resp);
 			break;
 		case MPATH_PRIN_RRES_SA :
-			mpath_format_readresv(resp, got, noisy);
+			mpath_format_readresv(resp);
 			break;
 		case MPATH_PRIN_RCAP_SA :
-			mpath_format_reportcapabilities(resp, got, noisy);
+			mpath_format_reportcapabilities(resp);
 			break;
 		case MPATH_PRIN_RFSTAT_SA :
-			mpath_format_readfullstatus(resp, got, noisy);
+			mpath_format_readfullstatus(resp);
 	}
 
 out:
@@ -407,7 +405,7 @@ out:
 }
 
 int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr,
-			      SenseData_t *Sensedata, int noisy)
+			      SenseData_t *Sensedata)
 {
 	condlog(3, "%s: status driver:%02x host:%02x scsi:%02x", dev,
 			io_hdr.driver_status, io_hdr.host_status ,io_hdr.status);
-- 
2.23.0
