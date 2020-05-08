From: mwilck@suse.com
Subject: [PATCH 1/2] libmultipath: set "enable_foreign" to NONE
	by default
Date: Fri,  8 May 2020 21:33:01 +0200
Message-ID: <20200508193302.11401-2-mwilck@suse.com>
References: <20200508193302.11401-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200508193302.11401-1-mwilck@suse.com>
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
Cc: "George, Martin" <Martin.George@netapp.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This has been requested by NetApp.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/defaults.h    | 4 ++--
 multipath/multipath.conf.5 | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index e5ee6afe..01a501bd 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -50,8 +50,8 @@
 #define DEFAULT_FIND_MULTIPATHS_TIMEOUT -10
 #define DEFAULT_UNKNOWN_FIND_MULTIPATHS_TIMEOUT 1
 #define DEFAULT_ALL_TG_PT ALL_TG_PT_OFF
-/* Enable all foreign libraries by default */
-#define DEFAULT_ENABLE_FOREIGN ""
+/* Enable no foreign libraries by default */
+#define DEFAULT_ENABLE_FOREIGN "NONE"
 
 #define CHECKINT_UNDEF		UINT_MAX
 #define DEFAULT_CHECKINT	5
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 05a5e8ff..28cea88c 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1228,10 +1228,11 @@ Enables or disables foreign libraries (see section
 .I FOREIGN MULTIPATH SUPPORT
 below). The value is a regular expression; foreign libraries are loaded
 if their name (e.g. \(dqnvme\(dq) matches the expression. By default,
-all foreign libraries are enabled.
+no foreign libraries are enabled. Set this to \(dqnvme\(dq to enable NVMe native
+multipath support, or \(dq.*\(dq to enable all foreign libraries.
 .RS
 .TP
-The default is: \fB\(dq\(dq\fR (the empty regular expression)
+The default is: \fB\(dqNONE\(dq\fR
 .RE
 .
 .
-- 
2.26.2
