From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 21/39] libmpathpersist: Pass sensebuffer as
	pointer
Date: Thu, 16 Jun 2016 11:47:27 +0200
Message-ID: <1466070465-1021-22-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

It makes no sense to pass the entire sense buffer as a value,
we should rather pass the pointer to avoid exploding the stack.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathpersist/mpath_pr_ioctl.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index c85fd10..c37c1e4 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -24,7 +24,8 @@
 int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp *resp, int noisy);
 void mpath_format_readkeys(struct prin_resp *pr_buff, int len , int noisy);
 void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy);
-int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr, SenseData_t Sensedata, int noisy);
+int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr,
+			      SenseData_t *Sensedata, int noisy);
 void dumpHex(const char* str, int len, int no_ascii);
 int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
                 unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
@@ -113,7 +114,7 @@ retry :
 
 	condlog(2, "%s: Duration=%u (ms)", dev, io_hdr.duration);
 
-	status = mpath_translate_response(dev, io_hdr, Sensedata, noisy);
+	status = mpath_translate_response(dev, io_hdr, &Sensedata, noisy);
 	condlog(3, "%s: status = %d", dev, status);
 
 	if (status == MPATH_PR_SENSE_UNIT_ATTENTION && (retry > 0))
@@ -353,7 +354,7 @@ retry :
 	condlog(2, "%s: duration = %u (ms)", dev, io_hdr.duration);
 	condlog(2, "%s: persistent reservation in: requested %d bytes but got %d bytes)", dev, mx_resp_len, got);
 
-	status = mpath_translate_response(dev, io_hdr, Sensedata, noisy);
+	status = mpath_translate_response(dev, io_hdr, &Sensedata, noisy);
 
 	if (status == MPATH_PR_SENSE_UNIT_ATTENTION && (retry > 0))
 	{
@@ -398,26 +399,25 @@ out:
 	return status;
 }
 
-int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr, SenseData_t Sensedata, int noisy)
+int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr,
+			      SenseData_t *Sensedata, int noisy)
 {
-	condlog(3, "%s: status driver:%02x host:%02x scsi:%02x", dev, 
-			io_hdr.driver_status, io_hdr.host_status ,io_hdr.status);
+	condlog(3, "%s: status driver:%02x host:%02x scsi:%02x", dev,
+		io_hdr.driver_status, io_hdr.host_status, io_hdr.status);
 	io_hdr.status &= 0x7e;
-	if ((0 == io_hdr.status) && (0 == io_hdr.host_status) &&
-			(0 == io_hdr.driver_status))
-	{
+	if ((0 == io_hdr.status) &&
+	    (0 == io_hdr.host_status) &&
+	    (0 == io_hdr.driver_status))
 		return MPATH_PR_SUCCESS;
-	}
 
-	switch(io_hdr.status)
-	{
+	switch(io_hdr.status) {
 		case SAM_STAT_GOOD:
 			break;
 		case SAM_STAT_CHECK_CONDITION:
-			condlog(2, "%s: Sense_Key=%02x, ASC=%02x ASCQ=%02x", dev,
-					Sensedata.Sense_Key, Sensedata.ASC, Sensedata.ASCQ);
-			switch(Sensedata.Sense_Key)
-			{
+			condlog(2, "%s: Sense_Key=%02x, ASC=%02x ASCQ=%02x",
+				dev, Sensedata->Sense_Key,
+				Sensedata->ASC, Sensedata->ASCQ);
+			switch(Sensedata->Sense_Key) {
 				case NO_SENSE:
 					return MPATH_PR_NO_SENSE;
 				case RECOVERED_ERROR:
@@ -450,8 +450,7 @@ int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr, SenseData_t S
 			return  MPATH_PR_OTHER;
 	}
 
-	switch(io_hdr.host_status)
-	{
+	switch(io_hdr.host_status) {
 		case DID_OK :
 			break;
 		default :
-- 
2.6.6
