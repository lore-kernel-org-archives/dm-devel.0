From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Fix panic in 2.6 with bounced bio and dm
Date: Fri, 25 Feb 2005 16:40:45 -0800 (PST)
Message-ID: <Pine.LNX.4.58.0502251640050.9237@ppc970.osdl.org>
References: <1109351021.5014.10.camel@markh1.pdx.osdl.net>
 <20050225161947.5fd6d343.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <20050225161947.5fd6d343.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Mark Haverkamp <markh@osdl.org>, axboe@suse.de, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On Fri, 25 Feb 2005, Andrew Morton wrote:
> 
> It seems very weird for dm to be shoving NULL page*'s into the middle of a
> bio's bvec array, so your fix might end up being a workaround pending a
> closer look at what's going on in there.

Yes. I don't see how this patch can be anything but bandaid to hide the 
real bug. Where do these "non-page" bvec's originate?

		Linus
