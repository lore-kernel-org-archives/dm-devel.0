From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 17/18] Replicator: new variable in generated file
Date: Mon,  2 Nov 2009 15:20:21 +0100
Message-ID: <1257171622-8380-18-git-send-email-zkabelac@redhat.com>
References: <1257171622-8380-1-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-2-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-3-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-4-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-5-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-6-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-7-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-8-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-9-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-10-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-11-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-12-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-13-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-14-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-15-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-16-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-17-git-send-email-zkabelac@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1257171622-8380-17-git-send-email-zkabelac@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

---
 lib/misc/configure.h.in |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/lib/misc/configure.h.in b/lib/misc/configure.h.in
index 4273eeb..a49cd6e 100644
--- a/lib/misc/configure.h.in
+++ b/lib/misc/configure.h.in
@@ -419,6 +419,9 @@
 /* Define to 1 to include the LVM readline shell. */
 #undef READLINE_SUPPORT
 
+/* Define to 1 to include built-in support for replicator. */
+#undef REPLICATOR_INTERNAL
+
 /* Define as the return type of signal handlers (`int' or `void'). */
 #undef RETSIGTYPE
 
-- 
1.6.5.1
