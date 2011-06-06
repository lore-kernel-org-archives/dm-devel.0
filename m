From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: dm-cache module
Date: Mon, 06 Jun 2011 12:06:34 +0200
Message-ID: <1307354794.752.7.camel@o>
References: <4BA5623F.8040502@daevel.fr> <20100321033704.GA6448@redhat.com>
	<15606e421003202156n21de56a6n868f84bf737cce51@mail.gmail.com>
	<1269270327.21395.42.camel@o>  <4BD7906E.6010602@daevel.fr>
	<1272442907.2031.79.camel@o> <1272463344.2031.91.camel@o>
	<4DE93315.3090903@cfl.rr.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4DE93315.3090903@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Phillip Susi <psusi@cfl.rr.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2011-06-03 at 15:16 -0400, Phillip Susi wrote:
> What ever came of this?  It doesn't look like either competing cache 
> target has made it into mainline yet.

Right.

We are working on a device-mapper caching target which shares code for
block, btree and transaction management with thin provisioning and
multiple snapshot targets which are aiming to go upstream shortly. This
is aiming at code sharing rather than distinct implementations of the
aforementioned functionalities.
All of those will receive LVM2 support as we go.

Heinz

> 
> It looks like two caching systems have made it into mainline, but 
> neither are usable for having an ssd cache a large hard disk. 
> CleanCache isn't usable because it does not have a backend that can use 
> a block device to hold the cache, and FsCache is only supported by nfs 
> and cifs.
> 
> Apparently Intel has added the ability to use an SSD to cache a big hard 
> disk to their matrix storage fakeraid in the new Z68 chipset and it is 
> generating a good deal of interest.  It would be nice to be able to do 
> something similar in Linux.
> 
> On 4/28/2010 10:02 AM, Heinz Mauelshagen wrote:
> > Olivier,
> >
> > some initial impressions:
> >
> > I've spent an hour porting the source code to 2.6.34-rc4 and doing first
> > tests.
> >
> > Those unveil, that it only works with cache block size equal to page
> > size (4KB here). With large cache block sizes it doesn't cache at all.
> >
> > That may well be the result of a porting flaw but I have to have a
> > closer look to tell. It works with quite decent performance with that
> > block size. Code looks like heavily derived from the dm-cache source and
> > overly complicated.
> >
> > Destroying a flashcache mapping with a large dirty cache flushs the
> > whole dirty content out which is not suitable to practical dm needs
> > requiring a mapping to be suspendable quickly during reconfiguration.
> >
> > Regards,
> > Heinz
> >
> > On Wed, 2010-04-28 at 10:21 +0200, Heinz Mauelshagen wrote:
> >> On Wed, 2010-04-28 at 03:33 +0200, Olivier B. wrote:
> >>> On 22/03/2010 16:05, Heinz Mauelshagen wrote:
> >>>> On Sun, 2010-03-21 at 00:56 -0400, Ming Zhao wrote:
> >>>>
> >>>>> Hi Mike,
> >>>>>
> >>>>> Thank you very much for your advice!
> >>>>>
> >>>>> I can revise dm-cache code and resubmit it as you suggested. I would
> >>>>> also love to know Heinz's progress on his implementation and work with
> >>>>> him if there anything I could contribute.
> >>>>>
> >>>> Hi all,
> >>>>
> >>>> this is a list of the functions of my dm-hstore
> >>>> device-mapper target implementation:
> >>>>
> >>>> o caches reads and writes keeping persistent state metadata.
> >>>> o writes back in order to enhance streaming performance
> >>>>     on fragmented access pattern.
> >>>> o can run on top of readonly original device
> >>>> o if so, writes back any dirty areas when set readwrite
> >>>>     (useful for tests)
> >>>> o readonly<->   readwrite access changes supported via message interface
> >>>> o initializes metadata for extents in cache in the background
> >>>>     in order to fasten cache construction
> >>>> o supports cache resizing via message interface or constructor
> >>>> o keeps metadata persistent by default
> >>>> o stores CRCs with metadata for integrity checks
> >>>> o stores versions with metadata to support future metadata migration
> >>>>
> >>>> Test features only:
> >>>> o transient cache
> >>>> o cache write through
> >>>>
> >>>>
> >>>> Provides very good performance on SSD cache backing stores.
> >>>>
> >>>> Has been shelved for a while because of other priorities so I need to
> >>>> rebase it to the actual kernel.
> >>>>
> >>>> Regards,
> >>>> Heinz
> >>>>
> >>>>
> >>> Hi,
> >>>
> >>> Facebook have just released "FlashCache" :
> >>> http://github.com/facebook/flashcache
> >>> in the documentation we can read :
> >>
> >>> Flashcache is built using the Linux Device Mapper (DM), part of the
> >>> Linux Storage Stack infrastructure that facilitates building SW-RAID and
> >>> other components.
> >>>
> >>> So it's an other implementation of the same concept, no ?
> >>
> >> Yes, it looks like it. I'll have a closer look how it differs form mine.
> >>
> >> Heinz
