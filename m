From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Fri, 7 Aug 2015 22:17:43 -0700
Message-ID: <CAF1ivSYAiRqG1RhxiHE+cfogB_VKyDDs0aE7YbtZ2o6UeGhZcQ@mail.gmail.com>
References: <20150731192337.GA8907@redhat.com>
	<CAF1ivSZbMDgyo_-wFGusSNSZ1fonSMWmNU9aVavGFaQsmEyYmQ@mail.gmail.com>
	<20150731213831.GA16464@redhat.com>
	<1438412290.26596.14.camel@hasee>
	<20150801163356.GA21478@redhat.com>
	<1438581502.26596.24.camel@hasee> <20150804113626.GA12682@lst.de>
	<1438754604.29731.31.camel@hasee> <20150807073001.GA17485@lst.de>
	<1438990806.24452.8.camel@ssi> <20150808003057.GA1811@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <20150808003057.GA1811@kmo-pixel>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, Philip Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On Fri, Aug 7, 2015 at 5:30 PM, Kent Overstreet
<kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, Aug 07, 2015 at 04:40:06PM -0700, Ming Lin wrote:
>>
>> On Fri, 2015-08-07 at 09:30 +0200, Christoph Hellwig wrote:
>> > I'm for solution 3:
>> >
>> >  - keep blk_bio_{discard,write_same}_split, but ensure we never built
>> >    a > 4GB bio in blkdev_issue_{discard,write_same}.
>>
>> This has problem as I mentioned in solution 1.
>> We need to also make sure max discard size is of proper granularity.
>> See below example.
>>
>>       4G: 8388608 sectors
>> UINT_MAX: 8388607 sectors
>>
>> dm-thinp block size = default discard granularity = 128 sectors
>>
>> blkdev_issue_discard(sector=0, nr_sectors=8388608)
>>
>> 1. Only ensure bi_size not overflow
>>
>> It doesn't work.
>>
>> [start_sector, end_sector]
>> [0, 8388607]
>>     [0, 8388606], then dm-thinp splits it to 2 bios
>>         [0, 8388479]
>>         [8388480, 8388606] ---> this has problem in process_discard_bio(),
>>                                 because the discard size(7 sectors) covers less than a block(128 sectors)
>>     [8388607, 8388607] ---> same problem
>>
>> 2. Ensure bi_size not overflow and max discard size is of proper granularity
>
> Ideally we'd get upper layers out of the business of knowing about the queue
> limits at all - that was the point of the patch series, after all.
>
> Instead of using UINT_MAX, would it work to just make the max 1 << 31 sectors?'

1 << 31 = 2G bytes = 0x400000 sectors.

Yes, that works as long as it's multiple of granularity.
