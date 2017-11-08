From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/6] multipath: add man page info for my prkey
	changes
Date: Tue,  7 Nov 2017 18:15:12 -0600
Message-ID: <1510100116-6206-3-git-send-email-bmarzins@redhat.com>
References: <1510100116-6206-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1510100116-6206-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Update the man pages to list the new configuration options and
multipathd commands.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.conf.5 | 17 +++++++++++++++++
 multipathd/multipathd.8    | 16 ++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 5b6dde7..92ad8b1 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -682,6 +682,17 @@ The default is: \fB/etc/multipath/wwids\fR
 .
 .
 .TP
+.B prkeys_file
+The full pathname of the prkeys file, which is used by multipathd to keep
+track of the persistent reservation key used for a specific WWID, when
+\fIreservation_key\fR is set to \fBfile\fR.
+.RS
+.TP
+The default is \fB/etc/multipath/prkeys\fR
+.RE
+.
+.
+.TP
 .B log_checker_err
 If set to
 .I once
@@ -703,6 +714,12 @@ the same as the RESERVATION KEY field of the PERSISTENT RESERVE OUT parameter
 list which contains an 8-byte value provided by the application client to the
 device server to identify the I_T nexus.
 .RS
+.PP
+Alternatively, this can be set to \fBfile\fR, which will store the RESERVATION
+KEY registered by mpathpersist in the \fIprkeys_file\fR. multipathd will then
+use this key to register additional paths as they appear.  When the
+registration is removed, the RESERVATION KEY is removed from the
+\fIprkeys_file\fR.
 .TP
 The default is: \fB<unset>\fR
 .RE
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 2615728..5c96680 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -247,6 +247,22 @@ Disable persistent reservation management on $map.
 Get the current persistent reservation management status of $map.
 .
 .TP
+.B map|multipath $map getprkey
+Get the current persistent reservation key associated with $map.
+.
+.TP
+.B map|multipath $map setprkey key $key
+Set the persistent reservation key associated with $map to $key in the
+\fIprkeys_file\fR. This key will only be used by multipathd if
+\fIreservation_key\fR is set to \fBfile\fR in \fI/etc/multipath.conf\fR.
+.
+.TP
+.B map|multipath $map unsetprkey
+Remove the persistent reservation key associated with $map from the
+\fIprkeys_file\fR. This will only unset the key used by multipathd if
+\fIreservation_key\fR is set to \fBfile\fR in \fI/etc/multipath.conf\fR.
+.
+.TP
 .B quit|exit
 End interactive session.
 .
-- 
2.7.4
