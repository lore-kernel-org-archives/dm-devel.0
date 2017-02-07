From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: v4.9, 4.4-final: 28 bioset threads on small notebook, 36 threads
 on cellphone
Date: Mon, 6 Feb 2017 16:47:24 -0900
Message-ID: <20170207014724.74tb37jj7u66lww3@moria.home.lan>
References: <20151211104937.GA23165@amd>
 <20151211140841.GA22873@redhat.com>
 <20160220174035.GA16459@amd>
 <20160220184258.GA3753@amd>
 <20160220195136.GA27149@redhat.com>
 <20160220200432.GB22120@amd>
 <20170206125309.GA29395@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170206125309.GA29395@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Mike Snitzer <snitzer@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, axboe@fb.com, hch@lst.de, neilb@suse.de, martin.petersen@oracle.com, dpark@posteo.net, ming.l@ssi.samsung.com, dm-devel@redhat.com, ming.lei@canonical.com, agk@redhat.com, jkosina@suse.cz, geoff@infradead.org, jim@jtan.com, pjk1939@linux.vnet.ibm.com, minchan@kernel.org, ngupta@vflare.org, oleg.drokin@intel.com, andreas.dilger@intel.com
List-Id: dm-devel.ids

On Mon, Feb 06, 2017 at 01:53:09PM +0100, Pavel Machek wrote:
> On Sat 2016-02-20 21:04:32, Pavel Machek wrote:
> > Hi!
> > 
> > > > > > > I know it is normal to spawn 8 threads for every single function,
> > > > > > ...
> > > > > > > but 28 threads?
> > > > > > > 
> > > > > > > root       974  0.0  0.0      0     0 ?        S<   Dec08   0:00 [bioset]
> > > > > > ...
> > > > > > 
> > > > > > How many physical block devices do you have?
> > > > > > 
> > > > > > DM is doing its part to not contribute to this:
> > > > > > dbba42d8a ("dm: eliminate unused "bioset" process for each bio-based DM device")
> > > > > > 
> > > > > > (but yeah, all these extra 'bioset' threads aren't ideal)
> > > > > 
> > > > > Still there in 4.4-final.
> > > > 
> > > > ...and still there in 4.5-rc4 :-(.
> > > 
> > > You're directing this concern to the wrong person.
> > > 
> > > I already told you DM is _not_ contributing any extra "bioset" threads
> > > (ever since commit dbba42d8a).
> > 
> > Well, sorry about that. Note that l-k is on the cc list, so hopefully
> > the right person sees it too.
> > 
> > Ok, let me check... it seems that 
> > 54efd50bfd873e2dbf784e0b21a8027ba4299a3e is responsible, thus Kent
> > Overstreet <kent.overstreet@gmail.com> is to blame.
> > 
> > Um, and you acked the patch, so you are partly responsible.
> 
> Still there on v4.9, 36 threads on nokia n900 cellphone.
> 
> So.. what needs to be done there?

So background:

We need rescuer threads because:

Say you allocate a bio from a bioset, submit that bio, and then allocate again
from that same bioset: if you're running underneath generic_make_request(),
you'll deadlock. Real submission of the first bio you allocated is blocked until
you return from your make_request_fn(), but you're blocking that trying to
allocate - this is handled (in a hacky way!) with the punt_bios_to_rescuer code
when we go to allocate from a bioset but have to block.

We need more than a single global rescuer, because:

The rescuer thread is just resubmitting bios, so if in the course of submitting
bios, _their_ drivers allocate new bios from biosets and block - oops, we're
recursing.

However:

The rescuer threads don't inherently need to be per bioset - they really ought
to be per block device.

Additionally, triggering the "punt bios to rescuer" code only when we go to
allocate from a bioset and block is wrong: it's possible to create these sorts
of deadlocks by blocking on other things. The right thing to do would be to
trigger this "punt bios to rescuer" thing whenever we schedule, and there's
still bios on current->bio_list.

This is actually how Jens's new(er) plugging code works (which post dates my
punt bios to rescuer hack). What needs to happen is Jens's scheduler hook for
block plugging needs to be be unified with both the current->bio_list thing
(which is really a block plug, just open coded, as it predates _all_ of this)
and the rescuer thread stuff.

The tricky part is going to be making the rescuer threads per block device
_correctly_ (without introducing new deadlocks)... reasoning out these deadlocks
always makes my head hurt, the biggest reason I made the rescuer threads per
bioset was that when I wrote the code I wasn't at all confident I could get
anything else right. Still uneasy about that :)

What needs rescuer threads?

- if we're allocating from a bioset, but we're not running under
  generic_make_request() (e.g. we're in filesystem code) - don't need a rescuer
  there, we're not blocking previously allocated bios from being submitted.

- if we're a block driver that doesn't allocate new bios, we don't need a
  rescuer thread.

  But note that any block driver that calls blk_queue_split() to handle
  arbitrary size bios is allocating bios. If we converted e.g. the standard
  request queue code to process bios/requests incrementally, instead of
  requiring them to be split, this would go away (and that's something that
  should be done anyways, it would improve performance by getting rid of segment
  counting).

So, we should only need one rescuer thread per block device - and if we get rid
of splitting to handle arbitrary size bios, most block devices won't need
rescuers.

The catch is that the correct rescuer to punt a bio to corresponds to the device
that _issued_ the bio, not the device the bio was submitted to, and that
information is currently lost by the time we block - that's the other reason I
made rescuers per bioset, since bios do track the bioset they were allocated
from.

But, I just got an idea for how to handle this that might be halfway sane, maybe
I'll try and come up with a patch...
