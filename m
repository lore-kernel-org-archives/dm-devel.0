From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 15/22] libmultipath: rdac checker: leave
	unsupported paths alone
Date: Tue, 30 Oct 2018 22:06:46 +0100
Message-ID: <20181030210653.29677-16-mwilck@suse.com>
References: <20181030210653.29677-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181030210653.29677-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

A checker shouldn't set the path state to PATH_DOWN if it fails
to obtain information about the path in the first place. Add logic
to the checker to distinguish a failed path from an unsupported path.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/rdac.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
index 266f8e10..8a3b73ec 100644
--- a/libmultipath/checkers/rdac.c
+++ b/libmultipath/checkers/rdac.c
@@ -26,6 +26,7 @@
 #define SCSI_COMMAND_TERMINATED	0x22
 #define SG_ERR_DRIVER_SENSE	0x08
 #define RECOVERED_ERROR		0x01
+#define ILLEGAL_REQUEST		0x05
 
 
 #define CURRENT_PAGE_CODE_VALUES	0
@@ -162,14 +163,14 @@ retry:
 	io_hdr.sbp = sense_b;
 	io_hdr.timeout = timeout * 1000;
 
-	if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
-		return 1;
+	if (ioctl(sg_fd, SG_IO, &io_hdr) < 0 && errno == ENOTTY)
+		return PATH_WILD;
 
 	/* treat SG_ERR here to get rid of sg_err.[ch] */
 	io_hdr.status &= 0x7e;
 	if ((0 == io_hdr.status) && (0 == io_hdr.host_status) &&
 	    (0 == io_hdr.driver_status))
-		return 0;
+		return PATH_UP;
 
 	/* check if we need to retry this error */
 	if (io_hdr.info & SG_INFO_OK_MASK) {
@@ -198,10 +199,14 @@ retry:
 			else
 				sense_key = sense_buffer[2] & 0xf;
 			if (RECOVERED_ERROR == sense_key)
-				return 0;
+				return PATH_UP;
+			else if (ILLEGAL_REQUEST == sense_key)
+				return PATH_WILD;
+			condlog(1, "rdac checker: INQUIRY failed with sense key %02x",
+				sense_key);
 		}
 	}
-	return 1;
+	return PATH_DOWN;
 }
 
 struct volume_access_inq
@@ -290,12 +295,14 @@ int libcheck_check(struct checker * c)
 
 	inqfail = 0;
 	memset(&inq, 0, sizeof(struct volume_access_inq));
-	if (0 != do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq),
-			c->timeout)) {
-		ret = PATH_DOWN;
+	ret = do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq),
+		     c->timeout);
+	if (ret != PATH_UP) {
 		inqfail = 1;
 		goto done;
-	} else if (((inq.PQ_PDT & 0xE0) == 0x20) || (inq.PQ_PDT & 0x7f)) {
+	}
+
+	if (((inq.PQ_PDT & 0xE0) == 0x20) || (inq.PQ_PDT & 0x7f)) {
 		/* LUN not connected*/
 		ret = PATH_DOWN;
 		goto done;
@@ -332,6 +339,9 @@ int libcheck_check(struct checker * c)
 
 done:
 	switch (ret) {
+	case PATH_WILD:
+		c->msgid = CHECKER_MSGID_UNSUPPORTED;
+		break;
 	case PATH_DOWN:
 		c->msgid = (inqfail ? RDAC_MSGID_INQUIRY_FAILED :
 			    checker_msg_string(&inq));
-- 
2.19.1
