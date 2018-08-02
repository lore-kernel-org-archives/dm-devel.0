From: WGH <wgh@torlan.ru>
Subject: LVM snapshot broke between 4.14 and 4.16
Date: Thu, 2 Aug 2018 18:10:54 +0300
Message-ID: <93bff248-6897-4867-841b-2dace11597de@torlan.ru>
References: <226835ba-2197-b850-6e5b-8ba14f7fd016@torlan.ru>
 <CAOi1vP_tYG77e71CdDiOcszSSEWrp9Vfi+KB7yFAXVQChkjP5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOi1vP_tYG77e71CdDiOcszSSEWrp9Vfi+KB7yFAXVQChkjP5A@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, linux-kernel@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 08/02/2018 04:31 PM, Ilya Dryomov wrote:
> On Thu, Aug 2, 2018 at 2:26 PM WGH <wgh@torlan.ru> wrote:
>> (I originally reported this problem here:
>> https://bugzilla.kernel.org/show_bug.cgi?id=200439)
>>
>> When I updated from 4.14 to 4.16, my LVM snapshotting script broke for
>> no apparent reason.
>>
>> My script has the following line, and it fails like this:
>> + lvcreate --size 5G --snapshot --name snap0 --permission r
>> /dev/mapper/vg0-lvol_rootfs
>>   device-mapper: create ioctl on
>> vg0-snap0-cowLVM-sDdIeh9cecWdaNyRfZC31mxgfwTa4sOeHMJXVOykGVRtfP6Aii7IHvwS066AOLOM-cow
>> failed: Device or resource busy
>>   Failed to lock logical volume vg0/lvol_rootfs.
>>   Aborting. Manual intervention required.
>>
>> At the same time, some errors appear in dmesg as well:
>> [   26.145279] generic_make_request: Trying to write to read-only
>> block-device dm-3 (partno 0)
>> [   26.145288] device-mapper: persistent snapshot: write_header failed
>> [   26.145847] device-mapper: table: 253:4: snapshot: Failed to read
>> snapshot metadata
>> [   26.145851] device-mapper: ioctl: error adding target to table
>>
>> I bisected the vanilla kernel, and the first bad commit is
>> [721c7fc701c71f693307d274d2b346a1ecd4a534] block: fail op_is_write()
>> requests to read-only partitions
> Adding Mike and dm-devel.
>
> From a quick look, --permission r sets DM_READONLY_FLAG, which makes dm
> mark the disk read-only with set_disk_ro(dm_disk(md), 1) in do_resume().
> A bit later it tries to write to the disk from write_header():
>
>   return chunk_io(ps, ps->header_area, 0, REQ_OP_WRITE, 0, 1);
>
> Thanks,
>
>                 Ilya

After further investigation, this was fixed on lvm2 side (userspace) in
https://sourceware.org/git/?p=lvm2.git;a=commit;h=a6fdb9d9d70f51c49ad11a87ab4243344e6701a3
(snapshot: keep COW writable for read-only volumes).

So I guess that's it. Time to poke my distribution package maintainers
to bump the package version.
