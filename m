From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 0/7] scsi_dh framework update
Date: Wed, 14 May 2008 19:45:40 -0700
Message-ID: <1210819540.21974.250.camel@chandra-ubuntu>
References: <482AFA62.2000506@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <482AFA62.2000506@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Hannes,

Thanks for the clean up and the new features. I have reviewed the code
but hasn't tested it. Comments follow.

BTW, checkpatch.pl generates warnings for patches 1 thru 5.

regards,

chandra
On Wed, 2008-05-14 at 16:42 +0200, Hannes Reinecke wrote:
> Hi James,
> 
> this is a repost of my patchset to update the scsi_dh infrastructure.
> 
> It's based on the current scsi-misc tree.
> 
> Main features of the patchset are:
> - Use a single callback for the notifier chain
> - Merge all device maps into a single list,
>   which will be scanned by a generic function
> - Add a sysfs attribute 'dh_state' for each sdev
> - Add a generic SPC-3 ALUA device handler
> - Update device handlers to check if the
>   device actually supports this handler.
>   When attaching manually we are able to attach
>   to basically any device, so we have to make sure
>   that the device handler is actually supported.
> - Manually attach a device when a hardware handler
>   is specified; this allows multipath to override
>   the built-in hardware table.
> 
> As per usual, comment etc are welcome.
> 
> Cheers,
> 
> Hannes

