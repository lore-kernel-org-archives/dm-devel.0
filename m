From: Domenico Viggiani <dviggiani@tiscali.it>
Subject: RE: multipath errors on first set-up
Date: Thu, 21 Feb 2008 10:43:08 +0100
Message-ID: <000001c8746e$2acf1c60$cf42e3c1@pitagora.it>
References: <20080219192317.GI15608@ether.msp.redhat.com>
	<DFB2D7E03264FB4392B70A38BFF9FC710202657B@BRBSEVS20000.s2.ms.unilever.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <DFB2D7E03264FB4392B70A38BFF9FC710202657B@BRBSEVS20000.s2.ms.unilever.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

> -----Original Message-----
> From: dm-devel-bounces@redhat.com 
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Rogan, Julian
> 
> Hi,
> Here is the output:
> 
> multipath -l
> 3600508b300930230a7495ae1b9500074
> [size=1 TB][features="0"][hwhandler="0"] \_ round-robin 0 [enabled]
>   \_ 0:0:0:1 sda  8:0     [active]
> \_ round-robin 0 [enabled]
>   \_ 1:0:0:1 sdb  8:16    [active]
> \_ round-robin 0 [enabled]
>   \_ 2:0:0:1 sdc  8:32    [active]
> \_ round-robin 0 [enabled]
>   \_ 3:0:0:1 sdd  8:48    [active]
> 
> A map was created:
> 
> /dev/mapper/3600508b300930230a7495ae1b9500074

Sometime, on a system of mine 'udev' doesn't create device node under /dev
and I need to run 'udevstart' but I hope it's a problem that will disappear
at next reboot.

--
DV
