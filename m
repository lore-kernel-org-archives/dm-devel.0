From: Chandra Seetharaman <sekharan@linux.vnet.ibm.com>
Subject: Re: [dm-devel] [PATCH 0/4] scsi_dh: Make scsi_dh_activate
	asynchronous
Date: Thu, 22 Oct 2009 09:06:28 -0700
Message-ID: <1256227588.6475.6.camel@chandra-ubuntu>
References: <20091021162240.8473.99556.sendpatchset@chandra-ubuntu>
	 <20091022010608.GA10445@infradead.org>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20091022010608.GA10445@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Benoit_Arthur@emc.com, Eddie.Williams@steeleye.com
List-Id: dm-devel.ids

Hi Christoph,

Thanks for looking into this.

Babu (LSI) and I did some testing and found couple of problems. Major
one was that moving all luns blindly causes luns to be moved to their
non-preferred path against the user's setting, which is a no-no.

Here is the email Babu sent on this:
http://marc.info/?l=linux-scsi&m=125495712310371&w=2

chandra

On Wed, 2009-10-21 at 21:06 -0400, Christoph Hellwig wrote:
> On Wed, Oct 21, 2009 at 09:22:40AM -0700, Chandra Seetharaman wrote:
> > Hello All,
> > 
> > Currently, device handlers process path activation in series. This leads
> > to a lot of time delay when more than 100 luns are involved. For example,
> > with lsi rdac 100+ luns take about 12-15 minutes. This was found by Moger
> > Babu of LSI.
> 
> So what happened to the suggestion to just switch over per target
> instead of per lun?   It's the obviously much better way to do, and
> unless there are bugs in the hardware preventing it from working it
> should be the way to go.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

