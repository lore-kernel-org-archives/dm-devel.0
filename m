From: Tejun Heo <tj@kernel.org>
Subject: [PATCH #blk-for-2.8] init: DEBUG_BLOCK_EXT_DEVT requires explicit
 root= param
Date: Mon, 01 Sep 2008 13:00:50 +0200
Message-ID: <48BBCB62.4040309@kernel.org>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <200808292123.07246.bzolnier@gmail.com> <48B90E81.5060905@kernel.org> <200808311538.38918.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <200808311538.38918.bzolnier@gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, dm-devel@redhat.com
List-Id: dm-devel.ids

DEBUG_BLOCK_EXT_DEVT shuffles SCSI and IDE device numbers and root
device number set using rdev become meaningless.  Root devices should
be explicitly specified using textual names.  Warn about it if root
can't be found and DEBUG_BLOCK_EXT_DEVT is enabled.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
There are other ways to specify device numbers directly (ie. root=8:0)
and DEBUG_BLOCK_EXT_DEVT being a debug option I don't think it
warrants a complex logic, so I just added simple warning message.

 init/do_mounts.c |    4 ++++
 1 file changed, 4 insertions(+)

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
 
