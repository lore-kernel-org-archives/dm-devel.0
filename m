From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/7] fs:  add blkdev name format specifier v2
Date: Fri, 17 Apr 2015 12:29:12 +0400
Message-ID: <1429259359-13480-1-git-send-email-dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, dm-devel@redhat.com
List-Id: dm-devel.ids

Currently in order to print block_device name one should  use blkdev() helper
which requires temproral buffer of size BDEVNAME_SIZE (32bytes). This is very
ineffective because result in stack usage bloating for deep IO call traces where
stack usage is close to maximum values.

It is reasonable to introduce dedicated format specifier for block_device name,
unfortunately "%pb", "%pB", "%pd" and "%pD" are already reserved for other data types
I've pick "%pg" ala geometry. If some one want to offer sane spacifier name
please let me know.

Changes from from v2
- fix use after free in dm/raid10 (Spotted by Jan Kara)
Changes from from v1
- bdevname() now works via "%pg" format specifier (in responce to Joe's comments)

TOC:
## Add format helpers and simple cleanup
lib: vsprintf add pg format specifier
fs: use gendisk disk_name where possible
## migrate subsystems to format helpers
block: use block_device name vsprintf helper
fs: use block_device name vsprintf helper
md: use block_device name vsprintf helper v2
block/partitions use block_device name vsprintf help v2
drivers: use block_device name vsprintf helper
