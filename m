From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: replace wrong device handler name for CLARiiON
 arrays
Date: Sun, 09 Oct 2016 07:21:45 +0800
Message-ID: <1475968905.2892.11.camel@linux.vnet.ibm.com>
References: <20161007161957.6042-1-xose.vazquez@gmail.com>
         <612033e6-1caa-30e8-b4f2-8cf3fd5190c7@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <612033e6-1caa-30e8-b4f2-8cf3fd5190c7@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, 2016-10-08 at 19:17 +0200, Hannes Reinecke wrote:
> On 10/07/2016 06:19 PM, Xose Vazquez Perez wrote:
> > At drivers/scsi/device_handler/scsi_dh_emc.c it was defined as:
> > #define CLARIION_NAME                   "emc"
> > 
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
> > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > Cc: SCSI ML <linux-scsi@vger.kernel.org>
> > Cc: device-mapper development <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> >  drivers/scsi/scsi_dh.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> > index 54d446c..b8d3b97 100644
> > --- a/drivers/scsi/scsi_dh.c
> > +++ b/drivers/scsi/scsi_dh.c
> > @@ -36,9 +36,9 @@ struct scsi_dh_blist {
> >  };
> > 
> >  static const struct scsi_dh_blist scsi_dh_blist[] = {
> > -	{"DGC", "RAID",			"clariion" },
> > -	{"DGC", "DISK",			"clariion" },
> > -	{"DGC", "VRAID",		"clariion" },
> > +	{"DGC", "RAID",			"emc" },
> > +	{"DGC", "DISK",			"emc" },
> > +	{"DGC", "VRAID",		"emc" },
> > 
> >  	{"COMPAQ", "MSA1000 VOLUME",	"hp_sw" },
> >  	{"COMPAQ", "HSV110",		"hp_sw" },
> > 
> Whee. Of course.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Actually, should we replace?  Aren't there older arrays still bearing
the clariion name, so we should have these entries in addition?

James


