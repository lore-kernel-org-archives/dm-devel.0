From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Wed, 27 May 2015 16:42:44 -0700
Message-ID: <CAF1ivSZ351yV4re1Ghf5yqPjgq6aXjrZT4yWd+T9msAFsBnDSw@mail.gmail.com>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-2-git-send-email-mlin@kernel.org>
	<20150526143626.GA4315@redhat.com>
	<CAF1ivSb3ptYObS3_8bJwWhq98EcNgAgRhN_L-c3uyFfCzdn=9A@mail.gmail.com>
	<20150526160400.GB4715@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20150526160400.GB4715-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, Philip Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joshua Morris <josh.h.morris-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On Tue, May 26, 2015 at 9:04 AM, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, May 26 2015 at 11:02am -0400,
> Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>> On Tue, May 26, 2015 at 7:36 AM, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Fri, May 22 2015 at  2:18pm -0400,
>> > Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> >
>> >> From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>
>> >> The way the block layer is currently written, it goes to great lengths
>> >> to avoid having to split bios; upper layer code (such as bio_add_page())
>> >> checks what the underlying device can handle and tries to always create
>> >> bios that don't need to be split.
>> >>
>> >> But this approach becomes unwieldy and eventually breaks down with
>> >> stacked devices and devices with dynamic limits, and it adds a lot of
>> >> complexity. If the block layer could split bios as needed, we could
>> >> eliminate a lot of complexity elsewhere - particularly in stacked
>> >> drivers. Code that creates bios can then create whatever size bios are
>> >> convenient, and more importantly stacked drivers don't have to deal with
>> >> both their own bio size limitations and the limitations of the
>> >> (potentially multiple) devices underneath them.  In the future this will
>> >> let us delete merge_bvec_fn and a bunch of other code.
>> >
>> > This series doesn't take any steps to train upper layers
>> > (e.g. filesystems) to size their bios larger (which is defined as
>> > "whatever size bios are convenient" above).
>> >
>> > bio_add_page(), and merge_bvec_fn, served as the means for upper layers
>> > (and direct IO) to build up optimally sized bios.  Without a replacement
>> > (that I can see anyway) how is this patchset making forward progress
>> > (getting Acks, etc)!?
>> >
>> > I like the idea of reduced complexity associated with these late bio
>> > splitting changes I'm just not seeing how this is ready given there are
>> > no upper layer changes that speak to building larger bios..
>> >
>> > What am I missing?
>>
>> See: [PATCH v4 02/11] block: simplify bio_add_page()
>> https://lkml.org/lkml/2015/5/22/754
>>
>> Now bio_add_page() can build lager bios.
>> And blk_queue_split() can split the bios in ->make_request() if needed.
>
> That'll result in quite large bios and always needing splitting.
>
> As Alasdair asked: please provide some performance data that justifies
> these changes.  E.g use a setup like: XFS on a DM striped target.  We
> can iterate on more complex setups once we have established some basic
> tests.

Here are fio results of XFS on a DM stripped target with 2 SSDs + 1 HDD.
Does it make sense?

                                         4.1-rc4                 4.1-rc4-patched
                                         ------------------
-----------------------
                                          (KB/s)                 (KB/s)
sequential-read-buf:            150822                 151371
sequential-read-direct:         408938                 421940
random-read-buf:                3404.9                  3389.1
random-read-direct:             4859.8                 4843.5
sequential-write-buf:            333455                 335776
sequential-write-direct:        44739                   43194
random-write-buf:                7272.1                 7209.6
random-write-direct:             4333.9                 4330.7



root@minggr:~/tmp/test# cat t.job
[global]
size=1G
directory=/mnt/
numjobs=8
group_reporting
runtime=300
time_based
bs=8k
ioengine=libaio
iodepth=64

[sequential-read-buf]
rw=read

[sequential-read-direct]
rw=read
direct=1

[random-read-buf]
rw=randread

[random-read-direct]
rw=randread
direct=1

[sequential-write-buf]
rw=write

[sequential-write-direct]
rw=write
direct=1

[random-write-buf]
rw=randwrite

[random-write-direct]
rw=randwrite
direct=1


root@minggr:~/tmp/test# cat run.sh
#!/bin/bash

jobs="sequential-read-buf sequential-read-direct random-read-buf
random-read-direct"
jobs="$jobs sequential-write-buf sequential-write-direct
random-write-buf random-write-direct"

#each partition is 100G
pvcreate /dev/sdb3 /dev/nvme0n1p1 /dev/sdc6
vgcreate striped_vol_group /dev/sdb3 /dev/nvme0n1p1 /dev/sdc6
lvcreate -i3 -I4 -L250G -nstriped_logical_volume striped_vol_group

for job in $jobs ; do
        umount /mnt > /dev/null 2>&1
        mkfs.xfs -f /dev/striped_vol_group/striped_logical_volume
        mount /dev/striped_vol_group/striped_logical_volume /mnt

        fio --output=${job}.log --section=${job} t.job
done
