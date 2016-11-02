From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 09/60] dm: dm.c: replace 'bio->bi_vcnt == 1'
 with !bio_multiple_segments
Date: Wed, 2 Nov 2016 10:24:54 -0400
Message-ID: <20161102142454.GA9263@redhat.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
	<1477728600-12938-10-git-send-email-tom.leiming@gmail.com>
	<20161031152901.GD30919@infradead.org>
	<20161102030906.22vwlv3ktp6l4bcy@kmo-pixel>
	<CACVXFVNxwL1Dm9Mbf=YXpjV4X5G45Ed_TOE1A=wAORWkEdaHCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CACVXFVNxwL1Dm9Mbf=YXpjV4X5G45Ed_TOE1A=wAORWkEdaHCA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "maintainer:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, linux-block <linux-block@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: dm-devel.ids

On Wed, Nov 02 2016 at  3:56am -0400,
Ming Lei <tom.leiming@gmail.com> wrote:

> On Wed, Nov 2, 2016 at 11:09 AM, Kent Overstreet
> <kent.overstreet@gmail.com> wrote:
> > On Mon, Oct 31, 2016 at 08:29:01AM -0700, Christoph Hellwig wrote:
> >> On Sat, Oct 29, 2016 at 04:08:08PM +0800, Ming Lei wrote:
> >> > Avoid to access .bi_vcnt directly, because it may be not what
> >> > the driver expected any more after supporting multipage bvec.
> >> >
> >> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> >>
> >> It would be really nice to have a comment in the code why it's
> >> even checking for multiple segments.
> >
> > Or ideally refactor the code to not care about multiple segments at all.
> 
> The check on 'bio->bi_vcnt == 1' is introduced in commit de3ec86dff160(dm:
> don't start current request if it would've merged with the previous), which
> fixed one performance issue.[1]
> 
> Looks the idea of the patch is to delay dispatching the rq if it
> would've merged with previous request and the rq is small(single bvec).
> I guess the motivation is to try to increase chance of merging with the delay.
> 
> But why does the code check on 'bio->bi_vcnt == 1'? Once the bio is
> submitted, .bi_vcnt isn't changed any more and merging doesn't change
> it too. So should the check have been on blk_rq_bytes(rq)?
> 
> Mike, please correct me if my understanding is wrong.
> 
> 
> [1] https://www.redhat.com/archives/dm-devel/2015-March/msg00014.html

The patch was labored over for quite a while and is based on suggestions I
got from Jens when discussing a very problematic aspect of old
.request_fn request-based DM performance for a multi-threaded (64
threads) sequential IO benchmark (vdbench IIRC).  The issue was reported
by NetApp.

The patch in question fixed the lack of merging that was seen with this
interleaved sequential IO benchmark.  The lack of merging was made worse
if a DM multipath device had more underlying paths (e.g. 4 instead of 2).

As for your question, about using blk_rq_bytes(rq) vs 'bio->bi_vcnt == 1'
.. not sure how that would be a suitable replacement.  But it has been a
while since I've delved into these block core merge details of old
.request_fn but _please_ don't change the logic of this code simply
because it is proving itself to be problematic for your current
patchset's cleanliness.

Mike
