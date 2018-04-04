From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 4/4] libmpathpersist: decrease log level of
	various messages
Date: Wed,  4 Apr 2018 18:22:00 +0200
Message-ID: <20180404162200.6518-5-mwilck@suse.com>
References: <20180404162200.6518-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180404162200.6518-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Silence a few libmpathpersist messages which need not be printed
at the default loglevel.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist.c  |  2 +-
 libmpathpersist/mpath_pr_ioctl.c | 32 ++++++++++++++++----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 5199e42..907a17c 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -909,7 +909,7 @@ int update_map_pr(struct multipath *mpp)
 
 	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
 	{
-		condlog(0,"%s: No key found. Device may not be registered. ", mpp->alias);
+		condlog(3,"%s: No key found. Device may not be registered. ", mpp->alias);
 		free(resp);
 		return MPATH_PR_SUCCESS;
 	}
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index dbed4ca..6dd7403 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -77,14 +77,14 @@ int prout_do_scsi_ioctl(char * dev, int rq_servact, int rq_scope,
 	cdb[8] = (unsigned char)(paramlen & 0xff);
 
 retry :
-	condlog(3, "%s: rq_servact = %d", dev, rq_servact);
-	condlog(3, "%s: rq_scope = %d ", dev, rq_scope);
-	condlog(3, "%s: rq_type = %d ", dev, rq_type);
-	condlog(3, "%s: paramlen = %d", dev, paramlen);
+	condlog(4, "%s: rq_servact = %d", dev, rq_servact);
+	condlog(4, "%s: rq_scope = %d ", dev, rq_scope);
+	condlog(4, "%s: rq_type = %d ", dev, rq_type);
+	condlog(4, "%s: paramlen = %d", dev, paramlen);
 
 	if (noisy)
 	{
-		condlog(3, "%s: Persistent Reservation OUT parameter:", dev);
+		condlog(4, "%s: Persistent Reservation OUT parameter:", dev);
 		dumpHex((const char *)paramp, paramlen,1);
 	}
 
@@ -113,7 +113,7 @@ retry :
 		return ret;
 	}
 
-	condlog(2, "%s: Duration=%u (ms)", dev, io_hdr.duration);
+	condlog(4, "%s: Duration=%u (ms)", dev, io_hdr.duration);
 
 	status = mpath_translate_response(dev, io_hdr, &Sensedata, noisy);
 	condlog(3, "%s: status = %d", dev, status);
@@ -121,7 +121,7 @@ retry :
 	if (status == MPATH_PR_SENSE_UNIT_ATTENTION && (retry > 0))
 	{
 		--retry;
-		condlog(2, "%s: retrying for Unit Attention. Remaining retries = %d",
+		condlog(3, "%s: retrying for Unit Attention. Remaining retries = %d",
 			dev, retry);
 		goto retry;
 	}
@@ -131,7 +131,7 @@ retry :
 	{
 		usleep(1000);
 		--retry;
-		condlog(2, "%s: retrying for sense 02/04/07."
+		condlog(3, "%s: retrying for sense 02/04/07."
 			" Remaining retries = %d", dev, retry);
 		goto retry;
 	}
@@ -224,7 +224,7 @@ void mpath_format_readfullstatus(struct prin_resp *pr_buff, int len, int noisy)
 
 	if (pr_buff->prin_descriptor.prin_readfd.number_of_descriptor == 0)
 	{
-		condlog(2, "No registration or resrvation found.");
+		condlog(3, "No registration or resrvation found.");
 		return;
 	}
 
@@ -351,15 +351,15 @@ retry :
 
 	got = mx_resp_len - io_hdr.resid;
 
-	condlog(2, "%s: duration = %u (ms)", dev, io_hdr.duration);
-	condlog(2, "%s: persistent reservation in: requested %d bytes but got %d bytes)", dev, mx_resp_len, got);
+	condlog(3, "%s: duration = %u (ms)", dev, io_hdr.duration);
+	condlog(4, "%s: persistent reservation in: requested %d bytes but got %d bytes)", dev, mx_resp_len, got);
 
 	status = mpath_translate_response(dev, io_hdr, &Sensedata, noisy);
 
 	if (status == MPATH_PR_SENSE_UNIT_ATTENTION && (retry > 0))
 	{
 		--retry;
-		condlog(2, "%s: retrying for Unit Attention. Remaining retries = %d", dev, retry);
+		condlog(3, "%s: retrying for Unit Attention. Remaining retries = %d", dev, retry);
 		goto retry;
 	}
 
@@ -368,7 +368,7 @@ retry :
 	{
 		usleep(1000);
 		--retry;
-		condlog(2, "%s: retrying for 02/04/07. Remaining retries = %d", dev, retry);
+		condlog(3, "%s: retrying for 02/04/07. Remaining retries = %d", dev, retry);
 		goto retry;
 	}
 
@@ -414,7 +414,7 @@ int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr,
 	case SAM_STAT_GOOD:
 		break;
 	case SAM_STAT_CHECK_CONDITION:
-		condlog(2, "%s: Sense_Key=%02x, ASC=%02x ASCQ=%02x",
+		condlog(3, "%s: Sense_Key=%02x, ASC=%02x ASCQ=%02x",
 			dev, Sensedata->Sense_Key,
 			Sensedata->ASC, Sensedata->ASCQ);
 		switch(Sensedata->Sense_Key) {
@@ -471,11 +471,11 @@ int mpath_isLittleEndian(void)
 	int num = 1;
 	if(*(char *)&num == 1)
 	{
-		condlog(2, "Little-Endian");
+		condlog(4, "Little-Endian");
 	}
 	else
 	{
-		condlog(2, "Big-Endian");
+		condlog(4, "Big-Endian");
 	}
 	return 0;
 }
-- 
2.16.1
