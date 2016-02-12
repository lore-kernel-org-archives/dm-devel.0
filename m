From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RCU-ified dm-mpath for testing/review
Date: Fri, 12 Feb 2016 10:26:51 -0500
Message-ID: <20160212152651.GB11104@redhat.com>
References: <56B77444.3030106@dev.mellanox.co.il>
	<56B776DE.30101@dev.mellanox.co.il>
	<20160207172055.GA6477@redhat.com> <56B99A49.5050400@suse.de>
	<20160209145547.GA21623@redhat.com> <56BA0689.9030007@suse.de>
	<20160210004518.GA23646@redhat.com>
	<20160211015030.GA4481@redhat.com>
	<20160211153452.GA7827@redhat.com> <56BDF7D7.8040106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56BDF7D7.8040106@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "keith.busch@intel.com" <keith.busch@intel.com>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Fri, Feb 12 2016 at 10:18am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 02/11/2016 04:34 PM, Mike Snitzer wrote:
> > On Wed, Feb 10 2016 at  8:50pm -0500,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> >> On Tue, Feb 09 2016 at  7:45pm -0500,
> >> Mike Snitzer <snitzer@redhat.com> wrote:
> >>
> >>>
> >>> OK, I took a crack at embracing RCU.  Only slightly better performance
> >>> on my single NUMA node testbed.  (But I'll have to track down a system
> >>> with multiple NUMA nodes to do any justice to the next wave of this
> >>> optimization effort)
> >>>
> >>> This RCU work is very heavy-handed and way too fiddley (there could
> >>> easily be bugs).  Anyway, please see:
> >>> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=devel2&id=d80a7e4f8b5be9c81e4d452137623b003fa64745
> >>>
> >>> But this might give you something to build on to arrive at something
> >>> more scalable?
> >>
> >> I've a bit more polished version of this work (broken up into multiple
> >> commits, with some fixes, etc) here:
> >> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel3
> >>
> >> Hannes and/or Sagi, if you get a chance to try this on your NUMA system
> >> please let me know how it goes.
> > 
> > Initial review has uncovered some locking problems with the current code
> > (nothing that caused crashes or hangs in my testing but...) so please
> > hold off on testing until you hear from me (hopefully tomorrow).
> > 
> Good news is that I've managed to hit the roof for my array with the
> devel2 version of those patches. (And a _heavily_ patched-up lpfc
> driver :-)
> So from that perspective everything's fine now; we've reached the
> hardware limit for my setup.
> Which in itself is quite impressive; beating Intel P3700 with 16FC
> is not bad methinks :-)
> 
> So thanks for all your work here.

Ah, that's really good news!  But devel2 is definitely _not_ destined
for upstream.  'devel3' is much closer to "ready".  But your testing and
review would really push it forward.

Please see/test:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel3

Also, please read this header:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=devel3&id=65a01b76502dd68e8ca298ee6614c0151b677f4a

Even with devel2 I hacked it such that repeat_count > 1 is effectively
broken.  I'm now _seriously_ considering deprecating repeat_count
completely (adding a DMWARN that will inform the user. e.g.:
"repeat_count > 1 is no longer supported").  I see no point going to
great lengths to maintain a dm-mpath feature that was only a hack for
when dm-mpath was bio-based.  What do you think?

Thanks,
Mike
