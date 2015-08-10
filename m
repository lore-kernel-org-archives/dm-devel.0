From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Mon, 10 Aug 2015 09:18:38 -0700
Message-ID: <1439223518.27204.13.camel@hasee>
References: <CAF1ivSZbMDgyo_-wFGusSNSZ1fonSMWmNU9aVavGFaQsmEyYmQ@mail.gmail.com>
	<20150731213831.GA16464@redhat.com> <1438412290.26596.14.camel@hasee>
	<20150801163356.GA21478@redhat.com>
	<yq18u9liwhj.fsf@sermon.lab.mkp.net>
	<1439099990.7880.0.camel@hasee> <20150809064128.GB2436@infradead.org>
	<1439103347.7880.3.camel@hasee> <20150809070128.GA25739@infradead.org>
	<1439104707.7880.8.camel@hasee> <20150810150216.GA22719@redhat.com>
	<1439223252.27204.10.camel@hasee>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <1439223252.27204.10.camel@hasee>
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
Cc: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, Philip Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Martin K.  Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joe Thornber <ejt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On Mon, 2015-08-10 at 09:14 -0700, Ming Lin wrote:
> On Mon, 2015-08-10 at 11:02 -0400, Mike Snitzer wrote:
> > On Sun, Aug 09 2015 at  3:18am -0400,
> > Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > 
> > > On Sun, 2015-08-09 at 00:01 -0700, Christoph Hellwig wrote:
> > > > On Sat, Aug 08, 2015 at 11:55:47PM -0700, Ming Lin wrote:
> > > > > Will change it to MAX_BIO_SECTORS.
> > > > > May I add your ACK?
> > > > 
> > > > Yes, please go ahead.
> > > 
> > > Thanks. I'll send a new version of the series once device-mapper guy
> > > acks.
> > > 
> > > Hi Mike,
> > > 
> > > I have updated my tree. Could you pull and re-test?
> > > https://git.kernel.org/cgit/linux/kernel/git/mlin/linux.git/log/?h=block-generic-req
> > > 
> > > The 2 thin-provisioning tests passed.
> > 
> > I've merged your latest branch with my dm-4.3 branch, I had one conflict
> > in the merge due to the dm_merge_bvec() change from 4.2-rc6 (no
> > surprise).  I've published the result here:
> > http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=block-late-bio-splitting
> > 
> > It passes the device-mapper-test-suite's 'thin-provisioning' tests.
> > 
> > > Hope I can have your ACK soon.
> > 
> > Shouldn't we also be using MAX_BIO_SECTORS in blkdev_issue_write_same
> > (instead of UINT_MAX >> 9)?
> 
> I also prefer using MAX_BIO_SECTORS.
> Otherwise, we may have non page size aligned splits.
> 
> Say, write_same 8G.
> 
> Using UINT_MAX >> 9, we'll have 2 sector aligned splits in
> blkdev_issue_write_same():
> 0 - (4G - 512 - 1)
> (4G - 512, 8G -1)

Actually, 3 sector aligned splits.

0 - (4G-512-1)
(4G-512), (8G-512-1)
(8G-512), (8G-1)

> 
> This looks weired.
> 
> Using MAX_BIO_SECTORS, we'll have 4 page size aligned splits:
> 0 - (2G -1)
> 2G - (4G - 1)
> 4G - (6G - 1)
> 6G - (8G - 1)
> 
> I'll use MAX_BIO_SECTORS in blkdev_issue_write_same() if no objection.
> 
> > 
> > Aside from that, I'm in favor of seeing this late bio splitting patchset
> > finally land upstream (hopefully in time for the 4.3 merge, Jens?):
> > 
> > Acked-by: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Thanks!
> 
> May I add your Ack to "PATCH: block: kill merge_bvec_fn() completely"
> also?
> 
> > 
> > p.s. I'll be working with Joe Thornber on optimizing DM (particularly
> > dm-thinp and dm-cache) once this patchset is included upstream.  You'll
> > see I've already added a couple WIP dm-thinp patches ontop.
> 
