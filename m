From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Fix panic in 2.6 with bounced bio and dm
Date: Sat, 26 Feb 2005 13:39:39 +0100
Message-ID: <20050226123934.GA1254@suse.de>
References: <1109351021.5014.10.camel@markh1.pdx.osdl.net>
	<20050225161947.5fd6d343.akpm@osdl.org>
	<Pine.LNX.4.58.0502251640050.9237@ppc970.osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0502251640050.9237@ppc970.osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Feb 25 2005, Linus Torvalds wrote:
> 
> 
> On Fri, 25 Feb 2005, Andrew Morton wrote:
> > 
> > It seems very weird for dm to be shoving NULL page*'s into the middle of a
> > bio's bvec array, so your fix might end up being a workaround pending a
> > closer look at what's going on in there.
> 
> Yes. I don't see how this patch can be anything but bandaid to hide the 
> real bug. Where do these "non-page" bvec's originate?

Yep that's the fishy part, there should not be NULL pages in the middle
(or empty bios, for that matter) submitted for io.

Mark, what was the bug that triggered you to write this patch?

-- 
Jens Axboe
