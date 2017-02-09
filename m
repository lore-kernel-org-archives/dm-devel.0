From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: v4.9, 4.4-final: 28 bioset threads on small notebook, 36 threads
 on cellphone
Date: Thu, 9 Feb 2017 12:25:23 -0900
Message-ID: <20170209212523.lgrgvk2squoo6x6f@moria.home.lan>
References: <20160220174035.GA16459@amd>
 <20160220184258.GA3753@amd>
 <20160220195136.GA27149@redhat.com>
 <20160220200432.GB22120@amd>
 <20170206125309.GA29395@amd>
 <20170207014724.74tb37jj7u66lww3@moria.home.lan>
 <20170207024906.4oswyuvxfnqkvbhr@moria.home.lan>
 <20170207203911.GA16980@amd>
 <20170207204510.qr2l2rg42ez2hobh@moria.home.lan>
 <20170208163407.GA3646@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170208163407.GA3646@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>, axboe@fb.com, hch@lst.de, neilb@suse.de, martin.petersen@oracle.com, dpark@posteo.net, ming.l@ssi.samsung.com, dm-devel@redhat.com, ming.lei@canonical.com, agk@redhat.com, jkosina@suse.cz, geoff@infradead.org, jim@jtan.com, pjk1939@linux.vnet.ibm.com, minchan@kernel.org, ngupta@vflare.org, oleg.drokin@intel.com, andreas.dilger@intel.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Feb 08, 2017 at 11:34:07AM -0500, Mike Snitzer wrote:
> On Tue, Feb 07 2017 at 11:58pm -0500,
> Kent Overstreet <kent.overstreet@gmail.com> wrote:
> 
> > On Tue, Feb 07, 2017 at 09:39:11PM +0100, Pavel Machek wrote:
> > > On Mon 2017-02-06 17:49:06, Kent Overstreet wrote:
> > > > On Mon, Feb 06, 2017 at 04:47:24PM -0900, Kent Overstreet wrote:
> > > > > On Mon, Feb 06, 2017 at 01:53:09PM +0100, Pavel Machek wrote:
> > > > > > Still there on v4.9, 36 threads on nokia n900 cellphone.
> > > > > > 
> > > > > > So.. what needs to be done there?
> > > > 
> > > > > But, I just got an idea for how to handle this that might be halfway sane, maybe
> > > > > I'll try and come up with a patch...
> > > > 
> > > > Ok, here's such a patch, only lightly tested:
> > > 
> > > I guess it would be nice for me to test it... but what it is against?
> > > I tried after v4.10-rc5 and linux-next, but got rejects in both cases.
> > 
> > Sorry, I forgot I had a few other patches in my branch that touch
> > mempool/biosets code.
> > 
> > Also, after thinking about it more and looking at the relevant code, I'm pretty
> > sure we don't need rescuer threads for block devices that just split bios - i.e.
> > most of them, so I changed my patch to do that.
> > 
> > Tested it by ripping out the current->bio_list checks/workarounds from the
> > bcache code, appears to work:
> 
> Feedback on this patch below, but first:
> 
> There are deeper issues with the current->bio_list and rescue workqueues
> than thread counts.
> 
> I cannot help but feel like you (and Jens) are repeatedly ignoring the
> issue that has been raised numerous times, most recently:
> https://www.redhat.com/archives/dm-devel/2017-February/msg00059.html
> 
> FYI, this test (albeit ugly) can be used to check if the dm-snapshot
> deadlock is fixed:
> https://www.redhat.com/archives/dm-devel/2017-January/msg00064.html
> 
> This situation is the unfortunate pathological worst case for what
> happens when changes are merged and nobody wants to own fixing the
> unforseen implications/regressions.   Like everyone else in a position
> of Linux maintenance I've tried to stay away from owning the
> responsibility of a fix -- it isn't working.  Ok, I'll stop bitching
> now.. I do bear responsibility for not digging in myself.  We're all
> busy and this issue is "hard".

Mike, it's not my job to debug DM code for you or sift through your bug reports.
I don't read dm-devel, and I don't know why you think I that's my job.

If there's something you think the block layer should be doing differently, post
patches - or at the very least, explain what you'd like to be done, with words.
Don't get pissy because I'm not sifting through your bug reports.

Hell, I'm not getting paid to work on kernel code at all right now, and you
trying to rope me into fixing device mapper sure makes me want to work on the
block layer more.

DM developers have a long history of working siloed off from the rest of the
block layer, building up their own crazy infrastructure (remember the old bio
splitting code?) and going to extreme lengths to avoid having to work on or
improve the core block layer infrastructure. It's ridiculous.

You know what would be nice? What'd really make my day is if just once I got a
thank you or a bit of appreciation from DM developers for the bvec iterators/bio
splitting work I did that cleaned up a _lot_ of crazy hairy messes. Or getting
rid of merge_bvec_fn, or trying to come up with a better solution for deadlocks
due to running under generic_make_request() now.
