From: Eli Stair <estair@ilm.com>
Subject: Re: 2.6.18.1, ext3: attempt to access beyond end of device
Date: Tue, 24 Oct 2006 10:15:11 -0700
Message-ID: <453E4A1F.5030708@ilm.com>
References: <20061018074753.GT22487@skl-net.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061018074753.GT22487@skl-net.de>
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


You might want to also address the MD(ADM) list 
(linux-raid@vger.kernel.org) with this.  I was seeing similar issues 
with raid10 prior to reporting several other issues, which are now fixed 
in 2.5.5 of mdadm.  I haven't seen this error since.

Try replicating it after re-creating the array with mdadm-2.5.5, and 
showing the mdadm -D /dev/md{n} && mdadm /dev/md{n} -E /dev/$member_dev

Cheers,

/eli


Andre Noll wrote:
> Hi
> 
> While doing some stress tests on our raid system, we encountered the
> following:
> 
> [13933.173768] EXT3-fs error (device dm-0): ext3_new_block: Allocating 
> block in system zone - blocks from 192708608, length 1
> [13933.176790] Aborting journal on device dm-0.
> [13934.512464] ext3_abort called.
> [13934.514031] EXT3-fs error (device dm-0): ext3_journal_start_sb: 
> Detected aborted journal
> [13934.517537] Remounting filesystem read-only
> [13934.519438] EXT3-fs error (device dm-0): ext3_free_blocks: Freeing 
> blocks in system zones - Block = 192708608, count = 1
> [13934.524084] EXT3-fs error (device dm-0) in ext3_free_blocks_sb: 
> Journal has aborted
> [14585.157319] attempt to access beyond end of device
> [14585.159480] dm-1: rw=1, want=9592553968, limit=5292146688
> 
> [many of these with different "want" values]
> 
> [14586.072700] Buffer I/O error on device dm-1, logical block 1313832302
> [14586.076005] lost page write due to I/O error on dm-1
> [14586.079177] Aborting journal on device dm-1.
> [14586.082161] EXT3-fs error (device dm-1) in ext3_dirty_inode: IO failure
> [14586.102836] EXT3-fs error (device dm-1) in ext3_ordered_writepage: IO 
> failure
> [14586.226243] ext3_abort called.
> [14586.226249] EXT3-fs error (device dm-1) in ext3_ordered_commit_write: 
> IO failure
> [14586.227872] ext3_abort called.
> [14586.227875] EXT3-fs error (device dm-1): ext3_journal_start_sb: 
> Detected aborted journal
> [14586.227878] Remounting filesystem read-only
> [14586.247468] EXT3-fs error (device dm-1): ext3_journal_start_sb: 
> Detected aborted journal
> [14587.486480] __journal_remove_journal_head: freeing b_committed_data
> [14587.489821] __journal_remove_journal_head: freeing b_committed_data
> [58760.477871] EXT3-fs error (device dm-1): ext3_readdir: bad entry in 
> directory #2: rec_len % 4 != 0 - offset=0, inode=1753114490, 
> rec_len=19037, name_len=53
> [145152.943222] EXT3-fs error (device dm-1): ext3_readdir: bad entry in 
> directory #2: rec_len % 4 != 0 - offset=0, inode=1753114490, 
> rec_len=19037, name_len=53
> 
> Further info:
> 
> root@ubuntu:~# vgs
>   VG   #PV #LV #SN Attr   VSize VFree
>   vg     1   2   0 wz--n- 6.36T    0
> root@ubuntu:~# pvs
>   PV         VG   Fmt  Attr PSize PFree
>   /dev/md0   vg   lvm2 a-   6.36T    0
> root@ubuntu:~# lvs
>   LV       VG   Attr   LSize Origin Snap%  Move Log Copy%
>   ext3_lv1 vg   -wi-ao 3.90T                             
>   ext3_lv2 vg   -wi-ao 2.46T                             
> root@ubuntu:~# df -h /dev/vg/*
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/vg/ext3_lv1      3.9T  724G  3.0T  20% /mnt/lv1
> /dev/vg/ext3_lv2      2.5T  552G  1.8T  24% /mnt/lv2
> root@ubuntu:~# uname -a
> Linux ubuntu 2.6.18.1 #1 SMP Sun Oct 15 13:43:51 CDT 2006 ppc64 GNU/Linux
> root@ubuntu:~# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdb[0] sdq[15] sdp[14] sdo[13] sdn[12] sdm[11] 
> sdl[10] sdk[9] sdj[8] sdi[7] sdh[6] sdg[5] sdf[4] sde[3] sdd[2] sdc[1]
>       6833669248 blocks level 6, 64k chunk, algorithm 2 [16/16] 
> [UUUUUUUUUUUUUUUU]
> 
> Andre
> 
> --
> The only person who always got his work done by Friday was Robinson Crusoe
> 
> 
> ------------------------------------------------------------------------
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
