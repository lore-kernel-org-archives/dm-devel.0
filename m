From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: 3PAR transparent failover with Linux
Date: Wed, 24 Sep 2014 00:11:44 +0200
Message-ID: <20140924001144.00007453@localhost>
References: <20140911125818.GC29930@glanzmann.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140911125818.GC29930@glanzmann.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: thomas@glanzmann.de, Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

Thomas Glanzmann wrote:
> Hello,
> we have two 3PARs 7400 which are configured for transparent failover. In
> the following manner:
> 
> Active           Passive
> 3PAR-1 - RCOPY - 3PAR-2
>   \                 /
>    \               /
> Active          Standby
> Optimized        /
>       \         /
>        Linux Box
> 
> When we run multipath -l before the failover two paths were 'active' the
> other paths 'failed'. Once we failed over and the ALUA state changed,
> all paths went to 'failed':
> 
> 360002ac0000000000000000a0000cc14 dm-17 3PARdata,VV
> size=50G features='0' hwhandler='0' wp=rw
> `-+- policy='service-time 0' prio=0 status=enabled
>   |- 6:0:6:0   sdak 66:64  failed undef running
>   |- 6:0:7:0   sdal 66:80  failed undef running
>   |- 7:0:6:0   sdbw 68:160 failed undef running
>   `- 7:0:7:0   sdbx 68:176 failed undef running

Do you have a log of the failover?

I think path_grouping_policy set to "multibus" suggests all paths are equal.
Is this actually true for this configuration? I assume paths to 3PAR-1
(active) should have a higher priority than paths to 3PAR-2 (passive).
Since the 3PAR supports ALUA I would change the path_grouping_policy to
"group_by_prio" and prio to "alua".
What is the output of "sg_rtpg -d" for all paths before and after the
failover?

> But we were able to continue I/O. So I wonder why multipath reported 'failed'
> but allowed to continue I/O. So from our standpoint the I/O was continuing. The
> transparent failover successfull. This is not supported by 3PAR for Linux but
> it is for VMware ESX.

Have you tried setting the path_checker to "tur"?
What is the output of "sg_turs -vvv" for all paths?

Sebastian
