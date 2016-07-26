From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcache super block corruption with non 4k pages
Date: Tue, 26 Jul 2016 04:49:18 -0800
Message-ID: <20160726124918.GA15102@kmo-pixel>
References: <1469091513-11233-1-git-send-email-stefan.bader@canonical.com>
 <fce2a0a9-47d1-a052-997c-b14cd62dcf46@canonical.com>
 <20160726102148.GA20130@kmo-pixel>
 <e09788a2-71f4-96ff-cca4-943c1bc1d9bb@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e09788a2-71f4-96ff-cca4-943c1bc1d9bb@canonical.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-bcache@vger.kernel.org, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, liuzhengyuang521@gmail.com, bcache@linux.ewheeler.net, apw@canonical.com
List-Id: dm-devel.ids

On Tue, Jul 26, 2016 at 02:32:31PM +0200, Stefan Bader wrote:
> On 26.07.2016 12:21, Kent Overstreet wrote:
> > On Tue, Jul 26, 2016 at 11:51:25AM +0200, Stefan Bader wrote:
> >> On 21.07.2016 10:58, Stefan Bader wrote:
> >>> I was pointed at the thread which seems to address the same after
> >>> I wrote most of below text. Did not want to re-write this so please
> >>> bear with the odd layout.
> >>>
> >>> https://www.redhat.com/archives/dm-devel/2016-June/msg00015.html
> >>>
> >>> Zhengyuan tries to fix the problem by relocating the superblock on
> >>> disk. But I am not sure whether there is really any guarantee about
> >>> how __bread fills data into the buffer_head. What if there is the next
> >>> odd arch with 128K pages?
> >>>
> >>> So below is an attempt to be more generic. Still I don't feel completely
> >>> happy with the way that a page moves (or is shared) between buffer_head
> >>> and biovec. What I tried to outline below is to let the register functions
> >>> allocate bio+biovec memory and use the in-memory sb_cache data to initialize
> >>> the biovec buffer.
> >>
> >> Any opinions here? Also adding LKML as I don't seem to get through moderation on
> >> dm-devel.
> > 
> > The correct solution is to rip out the __bread() and just read the superblock by
> > issuing a bio, the same way all the other IO in bcache is done.
> > 
> > This is the way it's done in the bcache-dev branch - unfortunately, the patch
> > that does that in bcache-dev is big and invasive and probably not worth the
> > hassle to backport:
> > 
> > https://evilpiepirate.org/git/linux-bcache.git/commit/?h=bcache-dev&id=303eb67bffad57b4d9e71523e7df04bf258e66d1
> 
> I agree that this looks better and also rather large.
> > 
> > Probably best to just do something small and localized.
> > 
> So what did you think about the change I did? It seemed to be ok for 4K and 64K
> at least and is rather small. And I believe that, compared to Zhengyuan's
> approach this would have the benefit of not changing the superblock sector. So
> it would be compatible with previously created superblocks.

Too ugly to live. Just kmalloc() 4k, allocate a bio on the stack, set it up, and
submit it with submit_bio_wait(). Use virt_to_page(), don't bother with raw
pages - you want 4k, not whatever the page size is.
