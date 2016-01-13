From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 0/2] Introduce the bulk IV mode for improving
 the crypto engine efficiency
Date: Wed, 13 Jan 2016 10:00:21 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1601130816560.11671@file01.intranet.prod.int.rdu2.redhat.com>
References: <cover.1450233399.git.baolin.wang@linaro.org> <5514385.nEhTK7fEcU@wuerfel> <alpine.LRH.2.02.1601122113240.24452@file01.intranet.prod.int.rdu2.redhat.com> <49336038.lhIkHu2mkF@wuerfel>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49336038.lhIkHu2mkF@wuerfel>
Sender: linux-raid-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: device-mapper development <dm-devel@redhat.com>, Mark Brown <broonie@kernel.org>, Milan Broz <gmazyland@gmail.com>, Jens Axboe <axboe@kernel.dk>, keith.busch@intel.com, linux-raid@vger.kernel.org, martin.petersen@oracle.com, Mike Snitzer <snitzer@redhat.com>, Baolin Wang <baolin.wang@linaro.org>, linux-block@vger.kernel.org, neilb@suse.com, LKML <linux-kernel@vger.kernel.org>, sagig@mellanox.com, tj@kernel.org, dan.j.williams@intel.com, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Wed, 13 Jan 2016, Arnd Bergmann wrote:

> On Tuesday 12 January 2016 21:18:12 Mikulas Patocka wrote:
> > On Wed, 13 Jan 2016, Arnd Bergmann wrote:
> > 
> > > On Tuesday 12 January 2016 18:31:19 Mikulas Patocka wrote:
> > > > 
> > > > Another possibility is to use dm-crypt block size 4k and use a filesystem 
> > > > with 4k blocksize on it (it will never send requests not aligned on 4k 
> > > > boundary, so we could reject such requests with an error).
> > > 
> > > Is there ever a reason to use something other than 4K block size on
> > > dm-crypt?
> > > 
> > >       Arnd
> > 
> > You can't use 4k block on CBC (and most other encryption modes). If only a 
> > part of 4k block is written (and then system crash happens), CBC would 
> > corrupt the block completely.
> > 
> > For example, suppose that EXT2 directory block is updated, the first 
> > 512-byte sector is written and the rest of the sectors is not written 
> > because of a crash. CBC would corrupt all sectors except the first one in 
> > this case.
> > 
> > You could use 4k block on XTS and ECB.
> 
> Ah, I did not know that ext2 was doing sub-block writes. This may be

Ext2 is not doing sub-block writes.

Generally, disks and SSDs do not guarantee 4k write atomicity (only disks 
with hardware 4k sector guarantee it).

For example, ext2 writes a full 4k block, only part of the block is 
written to the disk and then power failure happens. On the next reboot CBC 
will corrupt the unwritten part of the 4k block.

Mikulas

> something to address in the ext4 code (and other file systems), as
> a lot of flash storage devices (SD cards and eMMC) get really slow
> when you do writes smaller than 4K because of the internal
> read-modify-write cycle. Ideally you want to always drive those
> using 64K writes (for reads, it doesn't matter much).
> 
> For hard drives, there are still a couple of older models that have
> native 512 byte sectors, but the majority of new drivers also
> prefers 4K writes. SSDs are typically optimized for 4K writes because
> that is what they expect software to do, but they use larger writes
> internally.
> 
> 	Arnd
> 
