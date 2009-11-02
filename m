From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ext3 sequential read performance drop 2.6.29 ->
 2.6.30,2.6.31,...
Date: Mon, 2 Nov 2009 13:55:54 -0800
Message-ID: <20091102135554.b10ece3e.akpm@linux-foundation.org>
References: <20091013120955.6bd5844b@smartjog.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091013120955.6bd5844b@smartjog.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Laurent CORBES <laurent.corbes@smartjog.com>
Cc: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, 13 Oct 2009 12:09:55 +0200
Laurent CORBES <laurent.corbes@smartjog.com> wrote:

> Hi all,
> 
> While benchmarking some systems I discover a big sequential read performance
> drop using ext3 on ~ big files. The drop seems to be introduced in 2.6.30. I'm
> testing with 2.6.28.6 -> 2.6.29.6 -> 2.6.30.4 -> 2.6.31.3.

Seems that large performance regressions aren't of interest to this
list :(

> I'm running a software raid6 (chunk 256k) on 6 750Go 7200rpm disks. here are
> the raw datas of disks and raid device:
> 
> $ dd if=/dev/sda of=/dev/null bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 98.7483 seconds, 109 MB/s
> 
> $ dd if=/dev/md7 of=/dev/null bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 34.8744 seconds, 308 MB/s
> 
> Over the different kernels changes here are not important (~1MB on the raw disk
> and ~5MB on the raid device). The write of a 10GB file over the fs here is also
> almost constant at ~100MB/s.
> 
> $ dd if=/dev/zero of=/mnt/space/benchtmp//dd.out bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 102.547 seconds, 105 MB/s
> 
> However while reading this file there is a huge perf drop between 2.6.29.6 and
> 2.6.30.4 and 2.6.31.3:
> 
> 2.6.28.6:
> sj-dev-7:/mnt/space/Benchmark# dd if=dd.out of=/dev/null bs=1M
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 43.8288 seconds, 245 MB/s
> 
> 2.6.29.6:
> sj-dev-7:/mnt/space/Benchmark# dd if=dd.out of=/dev/null bs=1M
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 42.745 seconds, 251 MB/s
> 
> 2.6.30.4:
> $ dd if=/mnt/space/benchtmp//dd.out of=/dev/null bs=1M
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 48.621 seconds, 221 MB/s
> 
> 2.6.31.3:
> sj-dev-7:/mnt/space/Benchmark# dd if=dd.out of=/dev/null bs=1M
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 51.4148 seconds, 209 MB/s
> 
> ... Things going worst over time ...

Did you do any further investigation?  Do you think the regression is
due to MD changes, or to something else?


Thanks.

> Numbers are average over ~10 runs each.
> 
> I first check for stripe/stride aligment of the ext3 fs that is quite important
> in raid6. I recheck it and everything seems fine from my understandings and
> formula:
> raid6 chunk 256k -> stride = 64. 4 data disks -> stripe-width = 256 ?
> 
> In both case I'm using cfq IO scheduler and no special tuning is done with it.
> 
> 
> For informations the test server is a Dell PowerEdge R710 with SAS 6iR, 4GB
> ram and 6*750GB sata disks. I got the same behavior on PE2950 Perc6i, 2GB
> ram and 6*750GB sata disks. 
> 
> Here are misc informations about the setup:
> sj-dev-7:/mnt/space/Benchmark# cat /proc/mdstat 
> md7 : active raid6 sdf7[5] sde7[4] sdd7[3] sdc7[2] sdb7[1] sda7[0]
>       2923443200 blocks level 6, 256k chunk, algorithm 2 [6/6] [UUUUUU]
>       bitmap: 0/175 pages [0KB], 2048KB chunk
> 
> sj-dev-7:/mnt/space/Benchmark# dumpe2fs -h /dev/md7
> dumpe2fs 1.40-WIP (14-Nov-2006)
> Filesystem volume name:   <none>
> Last mounted on:          <not available>
> Filesystem UUID:          9c29f236-e4f2-4db4-bf48-ea613cd0ebad
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal resize_inode dir_index filetype
> needs_recovery sparse_super large_file Filesystem flags:         signed
> directory hash Default mount options:    (none)
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              713760
> Block count:              730860800
> Reserved block count:     0
> Free blocks:              705211695
> Free inodes:              713655
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      849
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         32
> Inode blocks per group:   1
> Filesystem created:       Thu Oct  1 15:45:01 2009
> Last mount time:          Mon Oct 12 13:17:45 2009
> Last write time:          Mon Oct 12 13:17:45 2009
> Mount count:              10
> Maximum mount count:      30
> Last checked:             Thu Oct  1 15:45:01 2009
> Check interval:           15552000 (6 months)
> Next check after:         Tue Mar 30 15:45:01 2010
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               128
> Journal inode:            8
> Default directory hash:   tea
> Directory Hash Seed:      378d4fd2-23c9-487c-b635-5601585f0da7
> Journal backup:           inode blocks
> Journal size:             128M
> 
> 
> Thanks all.
> 
> -- 
> Laurent Corbes - laurent.corbes@smartjog.com
> SmartJog SAS | Phone: +33 1 5868 6225 | Fax: +33 1 5868 6255 | www.smartjog.com
> 27 Blvd Hippolyte Marqu__s, 94200 Ivry-sur-Seine, France
> A TDF Group company
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
