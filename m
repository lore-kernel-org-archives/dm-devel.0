From: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 08:12:40 +0900
Message-ID: <20091217231240.GA1421@linux-sh.org>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<Pine.LNX.4.64.0912171725370.21142@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912171725370.21142@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Dec 17, 2009 at 05:37:57PM -0500, Mikulas Patocka wrote:
> On Thu, 17 Dec 2009, Paul Mundt wrote:
> > On Tue, Dec 15, 2009 at 04:57:49PM -0500, Mikulas Patocka wrote:
> > > (5) Wrapping makes long expressions harder to understand
> > > --------------------------------------------------------
> > > 
> > > If I have a complex expression, I do not try to wrap it at predefined
> > > 80-column boundaries, but at logical boundaries within the expression to make
> > > it more readable (the brain can't find matching parentheses fast, so we can
> > > help it by aligning the code according to topmost terms in the expression).
> > > 
> > > Example:
> > > 				if (unlikely(call_some_function(s, value) != RET
> > > _SUCCESS) ||
> > > 				    (var_1 == prev_var_1 && var_2 == prev_var_2)
> > >  ||
> > > 				    flags & (FLAG_1 | FLAG_2) ||
> > > 				    some_other_condition) {
> > > 				}
> > > 
> > > Now, if we impose 80-column limit, we get this. One may argue that is looks
> > > aesthetically better, but it is also less intelligible than the previous
> > > version:
> > > 				if (unlikely(call_some_function(s, value) !=
> > > 				    RET_SUCCESS) || (var_1 == prev_var_1 &&
> > > 				    var_2 == prev_var_2) || flags & (FLAG_1 |
> > > 				    FLAG_2) || some_other_condition) {
> > > 				}
> > > 
> > For starters, this is just crap. If you're writing code like this, then
> > line wrapping is really the least of your concerns. Take your function
> > return value and assign it to a variable before testing it in unlikely()
> > as per existing conventions and most of this goes away in this example.
> 
> I wouldn't say that this is better:
> 				int csf_failed, vars_equal, flags_12;
> 
> 				...
> 
> 				csf_failed = call_some_function(s, value) != RET_SUCCESS;
> 				vars_equal = var_1 == prev_var_1 && var_2 == prev_var_2;
> 				flags_12 = flags & (FLAG_1 | FLAG_2);
> 				if (unlikely(csf_failed) || vars_equal ||
> 				    flags_12 || some_other_conditions) {
> 				}
> 
> If you think that it is better, it's OK, just write your code like that. 
> And don't force it to everyone.
> 
No, I wouldn't say that that's better either, but that's also not how I
suggested cleaning reworking it. We have existing conventions for how
complex blocks are broken down in to more readable forms which you seem
to have issues grasping. My point is that you are purposely obfuscating
things, and therefore your entire rationale is suspect at best.

> For me, breaking the expression into variables is worse because:
> - adding/removing conditions must be done at 3 places (vs. my original 
> example, where it would be done only on 1 place)
> - when reading the conditions, your eyes must skip to two places (vs. my 
> original example, where you only read it at one place)
> 
> But everyone has different brain, so it may be that for you, the extra 
> variables are really more understandable. So write your code like that and 
> don't preach.
> 
This isn't a subjective thing as you are now trying to spin it. There are
existing conventions that the majority of kernel code follows and any of
your above obfuscated blocks are unlikely to show up in any code outside
of drivers/. How about actually reading through the coding style document
and existing code before attempting to cripple checkpatch.

You've also ignored everything that was stated about the reasons for why
we have this limit and why it is useful, instead focusing purely on the
fact that I've taken issue with your bogus examples that would never have
been applied in the first place.

If you simply wanted a way to get around the limit, then something like
Bart's patch is quite reasonable and I don't believe anyone has any
objections to it. This half-baked rationale for tossing it out completely
using examples that don't even show up in the kernel though is simply
nonsense. Perhaps if you spent half as much time auditing vendor patches
you would have some idea of why having these warnings is not just a nice
thing to have, but also the only sensible default.
