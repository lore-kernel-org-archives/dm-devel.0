From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Tue, 2 Jun 2015 13:59:06 -0700
Message-ID: <CAF1ivSY_7M1OhrMuXg0OKu7BPy=SbTHSHCk+2q6vfEVgvJL8YA@mail.gmail.com>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-2-git-send-email-mlin@kernel.org>
	<20150526143626.GA4315@redhat.com>
	<CAF1ivSb3ptYObS3_8bJwWhq98EcNgAgRhN_L-c3uyFfCzdn=9A@mail.gmail.com>
	<20150526160400.GB4715@redhat.com>
	<CAF1ivSZ351yV4re1Ghf5yqPjgq6aXjrZT4yWd+T9msAFsBnDSw@mail.gmail.com>
	<20150528003627.GD32216@agk-dp.fab.redhat.com>
	<1433138551.11778.4.camel@hasee>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <1433138551.11778.4.camel@hasee>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, Philip Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joshua Morris <josh.h.morris-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On Sun, May 31, 2015 at 11:02 PM, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, 2015-05-28 at 01:36 +0100, Alasdair G Kergon wrote:
>> On Wed, May 27, 2015 at 04:42:44PM -0700, Ming Lin wrote:
>> > Here are fio results of XFS on a DM stripped target with 2 SSDs + 1 HDD.
>> > Does it make sense?
>>
>> To stripe across devices with different characteristics?
>>
>> Some suggestions.
>>
>> Prepare 3 kernels.
>>   O - Old kernel.
>>   M - Old kernel with merge_bvec_fn disabled.
>>   N - New kernel.
>>
>> You're trying to search for counter-examples to the hypothesis that
>> "Kernel N always outperforms Kernel O".  Then if you find any, trying
>> to show either that the performance impediment is small enough that
>> it doesn't matter or that the cases are sufficiently rare or obscure
>> that they may be ignored because of the greater benefits of N in much more
>> common cases.
>>
>> (1) You're looking to set up configurations where kernel O performs noticeably
>> better than M.  Then you're comparing the performance of O and N in those
>> situations.
>>
>> (2) You're looking at other sensible configurations where O and M have
>> similar performance, and comparing that with the performance of N.
>
> I didn't find case (1).
>
> But the important thing for this series is to simplify block layer
> based on immutable biovecs. I don't expect performance improvement.
>
> Here is the changes statistics.
>
> "68 files changed, 336 insertions(+), 1331 deletions(-)"
>
> I run below 3 test cases to make sure it didn't bring any regressions.
> Test environment: 2 NVMe drives on 2 sockets server.
> Each case run for 30 minutes.
>
> 2) btrfs radi0
>
> mkfs.btrfs -f -d raid0 /dev/nvme0n1 /dev/nvme1n1
> mount /dev/nvme0n1 /mnt
>
> Then run 8K read.
>
> [global]
> ioengine=libaio
> iodepth=64
> direct=1
> runtime=1800
> time_based
> group_reporting
> numjobs=4
> rw=read
>
> [job1]
> bs=8K
> directory=/mnt
> size=1G
>
> 2) ext4 on MD raid5
>
> mdadm --create /dev/md0 --level=5 --raid-devices=2 /dev/nvme0n1 /dev/nvme1n1
> mkfs.ext4 /dev/md0
> mount /dev/md0 /mnt
>
> fio script same as btrfs test
>
> 3) xfs on DM stripped target
>
> pvcreate /dev/nvme0n1 /dev/nvme1n1
> vgcreate striped_vol_group /dev/nvme0n1 /dev/nvme1n1
> lvcreate -i2 -I4 -L250G -nstriped_logical_volume striped_vol_group
> mkfs.xfs -f /dev/striped_vol_group/striped_logical_volume
> mount /dev/striped_vol_group/striped_logical_volume /mnt
>
> fio script same as btrfs test
>
> ------
>
> Results:
>
>         4.1-rc4         4.1-rc4-patched
> btrfs   1818.6MB/s      1874.1MB/s
> ext4    717307KB/s      714030KB/s
> xfs     1396.6MB/s      1398.6MB/s

Hi Alasdair & Mike,

Would you like these numbers?
I'd like to address your concerns to move forward.

Thanks.
