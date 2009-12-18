From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] scripts/checkpatch.pl: Change long line warning to 105 chars
Date: Fri, 18 Dec 2009 19:41:50 +0100
Message-ID: <871visuntd.fsf@basil.nowhere.org>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
	<Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	<24653.1261110557@localhost>
	<1261113144.13734.317.camel@Joe-Laptop.home>
	<20091218055712.GA4186@linux-sh.org>
	<alpine.LFD.2.00.0912180942480.3712@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932337AbZLRSmA@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0912180942480.3712@localhost.localdomain> (Linus Torvalds's message of "Fri, 18 Dec 2009 09:43:49 -0800 (PST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Joe Perches <joe@perches.com>, Valdis.Kletnieks@vt.edu, Andy Whitcroft <apw@canonical.com>, Andrew Morton <akpm@linux-foundation.org>, Mikulas Patocka <mpatocka@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Linus Torvalds <torvalds@linux-foundation.org> writes:

>
> I like this. Except I think the indent test should count spaces too some 
> way. Or do we already warn about excessive space that should be tabs?

checkpatch warns about those.

(it triggers for me all the time because those happen when you 
copy patch reject blocks from hand and remove the leading character
without removing the space afterwards)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
