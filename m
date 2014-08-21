From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 22/30] multipath: Implement 'property'
	blacklist
Date: Thu, 21 Aug 2014 16:37:22 +0000 (UTC)
Message-ID: <loom.20140821T183107-637@post.gmane.org>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
	<1373958801-103613-23-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hannes Reinecke <hare <at> suse.de> writes:
> Multipath can only handle device properly which support the VPD
> page 0x83. Originally this was ensured by 'scsi_id', which would
> not present an ID_SERIAL value in these cases.
> With the move to udev 'ID_SERIAL' is now always present, so
> multipath would try to attach to _all_ SCSI devices.
> This patch implements an 'property' blacklist, which allows to
> blacklist a device based on the existence of udev properties.
> Any device not providing the udev property from the whitelist
> will be ignored.
> The default whitelist is set to '(ID_WWN|ID_SCSI_VPD)'.
> 
> [ ... ]

(replying to an e-mail of one year ago)

Hello Hannes,

I have a question about this patch. Which software component should set the
ID_SCSI_VPD parameter ? Is it udev, now integrated in systemd ? I'm asking
this because I haven't found any patch in the udev nor in the systemd
repositories that sets the ID_SCSI_VPD parameter. Does this mean that
another parameter should be used to restore support for SCSI devices that
support the VPD page 0x83 but do not report a WWN in that page ? Or does
this mean that systemd should be modified such that it sets the ID_SCSI_VPD
parameter ?

Thanks,

Bart.
