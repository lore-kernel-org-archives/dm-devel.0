From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 8/9] mpathpersist.8: fix examples in man page
Date: Mon, 27 May 2019 14:59:41 +0200
Message-ID: <20190527125942.8366-9-mwilck@suse.com>
References: <20190527125942.8366-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190527125942.8366-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

--prout-type is ignored in the REGISTER service action. The RESERVE service
action takes a Reservation Key, not a Service action Reservation Key, as
argument. The text mentions "Service Action Reservation Key" in several places
where it means the Reservation Key. Add examples for unregistering the current
key, and the CLEAR service action. Fix formatting with longer text in the
description lines (the .TP formatting would produce bad results if the
first line needs to be broken).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 mpathpersist/mpathpersist.8 | 43 +++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/mpathpersist/mpathpersist.8 b/mpathpersist/mpathpersist.8
index 885491dd..cd602e40 100644
--- a/mpathpersist/mpathpersist.8
+++ b/mpathpersist/mpathpersist.8
@@ -167,18 +167,43 @@ PR In: maximum allocation length. LEN is a decimal number between 0 and 8192.
 .SH EXAMPLE
 .\" ----------------------------------------------------------------------------
 .
-.TP
-Register the Service Action Reservation Key for the /dev/mapper/mpath9 device:
-\fBmpathpersist --out --register --param-sark=\fI123abc \fB--prout-type=\fI5 /dev/mapper/mpath9\fR
-.TP
-Read the Service Action Reservation Key for the /dev/mapper/mpath9 device:
+.PP
+Register the key \(dq123abc\(dq for the /dev/mapper/mpath9 device:
+.RS
+\fBmpathpersist --out --register --param-sark=\fI123abc /dev/mapper/mpath9\fR
+.RE
+.PP
+Read registered reservation keys for the /dev/mapper/mpath9 device:
+.RS
 \fBmpathpersist -i -k \fI/dev/mapper/mpath9\fR
-.TP
-Reserve the Service Action Reservation Key for the /dev/mapper/mpath9 device:
-\fBmpathpersist --out --reserve --param-sark=\fI123abc \fB--prout-type=\fI8 \fB-d \fI/dev/mapper/mpath9\fR
-.TP
+.RE
+.PP
+Create a reservation for the /dev/mapper/mpath9 device with the given
+reservation key:
+.RS
+\fBmpathpersist --out --reserve --param-rk=\fI123abc \fB--prout-type=\fI8 \fB-d \fI/dev/mapper/mpath9\fR
+.RE
+.PP
 Read the reservation status of the /dev/mapper/mpath9 device:
+.RS
 \fBmpathpersist -i -s -d \fI/dev/mapper/mpath9\fR
+.RE
+.PP
+Release the previously created reservation (note that the prout-type needs to
+be the same as above):
+.RS
+\fBmpathpersist --out --release --param-rk=\fI123abc \fB--prout-type=\fI8 \fB-d \fI/dev/mapper/mpath9\fR
+.RE
+.PP
+Remove the current key registered for this host (i.e. reset it to 0):
+.RS
+\fBmpathpersist --out --register-ignore -K \fI123abc\fB -S \fI0\fB \fI/dev/mapper/mpath9\fR
+.RE
+.PP
+Remove current reservation, and unregister all registered keys from all I_T nexuses:
+.RS
+\fBmpathpersist -oCK \fI123abc \fI/dev/mapper/mpath9\fR
+.RE
 .
 .
 .\" ----------------------------------------------------------------------------
-- 
2.21.0
