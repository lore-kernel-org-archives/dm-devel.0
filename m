From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Tue, 04 Aug 2015 23:03:24 -0700
Message-ID: <1438754604.29731.31.camel@hasee>
References: <1436168690-32102-1-git-send-email-mlin@kernel.org>
	<20150731192337.GA8907@redhat.com>
	<CAF1ivSZbMDgyo_-wFGusSNSZ1fonSMWmNU9aVavGFaQsmEyYmQ@mail.gmail.com>
	<20150731213831.GA16464@redhat.com> <1438412290.26596.14.camel@hasee>
	<20150801163356.GA21478@redhat.com> <1438581502.26596.24.camel@hasee>
	<20150804113626.GA12682@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20150804113626.GA12682-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Al-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, Philip Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Neil-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On Tue, 2015-08-04 at 13:36 +0200, Christoph Hellwig wrote:
> On Sun, Aug 02, 2015 at 10:58:22PM -0700, Ming Lin wrote:
> > I think the important thing is the late splitting for regular bio.
> > For discard/write_same bio, how about just don't do late splitting?
> 
> I'd hate having to special case them even more.  Especially as the
> discard splitting is nasty and we really don't want to send giant
> discards by default anyway (see Jens' patches to limit discard size
> by default).
> 
> So I'd recommend to keep everything as-is, just make sure we don't
> overflow bi_size.

Did you mean to remove "PATCH 4 block: remove split code in
blkdev_issue_discard" or to keep it?

Which of below 2 solutions you prefer?

- Solution 1

remove splits in blkdev_issue_{discard,write_same} and keep
blk_bio_{discard,write_same}_split

But for blkdev_issue_discard(), it's not enough if only make sure
bi_size not overflow, for example, discard 4G

4G bytes = 8388608 sectors
UINT_MAX = 8388607 sectors

So blkdev_issue_discard() will send 2 discard bios.
First bio: sector 0 .. 8388606
Second bio: sector 8388607 .. 8388607

In this case, the 2 discard tests in device-mapper-test-suite still
fail, probably because the second bio start sector is not aligned with
discard_granularity.

So I have to take into account discard_granularity(assume 32 sectors),
then blkdev_issue_discard() will send 2 discard bios, as

First bio: sector 0 .. 8388575
Second bio: sector 8388576 .. 8388607

In this case, both discard tests passed.

- Solution 2

special case discard/write_same bios(You said you hate it).

That is to keep splits in blkdev_issue_{discard,write_same} and remove
blk_bio_{discard,write_same}_split

I think this is more clean way because blkdev_issue_{discard,write_same}
already make sure we don't overflow bi_size.

And blk_bio_{discard,write_same}_split are actually duplicated with the
splits in blkdev_issue_{discard,write_same}. It's OK to remove it.
