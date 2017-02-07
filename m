From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: v4.9, 4.4-final: 28 bioset threads on small notebook, 36 threads
 on cellphone
Date: Tue, 7 Feb 2017 12:13:42 -0500
Message-ID: <20170207171341.GA29119@redhat.com>
References: <20151211104937.GA23165@amd>
 <20151211140841.GA22873@redhat.com>
 <20160220174035.GA16459@amd>
 <20160220184258.GA3753@amd>
 <20160220195136.GA27149@redhat.com>
 <20160220200432.GB22120@amd>
 <20170206125309.GA29395@amd>
 <20170207014724.74tb37jj7u66lww3@moria.home.lan>
 <20170207024906.4oswyuvxfnqkvbhr@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170207024906.4oswyuvxfnqkvbhr@moria.home.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, oleg.drokin@intel.com, ming.l@ssi.samsung.com, andreas.dilger@intel.com, martin.petersen@oracle.com, minchan@kernel.org, jkosina@suse.cz, ming.lei@canonical.com, kernel list <linux-kernel@vger.kernel.org>, jim@jtan.com, pjk1939@linux.vnet.ibm.com, axboe@fb.com, geoff@infradead.org, dm-devel@redhat.com, dpark@posteo.net, ngupta@vflare.org, hch@lst.de, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Feb 06 2017 at  9:49pm -0500,
Kent Overstreet <kent.overstreet@gmail.com> wrote:

> On Mon, Feb 06, 2017 at 04:47:24PM -0900, Kent Overstreet wrote:
> > On Mon, Feb 06, 2017 at 01:53:09PM +0100, Pavel Machek wrote:
> > > Still there on v4.9, 36 threads on nokia n900 cellphone.
> > > 
> > > So.. what needs to be done there?
> 
> > But, I just got an idea for how to handle this that might be halfway sane, maybe
> > I'll try and come up with a patch...
> 
> Ok, here's such a patch, only lightly tested:
> 
> -- >8 --
> Subject: [PATCH] block: Make rescuer threads per request_queue, not per bioset
> 
> Note: this patch is very lightly tested.
> 
> Also, trigger rescuing whenever with bios on current->bio_list, instead
> of only when we block in bio_alloc_bioset(). This is more correct, and
> should result in fewer rescuer threads.
> 
> XXX: The current->bio_list plugging needs to be unified with the
> blk_plug mechanism.
> 
> TODO: If we change normal request_queue drivers to handle arbitrary size
> bios by processing requests incrementally, instead of splitting bios,
> then we can get rid of rescuer threads from those devices.

Hi Kent,

I really appreciate you working on this further.  Thanks.

As I think you're probably already aware, a long standing issue with the
per bio_set rescuer is this bug (which manifests in dm-snapshot
deadlocks): https://bugzilla.kernel.org/show_bug.cgi?id=119841

Please also see this patch header, from a private branch from a while
ago, that describes the problem in detail:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=cd2c760b5a609e2aaf3735a7b9503a953535c368

Would welcome your consideration of that BZ as you think further and/or
iterate on this line of work.

Mike
