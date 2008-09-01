From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH #blk-for-2.8] init: DEBUG_BLOCK_EXT_DEVT requires explicit
   root= param
Date: Mon, 01 Sep 2008 13:38:17 +0200
Message-ID: <48BBD429.50907@kernel.org>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <200808292123.07246.bzolnier@gmail.com> <48B90E81.5060905@kernel.org> <200808311538.38918.bzolnier@gmail.com> <48BBCB62.4040309@kernel.org> <20080901111635.GN20055@kernel.dk> <48BBD01A.7000603@kernel.org> <20080901113059.GO20055@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20080901113059.GO20055@kernel.dk>
Sender: linux-next-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, dm-devel@redhat.com
List-Id: dm-devel.ids

DEBUG_BLOCK_EXT_DEVT shuffles SCSI and IDE device numbers and root
device number set using rdev become meaningless.  Root devices should
be explicitly specified using textual names.  Warn about it if root
can't be found and DEBUG_BLOCK_EXT_DEVT is enabled.  Also, add warning
to the help text.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
I think distros should enable it for early alpha/betas to catch odd
problems.  Well, anyways, here's the updated version.  Thanks.

 init/do_mounts.c  |    4 ++++
 lib/Kconfig.debug |    6 ++++++
 2 files changed, 10 insertions(+)

Index: work/init/do_mounts.c
===================================================================
--- work.orig/init/do_mounts.c
+++ work/init/do_mounts.c
@@ -263,6 +263,10 @@ retry:
 		printk("Please append a correct \"root=\" boot option; here are the available partitions:\n");
 
 		printk_all_partitions();
+#ifdef CONFIG_DEBUG_BLOCK_EXT_DEVT
+		printk("DEBUG_BLOCK_EXT_DEVT is enabled, you need to specify "
+		       "explicit textual name for \"root=\" boot option.\n");
+#endif
 		panic("VFS: Unable to mount root fs on %s", b);
 	}
 
Index: work/lib/Kconfig.debug
===================================================================
--- work.orig/lib/Kconfig.debug
+++ work/lib/Kconfig.debug
@@ -638,6 +638,12 @@ config DEBUG_BLOCK_EXT_DEVT
 	  userland code paths which assume predetermined contiguous
 	  device number allocation.
 
+	  Note that turning on this debug option shuffles all the
+	  device numbers for all IDE and SCSI devices including libata
+	  ones, so root partition specified using device number
+	  directly (via rdev or root=MAJ:MIN) won't work anymore.
+	  Textual device names (root=/dev/sdXn) will continue to work.
+
 	  Say N if you are unsure.
 
 config LKDTM
