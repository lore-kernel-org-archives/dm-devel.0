From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: clarify how to dump the
	multipathd config
Date: Tue, 29 Aug 2017 01:27:56 +0200
Message-ID: <20170828232756.13465-1-xose.vazquez@gmail.com>
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

Reported-by: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/main.c           | 2 +-
 multipath/multipath.conf.5 | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index dede017..0047bf1 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -119,7 +119,7 @@ usage (char * progname)
 		"  -c      check if a device should be a path in a multipath device\n"
 		"  -q      allow queue_if_no_path when multipathd is not running\n"
 		"  -d      dry run, do not create or update devmaps\n"
-		"  -t      dump internal hardware table\n"
+		"  -t      display the currently used multipathd configuration\n"
 		"  -r      force devmap reload\n"
 		"  -i      ignore wwids file\n"
 		"  -B      treat the bindings file as read only\n"
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index a78ec5b..57a771c 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -28,7 +28,8 @@ overwrite the built-in configuration table of \fBmultipathd\fP.
 Any line whose first non-white-space character is a '#' is considered
 a comment line. Empty lines are ignored.
 .PP
-Internal multipathd configuration can be displayed with the \fBmultipath -t\fR command.
+Currently used multipathd configuration can be displayed with the \fBmultipath -t\fR
+or \fBmultipathd show config\fR command.
 .
 .
 .\" ----------------------------------------------------------------------------
-- 
2.13.5
