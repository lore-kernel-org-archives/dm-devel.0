From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] Add userspace device-mapper target
Date: Fri, 9 Feb 2007 08:11:38 +0900 (JST)
Message-ID: <20070209081137X.fujita.tomonori@lab.ntt.co.jp>
References: <m3lkjltq1x.fsf@guaranine.beaverton.ibm.com>
	<20070209004800A.fujita.tomonori@lab.ntt.co.jp>
	<m31wl0k3rn.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m31wl0k3rn.fsf@guaranine.beaverton.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Dan Smith <danms@us.ibm.com>
Subject: Re: [dm-devel] [PATCH 1/2] Add userspace device-mapper target
Date: Thu, 08 Feb 2007 08:33:48 -0800

> FT>   - enable an user-space to pass the kernel data to write
> 
> FT>     If you add u64 (user's address) to struct
> FT> dmu_msg_map_response, the kernel can map user's pages and add them
> FT> to a bio. the write is done in a zero-copy manner. A user-space
> FT> process can simply mmap a file and pass the address of the
> FT> metadata (for CoW) to the
> FT> kernel. 2.6.20/drivers/scsi/scsi_tgt_lib.c does the same thing.
> 
> So we would need a pointer, an offset in the file, and then a length
> or size, correct?

We need a pointer and length (or size) but not an offset. This enables
an user-space to pass the kernel data to write. The data doesn't need
to be in a file. The user space can pass any kind of a memory address.


> In looking at bio_map_user(), and scsi_map_user_pages(), I'm not sure
> where the bio->bi_sector gets set to control where the metadata would
> be written.  I assume that we could just set it on the result of
> bio_map_user(), but I wonder if I'm missing something.

You need to set bio->bi_sector. bio_map_user() just grabs user's pages
and put them into a bio. Users of blk_rq_map_user (like SG_IO) doesn't
need bio->bi_sector.

Sorry, I should have mentioned blk_rq_map_user instead of bio_map_user.


> If (from userspace), I mmap the cow file, and make the metadata change
> in the mmap'd space, isn't there a chance that the metadata change
> could be written to disk before the dmu response goes back to the
> kernel?  The danger here is that the metadata gets written before the
> data block gets flushed to disk.  What am I missing?

Oh, yeah. That was a bad example.


> If you don't mmap the file, but rather just prepare a block of data
> with the metadata to be written, then it wouldn't be a problem.
> However, you would then have a problem if the metadata format you were
> using wasn't page or sector aligned.

Yeah, as you said, you can just allocate buffer and use it. If buffer
is properly aligned, we can do zero-copy. But if not, the kernel
allocates pages and copies user's pages (bio_copy_user). Sorry,
again. I should have mentioned blk_rq_map_user instead of
bio_map_user.
