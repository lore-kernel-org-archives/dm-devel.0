From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 09/60] dm: dm.c: replace 'bio->bi_vcnt == 1' with !bio_multiple_segments
Date: Wed, 2 Nov 2016 15:56:41 +0800
Message-ID: <CACVXFVNxwL1Dm9Mbf=YXpjV4X5G45Ed_TOE1A=wAORWkEdaHCA@mail.gmail.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
 <1477728600-12938-10-git-send-email-tom.leiming@gmail.com>
 <20161031152901.GD30919@infradead.org> <20161102030906.22vwlv3ktp6l4bcy@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161102030906.22vwlv3ktp6l4bcy@kmo-pixel>
Sender: linux-block-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, Nov 2, 2016 at 11:09 AM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:
> On Mon, Oct 31, 2016 at 08:29:01AM -0700, Christoph Hellwig wrote:
>> On Sat, Oct 29, 2016 at 04:08:08PM +0800, Ming Lei wrote:
>> > Avoid to access .bi_vcnt directly, because it may be not what
>> > the driver expected any more after supporting multipage bvec.
>> >
>> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>>
>> It would be really nice to have a comment in the code why it's
>> even checking for multiple segments.
>
> Or ideally refactor the code to not care about multiple segments at all.

The check on 'bio->bi_vcnt == 1' is introduced in commit de3ec86dff160(dm:
don't start current request if it would've merged with the previous), which
fixed one performance issue.[1]

Looks the idea of the patch is to delay dispatching the rq if it
would've merged with previous request and the rq is small(single bvec).
I guess the motivation is to try to increase chance of merging with the delay.

But why does the code check on 'bio->bi_vcnt == 1'? Once the bio is
submitted, .bi_vcnt isn't changed any more and merging doesn't change
it too. So should the check have been on blk_rq_bytes(rq)?

Mike, please correct me if my understanding is wrong.


[1] https://www.redhat.com/archives/dm-devel/2015-March/msg00014.html


thanks,
Ming Lei
