From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/4] branch-check: fix long->int truncation when
	profiling branches
Date: Wed, 30 May 2018 15:16:57 +0200
Message-ID: <20180530131822.086075870@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=branch_check-long.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Cc: dm-devel@redhat.com, stable@vger.kernel.org
List-Id: dm-devel.ids

The function __builtin_expect returns long type (see the gcc
documentation), and so do macros likely and unlikely. Unfortunatelly, when
CONFIG_PROFILE_ANNOTATED_BRANCHES is selected, the macros likely and
unlikely expand to __branch_check__ and __branch_check__ truncates the
long type to int. This unintended truncation may cause bugs in various
kernel code (we found a bug in dm-writecache because of it), so it's
better to fix __branch_check__ to return long.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 include/linux/compiler.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/compiler.h
===================================================================
--- linux-2.6.orig/include/linux/compiler.h	2018-02-26 20:34:17.000000000 +0100
+++ linux-2.6/include/linux/compiler.h	2018-05-30 14:11:53.000000000 +0200
@@ -21,7 +21,7 @@ void ftrace_likely_update(struct ftrace_
 #define unlikely_notrace(x)	__builtin_expect(!!(x), 0)
 
 #define __branch_check__(x, expect, is_constant) ({			\
-			int ______r;					\
+			long ______r;					\
 			static struct ftrace_likely_data		\
 				__attribute__((__aligned__(4)))		\
 				__attribute__((section("_ftrace_annotated_branch"))) \
