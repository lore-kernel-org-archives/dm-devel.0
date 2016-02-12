From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RCU-ified dm-mpath for testing/review
Date: Fri, 12 Feb 2016 13:00:32 -0500
Message-ID: <20160212180032.GA14013@redhat.com>
References: <20160207172055.GA6477@redhat.com> <56B99A49.5050400@suse.de>
	<20160209145547.GA21623@redhat.com> <56BA0689.9030007@suse.de>
	<20160210004518.GA23646@redhat.com>
	<20160211015030.GA4481@redhat.com>
	<20160211153452.GA7827@redhat.com> <56BDF7D7.8040106@suse.de>
	<20160212152651.GB11104@redhat.com> <56BE0295.4090809@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56BE0295.4090809@suse.de>
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

On Fri, Feb 12 2016 at 11:04am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 02/12/2016 04:26 PM, Mike Snitzer wrote:
> >On Fri, Feb 12 2016 at 10:18am -0500,
> >Hannes Reinecke <hare@suse.de> wrote:
> >>>
> >>Good news is that I've managed to hit the roof for my array with the
> >>devel2 version of those patches. (And a _heavily_ patched-up lpfc
> >>driver :-)
> >>So from that perspective everything's fine now; we've reached the
> >>hardware limit for my setup.
> >>Which in itself is quite impressive; beating Intel P3700 with 16FC
> >>is not bad methinks :-)
> >>
> >>So thanks for all your work here.
> >
> >Ah, that's really good news!  But devel2 is definitely _not_ destined
> >for upstream.  'devel3' is much closer to "ready".  But your testing and
> >review would really push it forward.
> >
> >Please see/test:
> >http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel3
> >
> >Also, please read this header:
> >http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=devel3&id=65a01b76502dd68e8ca298ee6614c0151b677f4a
> >
> >Even with devel2 I hacked it such that repeat_count > 1 is effectively
> >broken.  I'm now _seriously_ considering deprecating repeat_count
> >completely (adding a DMWARN that will inform the user. e.g.:
> >"repeat_count > 1 is no longer supported").  I see no point going to
> >great lengths to maintain a dm-mpath feature that was only a hack for
> >when dm-mpath was bio-based.  What do you think?
>
> Drop it, and make setting of which a no-op.
> Never liked it anyway, and these decisions should really be
> delegated to the path selector.

Sure, but my point is DM-mpath will no longer be able to provide the
ability to properly handle repeat_count > 1 (because updating the
->current_pgpath crushes the write-side of the RCU).

As such I've rebased 'devel3' to impose repeat_count = 1 (both in
dm-mpath.c and the defaults in each path selector).
