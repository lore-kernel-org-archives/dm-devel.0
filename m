From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 12:09:28 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0912181203040.3223@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
	<Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	<24653.1261110557@localhost> <m3my1g1hmr.fsf@intrepid.localdomain>
	<7004b08e0912180652p42777da3h70906f2fbdb60a69@mail.gmail.com>
	<Pine.LNX.4.64.0912181137140.23738@hs20-bc2-1.build.redhat.com>
	<alpine.LFD.2.00.0912180849080.3712@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0912180849080.3712@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Paul Mundt <lethal@linux-sh.org>, kevin granade <kevin.granade@gmail.com>, Alasdair G Kergon <agk@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>
List-Id: dm-devel.ids

On Fri, 18 Dec 2009, Linus Torvalds wrote:

> On Fri, 18 Dec 2009, Mikulas Patocka wrote:
> >
> > But think what happens when someone views that 100-char code on 80-char 
> > terminal (or for example 94-char, that I used for some times too) --- 
> > every second line will be wasted with just 20 characters on the left.
> 
> What kind of CRAZY crap argument is that?
> 
> The current rule is 80 characters - but how many lines are actually even 
> close to 80 characters long? Very few.
> 
> So that "every second line" statement is pure and utter idiocy. Instead, 
> what you get is totally the reverse: instead of wasting two lines _anyway_ 
> due to a hard-newline, you often get a single line instead (since most of 
> us don't work in 24x80 windows to begin with).
> 
> 			Linus

Function declarations are often larger than 80 characters. And if you wrap 
them at 100, you are wasting every second line on 80-character display.

If you make line length unlimited, the space will be used optimally on all 
displays --- a function with 200 character declaration will use 3 lines on 
80-character display and 2 lines on 100-character display.

And besides --- wrapping at 100 doesn't fix the initial problem (why I 
posted this thread) --- that making any modification to the function 
header or long expression requires the user to manually realign the 
arguments.

Mikulas
