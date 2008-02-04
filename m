From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 7/9] scsi_dh: Add support for SDEV_PASSIVE
Date: Mon, 04 Feb 2008 12:58:18 -0600
Message-ID: <1202151498.3096.84.camel@localhost.localdomain>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
	 <20080124003203.18871.52040.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20080124003203.18871.52040.sendpatchset@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, andmike@us.ibm.com, michaelc@cs.wisc.edu, jens.axboe@oracle.com
List-Id: dm-devel.ids


On Wed, 2008-01-23 at 16:32 -0800, Chandra Seetharaman wrote:
> Subject: scsi_dh: Add support for SDEV_PASSIVE
> 
> From: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> This patch adds a new device state SDEV_PASSIVE, to correspond to the
> passive side access of an active/passive multipathed device.

Really, no; this isn't right.  The state field of a SCSI device is for
the SCSI state model.  Passive might be a valid device mapper state, but
it's not a valid SCSI state.  If these patches can't work except by
mucking with the SCSI state model, there's some layering problem
elsewhere that needs sorting out.

James


