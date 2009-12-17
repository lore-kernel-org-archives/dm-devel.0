From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 18:29:25 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3tyvqgfs4.fsf@intrepid.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: dm-devel@redhat.com, Paul Mundt <lethal@linux-sh.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 17 Dec 2009, Krzysztof Halasa wrote:

> Paul Mundt <lethal@linux-sh.org> writes:
> 
> > For starters, this is just crap. If you're writing code like this, then
> > line wrapping is really the least of your concerns. Take your function
> > return value and assign it to a variable before testing it in unlikely()
> > as per existing conventions and most of this goes away in this example.
> > If you're testing an absurd amount of conditions in a single block with
> > needlessly verbose variable names, then yes, you will go over 80
> > characters. Consequently, your "clean" example doesn't look much better
> > than your purposely obfuscated one.
> 
> Then perhaps checkpatch should warn about too complex expressions
> instead? Line length is rather weak indication of complexity.
> The typical problem being printk() with the printed info approaching
> 80 chars (but there are others, of course).

No. If someone wrote an expression too long to be understood, he will not 
understand it when maintaining his code, he burns himself and he will 
eventually learn to not write such long expressions. Or ... if he 
understands it, there is no problem with it.

There is no need to make a script for it. The script isn't so smart to 
tell what is understandable and what is nto.


All these coding-style discussions are just nit-picking. If you move the 
code up or down a few lines, it won't help anything.

The real problems of hard-to-understand code are totally different than 
"is this line too long" or "is this expression too complex".


Examples (what I personally found hard to understand):

* excessive inheritance in C++ --- if you have object->method(params), it 
is impossible to determine what is really called if the person is using 
inheritance trees deeper than two levels.

* excessively deep calls --- for example, python's module loader is 
written partially in python and partially in C and it is impossible to 
determine what is the control flow between the parts (see also the 
previous problem about inheritance). In Linux, an example is waking a 
process waiting on a bit, that calls 8 nested functions.

* excessive abstractions --- find that these two drivers have some common 
part and blast an abstraction layer with method tables in an effort to 
share these common parts. I have seen when two drivers were merged this 
way, the resulting driver was as big as those two separate drivers. What 
the sharing saved, the abstraction layer added.

* repeating the same logic again and again and not making it a macro or a 
function --- it's not seen in Linux kernel, but in other project I have 
seen the code for allocating and initializing a structure being repeated 
38 times. It's not hard to read, it's hard to modify. Linux community 
tends to be obsessive the opposite way (which leads to problems too, if 
done excessively), see the previous paragraph.

* code diffuse --- one thing at different places. An example is the Linux 
cdrom stack (ide-cd, sr, drivers/cdrom).

* constructing function names by concatenating macro arguments --- i.e. 
try to find with grep, where is "outb_p" defined.


--- and rules for code formatting fix really nothing.

Mikulas
