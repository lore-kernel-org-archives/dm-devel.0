From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Shared snapshot tests
Date: Tue, 20 Apr 2010 02:58:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1004200207170.24170@hs20-bc2-1.build.redhat.com>
References: <20100415182356.GN13021@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100415182356.GN13021@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Daire Byrne <daire.byrne@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi!

Thanks for testing shared snapshots.

> Date: Thu, 15 Apr 2010 19:06:19 +0100
> From: Daire Byrne <daire.byrne@gmail.com>
> Subject: [dm-devel] Shared snapshot tests
> To: dm-devel@redhat.com
> 
> Hi,
> 
> I had some spare RAID hardware lying around and thought I'd give the
> new shared snapshots code a whirl. Maybe the results are of interest
> so I'm posting them here. I used the "r18" version of the code with
> 2.6.33 and patched lvm2-2.02.54.
> 
> Steps to create test environment:
> 
>   # pvcreate /dev/sdb
>   # vgcreate test_vg /dev/sdb
>   # lvcreate -L 1TB test_vg -n test_lv
>   # mkfs.xfs /dev/test_vg/test_lv
>   # mount /dev/test_vg/test_lv /mnt/images/
> 
>   # lvcreate -L 2TB -c 256 --sharedstore mikulas -s /dev/test_vg/test_lv
>   # lvcreate -s -n test_lv_ss1 /dev/test_vg/test_lv
>   # dd if=/dev/zero of=/mnt/images/dd-file bs=1M count=102400
>   # dd of=/dev/null if=/mnt/images/dd-file bs=1M count=102400
> 
> Raw speeds of the "test_lv" xfs formatted volume without any shared
> snapshot space allocated was 308 MB/s writes and 214 MB/s reads. I
> have done no further tuning.
> 
> No. snaps |  type  | chunk | writes  |  reads
> ----------------------------------------------
>         0   mikulas     4k    225MB/s   127MB/s
>         1   mikulas     4k     18MB/s   128MB/s
>         2   mikulas     4k     11MB/s   128MB/s
>         3   mikulas     4k     11MB/s   127MB/s
>         4   mikulas     4k     10MB/s   127MB/s
>        10   mikulas     4k      9MB/s   127MB/s
> 
>         0   mikulas     256k  242MB/s   129MB/s
>         1   mikulas     256k   38MB/s   130MB/s
>         2   mikulas     256k   37MB/s   131MB/s
>         3   mikulas     256k   36MB/s   132MB/s
>         4   mikulas     256k   33MB/s   129MB/s
>        10   mikulas     256k   31MB/s   128MB/s
> 
>         1   normal      256k   45MB/s   127MB/s
>         2   normal      256k   18MB/s   128MB/s
>         3   normal      256k   11MB/s   127MB/s
>         4   normal      256k    8MB/s   124MB/s
>        10   normal      256k    3MB/s   126MB/s
> 
> I wanted to test the "daniel" store but I got "multisnapshot:
> Unsupported chunk size" with everything except a chunksize of "16k".
> Even then the store was created but reported that it was 100% full.
> Nevertheless I created a few snapshots but performance didn't seem
> much different. I have not included the results as I could only use a
> chunksize of 16k. Also when removing the snapshots I got some kmalloc
> nastiness (needed to reboot). I think the daniel store is a bit
> broken.

Yes, daniel store is unmaintained. It doesn't report used space, it 
supports only 16k chunksize (the code seems to be written to handle 
generic chunk sizes, but who knows what would happen if we allowed 
arbitrary sizes?)

What kmalloc error did you get?

The daniel store is there only to make sure that the generic code could 
handle different exception stores.

> Observations/questions:
> 
>   (1) why does performance drop when you create the shared snapshot
> space but not create any actual snapshots and there is no COW being
> done? The kmultisnapd eats CPU...

kmultisnapd wakes up on writes, just to find out that there is no snapshot 
to write to. Maybe it would make sense to short-cirtcuit processing if 
there is no snapshots.

>   (2) similarly why does the read performance change at all
> (214->127MB/s). There is no COW overhead. This is the case for both
> the old snapshots and the new shared ones.

I am thinking that it could be because I/Os (including reads) are split at 
chunk size boundary. But then, it would be dependent on chunk size --- and 
it isn't.

Try this:
Don't use snapshots and load plain origin target manually with dmsetup:
dmsetup create origin --table "0 `blockdev --getsize /dev/sda1` snapshot-origin /dev/sda1"
(replace /dev/sda1 with the real device)
Now, /dev/mapper/origin and /dev/sda1 contain identical data.
Can you see 214->127MB/s read performance drop in /dev/mapper/origin?

Compare /sys/block/dm-X/queue content for the device if no snapshot is 
loaded and if some snapshot is loaded. Is there a difference? What if you 
manually set the values to be the same? (i.e. tweak max_sectors_kb or 
others)

>   (3) when writing why does it write data to the origin quickly in
> short bursts (buffer?) but then effectively stall while the COW
> read/write occurs? Why can you not write to the filesystem
> asynchronously while the COW is happening? This is the same for the
> normal/old snapshots too so I guess it is just an inherent limitation
> to ensure consistency?

The snapshots (both shared and non-shared) hold writes if there are more 
writes to do. If there are no more writes, the metadata state is committed 
and all the writes are dispatched to the origin.

The reason is to make as few commits as possible. If we committed after a 
few writes, these commits would slow things down.

Would it make sense to limit this write-holding? I think no, because it 
wouldn't improve i/o latency. It would just make i/o latency less 
variable. Can you think of an application where high i/o latency doesn't 
matter and variable i/o latency does matter?

>   (4) why is there a small (but appreciable) drop in writes as the
> number of snapshots increase? It should only have to do a single COW
> in all cases no?

Yes, it does just one cow and it uses ranges, so the data structures have 
no overhead for multiple snapshots.

Did you recreate the environment from scratch? (both the filesystem and 
the whole snapshot shared store)

The shared snapshot store writes continuously forward and if you didn't 
recreate it, it may be just increasing disk seek times as it moves to the 
device end.

A filesystem may be also writing to different places, so you'd better 
recreate it too.

>   (5) It takes a really long time (hours) to create a few TB worth of
> shared snapshot space when using 4k chunks. Seems much better with
> 256k. The old snapshots create almost instantly.

I may tune buffering. But 4k chunk size is supposed to be slow anyway. It 
writes bitmaps, with one bit for every 4k chunk.

Another reason may be that the RAID hardware can't cache small writes (if 
it's raid 4/5) and does read-modify-write for every 4k write.

(btw. it also supports 512-byte chunk size, but I use it only for stress 
testing. It is slow!)

> All in all it looks very interesting and is currently the best way of
> implementing shared snapshots for filesystems which don't have native
> support for it (e.g. btrfs). I found the zumastor stuff to be rather
> slow, buggy and difficult to operate in comparison.
> 
> The performance seem to be on par with with the normal/old snapshots
> and much much better once you increase the number of snapshots. If
> only the snapshot performance could be better overall (old and multi)
> - perhaps there are some further tweaks and tunings I could do?
> 
> Regards,
> 
> Daire

Mikulas
