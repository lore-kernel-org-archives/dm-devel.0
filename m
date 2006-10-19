From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Subject: [PATCH 0 of 4] fsstack: struct path
Date: Wed, 18 Oct 2006 20:57:07 -0400
Message-ID: <patchbomb.1161219427@thor.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1945974AbWJSBs5@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, akpm@osdl.org, hch@infradead.org, viro@ftp.linux.org.uk, mhalcrow@us.ibm.com, chris.mason@oracle.com, ezk@cs.sunysb.edu, penberg@cs.helsinki.fi, dm-devel@redhat.com, mingo@redhat.com, reiserfs-dev@namesys.com
List-Id: dm-devel.ids

The following patches attempt to fix up the problems with 'struct path' as
discussed in the 'fsstack: struct path' thread on linux-kernel. The net
effect is moving struct path from fs/namei.c to include/linux/namei.h, as it
is quite useful (and it will discourage the (ab)use of struct nameidata.)

The fsstack code benefits from it as the stackable fs dentries have to keep
track of the lower dentry as well as the lower vfsmount.

The first two patches rename Reiserfs's 'struct path' to 'struct treepath',
and Device Mapper's 'struct path' to 'struct dm_path', respectively.

The third patch moves struct path from fs/namei.c to include/linux/namei.h,
making it accessible to any part of the VFS as well as other parts of the
kernel - stackable filesystem like eCryptfs and Unionfs come to mind.

The fourth patch converts eCryptfs's dentry-vfsmount pairs in the dentry
private data to struct path.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
