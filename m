From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Tue, 11 Aug 2015 13:56:08 -0700
Message-ID: <1439326568.19144.11.camel@ssi>
References: <1439099990.7880.0.camel@hasee>
	<20150809064128.GB2436@infradead.org> <1439103347.7880.3.camel@hasee>
	<20150809070128.GA25739@infradead.org> <1439104707.7880.8.camel@hasee>
	<20150810150216.GA22719@redhat.com>
	<yq1si7rgllc.fsf@sermon.lab.mkp.net>
	<1439230696.26458.6.camel@ssi> <yq1bneeh9df.fsf@sermon.lab.mkp.net>
	<20150811024154.GA26351@redhat.com> <20150811033851.GA28533@kmo-pixel>
	<yq11tf9hg01.fsf@sermon.lab.mkp.net>
	<yq1si7pg0px.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <yq1si7pg0px.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Andreas-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Philip-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Al-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, Jiri-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, Joe Thornber <ejt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, drbd-user-cunTk1MwBs8@public.gmane.org
List-Id: dm-devel.ids

On Tue, 2015-08-11 at 14:05 -0400, Martin K. Petersen wrote:
> >>>>> "Martin" == Martin K Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> writes:
> 
> Martin> I agree except I really don't want to lop off anything unless
> Martin> the device locks up if we send it partial blocks. There was an
> Martin> array that had problems a while back but I believe they have
> Martin> been fixed.
> 
> Oh, and there are several arrays out there that have allocation units
> that are not powers of two. *sigh*

Do you still agree we cap discard to 2G as an interim solution?
https://git.kernel.org/cgit/linux/kernel/git/mlin/linux.git/commit/?h=block-generic-req&id=39d2f5f

If OK, I'll send out new version asking Jens to apply.
