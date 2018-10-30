From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 14/22] libmultipath: hp_sw checker: leave
	unsupported paths alone
Date: Tue, 30 Oct 2018 22:06:45 +0100
Message-ID: <20181030210653.29677-15-mwilck@suse.com>
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
 libmultipath/checkers/hp_sw.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/libmultipath/checkers/hp_sw.c b/libmultipath/checkers/hp_sw.c
index d7f1018c..1a820223 100644
--- a/libmultipath/checkers/hp_sw.c
+++ b/libmultipath/checkers/hp_sw.c
@@ -24,6 +24,7 @@
 #define SCSI_COMMAND_TERMINATED	0x22
 #define SG_ERR_DRIVER_SENSE	0x08
 #define RECOVERED_ERROR		0x01
+#define ILLEGAL_REQUEST		0x05
 #define MX_ALLOC_LEN		255
 #define HEAVY_CHECK_COUNT       10
 
@@ -68,14 +69,19 @@ do_inq(int sg_fd, int cmddt, int evpd, unsigned int pg_op,
 	io_hdr.sbp = sense_b;
 	io_hdr.timeout = timeout * 1000;
 
-	if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
-		return 1;
+	if (ioctl(sg_fd, SG_IO, &io_hdr) < 0) {
+		if (errno == ENOTTY)
+			return PATH_WILD;
+		else
+			return PATH_DOWN;
+	}
 
 	/* treat SG_ERR here to get rid of sg_err.[ch] */
 	io_hdr.status &= 0x7e;
 	if ((0 == io_hdr.status) && (0 == io_hdr.host_status) &&
 	    (0 == io_hdr.driver_status))
-		return 0;
+		return PATH_UP;
+
 	if ((SCSI_CHECK_CONDITION == io_hdr.status) ||
 	    (SCSI_COMMAND_TERMINATED == io_hdr.status) ||
 	    (SG_ERR_DRIVER_SENSE == (0xf & io_hdr.driver_status))) {
@@ -86,11 +92,13 @@ do_inq(int sg_fd, int cmddt, int evpd, unsigned int pg_op,
 				sense_key = sense_buffer[1] & 0xf;
 			else
 				sense_key = sense_buffer[2] & 0xf;
-			if(RECOVERED_ERROR == sense_key)
-				return 0;
+			if (RECOVERED_ERROR == sense_key)
+				return PATH_UP;
+			else if (ILLEGAL_REQUEST == sense_key)
+				return PATH_WILD;
 		}
 	}
-	return 1;
+	return PATH_DOWN;
 }
 
 static int
@@ -122,10 +130,15 @@ do_tur (int fd, unsigned int timeout)
 int libcheck_check(struct checker * c)
 {
 	char buff[MX_ALLOC_LEN];
+	int ret = do_inq(c->fd, 0, 1, 0x80, buff, MX_ALLOC_LEN, 0, c->timeout);
 
-	if (0 != do_inq(c->fd, 0, 1, 0x80, buff, MX_ALLOC_LEN, 0, c->timeout)) {
+	if (ret == PATH_WILD) {
+		c->msgid = CHECKER_MSGID_UNSUPPORTED;
+		return ret;
+	}
+	if (ret != PATH_UP) {
 		c->msgid = CHECKER_MSGID_DOWN;
-		return PATH_DOWN;
+		return ret;
 	};
 
 	if (do_tur(c->fd, c->timeout)) {
-- 
2.19.1
