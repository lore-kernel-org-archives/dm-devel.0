From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Bcache v13 09/16] Bcache: generic utility code
Date: Wed, 23 May 2012 09:51:29 -0700
Message-ID: <20120523165129.GA18143@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
 <20120522211706.GH14339@google.com>
 <20120523031214.GA607@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120523050808.GA29976@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120523055402.GC14312@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120523055402.GC14312-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Hello,

On Wed, May 23, 2012 at 01:54:02AM -0400, Kent Overstreet wrote:
> > I think that macro abuses tend to lead to worse code in general.
> > Exotic stuff becomes less painful with magic macros which in turn make
> > people use magic stuff even when more conventional mechanisms can do.
> > Maybe these are simple enough.  Maybe, I don't know.
> 
> Well, I'd really prefer it if C bitfields were well defined enough to
> use them for an on disk format, but... they aren't. That's all it's
> implementing.

AFAIK, there are two issues with bitfields - layout changing depending
on arch / compiler and the recent gcc bug (yes, it's agreed to be a
bug) which caused wider RMW cycle leading to corruption of adjacent
memory when the type of the bitfield is less than machine word size.
It's not like the defined macros can escape the former.  In fact, I
think the current code is already wrong - I don't see __le/beNN or
byte swapping going on.  We already __{LITTLE|BIG)_ENDIAN_BITFIELD
macros to deal with these, so I think it would be much better to use
them instead of the macros.

For the latter, well, it's a compiler bug and as long as you stick to
machine-word multiples - which I think already is the case, it
shouldn't be a problem.  There isn't much point in distorting the code
for a compiler bug.  If necessary, apply workaround which can be
removed / conditionalized later.

> > Unsure but either giving up type safety or implementing logic as
> > functions and wrap them with macros doing typechecks would be better.
> > Can't you use the existing prio_tree or prio_heap?
> 
> I'd definitely be fine with implementing both the heap and the fifo code
> as functions wrapped in macros that provided the typechecking.
> 
> The existing prio_heap code isn't sufficient to replace my heap code -
> it's missing heap_sift() and heap_full() (well, heap_full() could be
> open coded with prio_heap).
> 
> Suppose it wouldn't be that much work to add that to the existing
> prio_heap code and wrap it in some typechecking macros.

Yeah, that would be much preferable.  Also, while type checking is a
nice thing, I don't think it's a must.  It's C and all the basic data
structures we use don't have typecheck - container_of() doesn't have
dynamic typechecking which applies to all node based data structures
including list and all the trees, prio_heap doesn't, quicksort
doesn't.  I don't see why fifo should be any different.  Type checking
is nice to have but it isn't a must.  I think it's actually quite
overrated - lack of it seldomly causes actual headache.

> > Is type-dependent variable limit really necessary?  A lot of sysfs and
> > other interface doesn't care about input validation as long as it
> > doesn't break kernel.
> 
> For raw integers I wouldn't care much, but where integers with human
> readable units are accepted I'd really hate to lose the input validation
> as it's really easy for a user to accidently overflow an integer.

I don't think it matters all that much but if you're really concerned
maybe make a variant of memparse with min/max range arguments?

Thanks.

-- 
tejun
