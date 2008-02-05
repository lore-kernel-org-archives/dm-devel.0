From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/9] scsi_dh: Add support for SDEV_PASSIVE
Date: Tue, 5 Feb 2008 13:56:57 -0800
Message-ID: <20080205215657.GA20963@linux.vnet.ibm.com>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain> <20080124003203.18871.52040.sendpatchset@localhost.localdomain> <1202151498.3096.84.camel@localhost.localdomain> <1202156151.13537.14.camel@linuxchandra> <1202156914.3096.112.camel@localhost.localdomain> <47A8C14A.3030207@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47A8C14A.3030207@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, sekharan@us.ibm.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com
List-Id: dm-devel.ids

Mike Christie <michaelc@cs.wisc.edu> wrote:
> When IO is sent to a path that cannot execute IO optimally, the scsi hw 
> handler hook for sense processing (see rdac_check_sense in "[PATCH 8/9] 
> scsi_dh: add lsi rdac device handler" and the scsi_error.c hook in in 
> "scsi_dh: add skeleton for SCSI Device Handlers") will detect this and set 
> the state to passive so future IO is not execute on the path 
> (SG_IO/passthrough is allowed).
>
> I am not sure about alternatives. If we just exported the port access state 
> in sysfs, but did not fail IO from scsi_prep_state_check, then the users 
> could still check the state before sending IO. Would it be horrible to 
> convert apps to do this?

The majority of the boot up delays is caused by the kernel partition
scanning and other kernel init code (Chandra please correct if that is not
true). Sysfs attributes would not help here. One option maybe to add
handling of the newer BLKERR_ codes in the generators of IO or some
similar solution with a rollout possibly focused at the top generators of
IO.

A number of user apps like lvm scanning that execute media access commands
already have filter capability to filter devices that one does not want to
scan. Another class of device scanners just use inquiries which are not
effected by the passive state (though some could probably use udevinfo and
reduce the amount of repeated SCSI inquiries execute on the system.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
