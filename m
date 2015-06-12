From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Thu, 11 Jun 2015 22:49:02 -0700
Message-ID: <1434088142.2163.3.camel@hasee>
References: <20150526143626.GA4315@redhat.com>
	<CAF1ivSb3ptYObS3_8bJwWhq98EcNgAgRhN_L-c3uyFfCzdn=9A@mail.gmail.com>
	<20150526160400.GB4715@redhat.com>
	<CAF1ivSZ351yV4re1Ghf5yqPjgq6aXjrZT4yWd+T9msAFsBnDSw@mail.gmail.com>
	<20150528003627.GD32216@agk-dp.fab.redhat.com>
	<1433138551.11778.4.camel@hasee>
	<CAF1ivSY_7M1OhrMuXg0OKu7BPy=SbTHSHCk+2q6vfEVgvJL8YA@mail.gmail.com>
	<20150604210617.GA23710@redhat.com> <1433830169.1197.6.camel@hasee>
	<CAF1ivSbo456n+1JxDp7eAHAgKs5qBOcomN4N9hhCEXmy8i4nPQ@mail.gmail.com>
	<20150610214611.GA744@redhat.com>
	<CAF1ivSbvX1HooUBk-vB3vXGFbocKYimr=YSkLivAV_nSSMHxzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <CAF1ivSbvX1HooUBk-vB3vXGFbocKYimr=YSkLivAV_nSSMHxzg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Joshua Morris <josh.h.morris-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, Philip Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Nitin-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On Wed, 2015-06-10 at 15:06 -0700, Ming Lin wrote:
> On Wed, Jun 10, 2015 at 2:46 PM, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Wed, Jun 10 2015 at  5:20pm -0400,
> > Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> >> On Mon, Jun 8, 2015 at 11:09 PM, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >> > On Thu, 2015-06-04 at 17:06 -0400, Mike Snitzer wrote:
> >> >> We need to test on large HW raid setups like a Netapp filer (or even
> >> >> local SAS drives connected via some SAS controller).  Like a 8+2 drive
> >> >> RAID6 or 8+1 RAID5 setup.  Testing with MD raid on JBOD setups with 8
> >> >> devices is also useful.  It is larger RAID setups that will be more
> >> >> sensitive to IO sizes being properly aligned on RAID stripe and/or chunk
> >> >> size boundaries.
> >> >
> >> > Here are tests results of xfs/ext4/btrfs read/write on HW RAID6/MD RAID6/DM stripe target.
> >> > Each case run 0.5 hour, so it took 36 hours to finish all the tests on 4.1-rc4 and 4.1-rc4-patched kernels.
> >> >
> >> > No performance regressions were introduced.
> >> >
> >> > Test server: Dell R730xd(2 sockets/48 logical cpus/264G memory)
> >> > HW RAID6/MD RAID6/DM stripe target were configured with 10 HDDs, each 280G
> >> > Stripe size 64k and 128k were tested.
> >> >
> >> > devs="/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk"
> >> > spare_devs="/dev/sdl /dev/sdm"
> >> > stripe_size=64 (or 128)
> >> >
> >> > MD RAID6 was created by:
> >> > mdadm --create --verbose /dev/md0 --level=6 --raid-devices=10 $devs --spare-devices=2 $spare_devs -c $stripe_size
> >> >
> >> > DM stripe target was created by:
> >> > pvcreate $devs
> >> > vgcreate striped_vol_group $devs
> >> > lvcreate -i10 -I${stripe_size} -L2T -nstriped_logical_volume striped_vol_group
> >
> > DM had a regression relative to merge_bvec that wasn't fixed until
> > recently (it wasn't in 4.1-rc4), see commit 1c220c69ce0 ("dm: fix
> > casting bug in dm_merge_bvec()").  It was introduced in 4.1.
> >
> > So your 4.1-rc4 DM stripe testing may have effectively been with
> > merge_bvec disabled.
> 
> I'l rebase it to latest Linus tree and re-run DM stripe testing.

Here is the results for 4.1-rc7. Also looks good.

5. DM: stripe size 64k
		4.1-rc7		4.1-rc7-patched
		-------		---------------
		(MB/s)		(MB/s)
xfs read:	784.0		783.5  -0.06%
xfs write:	751.8		768.8  +2.26%
ext4 read:	837.0		832.3  -0.56%
ext4 write:	806.8		814.3  +0.92%
btrfs read:	787.5		786.1  -0.17%
btrfs write:	722.8		718.7  -0.56%


6. DM: stripe size 128k
		4.1-rc7		4.1-rc7-patched
		-------		---------------
		(MB/s)		(MB/s)
xfs read:	1045.5		1068.8  +2.22%
xfs write:	1058.9		1052.7  -0.58%
ext4 read:	1001.8		1020.7  +1.88%
ext4 write:	1049.9		1053.7  +0.36%
btrfs read:	1082.8		1084.8  +0.18%
btrfs write:	948.15		948.74  +0.06%
