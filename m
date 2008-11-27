From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: RE: Re: multipathing pending issues with rhel
Date: Thu, 27 Nov 2008 23:16:25 +0100
Message-ID: <20081127231625.69b450e0@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: egoggin@vmware.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> I think I inadvertantly made this matter worse about two years ago
> when I changed the clariion path checker to issue a scsi read via
> sg_read in libsg.c after inquiry page 0xc0 in order to discern an
> inactive from an active clariion snapshot logical unit.  This change
> to multipath-tools/libcheckers/emc_clariion.c causes a path check on
> a path to incur a reservation error if the reservation is held
> by a different I/T nexus.
> 
> A reasonable fix for this problem is to have sg_read in
> multipath-tools/libcheckers/libsg.c return PATH_UP even if the
> return value from ioctl is < 0 if the returned scsi status
> in io_hdr.status is SAM_STAT_RESERVATION_CONFLICT.
> 
I recently tried an upstream kernel with the device handlers
infrastructure, and it seems the kernel rightfully drops the io on
reservation conflicts ... with due message in the logs, and returning a
success to the devmapper. No queueing, no retry, no problem.

I'll have to do some more testing to convince myself, but in the mean
time :

1/ Do you confirm my observations ?

2/ Does the Clariion snapshot still need your suggested fix in this new
context ? If so, would you care to submit a patch ?

Thanks for the comment,
cvaroqui
