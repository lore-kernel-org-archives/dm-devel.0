From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 06/22] libmultipath/checkers: emc_clariion:
	use message id
Date: Tue, 30 Oct 2018 22:06:37 +0100
Message-ID: <20181030210653.29677-7-mwilck@suse.com>
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

emc_clariion is the only path checker that was using a non-constant
message ("read error" case). This isn't possible with the msgid
approach any more. Use condlog() for the dynamic log message and
simply report "read error" as checker message.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/emc_clariion.c | 60 +++++++++++++++++++---------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index 9115b1b9..f8e55b93 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -41,6 +41,35 @@
 				((struct emc_clariion_checker_LU_context *)\
 					(*c->mpcontext))->inactive_snap = 0
 
+enum {
+	MSG_CLARIION_QUERY_FAILED = CHECKER_FIRST_MSGID,
+	MSG_CLARIION_QUERY_ERROR,
+	MSG_CLARIION_PATH_CONFIG,
+	MSG_CLARIION_UNIT_REPORT,
+	MSG_CLARIION_PATH_NOT_AVAIL,
+	MSG_CLARIION_LUN_UNBOUND,
+	MSG_CLARIION_WWN_CHANGED,
+	MSG_CLARIION_READ_ERROR,
+	MSG_CLARIION_PASSIVE_GOOD,
+};
+
+#define _IDX(x) (MSG_CLARIION_ ## x - CHECKER_FIRST_MSGID)
+const char *libcheck_msgtable[] = {
+	[_IDX(QUERY_FAILED)] = ": sending query command failed",
+	[_IDX(QUERY_ERROR)] = ": query command indicates error",
+	[_IDX(PATH_CONFIG)] =
+	": Path not correctly configured for failover",
+	[_IDX(UNIT_REPORT)] =
+	": Path unit report page in unknown format",
+	[_IDX(PATH_NOT_AVAIL)] =
+	": Path not available for normal operations",
+	[_IDX(LUN_UNBOUND)] = ": Logical Unit is unbound or LUNZ",
+	[_IDX(WWN_CHANGED)] = ": Logical Unit WWN has changed",
+	[_IDX(READ_ERROR)] = ": Read error",
+	[_IDX(PASSIVE_GOOD)] = ": Active path is healthy",
+	NULL,
+};
+
 struct emc_clariion_checker_path_context {
 	char wwn[16];
 	unsigned wwn_set;
@@ -116,17 +145,16 @@ int libcheck_check (struct checker * c)
 	io_hdr.timeout = c->timeout * 1000;
 	io_hdr.pack_id = 0;
 	if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
-		MSG(c, "emc_clariion_checker: sending query command failed");
+		c->msgid = MSG_CLARIION_QUERY_FAILED;
 		return PATH_DOWN;
 	}
 	if (io_hdr.info & SG_INFO_OK_MASK) {
-		MSG(c, "emc_clariion_checker: query command indicates error");
+		c->msgid = MSG_CLARIION_QUERY_ERROR;
 		return PATH_DOWN;
 	}
 	if (/* Verify the code page - right page & revision */
 	    sense_buffer[1] != 0xc0 || sense_buffer[9] != 0x00) {
-		MSG(c, "emc_clariion_checker: Path unit report page in "
-		    "unknown format");
+		c->msgid = MSG_CLARIION_UNIT_REPORT;
 		return PATH_DOWN;
 	}
 
@@ -140,22 +168,19 @@ int libcheck_check (struct checker * c)
 		    ((sense_buffer[28] & 0x07) != 0x06))
 		/* Arraycommpath should be set to 1 */
 		|| (sense_buffer[30] & 0x04) != 0x04) {
-		MSG(c, "emc_clariion_checker: Path not correctly configured "
-		    "for failover");
+		c->msgid = MSG_CLARIION_PATH_CONFIG;
 		return PATH_DOWN;
 	}
 
 	if ( /* LUN operations should indicate normal operations */
 		sense_buffer[48] != 0x00) {
-		MSG(c, "emc_clariion_checker: Path not available for normal "
-		    "operations");
+		c->msgid = MSG_CLARIION_PATH_NOT_AVAIL;
 		return PATH_SHAKY;
 	}
 
 	if ( /* LUN should at least be bound somewhere and not be LUNZ */
 		sense_buffer[4] == 0x00) {
-		MSG(c, "emc_clariion_checker: Logical Unit is unbound "
-		    "or LUNZ");
+		c->msgid = MSG_CLARIION_LUN_UNBOUND;
 		return PATH_DOWN;
 	}
 
@@ -166,8 +191,7 @@ int libcheck_check (struct checker * c)
 	 */
 	if (ct->wwn_set) {
 		if (memcmp(ct->wwn, &sense_buffer[10], 16) != 0) {
-			MSG(c, "emc_clariion_checker: Logical Unit WWN "
-			    "has changed!");
+			c->msgid = MSG_CLARIION_WWN_CHANGED;
 			return PATH_DOWN;
 		}
 	} else {
@@ -202,14 +226,15 @@ int libcheck_check (struct checker * c)
 				condlog(3, "emc_clariion_checker: Active "
 					"path to inactive snapshot WWN %s.",
 					wwnstr);
-			} else
-				MSG(c, "emc_clariion_checker: Read "
+			} else {
+				condlog(3, "emc_clariion_checker: Read "
 					"error for WWN %s.  Sense data are "
 					"0x%x/0x%x/0x%x.", wwnstr,
 					sbb[2]&0xf, sbb[12], sbb[13]);
+				c->msgid = MSG_CLARIION_READ_ERROR;
+			}
 		} else {
-			MSG(c, "emc_clariion_checker: Active path is "
-			    "healthy.");
+			c->msgid = MSG_CLARIION_PASSIVE_GOOD;
 			/*
 			 * Remove the path from the set of paths to inactive
 			 * snapshot LUs if it was in this list since the
@@ -225,8 +250,7 @@ int libcheck_check (struct checker * c)
 				wwnstr);
 			ret = PATH_DOWN;
 		} else {
-			MSG(c,
-			    "emc_clariion_checker: Passive path is healthy.");
+			c->msgid = MSG_CLARIION_PASSIVE_GOOD;
 			ret = PATH_UP;	/* not ghost */
 		}
 	}
-- 
2.19.1
