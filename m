From: Dan Smith <danms@us.ibm.com>
Subject: Re: [PATCH 1/2] Add userspace device-mapper target
Date: Fri, 09 Feb 2007 07:54:03 -0800
Message-ID: <m3k5yrgwdg.fsf@guaranine.beaverton.ibm.com>
References: <m3lkjltq1x.fsf@guaranine.beaverton.ibm.com>
	<20070209004800A.fujita.tomonori@lab.ntt.co.jp>
	<m31wl0k3rn.fsf@guaranine.beaverton.ibm.com>
	<20070209081137X.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070209081137X.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Fri, 9 Feb 2007 08:11:38 +0900 (JST)")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

FT> We need a pointer and length (or size) but not an offset. This
FT> enables an user-space to pass the kernel data to write.=20

Why not an offset?  If the kernel knows nothing of the format of the
metadata, then userspace needs to be able to say "Put 512 bytes from
this buffer at sector 23 on the disk".

FT> You need to set bio->bi_sector. bio_map_user() just grabs user's
FT> pages and put them into a bio. Users of blk_rq_map_user (like
FT> SG_IO) doesn't need bio->bi_sector.

Right, ok, I've looked through scsi_ioctl.c and cdrom.c and I have a
much better idea of how it is currently used.
=20
FT> Yeah, as you said, you can just allocate buffer and use it. If
FT> buffer is properly aligned, we can do zero-copy. But if not, the
FT> kernel allocates pages and copies user's pages
FT> (bio_copy_user).

Right.  I think this would be very good for both performance and ease
of use.  Keeping track of requests in userspace to properly handle the
endio and corresponding metadata flush can be a pain.  I don't think,
however, that we should completely get rid of the DMU_FLAG_SYNC
behavior, because if someone wanted to use dm-userspace block block
debugging or something, they may want to be able to intercept both the
request and the endio.

I'll take a stab at making this change and will post it when I have
something working...

- --=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFzJkmwtEf7b4GJVQRAsvPAKCCCmKCPqziEGA39pbpNB8rPm/URgCdFLQg
7zvBXPLXRhvsdezVQRAGMyg=3D
=3Dr63I
-----END PGP SIGNATURE-----
