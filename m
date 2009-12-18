From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] scripts/checkpatch.pl: Change long line warning to 105
 chars
Date: Fri, 18 Dec 2009 09:43:49 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0912180942480.3712@localhost.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <20091217061229.GD3946@linux-sh.org> <m3tyvqgfs4.fsf@intrepid.localdomain> <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com> <24653.1261110557@localhost>
 <1261113144.13734.317.camel@Joe-Laptop.home> <20091218055712.GA4186@linux-sh.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932321AbZLRRox@vger.kernel.org>
In-Reply-To: <20091218055712.GA4186@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Mundt <lethal@linux-sh.org>
Cc: Joe Perches <joe@perches.com>, Valdis.Kletnieks@vt.edu, Andy Whitcroft <apw@canonical.com>, Andrew Morton <akpm@linux-foundation.org>, Mikulas Patocka <mpatocka@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids



On Fri, 18 Dec 2009, Paul Mundt wrote:

> On Thu, Dec 17, 2009 at 09:12:24PM -0800, Joe Perches wrote:
> > On Thu, 2009-12-17 at 23:29 -0500, Valdis.Kletnieks@vt.edu wrote:
> > > Yeah, but I respectfully submit that if the regexp '^\t{6}' matches a non-
> > > continuation line, it's probably in its rights to whinge. 
> > > 	grep -r -P '^\t{7:}(?!(.*,$|.*\);$))' . | more
> > > produces a whole lot of "this can't end well" output.
> > 
> > I think this is a good test to add to checkpatch.
> > 
> > Add 105 character long line WARN test
> > Add 80 character long line STRICT test
> > Add 6+ leading indent tabs test, consider restructuring
> > 
> This looks like a reasonable compromise.

I like this. Except I think the indent test should count spaces too some 
way. Or do we already warn about excessive space that should be tabs?

		Linus
