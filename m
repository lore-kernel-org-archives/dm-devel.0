From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/9] scsi_dh: Implement common device table handling
Date: Thu, 26 Jun 2008 07:41:03 -0700
Message-ID: <1214491263.31845.0.camel@chandra-ubuntu>
References: <20080624100349.06F5A10B5DE@craiglockhart-ipmi.suse.de>
	 <1214441566.32521.10.camel@chandra-ubuntu>  <48638F7C.9090602@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <48638F7C.9090602@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

Great then.

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Thu, 2008-06-26 at 14:45 +0200, Hannes Reinecke wrote:
> Hi Chandra,
> 
> Chandra Seetharaman wrote:
> > Other than one minor issue the code looks good (sorry for the late
> > realization on my part).
> > 
> > Issue: scsi_dh_handler_detach() references scsi_dh with no check for
> > null and scsi_dh_notifier() call it with scsi_dh == NULL. code can be
> > changed to get the device handler from sdev.
> > 
> This is fixed in patch 7/9. I thought I had rediffed them properly,
> but apparently not. Sorry for that.
> 
> Thanks for the review.
> 
> Cheers,
> 
> Hannes

