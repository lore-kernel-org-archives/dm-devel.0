From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: allow a target to relax discard restrictions
Date: Thu, 28 Apr 2011 11:04:49 -0400
Message-ID: <20110428150448.GA19853@redhat.com>
References: <20110427150623.GC13487@infradead.org>
	<20110427151911.GF7294@redhat.com>
	<20110427215537.GA13386@redhat.com>
	<20110428084117.GA32658@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110428084117.GA32658@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Thu, Apr 28 2011 at  4:41am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Apr 27, 2011 at 05:55:38PM -0400, Mike Snitzer wrote:
> > A target, like the upcoming thin provisioning target, may want to allow
> > discards even if the underlying devices do not support them natively.
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> This would work, but I thing it's really confusing to have your
> new discards_supported flag in the dm_target structure in addition
> to the existing discards_supported in the dm_table and the
> num_discard_requests field there.

It's only confusing if you allow it to be ;)  More seriously: I agree,
the target override might lend itself to confusion.

> May we should allow the target to set a tristate
> 
> enum discard_enabled {
> 	NEVER,
> 	ALWAYS,
> 	PASSTHROUGH
> }
> 
> to indicate it's discard support?

[feel free to skip to my question at the very end if I'm boring]

The above would require all targets with num_discard_requests!=0 to have
an additional explicit PASSTHROUGH opt-in.  Seems like a bit much.
Could fix that if we reordered PASSTHROUGH to be the default (0).

But I don't think having an explicit NEVER buys us much; avoids checking
the target for num_discard_requests>0 but that's not a huge win or
anything.  And it would require each target to set NEVER to get that
mini-optimization.

So that leaves:
enum discard_enabled {
       PASSTHROUGH,
       ALWAYS
}

Which is best expressed with a single flag.

With existing code (and proposed target 'discards_supported' override)
NEVER       = ti->num_discard_requests=0
ALWAYS      = ti->discards_supported=1
PASSTHROUGH = ti->num_discard_requests > 0

Would just renaming the target's 'discards_supported' override to
'discards_always_supported' help?  If not that name some other name?

Mike
