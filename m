From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Date: Tue, 12 Apr 2011 19:29:29 +0200
Message-ID: <4DA48BF9.4050304@fusionio.com>
References: <4DA2F00E.6010907@fusionio.com> <20110411223623.4278fad1@notabene.brown> <4DA2F8AD.1060605@fusionio.com> <20110412011255.GA29236@infradead.org> <4DA40F0E.1070903@fusionio.com> <20110412122248.GC31057@dastard> <4DA4456F.3070301@fusionio.com> <20110412124134.GD31057@dastard> <4DA44C86.3090305@fusionio.com> <20110412133117.GE31057@dastard> <20110412165830.GC23764@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110412165830.GC23764@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On 2011-04-12 18:58, hch@infradead.org wrote:
> On Tue, Apr 12, 2011 at 11:31:17PM +1000, Dave Chinner wrote:
>> I don't think so. e.g. in the XFS allocation path we do btree block
>> readahead, then go do the real work. The real work can end up with a
>> deeper stack before blocking on locks or completions unrelated to
>> the readahead, leading to schedule() being called and an unplug
>> being issued at that point.  You might think it contrived, but if
>> you can't provide a guarantee that it can't happen then I have to
>> assume it will happen.
> 
> In addition to the stack issue, which is a killer to this also has
> latency implications.  Before we could submit a synchronous metadata
> read request inside readpage or writepage and kick it off to the disk
> immediately, while now it won't get submitted until we block the next
> time, i.e. have done some more work that could have been used for
> doing I/O in the background.  With the kblockd offload not only have
> we spent more time but at the point where we finally kick it we
> also need another context switch.  It seem like we really need to
> go through the filesystems and explicitly flush the plugging queue
> for such cases.  In fact a bio flag marking things as synchronous
> metadata reads would help, but then again we need to clean up our
> existing bio flags first..

I think it would be a good idea to audit the SYNC cases, and if feasible
let that retain the 'immediate kick off' logic. If not, have some way to
signal that at least. Essentially allow some fine grained control of
what goes into the plug and what does not.

-- 
Jens Axboe
