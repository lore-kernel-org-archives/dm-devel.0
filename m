From: syrius.ml@no-log.org
Subject: Re: dev kernels(bio change), evms_activate still
	produces oops
Date: Thu, 10 Feb 2005 01:39:50 +0100
Message-ID: <87d5v9b6nz.87bratb6nz@87acqdb6nz.message.id>
References: <87sm48dnh2.87r7jsdnh2@87pszcdnh2.message.id>
	<20050209231044.GA959@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
In-Reply-To: <20050209231044.GA959@osdl.org> (Dave Olien's message of "Wed,
	9 Feb 2005 15:10:44 -0800")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dave Olien <dmo@osdl.org>
Cc: evms-devel@lists.sourceforge.net, syrius.ml@no-log.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

--=-=-=

Dave Olien <dmo@osdl.org> writes:

You're right, I'm using raid5.
I can reproduce the oops here by creating a raid5 array (using evms in
my case) with kernel 2.6.10 (bio.c rev <= 1.71) then rebooting to
2.6.10-ac10 or 2.6.11-rc3-bk6 (bio.c rev >= 1.72)
(for information, a 2.6.11-rc3.bk5 + bio.c rev=1.71 doesn't produce
the oops)

> Sorry for being so slow.  Here's a patch that I believe will fix this oops.
> Please give this a try and let me know.  The problem is that when I
> coded up the new bio_clone() code, I made the bad assumption that the
> bio passed in would have been allocated from a bio_set.  In the case
> of raid5 and raid6, this isn't the case.  So, when raid5 passes one
> of its bio's into the dm code, and dm tries to bio_clone() it,
> bio_clone() dereferences a NULL pointer.
>
> As a quick fix, this patch changes bio_clone() to just use the global
> bio_set to allocate the new bio.  Problem is, this potentially sets
> up another bio exhaustion case.  I'm thinking there should maybe
> be a bio_clone_bioset() that accepts a bio_set pointer as an argument.
> That way, dm could for example pass in it's own bio_set to allocate
> from.
>
> But for now, here's the quick patch.  Please give it a try and give
> me the results.
>
>
> diff -ur linux-2.6.11-rc3-bk4-udm1/fs/bio.c linux-2.6.11-rc3-bk4-udm1-patch/fs/bio.c
> --- linux-2.6.11-rc3-bk4-udm1/fs/bio.c	2005-02-08 15:36:16.000000000 -0800
> +++ linux-2.6.11-rc3-bk4-udm1-patch/fs/bio.c	2005-02-09 14:56:39.000000000 -0800
> @@ -258,7 +258,7 @@
>   */
>  struct bio *bio_clone(struct bio *bio, int gfp_mask)
>  {
> -	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bio->bi_set);
> +	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);
>  
>  	if (b)
>  		__bio_clone(b, bio);

Unfortunatly that does not the trick.
It still oops. Here is the call trace from 2.6.11-rc3-bk6 +
dm-2.6.11-rc3-udm2:


--=-=-=
Content-Disposition: inline; filename=vmware-linux1.serial_out.txt

device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
md: md driver 0.90.1 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bind<dm-1>
md: bind<dm-2>
md: bind<dm-3>
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :   984.000 MB/sec
raid5: using function: pIII_sse (984.000 MB/sec)
md: raid5 personality registered as nr 4
raid5: device dm-3 operational as raid disk 2
raid5: device dm-2 operational as raid disk 1
raid5: device dm-1 operational as raid disk 0
raid5: allocated 3158kB for md0
raid5: raid level 5 set md0 active with 3 out of 3 devices, algorithm 0
RAID5 conf printout:
 --- rd:3 wd:3 fd:0
 disk 0, o:1, dev:dm-1
 disk 1, o:1, dev:dm-2
 disk 2, o:1, dev:dm-3
Unable to handle kernel NULL pointer dereference at virtual address 00000004
 printing eip:
c01fb879
*pde = 00000000
Oops: 0000 [#1]
PREEMPT 
Modules linked in: raid5 xor md ide_cd cdrom dm_mod
CPU:    0
EIP:    0060:[<c01fb879>]    Not tainted VLI
EFLAGS: 00010212   (2.6.11-rc3-bk6) 
EIP is at __make_request+0x29/0x4b0
eax: 00000000   ebx: d7c30758   ecx: 00000000   edx: d7781680
esi: d7c30758   edi: 00000000   ebp: d7bf379c   esp: d7bf376c
ds: 007b   es: 007b   ss: 0068
Process evms_activate (pid: 987, threadinfo=d7bf2000 task=d7bb3a60)
Stack: 00000000 00000000 d7bb3a60 c0127d80 0000003f d7bf379c 00000086 00000008 
       d7eeefc0 d7c30758 d7ee0040 d7bf37c8 d7bf3820 c01fc112 d7c30758 d7781680 
       d7c301b8 d7bf387c 00000000 d7bb3a60 c0127d80 d7bf37e0 d7bf37e0 00000010 
Call Trace:
 [<c0102ccf>] show_stack+0x7f/0xa0
 [<c0102e6a>] show_registers+0x15a/0x1c0
 [<c0103060>] die+0xf0/0x190
 [<c010ddcb>] do_page_fault+0x31b/0x670
 [<c010290b>] error_code+0x2b/0x30
 [<c01fc112>] generic_make_request+0x152/0x210
 [<d8812787>] __clone_and_map+0x287/0x2a0 [dm_mod]
 [<d881283b>] __split_bio+0x9b/0x120 [dm_mod]
 [<d881292f>] dm_request+0x6f/0xb0 [dm_mod]
 [<c01fc112>] generic_make_request+0x152/0x210
 [<d884fbeb>] handle_stripe+0x69b/0xe20 [raid5]
 [<d8850846>] make_request+0x216/0x340 [raid5]
 [<c01fc112>] generic_make_request+0x152/0x210
 [<d8812787>] __clone_and_map+0x287/0x2a0 [dm_mod]
 [<d881283b>] __split_bio+0x9b/0x120 [dm_mod]
 [<d881292f>] dm_request+0x6f/0xb0 [dm_mod]
 [<c01fc112>] generic_make_request+0x152/0x210
 [<c01fc230>] submit_bio+0x60/0x100
 [<c0153c85>] submit_bh+0xd5/0x130
 [<c0152c02>] block_read_full_page+0x182/0x2a0
 [<c0136fbb>] read_pages+0xeb/0x130
 [<c01370f8>] __do_page_cache_readahead+0xf8/0x180
 [<c0137315>] blockable_page_cache_readahead+0x35/0x70
 [<c0137587>] page_cache_readahead+0x237/0x2b0
 [<c01309b6>] do_generic_mapping_read+0x526/0x540
 [<c0130cb3>] __generic_file_aio_read+0x1e3/0x220
 [<c0130e06>] generic_file_read+0xa6/0xc0
 [<c014f3ad>] vfs_read+0x9d/0x120
 [<c014f67b>] sys_read+0x4b/0x80
 [<c0102763>] syscall_call+0x7/0xb
Code: 00 00 55 89 e5 57 31 ff 56 53 83 ec 24 8b 55 0c 8b 75 08 8b 02 89 45 e0 8b 42 1c c1 e8 09 89 45 ec 8b 4a 2c 0f b7 42 16 8d 04 40 <8b> 44 81 04 c1 e8 09 89 45 e8 8d 45 0c 8b 5a 10 89 44 24 04 89 
 

--=-=-=


Thanks

-- 

--=-=-=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--=-=-=--
