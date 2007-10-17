From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: multibus / failover and EMC CX600
Date: Wed, 17 Oct 2007 14:49:39 -0500
Message-ID: <47166753.20400@cs.wisc.edu>
References: <061401c810a7$cac685d0$0a00a8c0@ALDI2>	<4715E6A4.7060308@linpro.no>
	<4715ED28.9020102@suse.de> <471600F7.5090607@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <471600F7.5090607@linpro.no>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Tore Anderson wrote:
> * Hannes Reinecke
> 
>> That's the dev_loss_tmo setting. Just increase it to something to
>> your liking.
> 
> Oh, sweet.  This knob won't affect how long the layer will hold I/O
> before failing it (like lpfc_nodev_tmo), I assume?  (I'm worried about
> it taking longer for dm-multipath to detect failed paths).
> 

With newer versions of lpfc you can set 
/sys/class/fc_rport/rportXYZ/fast_io_fail_tmo to a low value so that IO 
is failed quickly, and then set the dev_loss_tmo to a high value so the 
device is not removed quickly.

The only problem may be that there is a race where dm-multpiath could be 
queueing IO to the scsi layer while the scsi layer is reporting a 
failure. That IO that was getting queued will then sit in the scsi layer 
until dev_loss_tmo fires. That is fixed with this patchset
http://marc.info/?l=linux-scsi&m=117399843216280&w=2
but I never finished testing it out.
