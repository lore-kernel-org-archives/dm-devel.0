From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: clean up and organize
	libmpathpersist/mpath_persistent_reserve_{out, in}.3
Date: Tue,  1 Nov 2016 13:48:56 +0100
Message-ID: <20161101124856.7360-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/mpath_persistent_reserve_in.3  | 172 ++++++++++++---------
 libmpathpersist/mpath_persistent_reserve_out.3 | 200 +++++++++++++++----------
 2 files changed, 226 insertions(+), 146 deletions(-)

diff --git a/libmpathpersist/mpath_persistent_reserve_in.3 b/libmpathpersist/mpath_persistent_reserve_in.3
index 8601645..5ed0779 100644
--- a/libmpathpersist/mpath_persistent_reserve_in.3
+++ b/libmpathpersist/mpath_persistent_reserve_in.3
@@ -1,80 +1,116 @@
+.\" ----------------------------------------------------------------------------
+.\" Update the date below if you make any significant change.
+.\" Make sure there are no errors with:
+.\" groff -z -wall -b -e -t libmpathpersist/mpath_persistent_reserve_in.3
 .\"
-.TH MPATH_PERSISTENT_RESERVE_IN 3  2011-04-08 "Linux Manpage"
+.\" ----------------------------------------------------------------------------
+.
+.TH MPATH_PERSISTENT_RESERVE_IN 3 2016-11-01 "Linux"
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH NAME
+.\" ----------------------------------------------------------------------------
+.
 mpath_persistent_reserve_in
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH SYNOPSIS
+.\" ----------------------------------------------------------------------------
+.
 .B #include <mpath_persist.h>
-.sp
-.BI "int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp *resp, int noisy, int verbose)"
-.sp
+.P
+.BI "int mpath_persistent_reserve_in" "(int fd, int rq_servact, struct prin_resp *resp, int noisy, int verbose)"
+.P
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH DESCRIPTION
-The function in the
-.BR mpath_persistent_reserve_in ()
-sends PRIN command to the DM device and gets the response.
-.br
-.BI Parameters:
-.br
+.\" ----------------------------------------------------------------------------
+.
+The function in the \fBmpath_persistent_reserve_in ()\fR sends PRIN command to
+the DM device and gets the response.
+.TP
+.B Parameters:
+.RS
+.TP 12
 .I fd
-.B The file descriptor of a multipath device. Input argument.
-.br
+The file descriptor of a multipath device. Input argument.
+.TP
 .I rq_servact
-.B PRIN command service action. Input argument
-.br
+PRIN command service action. Input argument.
+.TP
 .I resp
-.B The response from PRIN service action. The caller should manage the memory allocation of this structure
-.br
+The response from PRIN service action. The caller should manage the memory allocation of this structure.
+.TP
 .I noisy
-.B Turn on debugging trace: Input argument. 0->Disable, 1->Enable
-.br
+Turn on debugging trace: Input argument. 0->Disable, 1->Enable.
+.TP
 .I verbose
-.B Set verbosity level. Input argument. value:[0-3]. 0->Crits and Errors, 1->Warnings, 2->Info, 3->Debug
-.br
-
-.SH "RETURNS"
-.I MPATH_PR_SUCCESS
-.B if PR command successful
-.br
-.I MPATH_PR_SYNTAX_ERROR
-.B if  syntax error or invalid parameter
-.br
-.I MPATH_PR_SENSE_NOT_READY
-.B  if command fails with [sk,asc,ascq: 0x2,*,*]
-.br
-.I MPATH_PR_SENSE_MEDIUM_ERROR
-.B  if command fails with [sk,asc,ascq: 0x3,*,*]
-.br
-.I MPATH_PR_SENSE_HARDWARE_ERROR
-.B  if command fails with [sk,asc,ascq: 0x4,*,*]
-.br
-.I MPATH_PR_SENSE_INVALID_OP
-.B  if command fails with [sk,asc,ascq: 0x5,0x20,0x0]
-.br
-.I MPATH_PR_ILLEGAL_REQ
-.B  if command fails with [sk,asc,ascq: 0x5,*,*]
-.br
-.I MPATH_PR_SENSE_UNIT_ATTENTION
-.B  if command fails with [sk,asc,ascq: 0x6,*,*]
-.br
-.I MPATH_PR_SENSE_ABORTED_COMMAND
-.B  if command fails with [sk,asc,ascq: 0xb,*,*]
-.br
-.I MPATH_PR_NO_SENSE
-.B  if command fails with [sk,asc,ascq: 0x0,*,*]
-.br
-.I MPATH_PR_SENSE_MALFORMED
-.B if command fails with SCSI command malformed
-.br
-.I MPATH_PR_FILE_ERROR
-.B if command fails while accessing file (device node) problems(e.g. not found)
-.br
-.I MPATH_PR_DMMP_ERROR
-.B if Device Mapper related error.(e.g Error in getting dm info)
-.br
-.I MPATH_PR_OTHER
-.B if other error/warning has occurred(e.g transport or driver error)
-.br
-
-
+Set verbosity level. Input argument. value:[0-3]. 0->Crits and Errors, 1->Warnings, 2->Info, 3->Debug.
+.RE
+.
+.
+.\" ----------------------------------------------------------------------------
+.SH RETURNS
+.\" ----------------------------------------------------------------------------
+.
+.TP 12
+.B MPATH_PR_SUCCESS
+If PR command successful.
+.TP
+.B MPATH_PR_SYNTAX_ERROR
+If syntax error or invalid parameter.
+.TP
+.B MPATH_PR_SENSE_NOT_READY
+If command fails with [sk,asc,ascq: 0x2,*,*].
+.TP
+.B MPATH_PR_SENSE_MEDIUM_ERROR
+If command fails with [sk,asc,ascq: 0x3,*,*].
+.TP
+.B MPATH_PR_SENSE_HARDWARE_ERROR
+If command fails with [sk,asc,ascq: 0x4,*,*].
+.TP
+.B MPATH_PR_SENSE_INVALID_OP
+If command fails with [sk,asc,ascq: 0x5,0x20,0x0].
+.TP
+.B MPATH_PR_ILLEGAL_REQ
+If command fails with [sk,asc,ascq: 0x5,*,*].
+.TP
+.B MPATH_PR_SENSE_UNIT_ATTENTION
+If command fails with [sk,asc,ascq: 0x6,*,*].
+.TP
+.B MPATH_PR_SENSE_ABORTED_COMMAND
+If command fails with [sk,asc,ascq: 0xb,*,*].
+.TP
+.B MPATH_PR_NO_SENSE
+If command fails with [sk,asc,ascq: 0x0,*,*].
+.TP
+.B MPATH_PR_SENSE_MALFORMED
+If command fails with SCSI command malformed.
+.TP
+.B MPATH_PR_FILE_ERROR
+If command fails while accessing file (device node) problems(e.g. not found).
+.TP
+.B MPATH_PR_DMMP_ERROR
+If Device Mapper related error.(e.g Error in getting dm info).
+.TP
+.B MPATH_PR_OTHER
+If other error/warning has occurred(e.g transport or driver error).
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH "SEE ALSO"
-.I  mpath_persistent_reserve_out      mpathpersist     /usr/share/doc/mpathpersist/README
-.br
+.\" ----------------------------------------------------------------------------
+.
+.BR mpathpersist (8).
+.
+.
+.\" ----------------------------------------------------------------------------
+.SH AUTHORS
+.\" ----------------------------------------------------------------------------
+.
+\fImultipath-tools\fR was developed by Christophe Varoqui <christophe.varoqui@opensvc.com>
+and others.
+.\" EOF
diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 b/libmpathpersist/mpath_persistent_reserve_out.3
index 8a3b52c..e11eb57 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -1,92 +1,136 @@
+.\" ----------------------------------------------------------------------------
+.\" Update the date below if you make any significant change.
+.\" Make sure there are no errors with:
+.\" groff -z -wall -b -e -t libmpathpersist/mpath_persistent_reserve_out.3
 .\"
-.TH MPATH_PERSISTENT_RESERVE_OUT 3  2011-04-08 "Linux Manpage"
+.\" ----------------------------------------------------------------------------
+.
+.TH MPATH_PERSISTENT_RESERVE_OUT 3 2016-11-01 "Linux"
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH NAME
+.\" ----------------------------------------------------------------------------
+.
 mpath_persistent_reserve_out
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH SYNOPSIS
+.\" ----------------------------------------------------------------------------
+.
 .B #include <mpath_persist.h>
-.sp
-.BI "int mpath_persistent_reserve_out (int fd, int rq_servact, struct prin_resp *resp, int noisy, int verbose)"
-.sp
+.P
+.BI "int mpath_persistent_reserve_out" "(int fd, int rq_servact, struct prin_resp *resp, int noisy, int verbose)"
+.P
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH DESCRIPTION
-The function in the
-.BR mpath_persistent_reserve_out ()
-sends PR OUT command to the DM device and gets the response.
-.br
-.BI Parameters:
-.br
+.\" ----------------------------------------------------------------------------
+.
+The function in the \fBmpath_persistent_reserve_out ()\fR sends PROUT command to
+the DM device and gets the response.
+.TP
+.B Parameters:
+.RS
+.TP 12
 .I fd
-.B The file descriptor of a multipath device. Input argument.
-.br
+The file descriptor of a multipath device. Input argument.
+.TP
 .I rq_servact
-.B PROUT command service action. Input argument
-.br
+PROUT command service action. Input argument.
+.TP
 .I rq_scope
-.B Persistent reservation scope. The value should be always LU_SCOPE (0h).
-.br
+Persistent reservation scope. The value should be always LU_SCOPE (0h).
+.TP
 .I rq_type
-.B Persistent reservation type. The valid values of persistent reservation types are
-      5h (Write exclusive - registrants only)
-      6h (Exclusive access - registrants only)
-      7h (Write exclusive - All registrants)
-      8h (Exclusive access - All registrants).
-.br
+Persistent reservation type. The valid values of persistent reservation types are:
+.RS
+.IP
+5h (Write exclusive - registrants only).
+.IP
+6h (Exclusive access - registrants only).
+.IP
+7h (Write exclusive - All registrants).
+.IP
+8h (Exclusive access - All registrants).
+.RE
+.TP
 .I paramp
-.B PROUT command parameter data. The paramp is a struct which describes PROUT parameter list. Caller should manage the memory allocation of this structure.
-.br
+PROUT command parameter data. The paramp is a struct which describes PROUT
+parameter list. Caller should manage the memory allocation of this structure.
+.TP
 .I noisy
-.B Turn on debugging trace: Input argument. 0->Disable, 1->Enable.
-.br
+Turn on debugging trace: Input argument. 0->Disable, 1->Enable.
+.TP
 .I verbose
-.B Set verbosity level. Input argument. value: 0 to 3. 0->Crits and Errors, 1->Warnings, 2->Info, 3->Debug
-
-.SH "RETURNS"
-.I MPATH_PR_SUCCESS
-.B if PR command successful else returns any one of the status mentioned below
-.br
-.I MPATH_PR_SYNTAX_ERROR
-.B if  syntax error or invalid parameter
-.br
-.I MPATH_PR_SENSE_NOT_READY
-.B  if command fails with [sk,asc,ascq: 0x2,*,*]
-.br
-.I MPATH_PR_SENSE_MEDIUM_ERROR
-.B  if command fails with [sk,asc,ascq: 0x3,*,*]
-.br
-.I MPATH_PR_SENSE_HARDWARE_ERROR
-.B  if command fails with [sk,asc,ascq: 0x4,*,*]
-.br
-.I MPATH_PR_SENSE_INVALID_OP
-.B  if command fails with [sk,asc,ascq: 0x5,0x20,0x0]
-.br
-.I MPATH_PR_ILLEGAL_REQ
-.B  if command fails with [sk,asc,ascq: 0x5,*,*]
-.br
-.I MPATH_PR_SENSE_UNIT_ATTENTION
-.B  if command fails with [sk,asc,ascq: 0x6,*,*]
-.br
-.I MPATH_PR_SENSE_ABORTED_COMMAND
-.B  if command fails with [sk,asc,ascq: 0xb,*,*]
-.br
-.I MPATH_PR_NO_SENSE
-.B  if command fails with [sk,asc,ascq: 0x0,*,*]
-.br
-.I MPATH_PR_SENSE_MALFORMED
-.B if command fails with SCSI command malformed
-.br
-.I MPATH_PR_RESERV_CONFLICT
-.B if command fails with reservation conflict
-.br
-.I MPATH_PR_FILE_ERROR
-.B if command fails while accessing file (device node) problems(e.g. not found)
-.br
-.I MPATH_PR_DMMP_ERROR
-.B if Device Mapper related error.(e.g Error in getting dm info)
-.br
-.I MPATH_PR_OTHER
-.B if other error/warning has occurred(e.g transport or driver error)
-.br
-
-
+Set verbosity level. Input argument. value: 0 to 3. 0->Crits and Errors, 1->Warnings, 2->Info, 3->Debug.
+.RE
+.
+.
+.\" ----------------------------------------------------------------------------
+.SH RETURNS
+.\" ----------------------------------------------------------------------------
+.
+.TP 12
+.B MPATH_PR_SUCCESS
+If PR command successful else returns any one of the status mentioned below.
+.TP
+.B MPATH_PR_SYNTAX_ERROR
+If syntax error or invalid parameter.
+.TP
+.B MPATH_PR_SENSE_NOT_READY
+If command fails with [sk,asc,ascq: 0x2,*,*].
+.TP
+.B MPATH_PR_SENSE_MEDIUM_ERROR
+If command fails with [sk,asc,ascq: 0x3,*,*].
+.TP
+.B MPATH_PR_SENSE_HARDWARE_ERROR
+If command fails with [sk,asc,ascq: 0x4,*,*].
+.TP
+.B MPATH_PR_SENSE_INVALID_OP
+If command fails with [sk,asc,ascq: 0x5,0x20,0x0].
+.TP
+.B MPATH_PR_ILLEGAL_REQ
+If command fails with [sk,asc,ascq: 0x5,*,*].
+.TP
+.B MPATH_PR_SENSE_UNIT_ATTENTION
+If command fails with [sk,asc,ascq: 0x6,*,*].
+.TP
+.B MPATH_PR_SENSE_ABORTED_COMMAND
+If command fails with [sk,asc,ascq: 0xb,*,*].
+.TP
+.B MPATH_PR_NO_SENSE
+If command fails with [sk,asc,ascq: 0x0,*,*].
+.TP
+.B MPATH_PR_SENSE_MALFORMED
+If command fails with SCSI command malformed.
+.TP
+.B MPATH_PR_FILE_ERROR
+If command fails while accessing file (device node) problems(e.g. not found).
+.TP
+.B MPATH_PR_DMMP_ERROR
+If Device Mapper related error.(e.g Error in getting dm info).
+.TP
+.B MPATH_PR_OTHER
+If other error/warning has occurred(e.g transport or driver error).
+.TP
+.B MPATH_PR_RESERV_CONFLICT
+If command fails with reservation conflict.
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH "SEE ALSO"
-.I mpath_persistent_reserve_in mpathpersist /usr/share/doc/mpathpersist/README
-.br
+.\" ----------------------------------------------------------------------------
+.
+.BR mpathpersist (8).
+.
+.
+.\" ----------------------------------------------------------------------------
+.SH AUTHORS
+.\" ----------------------------------------------------------------------------
+.
+\fImultipath-tools\fR was developed by Christophe Varoqui <christophe.varoqui@opensvc.com>
+and others.
+.\" EOF
-- 
2.10.2
