From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: Oops in dm-multipath
Date: Fri, 12 Jun 2009 16:37:03 +0200
Message-ID: <20090612143702.GA17037@schmichrtp.de.ibm.com>
References: <4A2FB289.3050008@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A2FB289.3050008@linux.vnet.ibm.com>
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

On Wed, Jun 10, 2009 at 03:18:01PM +0200, Christian May wrote:
> Hi,
>
> I've setup an IBM z10 LPAR (mainframe server) with selfmade kernel.  
> Attached to the System z10 was an IBM DS8000 storage server. 10x SCSI  
> LUNs were assigned to LPAR via two pathes:
> Example:
> 36005076303ffc48e000000000000c03e dm-2 IBM,2107900
> size=5.0G features='1 queue_if_no_path' hwhandler='0' wp=rw
> `-+- policy='round-robin 0' prio=2 status=enabled
>  |- 2:0:1:1077821632 sde   8:64   active ready  running
>  `- 3:0:2:1077821632 sdf   8:80   active ready  running
>
> Special parameter setting: dev_loss_tmo=90sec; fast_io_fail_tmo=5sec
[...]
> Kernel version: 2.6.29-37.x.20090604
[...]

It might make more sense to use the 2.6.30 kernel and not an internal
build for discussing this in public.

--
Christof Schmitt
