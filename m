From: McPacino <mcpacino@gmail.com>
Subject: Re: introduce dm-snap-mv
Date: Fri, 8 Oct 2010 17:01:06 +0800
Message-ID: <AANLkTimip4sT6Pkzz=-jA3RWiGnqfNtmbJzW_Hn1ynFt@mail.gmail.com>
References: <20101006083150.GA15758@zhongling>
	<201010071431.14937.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201010071431.14937.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Phillips <phillips@phunq.net>, Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>
List-Id: dm-devel.ids

Hi Daniel,

It is very cumbersome to deal with small (512, 1024 or 2048) blocksize.

I used fixed size (4096 bytes) block to save the exception list.

If the blocksize is 512 byte, I have to invoke __getblk() 8 times to re=
ad
the exception list. And what more cumbersome is, my exception list
struct might scatter in 8 non-continuous memory segments.

In my code, each exception is presented by a 6-bytes struct. 4K
block can present an exception list containing at most about 670
exceptions. If I used 512 bytes block to present an exception list,
the number is just about 80. That is too small.

So, it's really a big favor to me if __getblk() could read 4K buffer
head in any case.

PS: There is no other kernel component have the demand like my
case? I am learning ext FS code now.

Regards.

Cong Meng.



On Fri, Oct 8, 2010 at 5:31 AM, Daniel Phillips <phillips@phunq.net> wr=
ote:
> Hi Meng,
>
> The patch looks sensible, however the question is: why do you want to
> do this? =A0Would it not be better to generalize your metadata format=
 to
> accomodate the device's native blocksize?
>
> Regards,
>
> Daniel
>
>> a kernel patch
>> --------------
>> Now, dm-snap-mv highly depends on a kernel patch below, which make _=
_getblk()
>> can get a 4K buffer head while block size of the disk is NOT 4K.
>>
>> Signed-off-by: Cong Meng <mcpacino@gmail.com>
>> ---
>> =A0fs/buffer.c | =A0 =A07 ++-----
>> =A01 files changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index 3e7dca2..f7f9d33 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -1051,10 +1051,7 @@ grow_buffers(struct block_device *bdev, secto=
r_t block, int size)
>> =A0 =A0 =A0 pgoff_t index;
>> =A0 =A0 =A0 int sizebits;
>>
>> - =A0 =A0 sizebits =3D -1;
>> - =A0 =A0 do {
>> - =A0 =A0 =A0 =A0 =A0 =A0 sizebits++;
>> - =A0 =A0 } while ((size << sizebits) < PAGE_SIZE);
>> + =A0 =A0 sizebits =3D PAGE_CACHE_SHIFT - bdev->bd_inode->i_blkbits;
>>
>> =A0 =A0 =A0 index =3D block >> sizebits;
>>
>> @@ -2924,7 +2921,7 @@ int submit_bh(int rw, struct buffer_head * bh)
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 bio =3D bio_alloc(GFP_NOIO, 1);
>>
>> - =A0 =A0 bio->bi_sector =3D bh->b_blocknr * (bh->b_size >> 9);
>> + =A0 =A0 bio->bi_sector =3D bh->b_blocknr << (bh->b_bdev->bd_inode-=
>i_blkbits - 9);
>> =A0 =A0 =A0 bio->bi_bdev =3D bh->b_bdev;
>> =A0 =A0 =A0 bio->bi_io_vec[0].bv_page =3D bh->b_page;
>> =A0 =A0 =A0 bio->bi_io_vec[0].bv_len =3D bh->b_size;
>
