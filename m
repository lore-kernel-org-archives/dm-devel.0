From: Dan Smith <danms@us.ibm.com>
Subject: Re: [PATCH 1/2] Add userspace device-mapper target
Date: Thu, 08 Feb 2007 08:33:48 -0800
Message-ID: <m31wl0k3rn.fsf@guaranine.beaverton.ibm.com>
References: <m3lkjltq1x.fsf@guaranine.beaverton.ibm.com>
	<20070209004800A.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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

FT> - The current ring buffer interface is the producer/consumer
FT> pointer scheme. It's simple but it doesn't work for multi
FT> processes/threads.  Seems that kevent has a better ring buffer
FT> interface. And it's trying to introduce new system calls for its
FT> ring buffer. They might work for dm-user.

Ok, I'll take a look.  It would certainly be preferable to reuse
something else in the kernel.

FT>   - enable an user-space to pass the kernel data to write

FT>     If you add u64 (user's address) to struct
FT> dmu_msg_map_response, the kernel can map user's pages and add them
FT> to a bio. the write is done in a zero-copy manner. A user-space
FT> process can simply mmap a file and pass the address of the
FT> metadata (for CoW) to the
FT> kernel. 2.6.20/drivers/scsi/scsi_tgt_lib.c does the same thing.

So we would need a pointer, an offset in the file, and then a length
or size, correct?

In looking at bio_map_user(), and scsi_map_user_pages(), I'm not sure
where the bio->bi_sector gets set to control where the metadata would
be written.  I assume that we could just set it on the result of
bio_map_user(), but I wonder if I'm missing something.

If (from userspace), I mmap the cow file, and make the metadata change
in the mmap'd space, isn't there a chance that the metadata change
could be written to disk before the dmu response goes back to the
kernel?  The danger here is that the metadata gets written before the
data block gets flushed to disk.  What am I missing?

If you don't mmap the file, but rather just prepare a block of data
with the metadata to be written, then it wouldn't be a problem.
However, you would then have a problem if the metadata format you were
using wasn't page or sector aligned.

FT>   - Introduing DMU_FLAG_LINKED

FT>     If userspace uses DMU_FLAG_LINKED to ask the kernel to perform
FT> multiple commands atomically and sequentially. For example, if
FT> userspace needs to one data block and a metadata block (for the
FT> data block) for CoW, userspace can send two dmu_msg_map_response
FT> to the kernel. The former for the data block is with
FT> DMU_FLAG_LINKED and the latter is for the metadata block (usespace
FT> uses the above feature). The kernel performs two writes
FT> sequentially and then completes the original I/O (endio).

Given that we clear up how the above would work (or at least clear up
my understanding of it), then I think this would be a good way to
eliminate the DMU_FLAG_SYNC latency that we see now.

Thanks!

- --=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFy1DxwtEf7b4GJVQRAmVwAJ9rC4YPP0rpmmDCbI7HV8t09p4NLwCfa2lc
BT7qEWM2KcuM2+6jcS5jnAs=3D
=3D296t
-----END PGP SIGNATURE-----
