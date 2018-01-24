From: Martin Wilck <mwilck@suse.com>
Subject: Re: [dm-devel] [PATCH] dm mpath selector: more evenly distribute
 ties
Date: Wed, 24 Jan 2018 20:09:25 +0100
Message-ID: <1516820965.6927.10.camel@suse.com>
References: <20180119230737.133596-1-khazhy@google.com>
         <1516791437.6678.6.camel@suse.com>
         <CACGdZYK5XBCjDgAyQ7+-teR24-G9fp1yuKqHawGLYd79BbGO=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACGdZYK5XBCjDgAyQ7+-teR24-G9fp1yuKqHawGLYd79BbGO=Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Khazhismel Kumykov <khazhy@google.com>
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, 2018-01-24 at 10:44 -0800, Khazhismel Kumykov wrote:
> On Wed, Jan 24, 2018 at 2:57 AM, Martin Wilck <mwilck@suse.com>
> wrote:
> > On Fri, 2018-01-19 at 15:07 -0800, Khazhismel Kumykov wrote:
> > > Move the last used path to the end of the list (least preferred)
> > > so
> > > that
> > > ties are more evenly distributed.
> > > 
> > > For example, in case with three paths with one that is slower
> > > than
> > > others, the remaining two would be unevenly used if they tie.
> > > This is
> > > due to the rotation not being a truely fair distribution.
> > > 
> > > Illustrated: paths a, b, c, 'c' has 1 outstanding IO, a and b are
> > > 'tied'
> > > Three possible rotations:
> > > (a, b, c) -> best path 'a'
> > > (b, c, a) -> best path 'b'
> > > (c, a, b) -> best path 'a'
> > > (a, b, c) -> best path 'a'
> > > (b, c, a) -> best path 'b'
> > > (c, a, b) -> best path 'a'
> > > ...
> > 
> > 
> > This happens only if a and b actually have the same weight (e.g.
> > queue
> > length for the queue-length selector). If 'a' really receives more
> > IO,
> > its queue grows, and the selector will start preferring 'b', so the
> > effect should level out automatically with the current code as soon
> > as
> > you have real IO going on. But maybe I haven't grasped what you're
> > referring to as "tied".
> 
> Yes, for "tied" I'm referring to paths with the same weight. As queue
> length grows it does tend to level out, but in the case where queue
> length doesn't grow (in this example I'm imagining 2 concurrent
> requests to the device) the bias does show and the selectors really
> do
> send 'a' 2x more requests than 'b' (when 'c' is much slower and 'a'
> and 'b' are ~same speed).

Have you actually observed this? I find the idea pretty academical that
two paths would be walking "tied" this way. In practice, under IO load,
I'd expect queue lengths (and service-times, for that matter) to
fluctuate enough to prevent this effect to be measurable. But of
course, I may be wrong. If you really did observe this, the next
question would be: does hurt performance to an extent that can be
noticed/measured? I reckon that if 'a' got saturated under the load,
hurting performance, its queue length would grow quickly and 'b' would
automatically get preferred.

> > OTOH, if the "best" path has much lower queue length than the other
> > paths for whatever reason, your pushing it to the tail will require
> > a
> > full list walk with every new call of the selector. I see tjat as a
> > small disadvantage of your approach.
> 
> I see, with best at the tail, we would not see as much benefit from
> the check if a path has no IOs on it in queue-length. In service-time
> no such short circuit exists, so I don't believe anything changes
> there. Am I understanding this correctly?

Forget that. I was confused. We're walking the entire list every time
anyway, except for the . I find it strange to put the best candidate to
the tail every time, but I can't prove that it really hurts.

Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
