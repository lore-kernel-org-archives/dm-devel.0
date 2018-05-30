From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] branch-check: fix long->int truncation when profiling
 branches
Date: Wed, 30 May 2018 08:19:22 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1805300818140.24812@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180528155432.2864616-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180528155432.2864616-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
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
