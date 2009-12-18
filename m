From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 09:28:21 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0912180925130.3712@localhost.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
	<Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	<24653.1261110557@localhost> <m3my1g1hmr.fsf@intrepid.localdomain>
	<7004b08e0912180652p42777da3h70906f2fbdb60a69@mail.gmail.com>
	<Pine.LNX.4.64.0912181137140.23738@hs20-bc2-1.build.redhat.com>
	<alpine.LFD.2.00.0912180849080.3712@localhost.localdomain>
	<Pine.LNX.4.64.0912181203040.3223@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0912181203040.3223@hs20-bc2-1.build.redhat.com>
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
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Paul Mundt <lethal@linux-sh.org>, kevin granade <kevin.granade@gmail.com>, Alasdair G Kergon <agk@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>
List-Id: dm-devel.ids



On Fri, 18 Dec 2009, Mikulas Patocka wrote:
> 
> Function declarations are often larger than 80 characters. And if you wrap 
> them at 100, you are wasting every second line on 80-character display.

If you care so much, use a non-wrapping editor. That's what I do.

> If you make line length unlimited, the space will be used optimally on all 
> displays --- a function with 200 character declaration will use 3 lines on 
> 80-character display and 2 lines on 100-character display.

Yeah, and that's just crazy.

We all use good hardware these days, but we certainly don't have unlimited 
line length. And wrapping is ugly. So sane people (definition: "me") use 
editors that don't wrap (marking long lines at the end instead), and for 
the very rare case when I use a small terminal, I'll need to go look if I 
care (which is seldom).

> And besides --- wrapping at 100 doesn't fix the initial problem (why I 
> posted this thread) --- that making any modification to the function 
> header or long expression requires the user to manually realign the 
> arguments.

Sure. Nothing fixes the problem that you need to _occasionally_ wrap.

But the real problem is that crazy people consider checkpatch.pl to be so 
important that they wrap whether it makes sense or not.

Sense. It's what some people have. Too rare, though.

I'll happily remove the checkpatch.pl limit entirely, and ask people to 
try to use common sense, though.

		Linus
