From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: Problem with Multipath (devices not ready)
Date: Fri, 17 Feb 2006 20:00:32 +0100
Message-ID: <43F61D50.3060509@bzed.de>
References: <!&!AAAAAAAAAAAYAAAAAAAAANNuC7JXowhAhztxsUsdl9nCgAAAEAAAAFrKzybPoitElCE3HsMmQqIBAAAAAA==@est.ips.pt>	<1139513000.2915.4.camel@zezette>	<43EB9B48.7020707@bzed.de>
	<43F07DDA.70702@est.ips.pt>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43F07DDA.70702@est.ips.pt>
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

Hi,
>     I've tried: update OS, update drivers, update multipath, re-configurate 
> multipath...
>   
did you update to multipath >= 0.4.6 ?

>     What do you think I should try now ?
>   
Probably I've missed it - but how do you access the CX? Via a switch?
direct? How many HBAs do you use? Are they all allowed to connect to the
machine?

Did you try it without any multipath.conf at all? The defaults in 0.4.6
work well.

> LUN_TESTES (360060160256014006adcbf64a644da11)
>
> [size=458 GB][features="0"][hwhandler="0"]
>
> \_ round-robin 0 [active]
>
>  \_ 3:0:0:0 sdc 8:32 [failed][faulty]
>
>  \_ 3:0:1:0 sdd 8:48 [failed][faulty]
>
>  \_ 3:0:2:0 sde 8:64 [active][ready]
>
>  \_ 3:0:3:0 sdf 8:80 [active][ready]
>   
although sdc and sdd are faulty you should be able to access the LUN -
you have 2 active and ready paths to it. Look for LUN_TESTES in your
/dev directory.

Do you have the right udev rules for multipath? As all distros do handle
this on a different way - which distro and udev version are you using?

Make sure dm events are not discarded.
On debian sarge for example you ahve to change this in udev.rules:

#KERNEL="dm-[0-9]*",    OPTIONS="ignore_device"
KERNEL="dm-[0-9]*", PROGRAM="/sbin/devmap_name %M %m", NAME="%k",
SYMLINK="%c"

Are the multipath rules for udev installed? Do you have any errors from
udev in your log?


I hope I could give you some more hints.


Best regards,

Bernd
