From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] Associate HBA and storage in rdac_controller to
 support partitions in storage
Date: Wed, 27 Jul 2011 11:20:30 -0700
Message-ID: <1311790830.3210.997.camel@chandra-lucid.beaverton.ibm.com>
References: <1311196948.5505.10779.camel@chandra-lucid.beaverton.ibm.com>
	 <1311762897.5029.0.camel@mulgrave>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1311762897.5029.0.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>, "Moger, Babu" <Babu.Moger@netapp.com>, yanling.Qi@netapp.com, "Stankey, Robert" <Robert.Stankey@netapp.com>
List-Id: dm-devel.ids

Oops. Sorry. By mistake sent an earlier version. Will send the correct
version.
On Wed, 2011-07-27 at 14:34 +0400, James Bottomley wrote:
> On Wed, 2011-07-20 at 14:22 -0700, Chandra Seetharaman wrote:
> > rdac hardware handler assumes that there is one-to-one relation ship
> > between the host and the controller w.r.t lun.  IOW, it does not
> > support "multiple storage partitions" within a storage.
> > 
> > Example:
> > HBA1 and HBA2 see lun 0 and 1 in storage A (1)
> > HBA3 and HBA4 see lun 0 and 1 in storage A (2)
> > HBA5 and HBA6 see lun 0 and 1 in storage A (3)
> > 
> > luns 0 and 1 in (1), (2) and (3) are totally different.
> > 
> > But, rdac handler treats the lun 0s (and lun 1s) as the same when 
> > sending a mode select to the controller, which is wrong.
> > 
> > This patch makes the rdac hardware handler associate HBA and the
> > storage w.r.t lun (and not the host itself).
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > ---
> >  drivers/scsi/device_handler/scsi_dh_rdac.c |   10 +++++++---
> >  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> This doesn't apply;
> 
> patching file drivers/scsi/device_handler/scsi_dh_rdac.c
> Hunk #1 succeeded at 158 (offset 9 lines).
> Hunk #2 FAILED at 381.
> Hunk #3 FAILED at 389.
> Hunk #4 FAILED at 403.
> Hunk #5 FAILED at 526.
> 4 out of 5 hunks FAILED -- saving rejects to file
> drivers/scsi/device_handler/scsi_dh_rdac.c.rej
> 
> 
> it looks like there's a missing intermediate patch somewhere, can you
> check scsi-misc and tell me what it is?
> 
> Thanks,
> 
> James
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


