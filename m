From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: release 0.4.4 ?
Date: Wed, 20 Apr 2005 22:39:56 +0200
Message-ID: <1114029597.24817.138.camel@zezette>
References: <1113731446.24817.4.camel@zezette>
	<1113953571.24817.97.camel@zezette>
	<20050420133116.GW29071@marowsky-bree.de>
	<1114006824.24817.108.camel@zezette>
	<20050420201249.GS29071@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050420201249.GS29071@marowsky-bree.de>
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

On mer, 2005-04-20 at 22:12 +0200, Lars Marowsky-Bree wrote:
> On 2005-04-20T16:20:23, christophe varoqui <christophe.varoqui@free.fr> wrote:
> 
> > I guess I'll setup the OSDL environment now, for testing and debugging.
> > Hope to be able to diagnose in a few hours.
> 
> Something else is strange.
> 
> This is what /sbin/multipath creates:
> 
> 0 267249280 multipath 0 1 emc 2 1 round-robin 0 2 1 66:208 1000 8:240 1000 round-robin 0 2 1 65:224 1000 8:0 1000
> action preset to 0
> action set to 4
> create: 3600601607cf30e00164589a37a31d911
> [size=127 GB][features="0"][hwhandler="1 emc"]
> \_ round-robin 0 [first]
>   \_ 1:0:1:0 sdat 66:208  [ready ]
>   \_ 0:0:1:0 sdp  8:240   [ready ]
> \_ round-robin 0 
>   \_ 1:0:0:0 sdae 65:224  [ready ]
>   \_ 0:0:0:0 sda  8:0     [ready ]
> 
> multipathd however:
> ...
> Apr 20 22:09:11 chip multipathd: getprio = /sbin/pp_emc /dev/%n (controler setting)
> Apr 20 22:09:11 chip multipathd: error calling out /sbin/pp_emc /dev/sdp
> 
from libmultipath/discovery.c:devinfo() :

                if (apply_format(pp->getprio, &buff[0], pp)) {
                        pp->priority = 1;
                } else if (execute_program(buff, prio, 16)) {
                        condlog(3, "error calling out %s", buff);
                        pp->priority = 1;
                } else
                        pp->priority = atoi(prio);

A failed exec results in a default path weight.
This code is common to multipath and multipathd

> Resulting in a flat map:
> 3600601607cf30e0070af8bb37a31d911
> [size=133 GB][features="0"][hwhandler="1 emc"]
> \_ round-robin 0 [active][first]
>   \_ 0:0:1:12 sdab 65:176  [ready ][active]
>   \_ 1:0:0:12 sdaq 66:160  [ready ][active]
>   \_ 1:0:1:12 sdbf 67:144  [ready ][active]
>   \_ 0:0:0:12 sdm  8:192   [ready ][active]
> 
> Which is broken and actually causes the system to misbehave quite
> spectacularly.
> 
Indeed.

> What is multipathd doing differently from multipath? The two parts being
> distinct in behaviour is really one of the worst design decisions in the
> entire setup, in my not so humble opinion.
> 
Sure, it was acknowledged and corrected from 0.4.2.

Multipathd *never* decides to change a map. All it does is exec
multipath, which means two runs of multipath gave 2 differents maps :
very bad, but nothing to do with code divergence between daemon and
tool.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
