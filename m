From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 09:34:35 +0100
Message-ID: <m3tyvqgfs4.fsf@intrepid.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764141AbZLQIeo@vger.kernel.org>
In-Reply-To: <20091217061229.GD3946@linux-sh.org> (Paul Mundt's message of
	"Thu, 17 Dec 2009 15:12:30 +0900")
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Mundt <lethal@linux-sh.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Paul Mundt <lethal@linux-sh.org> writes:

> For starters, this is just crap. If you're writing code like this, then
> line wrapping is really the least of your concerns. Take your function
> return value and assign it to a variable before testing it in unlikely()
> as per existing conventions and most of this goes away in this example.
> If you're testing an absurd amount of conditions in a single block with
> needlessly verbose variable names, then yes, you will go over 80
> characters. Consequently, your "clean" example doesn't look much better
> than your purposely obfuscated one.

Then perhaps checkpatch should warn about too complex expressions
instead? Line length is rather weak indication of complexity.
The typical problem being printk() with the printed info approaching
80 chars (but there are others, of course).

BTW I remember we have already agreed that the 80-chars limit is a bad
thing, though apparently nobody bothered to fix the docs and checkpatch.

> The 80 character limit isn't a hard limit, but it's still an excellent
> guideline largely because it stops people from writing code like in your
> above example.

What is more important is it stops people from writing a perfectly
readable code, forcing them to make the code (much) worse.

> Some amount of common sense is necessary, and most
> people in a position of applying patches can work out when to ignore
> checkpatch and when not to.

Precisely - we need common sense instead of artificial limits which are
almost unrelated to the actual problem.

> Aiming to keep things around 80 characters has served us well over the
> years,

I don't think so. I think it made more harm than good. Some people
routinely ignore this "!!!!! ERROR !!!!!" but a large part of developers
make the code (sometimes much) worse for this very reason.
Fortunately the patches are reviewed.

> One only has to take a look through some of the
> staging/ drivers pre-cleanup efforts for examples that clearly benefit
> from triggering these warnings rather than implicitly supporting insane
> tab depths.

Checkpatch doesn't check for sane/insane tab depths. It's not that
trivial. Unfortunately, checking line length is a very poor substitute.

Yes, checkpatch probably could warn about having many long lines (though
I wouldn't mention the "80" number). But it should be clear it's not
about the length but about (possible) complexity.
-- 
Krzysztof Halasa
