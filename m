From: Teng-Feng Yang <shinrairis@gmail.com>
Subject: Performance issue when building thin-pool on top of
	RAID6 device
Date: Tue, 18 Feb 2014 17:13:26 +0800
Message-ID: <CAKTMprP3KeSQ+VbBO2q6gQa5UWawcKqKisbC-4EGrPfuk1bViQ@mail.gmail.com>
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

Dear all,

I have been working on tuning the dm-thin performance on my storage server.
I surprisingly find out that the write performance of newly created
thin volume formatted as EXT4 has degraded significantly, when
building thin-pool on top of RAID6 device.
Thin pools in all experiment use 1MB block size, and I format all
target volumes as EXT4 and mount them on /mnt.
The following is the performance statistics I gather under different
circumstances.

Thin volume on top of a thin pool created by a Plextor M5P 128GB SSD
as metadata device
and a RAID6 block device composed by 7 disks (chunk size = 512KB) as a
data device
dennis@desktop:~$ sudo dd if=/dev/zero of=/mnt/zero.img bs=1M count=25000
25000+0 records in
25000+0 records out
26214400000 bytes (26 GB) copied, 245.808 s, 107 MB/s

Directly make filesystem on RAID6 block device composed by 7 disks
dennis@desktop:~$ sudo dd if=/dev/zero of=/mnt/zero.img bs=1M count=25000
25000+0 records in
25000+0 records out
26214400000 bytes (26 GB) copied, 129.543 s, 202 MB/s

Thin volume on top of a thin pool created by a Plextor M5P 128GB SSD
as metadata device
and a RAID0 block device composed by 7 disks as a data device
dennis@desktop:~$ sudo dd if=/dev/zero of=/mnt/zero.img bs=1M count=25000
25000+0 records in
25000+0 records out
26214400000 bytes (26 GB) copied, 46.1227 s, 568 MB/s

Directly make filesystem on RAID6 block device composed by 7 disks
dennis@desktop:~$ sudo dd if=/dev/zero of=/mnt/zero.img bs=1M count=25000
25000+0 records in
25000+0 records out
26214400000 bytes (26 GB) copied, 48.1104 s, 545 MB/s

It is clear that the write performance has degraded significantly when
we use RAID6 as thin-pool,
but there is no similar behavior when using RAID0 as thin-pool instead.
I dig a little deeper on this issue and find that if we can perfectly
fit a pool block into a RAID6 stripe,
there would be only 20~30% performance loss comparing to RAW RAID6.
However, this poses a restriction on the disks number we can use to
build a RAID6 for pool, and limit the maximum pool size as well.
Is there any other way I can do to improve the write performance when
using RAID6 as pool?

Any help would be grateful.
Thanks

Dennis
