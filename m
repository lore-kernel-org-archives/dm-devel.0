From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] Add userspace device-mapper target
Date: Sat, 10 Feb 2007 09:34:43 +0900
Message-ID: <20070210093443Q.fujita.tomonori@lab.ntt.co.jp>
References: <m31wl0k3rn.fsf@guaranine.beaverton.ibm.com>
	<20070209081137X.fujita.tomonori@lab.ntt.co.jp>
	<m3k5yrgwdg.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3k5yrgwdg.fsf@guaranine.beaverton.ibm.com>
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
Date: Fri, 09 Feb 2007 07:54:03 -0800

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> FT> We need a pointer and length (or size) but not an offset. This
> FT> enables an user-space to pass the kernel data to write. 
> 
> Why not an offset?  If the kernel knows nothing of the format of the
> metadata, then userspace needs to be able to say "Put 512 bytes from
> this buffer at sector 23 on the disk".

Oops, I thought that we are talking about what to add to
dmu_msg_map_response structure. We need an offset for this feature,
but we already have it.


> FT> You need to set bio->bi_sector. bio_map_user() just grabs user's
> FT> pages and put them into a bio. Users of blk_rq_map_user (like
> FT> SG_IO) doesn't need bio->bi_sector.
> 
> Right, ok, I've looked through scsi_ioctl.c and cdrom.c and I have a
> much better idea of how it is currently used.

Yeah, they are better examples.


> FT> Yeah, as you said, you can just allocate buffer and use it. If
> FT> buffer is properly aligned, we can do zero-copy. But if not, the
> FT> kernel allocates pages and copies user's pages
> FT> (bio_copy_user).
> 
> Right.  I think this would be very good for both performance and ease
> of use.  Keeping track of requests in userspace to properly handle the
> endio and corresponding metadata flush can be a pain.  I don't think,
> however, that we should completely get rid of the DMU_FLAG_SYNC
> behavior, because if someone wanted to use dm-userspace block block
> debugging or something, they may want to be able to intercept both the
> request and the endio.
> 
> I'll take a stab at making this change and will post it when I have
> something working...

Great! Thanks.
