From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: linux-next: Tree for August 27
Date: Fri, 29 Aug 2008 21:23:07 +0200
Message-ID: <200808292123.07246.bzolnier@gmail.com>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <48B7C361.9070008@kernel.org> <20080829094249.GQ20055@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20080829094249.GQ20055@kernel.dk>
Content-Disposition: inline
Sender: linux-next-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, dm-devel@redhat.com
List-Id: dm-devel.ids


Hi,

On Friday 29 August 2008, Jens Axboe wrote:
> On Fri, Aug 29 2008, Tejun Heo wrote:
> > Jens Axboe wrote:
> > >> On the somehow related topic - CONFIG_DEBUG_BLOCK_EXT_DEVT which is
> > >> introduced by commit 3e5ba59bbab878f60b8b87004ac55a464bddc819 ("block:
> > >> implement CONFIG_DEBUG_BLOCK_EXT_DEVT") is way too intrusive to be
> > >> enabled by default if CONFIG_DEBUG_KERNEL is set as it easily results
> > >> in no longer bootable systems (+ help entry for the new option says
> > >> "Say N if you are unsure.").
> > >>
> > >> Tejun/Jens: please consider changing this.
> > > 
> > > I have change the default to 'n' for now.
> > 
> > Hmmm... it broke booting?  Bart, can you please elaborate a bit what got
> > broken?  Did it fail to locate the root partition or were you using
> > static device nodes?
> 
> It works fine for me, fwiw.

It fails to locate the root partition if you are using the default root
device on x86 (the one hard-wired into bzImage, it uses hard-coded 8-bit
major/minor numbers).

Now I see that the issue is easily fixed by passing the root device name
with "root=" (since it will figure out the actual major/minor numbers
later) and that the default root device is said to be deprecated according
to Documentation/x86/boot.txt (OTOH there is no warning at all that it is
deprecated and that you should be using "root=" so I'm not convinced that
I'm the only one who would hit the unfortunate combination).

Actually it seems that CONFIG_DEBUG_BLOCK_EXT_DEVT introduction (which I
think is a nice step forward) is a good oportunity to put the deprecation
of the default root device further, i.e. it may be worth to hook the
default root device check and/or CONFIG_DEBUG_BLOCK_EXT_DEVT one into
mount_block_root().

Thanks,
Bart
