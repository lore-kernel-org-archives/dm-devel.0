From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 18:33:12 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0912171829340.21142@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<Pine.LNX.4.64.0912171725370.21142@hs20-bc2-1.build.redhat.com>
	<20091217231240.GA1421@linux-sh.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091217231240.GA1421@linux-sh.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Paul Mundt <lethal@linux-sh.org>
Cc: dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Fri, 18 Dec 2009, Paul Mundt wrote:

> On Thu, Dec 17, 2009 at 05:37:57PM -0500, Mikulas Patocka wrote:
> > On Thu, 17 Dec 2009, Paul Mundt wrote:
> > > On Tue, Dec 15, 2009 at 04:57:49PM -0500, Mikulas Patocka wrote:
> > > > (5) Wrapping makes long expressions harder to understand
> > > > --------------------------------------------------------
> > > > 
> > > > If I have a complex expression, I do not try to wrap it at predefined
> > > > 80-column boundaries, but at logical boundaries within the expression to make
> > > > it more readable (the brain can't find matching parentheses fast, so we can
> > > > help it by aligning the code according to topmost terms in the expression).
> > > > 
> > > > Example:
> > > > 				if (unlikely(call_some_function(s, value) != RET
> > > > _SUCCESS) ||
> > > > 				    (var_1 == prev_var_1 && var_2 == prev_var_2)
> > > >  ||
> > > > 				    flags & (FLAG_1 | FLAG_2) ||
> > > > 				    some_other_condition) {
> > > > 				}
> > > > 
> > > > Now, if we impose 80-column limit, we get this. One may argue that is looks
> > > > aesthetically better, but it is also less intelligible than the previous
> > > > version:
> > > > 				if (unlikely(call_some_function(s, value) !=
> > > > 				    RET_SUCCESS) || (var_1 == prev_var_1 &&
> > > > 				    var_2 == prev_var_2) || flags & (FLAG_1 |
> > > > 				    FLAG_2) || some_other_condition) {
> > > > 				}
> > > > 
> > > For starters, this is just crap. If you're writing code like this, then
> > > line wrapping is really the least of your concerns. Take your function
> > > return value and assign it to a variable before testing it in unlikely()
> > > as per existing conventions and most of this goes away in this example.
> > 
> > I wouldn't say that this is better:
> > 				int csf_failed, vars_equal, flags_12;
> > 
> > 				...
> > 
> > 				csf_failed = call_some_function(s, value) != RET_SUCCESS;
> > 				vars_equal = var_1 == prev_var_1 && var_2 == prev_var_2;
> > 				flags_12 = flags & (FLAG_1 | FLAG_2);
> > 				if (unlikely(csf_failed) || vars_equal ||
> > 				    flags_12 || some_other_conditions) {
> > 				}
> > 
> > If you think that it is better, it's OK, just write your code like that. 
> > And don't force it to everyone.
> > 
> No, I wouldn't say that that's better either, but that's also not how I
> suggested cleaning reworking it. We have existing conventions for how
> complex blocks are broken down in to more readable forms which you seem
> to have issues grasping. My point is that you are purposely obfuscating
> things, and therefore your entire rationale is suspect at best.

So, how would you clean this complex code block?

Mikulas
