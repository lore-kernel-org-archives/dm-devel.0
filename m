From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] select STACKTRACE if using it
Date: Mon, 12 Sep 2011 07:05:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1109120703190.10238@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-thinp: select STACKTRACE if using it

This patch selects option "STACKTRACE" if dm-thinp uses it. If we don't 
select this option, it isn't included in the kernel and dm-thinp can't be 
compiled.

Mikulas

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-3.1-rc3-fast/drivers/md/Kconfig
===================================================================
--- linux-3.1-rc3-fast.orig/drivers/md/Kconfig	2011-09-12 12:56:37.000000000 +0200
+++ linux-3.1-rc3-fast/drivers/md/Kconfig	2011-09-12 12:56:39.000000000 +0200
@@ -271,7 +271,8 @@ config DM_BLOCK_LOCKING
 
 config DM_BLOCK_STACK_TRACING
 	boolean "Keep a stack trace of all lock holders"
-	depends on DM_BLOCK_LOCKING
+	depends on DM_BLOCK_LOCKING && STACKTRACE_SUPPORT
+	select STACKTRACE
 
 	---help---
 
