From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 23:35:20 +0000
Message-ID: <20091217233520.GH18217@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <20091217061229.GD3946@linux-sh.org> <m3tyvqgfs4.fsf@intrepid.localdomain> <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754873AbZLQXfd@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Dec 17, 2009 at 06:29:25PM -0500, Mikulas Patocka wrote:

> No. If someone wrote an expression too long to be understood, he will not 
> understand it when maintaining his code, he burns himself and he will 
> eventually learn to not write such long expressions. Or ... if he 
> understands it, there is no problem with it.

Yes, there is.  Somebody else trying to find a bug.  And having to
figure out which of five unfamiliar pieces of code is likelier
candidate.

> There is no need to make a script for it. The script isn't so smart to 
> tell what is understandable and what is nto.

Oh, definitely.  No arguments on that one...
