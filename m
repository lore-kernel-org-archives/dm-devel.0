From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/3] document "disable_changed_wwids" config
	parameter
Date: Fri, 11 Nov 2016 16:58:21 -0600
Message-ID: <1478905103-9735-2-git-send-email-bmarzins@redhat.com>
References: <1478905103-9735-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1478905103-9735-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.conf.5 | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index a1f25d5..fa2df48 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -853,6 +853,17 @@ The default is \fBno\fR
 .RE
 .
 .
+.TP
+.B disable_changed_wwids
+If set to \fIyes\fR, multipathd will check the path wwid on change events, and
+if it has changed from the wwid of the multipath device, multipathd will
+disable access to the path until the wwid changes back.
+.RS
+.TP
+Default value is \fBno\fR
+.RE
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "blacklist section"
 .\" ----------------------------------------------------------------------------
-- 
1.8.3.1
