From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/2] multipath.conf.5: document foreign library
	support
Date: Thu, 15 Aug 2019 14:46:56 +0000
Message-ID: <20190815144638.5664-3-martin.wilck@suse.com>
References: <20190815144638.5664-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190815144638.5664-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Add documentation for foreign library support, and for the
"enable_foreign" parameter.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.conf.5 | 40 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index f7d21b4c..c1446231 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1194,6 +1194,21 @@ makes multipath immediately mark a device with only ghost paths as ready.
 The default is: \fBno\fR
 .RE
 .
+.
+.TP
+.B enable_foreign
+Enables or disables foreign libraries (see section
+.I FOREIGN MULTIPATH SUPPORT
+below). The value is a regular expression; foreign libraries are loaded
+if their name (e.g. \(dqnvme\(dq) matches the expression. By default,
+all foreign libraries are enabled.
+.RS
+.TP
+The default is: \fB\(dq\(dq\fR (the empty regular expression)
+.RE
+.
+.
+
 .
 .\" ----------------------------------------------------------------------------
 .SH "blacklist and blacklist_exceptions sections"
@@ -1735,6 +1750,31 @@ unpredictable ways. If the \(dqmarginal_path\(dq method is active, the
 .
 .
 .\" ----------------------------------------------------------------------------
+.SH "FOREIGN MULTIPATH SUPPORT"
+.\" ----------------------------------------------------------------------------
+.
+multipath and multipathd can load \(dqforeign\(dq libraries to add
+support for other multipathing technologies besides the Linux device mapper.
+Currently this support is limited to printing detected information about
+multipath setup. In topology output, the names of foreign maps are prefixed by
+the foreign library name in square brackets, as in this example:
+.
+.P
+.EX
+# multipath -ll
+uuid.fedcba98-3579-4567-8765-123456789abc [nvme]:nvme4n9 NVMe,Some NVMe controller,FFFFFFFF
+size=167772160 features='n/a' hwhandler='ANA' wp=rw
+|-+- policy='n/a' prio=50 status=optimized
+| `- 4:38:1    nvme4c38n1 0:0     n/a   optimized    live
+`-+- policy='n/a' prio=50 status=optimized
+  `- 4:39:1    nvme4c39n1 0:0     n/a   optimized    live
+.EE
+.
+.P
+The \(dqnvme\(dq foreign library provides support for NVMe native multipathing
+in the kernel. It is part of the standard multipath package.
+.
+.\" ----------------------------------------------------------------------------
 .SH "KNOWN ISSUES"
 .\" ----------------------------------------------------------------------------
 .
-- 
2.22.0
