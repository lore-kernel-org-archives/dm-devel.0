From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] Don't blacklist nvme
Date: Wed, 15 Feb 2017 20:58:43 -0500
Message-ID: <20170216015843.GA9019@redhat.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
	<941dc20e-47ba-5b9d-5082-a87ff1530cb6@sandisk.com>
	<20170214230023.GA1148@localhost.localdomain>
	<20170215145721.GB4241@infradead.org>
	<20170215172402.GA16197@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170215172402.GA16197@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 15 2017 at 12:24pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> On Wed, Feb 15, 2017 at 06:57:21AM -0800, Christoph Hellwig wrote:
> > On Tue, Feb 14, 2017 at 06:00:23PM -0500, Keith Busch wrote:
> > > Good point. I was unknowingly running with CONFIG_SCSI_DH disabled,
> > > and blissfully unaware of its existence! After enabling that option,
> > > I see what you mean.
> > 
> > Someone needs to fix that crash ASAP.  I though Hannes had patches for
> > them a long time ago in the SuSE tree, but they never went anywhere.
> 
> Adding Hannes.
> 
> I can work around this by setting the parameters from multipath-tools
> specific to NVMe, but that seems worng. Blindly calling scsi specific
> directly from dm-mpath isn't a good idea.

Right, not a good idea.  Any SCSI specific code in DM multipath needs to
be made conditional.  It has been on TODO for a while (with an eye
toward NVMe support) but testbeds are hard to come by.

All patches welcome.  But reports are also welcome, like any crash you
hit.  Just send me email and I'll fix it up best I can.

This work is very timely given NVMe over Fabrics definitely has elevated
priority.

Thanks,
Mike
