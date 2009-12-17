From: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 15:12:30 +0900
Message-ID: <20091217061229.GD3946@linux-sh.org>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
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

On Tue, Dec 15, 2009 at 04:57:49PM -0500, Mikulas Patocka wrote:
> (5) Wrapping makes long expressions harder to understand
> --------------------------------------------------------
> 
> If I have a complex expression, I do not try to wrap it at predefined
> 80-column boundaries, but at logical boundaries within the expression to make
> it more readable (the brain can't find matching parentheses fast, so we can
> help it by aligning the code according to topmost terms in the expression).
> 
> Example:
> 				if (unlikely(call_some_function(s, value) != RET
> _SUCCESS) ||
> 				    (var_1 == prev_var_1 && var_2 == prev_var_2)
>  ||
> 				    flags & (FLAG_1 | FLAG_2) ||
> 				    some_other_condition) {
> 				}
> 
> Now, if we impose 80-column limit, we get this. One may argue that is looks
> aesthetically better, but it is also less intelligible than the previous
> version:
> 				if (unlikely(call_some_function(s, value) !=
> 				    RET_SUCCESS) || (var_1 == prev_var_1 &&
> 				    var_2 == prev_var_2) || flags & (FLAG_1 |
> 				    FLAG_2) || some_other_condition) {
> 				}
> 
For starters, this is just crap. If you're writing code like this, then
line wrapping is really the least of your concerns. Take your function
return value and assign it to a variable before testing it in unlikely()
as per existing conventions and most of this goes away in this example.
If you're testing an absurd amount of conditions in a single block with
needlessly verbose variable names, then yes, you will go over 80
characters. Consequently, your "clean" example doesn't look much better
than your purposely obfuscated one.

The 80 character limit isn't a hard limit, but it's still an excellent
guideline largely because it stops people from writing code like in your
above example. Some amount of common sense is necessary, and most
people in a position of applying patches can work out when to ignore
checkpatch and when not to. The exception that you also noted is that
some people run checkpatch on inbound patches before applying them, so
having a flag to ignore the line size (or at least make it non-fatal) is
probably not the worst idea ever -- although I disagree with killing off
any notice about the line size completely.

Aiming to keep things around 80 characters has served us well over the
years, so I don't quite agree with suddenly adopting an anything goes
policy in checkpatch. People that don't care about the limit can disable
it in their scripts while folks running their patches through prior to
list submission are still better off being reminded that they should keep
things reasonably close. One only has to take a look through some of the
staging/ drivers pre-cleanup efforts for examples that clearly benefit
from triggering these warnings rather than implicitly supporting insane
tab depths.
