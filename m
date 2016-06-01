From: Mikulas Patocka <mpatocka@redhat.com>
Subject: RE: [PATCH] dm-log-writes: fix bug with too large bios
Date: Wed, 1 Jun 2016 13:32:59 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1606010621140.6561@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1605271047280.2109@file01.intranet.prod.int.rdu2.redhat.com> <07bf01d1bbbd$53991750$facb45f0$@codenest.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <07bf01d1bbbd$53991750$facb45f0$@codenest.com>
Sender: linux-bcache-owner@vger.kernel.org
To: James Johnston <johnstonj.public@codenest.com>
Cc: "'Alasdair G. Kergon'" <agk@redhat.com>, 'Mike Snitzer' <msnitzer@redhat.com>, 'Josef Bacik' <jbacik@fb.com>, dm-devel@redhat.com, 'Eric Wheeler' <bcache@lists.ewheeler.net>, 'Tim Small' <tim@buttersideup.com>, 'Kent Overstreet' <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, dm-crypt@saout.de, 'Neil Brown' <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids



On Wed, 1 Jun 2016, James Johnston wrote:

> Hi Mikulas,
> 
> > bio_alloc can allocate a bio with at most BIO_MAX_PAGES (256) vector
> > entries. However, the incoming bio may have more vector entries if it was
> > allocated by other means. For example, bcache submits bios with more than
> > BIO_MAX_PAGES entries. This results in bio_alloc failure.
> > 
> > To avoid the failure, change the code so that it allocates bio with at
> > most BIO_MAX_PAGES entries. If the incoming bio has more entries,
> > bio_add_page will fail and a new bio will be allocated - the code that
> > handles bio_add_page failure already exists in the dm-log-writes target.
> > 
> > Also, move atomic_inc(&lc->io_blocks) before bio_alloc to fix a bug that
> > the target hangs if bio_alloc fails. The error path does put_io_block(lc),
> > so we must do atomic_inc(&lc->io_blocks) before invoking the error path to
> > avoid underflow of lc->io_blocks.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org	# v4.1+
> 
> How does this relate to the previous patch you made to dm-crypt?  How best
> should I test this?  It looks like the dm-crypt patch fixed the problem.
> 
> Should I test by applying this patch ONLY and reverting the dm-crypt patch?
> (i.e. does this patch also fix the problem.)  Or should I just test with
> both patches applied simultaneously?
> 
> James

When I found a bug in dm-crypt, I searched the other targets for the same 
problem and found out that the same bug is also present in dm-log-writes.

The bug in dm-log-writes can be reproduced if you make a bcache device 
with 2MiB bucket size and place in on the dm-log-writes target.

When the bug is present, the dm-log-writes target reports "device-mapper: 
log-writes: Couldn't alloc log bio".

This is a script that triggers the bug for dm-log-writes. Before running 
the script, create devices /dev/mapper/loop-test1, loop-test2 and 
loop-test3.

Mikulas


wipefs -a /dev/mapper/loop-test1
./make-bcache --wipe-bcache --bucket 2M -C /dev/mapper/loop-test1
dmsetup create backCrypt --table "0 `blockdev --getsize /dev/mapper/loop-test2` log-writes /dev/mapper/loop-test2 /dev/mapper/loop-test3"
wipefs -a /dev/mapper/backCrypt
./make-bcache --wipe-bcache -B /dev/mapper/backCrypt
modprobe bcache
echo /dev/mapper/loop-test1 > /sys/fs/bcache/register
echo /dev/mapper/backCrypt > /sys/fs/bcache/register
./bcache-super-show /dev/mapper/loop-test1 | grep cset.uuid | cut -f 3 >/sys/block/bcache0/bcache/attach
echo writeback > /sys/block/bcache0/bcache/cache_mode

cd /sys/block/bcache0/bcache
echo 0 > sequential_cutoff
# Verify that the cache is attached (i.e. does not say "no cache")
cat state
dd if=/dev/urandom of=/dev/bcache0 bs=1M count=250
cat dirty_data
cat state
echo 1 > detach
cat dirty_data
cat state
