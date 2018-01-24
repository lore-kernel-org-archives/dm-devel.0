From: Martin Wilck <mwilck@suse.com>
Subject: Re: [dm-devel] [PATCH] dm mpath selector: more evenly distribute
 ties
Date: Wed, 24 Jan 2018 21:00:29 +0100
Message-ID: <1516824029.6927.14.camel@suse.com>
References: <20180119230737.133596-1-khazhy@google.com>
         <1516791437.6678.6.camel@suse.com>
         <CACGdZYK5XBCjDgAyQ7+-teR24-G9fp1yuKqHawGLYd79BbGO=Q@mail.gmail.com>
         <1516820965.6927.10.camel@suse.com>
         <CACGdZYKVDqZ+qwFAMSb6p+dVe4cfaPhcnXoqZirURQYqmKbWdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACGdZYKVDqZ+qwFAMSb6p+dVe4cfaPhcnXoqZirURQYqmKbWdQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Khazhismel Kumykov <khazhy@google.com>
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, 2018-01-24 at 11:41 -0800, Khazhismel Kumykov wrote:
> On Wed, Jan 24, 2018 at 11:09 AM, Martin Wilck <mwilck@suse.com>
> wrote:
> > On Wed, 2018-01-24 at 10:44 -0800, Khazhismel Kumykov wrote:
> > > On Wed, Jan 24, 2018 at 2:57 AM, Martin Wilck <mwilck@suse.com>
> > > wrote:
> > > > On Fri, 2018-01-19 at 15:07 -0800, Khazhismel Kumykov wrote:
> > > > > Move the last used path to the end of the list (least
> > > > > preferred)
> > > > > so
> > > > > that
> > > > > ties are more evenly distributed.
> > > > > 
> > > > > For example, in case with three paths with one that is slower
> > > > > than
> > > > > others, the remaining two would be unevenly used if they tie.
> > > > > This is
> > > > > due to the rotation not being a truely fair distribution.
> > > > > 
> > > > > Illustrated: paths a, b, c, 'c' has 1 outstanding IO, a and b
> > > > > are
> > > > > 'tied'
> > > > > Three possible rotations:
> > > > > (a, b, c) -> best path 'a'
> > > > > (b, c, a) -> best path 'b'
> > > > > (c, a, b) -> best path 'a'
> > > > > (a, b, c) -> best path 'a'
> > > > > (b, c, a) -> best path 'b'
> > > > > (c, a, b) -> best path 'a'
> > > > > ...
> > > > 
> > > > 
> > > > This happens only if a and b actually have the same weight
> > > > (e.g.
> > > > queue
> > > > length for the queue-length selector). If 'a' really receives
> > > > more
> > > > IO,
> > > > its queue grows, and the selector will start preferring 'b', so
> > > > the
> > > > effect should level out automatically with the current code as
> > > > soon
> > > > as
> > > > you have real IO going on. But maybe I haven't grasped what
> > > > you're
> > > > referring to as "tied".
> > > 
> > > Yes, for "tied" I'm referring to paths with the same weight. As
> > > queue
> > > length grows it does tend to level out, but in the case where
> > > queue
> > > length doesn't grow (in this example I'm imagining 2 concurrent
> > > requests to the device) the bias does show and the selectors
> > > really
> > > do
> > > send 'a' 2x more requests than 'b' (when 'c' is much slower and
> > > 'a'
> > > and 'b' are ~same speed).
> > 
> > Have you actually observed this? I find the idea pretty academical
> > that
> > two paths would be walking "tied" this way. In practice, under IO
> > load,
> > I'd expect queue lengths (and service-times, for that matter) to
> > fluctuate enough to prevent this effect to be measurable. But of
> > course, I may be wrong. If you really did observe this, the next
> > question would be: does hurt performance to an extent that can be
> > noticed/measured? I reckon that if 'a' got saturated under the
> > load,
> > hurting performance, its queue length would grow quickly and 'b'
> > would
> > automatically get preferred.
> 
> This is fairly simple to observe - start two sync reader threads
> against a device with 3 backing paths, with one path taking longer on
> average to complete requests than the other two. One of the 'faster'
> paths will be used ~2x more than the other. Perhaps not that common a
> situation, but is a real one. The bias seemed simple to remove, so
> that the two (or N) paths would be used equally.
> 
> I don't see a downside to more evenly distributing in this case,
> although I can't say I've directly observed performance downsides for
> a biased distribution (aside from the distribution being biased
> itself
> being a downside).
> The bias of note is inherent to the order paths are added to the
> selector (and which path is 'always bad'), so if 'a' is saturated due
> to this, then slows, once it recovers it will continue to be
> preferred, versus in an even distribution.

Well, the expectation is indeed that load is spread equally, and I can
also see no downside. So:

Reviewed-by: Martin Wilck <mwilck@suse.com>

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
