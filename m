From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcache super block corruption with non 4k pages
Date: Tue, 26 Jul 2016 02:21:48 -0800
Message-ID: <20160726102148.GA20130@kmo-pixel>
References: <1469091513-11233-1-git-send-email-stefan.bader@canonical.com>
 <fce2a0a9-47d1-a052-997c-b14cd62dcf46@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fce2a0a9-47d1-a052-997c-b14cd62dcf46@canonical.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-bcache@vger.kernel.org, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, liuzhengyuang521@gmail.com, bcache@linux.ewheeler.net, apw@canonical.com
List-Id: dm-devel.ids

On Tue, Jul 26, 2016 at 11:51:25AM +0200, Stefan Bader wrote:
> On 21.07.2016 10:58, Stefan Bader wrote:
> > I was pointed at the thread which seems to address the same after
> > I wrote most of below text. Did not want to re-write this so please
> > bear with the odd layout.
> > 
> > https://www.redhat.com/archives/dm-devel/2016-June/msg00015.html
> > 
> > Zhengyuan tries to fix the problem by relocating the superblock on
> > disk. But I am not sure whether there is really any guarantee about
> > how __bread fills data into the buffer_head. What if there is the next
> > odd arch with 128K pages?
> > 
> > So below is an attempt to be more generic. Still I don't feel completely
> > happy with the way that a page moves (or is shared) between buffer_head
> > and biovec. What I tried to outline below is to let the register functions
> > allocate bio+biovec memory and use the in-memory sb_cache data to initialize
> > the biovec buffer.
> 
> Any opinions here? Also adding LKML as I don't seem to get through moderation on
> dm-devel.

The correct solution is to rip out the __bread() and just read the superblock by
issuing a bio, the same way all the other IO in bcache is done.

This is the way it's done in the bcache-dev branch - unfortunately, the patch
that does that in bcache-dev is big and invasive and probably not worth the
hassle to backport:

https://evilpiepirate.org/git/linux-bcache.git/commit/?h=bcache-dev&id=303eb67bffad57b4d9e71523e7df04bf258e66d1

Probably best to just do something small and localized.
