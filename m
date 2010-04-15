From: Daire Byrne <daire.byrne@gmail.com>
Subject: Shared snapshot tests
Date: Thu, 15 Apr 2010 19:06:19 +0100
Message-ID: <y2h131780341004151106k584e905fv5b659d4f9fd2366a@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi,

I had some spare RAID hardware lying around and thought I'd give the
new shared snapshots code a whirl. Maybe the results are of interest
so I'm posting them here. I used the "r18" version of the code with
2.6.33 and patched lvm2-2.02.54.

Steps to create test environment:

  # pvcreate /dev/sdb
  # vgcreate test_vg /dev/sdb
  # lvcreate -L 1TB test_vg -n test_lv
  # mkfs.xfs /dev/test_vg/test_lv
  # mount /dev/test_vg/test_lv /mnt/images/

  # lvcreate -L 2TB -c 256 --sharedstore mikulas -s /dev/test_vg/test_lv
  # lvcreate -s -n test_lv_ss1 /dev/test_vg/test_lv
  # dd if=/dev/zero of=/mnt/images/dd-file bs=1M count=102400
  # dd of=/dev/null if=/mnt/images/dd-file bs=1M count=102400

Raw speeds of the "test_lv" xfs formatted volume without any shared
snapshot space allocated was 308 MB/s writes and 214 MB/s reads. I
have done no further tuning.

No. snaps |  type  | chunk | writes  |  reads
----------------------------------------------
        0   mikulas     4k    225MB/s   127MB/s
        1   mikulas     4k     18MB/s   128MB/s
        2   mikulas     4k     11MB/s   128MB/s
        3   mikulas     4k     11MB/s   127MB/s
        4   mikulas     4k     10MB/s   127MB/s
       10   mikulas     4k      9MB/s   127MB/s

        0   mikulas     256k  242MB/s   129MB/s
        1   mikulas     256k   38MB/s   130MB/s
        2   mikulas     256k   37MB/s   131MB/s
        3   mikulas     256k   36MB/s   132MB/s
        4   mikulas     256k   33MB/s   129MB/s
       10   mikulas     256k   31MB/s   128MB/s

        1   normal      256k   45MB/s   127MB/s
        2   normal      256k   18MB/s   128MB/s
        3   normal      256k   11MB/s   127MB/s
        4   normal      256k    8MB/s   124MB/s
       10   normal      256k    3MB/s   126MB/s

I wanted to test the "daniel" store but I got "multisnapshot:
Unsupported chunk size" with everything except a chunksize of "16k".
Even then the store was created but reported that it was 100% full.
Nevertheless I created a few snapshots but performance didn't seem
much different. I have not included the results as I could only use a
chunksize of 16k. Also when removing the snapshots I got some kmalloc
nastiness (needed to reboot). I think the daniel store is a bit
broken.

Observations/questions:

  (1) why does performance drop when you create the shared snapshot
space but not create any actual snapshots and there is no COW being
done? The kmultisnapd eats CPU...
  (2) similarly why does the read performance change at all
(214->127MB/s). There is no COW overhead. This is the case for both
the old snapshots and the new shared ones.
  (3) when writing why does it write data to the origin quickly in
short bursts (buffer?) but then effectively stall while the COW
read/write occurs? Why can you not write to the filesystem
asynchronously while the COW is happening? This is the same for the
normal/old snapshots too so I guess it is just an inherent limitation
to ensure consistency?
  (4) why is there a small (but appreciable) drop in writes as the
number of snapshots increase? It should only have to do a single COW
in all cases no?
  (5) It takes a really long time (hours) to create a few TB worth of
shared snapshot space when using 4k chunks. Seems much better with
256k. The old snapshots create almost instantly.

All in all it looks very interesting and is currently the best way of
implementing shared snapshots for filesystems which don't have native
support for it (e.g. btrfs). I found the zumastor stuff to be rather
slow, buggy and difficult to operate in comparison.

The performance seem to be on par with with the normal/old snapshots
and much much better once you increase the number of snapshots. If
only the snapshot performance could be better overall (old and multi)
- perhaps there are some further tweaks and tunings I could do?

Regards,

Daire
