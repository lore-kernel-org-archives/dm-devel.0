From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 08/16] multipath.conf.5: document
	"ignore_wwids"
Date: Fri, 19 Jan 2018 01:29:08 +0100
Message-ID: <20180119002916.10323-9-mwilck@suse.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

---
 multipath/multipath.conf.5 | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index ab151e720d75..33ad775139c4 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -954,12 +954,43 @@ device again, as soon as it sees a path with that WWID. This should allow most
 users to have multipath automatically choose the correct paths to make into
 multipath devices, without having to edit the blacklist.
 .RS
+.PP
+If \fBignore_wwids\fR is set to
+.I no
+, only method
+.I 2
+above (manual creation by the user) will be used for creating new maps.
+.RE
+.RS
 .TP
 The default is: \fBno\fR
 .RE
 .
 .
 .TP
+.B ignore_wwids
+If set to
+.I no
+, multipath and multipathd only consider paths matching a WWID listed in
+the \fBwwids_file\fR as valid multipath devices. Automatic multipath map
+creation is disabled.
+.
+If set to
+.I yes
+, and \fBfind_multipaths\fR is
+.I no
+, every device which is not blacklisted
+will be treated as a potential multipath member. See above for
+the logic if  \fBfind_multipaths\fR is set to
+.I yes.
+.
+.RS
+.TP
+The default is: \fBoff\fR
+.RE
+.
+.
+.TP
 .B uxsock_timeout
 CLI receive timeout in milliseconds. For larger systems CLI commands
 might timeout before the multipathd lock is released and the CLI command
-- 
2.15.1
