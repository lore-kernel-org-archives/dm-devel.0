From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Clariion EMC RX300 and "long trespass command will
	be send" message
Date: Tue, 10 Mar 2009 10:35:12 -0400
Message-ID: <20090310143512.GE22889@mars.virtualiron.com>
References: <81c921f30903100341h59740b3dtedb61960b5e5daf7@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <81c921f30903100341h59740b3dtedb61960b5e5daf7@mail.gmail.com>
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

> [5078349.903410] scsi 6:0:0:0: rejecting I/O to dead device
... snip ..
> scsi 6:0:0:0 not exist at lsscsi:

How did it disappear?
> 
> # lscsi
> [8:0:0:0]    disk    DGC      RAID 5           0324  /dev/sdc
> [9:0:0:0]    disk    DGC      RAID 5           0324  /dev/sdd
> [10:0:0:0]   disk    DGC      RAID 5           0324  /dev/sda
> [11:0:0:0]   disk    DGC      RAID 5           0324  /dev/sdb
> 
> multipath is working fine:
> # multipath -ll
> mpath0 (360060160e5101f0020efc45a01cddd11) dm-6 DGC     ,RAID 5
> [size=512G][features=1 queue_if_no_path][hwhandler=1 emc]
> \_ round-robin 0 [prio=2][active]
>  \_ 8:0:0:0  sdc 8:32  [active][ready]
>  \_ 9:0:0:0  sdd 8:48  [active][ready]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 10:0:0:0 sda 8:0   [active][ready]
>  \_ 11:0:0:0 sdb 8:16  [active][ready]
> 
> Dispositve 254:6 is mpath0:
> # devmap_name 254 6
> mpath0
> 
> How could can I stop scsi system / multipath from this messages ?

Try: multipathd -k'reconfigure'
