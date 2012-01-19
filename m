From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: dmsetup fails on latest kernel
Date: Thu, 19 Jan 2012 13:16:07 -0800
Message-ID: <4F188817.3090104@zytor.com>
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com> <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020104080804060708030908"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------020104080804060708030908
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Here is a patch which should fix this problem.  I will run a few more
tests and then push it with the rest of the urgent queue to Linus.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------020104080804060708030908
Content-Type: text/x-patch;
 name="0001-x86-syscall-Need-__ARCH_WANT_SYS_IPC-for-32-bits.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-syscall-Need-__ARCH_WANT_SYS_IPC-for-32-bits.patch"

From 497e064320506cd15f7bdd659204b576c80bf24e Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 19 Jan 2012 12:41:25 -0800
Subject: [PATCH] x86, syscall: Need __ARCH_WANT_SYS_IPC for 32 bits

In checkin

  303395ac3bf3 x86: Generate system call tables and unistd_*.h from tables

the feature macros in <asm/unistd.h> were unified between 32 and 64
bits.  Unfortunately 32 bits requires __ARCH_WANT_SYS_IPC and this was
inadvertently dropped.

Reported-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com
---
 arch/x86/include/asm/unistd.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index b4a3db7..21f77b8 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -7,6 +7,7 @@
 #  include <asm/unistd_32.h>
 #  define __ARCH_WANT_IPC_PARSE_VERSION
 #  define __ARCH_WANT_STAT64
+#  define __ARCH_WANT_SYS_IPC
 #  define __ARCH_WANT_SYS_OLD_MMAP
 #  define __ARCH_WANT_SYS_OLD_SELECT
 
-- 
1.7.6.5


--------------020104080804060708030908--
