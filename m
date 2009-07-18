From: Neil Brown <neilb@suse.de>
Subject: How to handle >16TB devices on 32 bit hosts ??
Date: Sat, 18 Jul 2009 10:08:10 +1000
Message-ID: <19041.4714.686158.130252@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids


Hi,
 It has recently come to by attention that Linux on a 32 bit host does
 not handle devices beyond 16TB particularly well.

 In particular, any access that goes through the page cache for the
 block device is limited to a pgoff_t number of pages.
 As pgoff_t is "unsigned long" and hence 32bit, and as page size is
 4096, this comes to 16TB total.

 A filesystem created on a 17TB device should be able to access and
 cache file data perfectly providing CONFIG_LBDAF is set.
 However if the filesystem caches metadata using the block device,
 then metadata beyond 16TB will be a problem.

 Access to the block device (/dev/whatever) via open/read/write will
 also cause problems beyond 16TB, though if O_DIRECT is used I think
 it should work OK (it will probably try to flushed out completely
 irrelevant parts of the page cache before allowing the IO, but that
 is a benign error case I think).

 With 2TB drives easily available, more people will probably try
 building arrays this big and we cannot just assume they will only do
 it on 64bit hosts.

 So the question I wanted to ask really is:  is there any point in
 allowing >16TB arrays to be created on 32bit hosts, or should we just
 disallow them?  If we allow them, what steps should we take to make
 the possible failure modes more obvious?

 As I said, I think O_DIRECT largely works fine on these devices and
 we could fix the few irregularities with little effort.  So one step
 might be to make mkfs/fsck utilities use O_DIRECT on >16TB devices on
 32bit hosts.

 Given that non-O_DIRECT can fail (e.g. in do_generic_file_read,
       index = *ppos >> PAGE_CACHE_SHIFT
 will lose data if *ppos is beyond 44 bits) we should probably fail
 opens on devices larger than 16TB.... though just failing the open
 doesn't help if the device can change size, as dm and md devices can.

 I believe ext[234] uses the block device's page cache for metadata, so
 they cannot safely be used with >16TB devices on 32bit.  Is that
 correct?  Should they fail a mount attempt? Do they?

 Are there any filesystems that do not use the block device cache and
 so are not limited to 16TB on 32bit?

 Even if no filesystem can use >16TB on 32bit, I suspect dm can
 usefully use such a device for logical volume management, and as long
 as each logical volume does not exceed 16TB, all should be happy.  So
 completely disallowing them might not be best.

 I suppose we could add a CONFIG option to make pgoff_t be 
 "unsigned long long".  Would the cost/benefit of that be acceptable?

 Your thoughts are most welcome.

Thanks,
NeilBrown
