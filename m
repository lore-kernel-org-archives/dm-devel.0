From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 4/7] scsi_dh: Update EMC handler
Date: Fri, 16 May 2008 11:38:40 -0700
Message-ID: <1210963120.21974.336.camel@chandra-ubuntu>
References: <20080514144324.3000410B5DF@craiglockhart-ipmi.suse.de>
	 <1210819629.21974.255.camel@chandra-ubuntu>  <482BEFAC.7030400@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <482BEFAC.7030400@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Thu, 2008-05-15 at 10:09 +0200, Hannes Reinecke wrote:
> Hi Chandra,
> 
> Chandra Seetharaman wrote:
> > On Wed, 2008-05-14 at 16:43 +0200, Hannes Reinecke wrote:
> > <snip>
> > 
> >> @@ -438,10 +604,32 @@ static int clariion_bus_attach(struct scsi_device *sdev)
> >>  	sdev->scsi_dh_data = scsi_dh_data;
> >>  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> >>
> > Can move the block above to be just before try_module_get() and avoid
> > undoing it in the failed path.
> > 
> Hmm. Yes, we could. But that means I have to pass the scsi_dh_data structure
> to basically every function.
> Let me check how this pans out.

Yeah, it is a catch-22 problem. I will think about it too.

> 
> Cheers,
> 
> Hannes

