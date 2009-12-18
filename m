From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scripts/checkpatch.pl: Change long line warning to 105
 chars
Date: Fri, 18 Dec 2009 09:54:44 -0800
Message-ID: <1261158884.24328.37.camel@Joe-Laptop.home>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	 <20091217061229.GD3946@linux-sh.org> <m3tyvqgfs4.fsf@intrepid.localdomain>
	 <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	 <24653.1261110557@localhost> <1261113144.13734.317.camel@Joe-Laptop.home>
	 <20091218055712.GA4186@linux-sh.org>
	 <alpine.LFD.2.00.0912180942480.3712@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755305AbZLRRyr@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0912180942480.3712@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Valdis.Kletnieks@vt.edu, Andy Whitcroft <apw@canonical.com>, Andrew Morton <akpm@linux-foundation.org>, Mikulas Patocka <mpatocka@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 2009-12-18 at 09:43 -0800, Linus Torvalds wrote:
> I like this. Except I think the indent test should count spaces too some 
> way. Or do we already warn about excessive space that should be tabs?

Andy's the checkpatch guy to verify this but:

There's a separate test for spaces that should be tabs.

If you had a 64 space indent and ran the silly script,
it'd complain about the spaces.

If you converted the spaces to tabs and ran the silly
script again with --strict, it'd complain about the
indent depth.
