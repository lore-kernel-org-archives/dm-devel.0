From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: A thin-p over 256 GiB fails with I/O errors with
 non-power-of-two chunk
Date: Tue, 22 Jan 2013 12:10:20 +0100
Message-ID: <50FE739C.5090200@redhat.com>
References: <201301180219.10467.db@kavod.com>
	<20130121184954.GA18892@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130121184954.GA18892@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: sandeen@redhat.com, Daniel Browning <db@kavod.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Dne 21.1.2013 19:49, Mike Snitzer napsal(a):
> On Fri, Jan 18 2013 at  5:19am -0500,
> Daniel Browning <db@kavod.com> wrote:
>
>> Why do I get the following error, and what should I do about it? When I
>> create a raid0 md with a non-power-of-two chunk size (e.g. 1152K instead of
>> 512K), then create a thinly-provisioned volume that is over 256 GiB, I get
>> the following dmesg error when I try to create a file system on it:
>>
>>      "make_request bug: can't convert block across chunks or bigger than 1152k 4384 127"
>>
>> This bubbles up to mkfs.xfs as
>>
>>      "libxfs_device_zero write failed: Input/output error"
>>
>> What I find interesting is that it seems to require all three conditions
>> (chunk size, thin-p, and >256 GiB) in order to fail. Without those, it seems
>> to work fine:
>>
>>      * Power-of-two chunk (e.g. 512K), thin-p vol, >256 GiB? Works.
>>      * Non-power-of-two chunk (e.g. 1152K), thin-p vol, <256 GiB? Works.
>>      * Non-power-of-two chunk (e.g. 1152K), regular vol, >256 GiB? Works.
>>      * Non-power-of-two chunk (e.g. 1152K), thin-p vol, >256 GiB? FAIL.
>>
>> Attached is a self-contained test case to reproduce the error, version
>> numbers, and an strace. Thank you in advance,
>> --
>> Daniel Browning
>> Kavod Technologies
>>
>> Appendix A. Self-contained reproduce script
>> ===========================================================
>> dd if=/dev/zero of=loop0.img bs=1G count=150; losetup /dev/loop0 loop0.img
>> dd if=/dev/zero of=loop1.img bs=1G count=150; losetup /dev/loop1 loop1.img
>> mdadm --create /dev/md99 --verbose --level=0 --raid-devices=2 \
>>        --chunk=1152K /dev/loop0 /dev/loop1
>> pvcreate /dev/md99
>> vgcreate test_vg /dev/md99
>> lvcreate --size 257G --type thin-pool --thinpool test_thin_pool test_vg
>> lvcreate --virtualsize 257G --thin test_vg/test_thin_pool --name test_lv
>> mkfs.xfs /dev/test_vg/test_lv
>>
>> # That is where the error occurs. Next is cleanup.
>> lvremove -f /dev/test_vg/test_lv
>> lvremove -f /dev/mapper/test_vg-test_thin_pool
>> vgremove -f test_vg
>> pvremove /dev/md99
>> mdadm --stop /dev/md99
>> mdadm --zero-superblock /dev/loop0 /dev/loop1
>> losetup -d /dev/loop0 /dev/loop1
>> rm loop*.img
>
> Limits of the raid0 device (/dev/md99):
> cat /sys/block/md99/queue/minimum_io_size
> 1179648
> cat /sys/block/md99/queue/optimal_io_size
> 2359296
>
> Limits of the thin-pool device (/dev/test_vg/test_thin_pool):
> cat /sys/block/dm-9/queue/minimum_io_size
> 512
> cat /sys/block/dm-9/queue/optimal_io_size
> 262144
>
> Limits of the thin-device device (/dev/test_vg/test_lv):
> cat /sys/block/dm-10/queue/minimum_io_size
> 512
> cat /sys/block/dm-10/queue/optimal_io_size
> 262144
>
> I notice that lvcreate is not using a thin-pool chunksize that matches
> the raid0's chunksize (just uses the lvm2 default of 256K).
>
> Switching the thin-pool lvcreate to use --chunksize 1152K at least
> enables me to format the filesystem.
>
> And both the thin-pool and thin device have an optimal_io_size that
> matches the chunk_size of the underlying raid volume:
>
> cat /sys/block/dm-9/queue/optimal_io_size
> 1179648
> cat /sys/block/dm-10/queue/optimal_io_size
> 1179648
>
> I'm still investigating the limits issue when --chunksize 1152K isn't
> used for the thin-pool lvcreate.

Just a comment for the selection of thin chunksize here -

I think it has couple aspects here - by default (unless changed via
lvm.conf {allocation/thin_pool_chunk_size}) it is targeting for 64K
and scales chunksize up to fit thin metadata within 128MB.
(compiled in as DEFAULT_THIN_POOL_OPTIMAL_SIZE)
So lvm2 here scaled from 64k to 256k in multiTB case.

lvcreate currently doesn't look out for geometry of underlying PV(s) during 
its allocation (somewhat chicken-egg problem) - yet there are possible ways to 
try to put this into equation - thought it might not be actually wanted by the 
user - since for snapshots the smaller chunksize is more usable
(>1MB is quite a lot here IMHO) - but it probably worth some thinking.

Zdenek
