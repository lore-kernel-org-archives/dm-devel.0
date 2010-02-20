From: malahal@us.ibm.com
Subject: Re: multipath: Determine which device to use for
 grubdevice.map file
Date: Fri, 19 Feb 2010 16:04:34 -0800
Message-ID: <20100220000434.GA7527@us.ibm.com>
References: <4B7DE60A.9020805@storix.com>
	<8F08A56613D77044BD153E2AC5DA0F8403B0E9F0@CORPUSMX40A.corp.emc.com>
	<4B7F1194.2040201@storix.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4B7F1194.2040201@storix.com>
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

> mpatha (36006016094511600449d92ae1937d611) dm-0 DGC,DISK
> [size=50G][features=1 queue_if_no_path][hwhandler=1 emc][rw]
> \_ round-robin 0 [prio=2][active]
> \_ 2:0:1:0 sdd 8:48  [active][ready]
> \_ 3:0:1:0 sdf 8:80  [active][ready]
> \_ round-robin 0 [prio=0][enabled]
> \_ 2:0:0:0 sdc 8:32  [active][ready]
> \_ 3:0:0:0 sde 8:64  [active][ready]
>
> Out of the 4 paths, only two (sdd and sdf) are active. This output is 
> not very good to parse through in a script to determine which disks I 
> can specify in my device.map file. Is there a command or better way to 
> determine which underlying paths I can use in my device.map file.

You can probably get it from "dmsetup status <device>", but it may be
even harder to parse!

Thanks, Malahal.
