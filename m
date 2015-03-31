From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [RFC] [PATCH 0/7] fs: add blkdev name format specifier
Date: Tue, 31 Mar 2015 20:01:14 +0400
Message-ID: <1427817681-4494-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>, viro@zeniv.linux.org.uk
List-Id: dm-devel.ids

Currently in order to print block_device name one should  use blkdev() helper
which requires temproral buffer of size BDEVNAME_SIZE (32bytes). This is very
ineffective because result in stack usage bloating for deep IO call traces where
stack usage is close to maximum values.

It is reasonable to introduce dedicated format specifier for block_device name,
unfortunately "%pb", "%pB", "%pd" and "%pD" are already reserved for other data types
I've pick "%pg" ala geometry. If some one want to offer sane spacifier name
please let me know.

Since this is RFC version I've pick rough patch split policy (based on subsystem).
Please let me know if patchset should be split in different way.

TOC:
## Add format helpers and simple cleanup
lib: vsprintf add pg format specifier
fs: use gendisk disk_name where possible
## migrate subsystems to format helpers
block: use block_device name vsprintf helper
fs: use block_device name vsprintf helper
md: use block_device name vsprintf helper
block/partitions use block_device name vsprintf help
drivers: use block_device name vsprintf helper
