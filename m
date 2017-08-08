From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [BUG] BLKZEROOUT on dm-crypt container cause OOM / kernel panic
Date: Tue, 8 Aug 2017 18:23:01 +0800
Message-ID: <CAGnHSEngW1Ugf66V5henR9fMEev0xcJnKVY9MjJb19gy3CkgNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, gmazyland@gmail.com, "axboe@fb.com" <axboe@fb.com>, axboe@kernel.dk, "hch@lst.de" <hch@lst.de>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

(Sorry for the spam. Having hard time moving the thread from
outlook.com to gmail.com for linux-block. Please reply to this, thank
you.)

Hi again,

I think I have sort of identified the problem. It appears to me that
both the block layer and dm-crypt is defected on handling this.

First of all, check out the "fallback" zero out implementation, which
is used in this case, here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/block/blk-lib.c?h=v4.12#n309

From the outer loop, it seem to imply that this should be done in
multiple "bio"s, if the request (original "nr_sects") is larger than
BIO_MAX_PAGES:

...
while (nr_sects != 0) {
        bio = next_bio(bio, min(nr_sects, (sector_t)BIO_MAX_PAGES),
                        gfp_mask);
...
}
...

However, there is a inner loop:

...
        while (nr_sects != 0) {
                sz = min((sector_t) PAGE_SIZE >> 9 , nr_sects);
                bi_size = bio_add_page(bio, ZERO_PAGE(0), sz << 9, 0);
                nr_sects -= bi_size >> 9;
                sector += bi_size >> 9;
                if (bi_size < (sz << 9))
                        break;
        }
...

which apparently would loop over the whole request on its own, making
the outer loop a bogus one.

The request ends up being done in a single (huge) bio. When the bio is
passed on to dm-crypt, it appears that dm-crypt will not split the bio
either when it allocates buffer for conversion/encryption:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/md/dm-crypt.c?h=v4.12#n1694

which leads to possible enormous uptake of memory, causing OOM / kernel panic.

There seems to be some measure that is suppose to split large bio though:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/md/dm-crypt.c?h=v4.12#n2787

Apparently it is called before kcryptd_crypt_write_convert() /
crypt_alloc_buffer(). However, I don't really parse
dm_accept_partial_bio() (or the comment about it) so I don't really
know what it actually does or how it does it. Neither can I see it
helps in reality anyway.

Here is another test case that shows the problem:
https://ptpb.pw/BWWo.png
https://ptpb.pw/aRTE.png

Regards,
Tom Yan


> From: Tom Yan
> Sent: Monday, August 7, 2017 9:58 AM
> To: dm-devel@redhat.com
> Subject: [BUG] BLKZEROOUT on dm-crypt container cause OOM / kernel panic
>
> Hi all,
>
> When I do the following:
>
> cryptsetup open /dev/sdX[Y] rand --type plain --key-file /dev/random;
> blkdiscard -z /dev/mapper/rand
>
> Some OOM killings and a kernel panic occur. Here is a screenshot:
> https://gitlab.com/cryptsetup/cryptsetup/uploads/207ffdada52f3172f54a014c67159625/DSC_0129.JPG
>
> Similar issue is NOT found in doing `cat /dev/zero > /dev/mapper/rand`, or `blkdiscard -z /dev/sdX[Y]` (without opening a dm-crypt on it), on the same hardware and configuration.
>
> Note that `blkdiscard -z` does not trigger the BLKDISCARD ioctl but the BLKZEROOUT ioctl. And the devices I have been testing on are USB devices that does NOT support WRITE SAME or UNMAP.
>
> Regards,
> Tom Yan
