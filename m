From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Wed, 10 Jun 2015 14:20:37 -0700
Message-ID: <CAF1ivSbo456n+1JxDp7eAHAgKs5qBOcomN4N9hhCEXmy8i4nPQ@mail.gmail.com>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-2-git-send-email-mlin@kernel.org>
	<20150526143626.GA4315@redhat.com>
	<CAF1ivSb3ptYObS3_8bJwWhq98EcNgAgRhN_L-c3uyFfCzdn=9A@mail.gmail.com>
	<20150526160400.GB4715@redhat.com>
	<CAF1ivSZ351yV4re1Ghf5yqPjgq6aXjrZT4yWd+T9msAFsBnDSw@mail.gmail.com>
	<20150528003627.GD32216@agk-dp.fab.redhat.com>
	<1433138551.11778.4.camel@hasee>
	<CAF1ivSY_7M1OhrMuXg0OKu7BPy=SbTHSHCk+2q6vfEVgvJL8YA@mail.gmail.com>
	<20150604210617.GA23710@redhat.com> <1433830169.1197.6.camel@hasee>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <1433830169.1197.6.camel@hasee>
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
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Philip Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Joshua Morris <josh.h.morris-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Jun 8, 2015 at 11:09 PM, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, 2015-06-04 at 17:06 -0400, Mike Snitzer wrote:
>> We need to test on large HW raid setups like a Netapp filer (or even
>> local SAS drives connected via some SAS controller).  Like a 8+2 drive
>> RAID6 or 8+1 RAID5 setup.  Testing with MD raid on JBOD setups with 8
>> devices is also useful.  It is larger RAID setups that will be more
>> sensitive to IO sizes being properly aligned on RAID stripe and/or chunk
>> size boundaries.
>
> Here are tests results of xfs/ext4/btrfs read/write on HW RAID6/MD RAID6/DM stripe target.
> Each case run 0.5 hour, so it took 36 hours to finish all the tests on 4.1-rc4 and 4.1-rc4-patched kernels.
>
> No performance regressions were introduced.
>
> Test server: Dell R730xd(2 sockets/48 logical cpus/264G memory)
> HW RAID6/MD RAID6/DM stripe target were configured with 10 HDDs, each 280G
> Stripe size 64k and 128k were tested.
>
> devs="/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk"
> spare_devs="/dev/sdl /dev/sdm"
> stripe_size=64 (or 128)
>
> MD RAID6 was created by:
> mdadm --create --verbose /dev/md0 --level=6 --raid-devices=10 $devs --spare-devices=2 $spare_devs -c $stripe_size
>
> DM stripe target was created by:
> pvcreate $devs
> vgcreate striped_vol_group $devs
> lvcreate -i10 -I${stripe_size} -L2T -nstriped_logical_volume striped_vol_group
>
> Here is an example of fio script for stripe size 128k:
> [global]
> ioengine=libaio
> iodepth=64
> direct=1
> runtime=1800
> time_based
> group_reporting
> numjobs=48
> gtod_reduce=0
> norandommap
> write_iops_log=fs
>
> [job1]
> bs=1280K
> directory=/mnt
> size=5G
> rw=read
>
> All results here: http://minggr.net/pub/20150608/fio_results/
>
> Results summary:
>
> 1. HW RAID6: stripe size 64k
>                 4.1-rc4         4.1-rc4-patched
>                 -------         ---------------
>                 (MB/s)          (MB/s)
> xfs read:       821.23          812.20  -1.09%
> xfs write:      753.16          754.42  +0.16%
> ext4 read:      827.80          834.82  +0.84%
> ext4 write:     783.08          777.58  -0.70%
> btrfs read:     859.26          871.68  +1.44%
> btrfs write:    815.63          844.40  +3.52%
>
> 2. HW RAID6: stripe size 128k
>                 4.1-rc4         4.1-rc4-patched
>                 -------         ---------------
>                 (MB/s)          (MB/s)
> xfs read:       948.27          979.11  +3.25%
> xfs write:      820.78          819.94  -0.10%
> ext4 read:      978.35          997.92  +2.00%
> ext4 write:     853.51          847.97  -0.64%
> btrfs read:     1013.1          1015.6  +0.24%
> btrfs write:    854.43          850.42  -0.46%
>
> 3. MD RAID6: stripe size 64k
>                 4.1-rc4         4.1-rc4-patched
>                 -------         ---------------
>                 (MB/s)          (MB/s)
> xfs read:       847.34          869.43  +2.60%
> xfs write:      198.67          199.03  +0.18%
> ext4 read:      763.89          767.79  +0.51%
> ext4 write:     281.44          282.83  +0.49%
> btrfs read:     756.02          743.69  -1.63%
> btrfs write:    268.37          265.93  -0.90%
>
> 4. MD RAID6: stripe size 128k
>                 4.1-rc4         4.1-rc4-patched
>                 -------         ---------------
>                 (MB/s)          (MB/s)
> xfs read:       993.04          1014.1  +2.12%
> xfs write:      293.06          298.95  +2.00%
> ext4 read:      1019.6          1020.9  +0.12%
> ext4 write:     371.51          371.47  -0.01%
> btrfs read:     1000.4          1020.8  +2.03%
> btrfs write:    241.08          246.77  +2.36%
>
> 5. DM: stripe size 64k
>                 4.1-rc4         4.1-rc4-patched
>                 -------         ---------------
>                 (MB/s)          (MB/s)
> xfs read:       1084.4          1080.1  -0.39%
> xfs write:      1071.1          1063.4  -0.71%
> ext4 read:      991.54          1003.7  +1.22%
> ext4 write:     1069.7          1052.2  -1.63%
> btrfs read:     1076.1          1082.1  +0.55%
> btrfs write:    968.98          965.07  -0.40%
>
> 6. DM: stripe size 128k
>                 4.1-rc4         4.1-rc4-patched
>                 -------         ---------------
>                 (MB/s)          (MB/s)
> xfs read:       1020.4          1066.1  +4.47%
> xfs write:      1058.2          1066.6  +0.79%
> ext4 read:      990.72          988.19  -0.25%
> ext4 write:     1050.4          1070.2  +1.88%
> btrfs read:     1080.9          1074.7  -0.57%
> btrfs write:    975.10          972.76  -0.23%

Hi Mike,

How about these numbers?

I'm also happy to run other fio jobs your team used.

Thanks.
