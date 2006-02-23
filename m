From: =?ISO-8859-1?Q?Jo=E3o_Daniel?= <jd-apinf@est.ips.pt>
Subject: Re: Problem with Multipath (devices not ready)
Date: Thu, 23 Feb 2006 15:38:07 +0000
Message-ID: <43FDD6DF.2040301@est.ips.pt>
References: <!&!AAAAAAAAAAAYAAAAAAAAANNuC7JXowhAhztxsUsdl9nCgAAAEAAAAFrKzybPoitElCE3HsMmQqIBAAAAAA==@est.ips.pt>	<1139513000.2915.4.camel@zezette>	<43EB9B48.7020707@bzed.de>	<43F07DDA.70702@est.ips.pt>
	<43F61D50.3060509@bzed.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43F61D50.3060509@bzed.de>
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

  =20
    The problem is the QLogic driver.
    I use the driver below.

    EMC CLARiiON CXx00 and EMC Symmetrix approved common Linux installer=20
for v2.6.x kernels -> 8.01.00-4
    [=20
http://support.qlogic.com/support/oem_product_detail.asp?p_id=3D253&oemid=
=3D65&oemname=3DQLA2340=20
]
  =20
    This driver is not working properly under SLES9 SP3.
    I have connections to a LUN through different SPs, but only the=20
paths to the SP that controls the LUN work.

    QLogic does not support its drivers for SLES9 SP3.
    The QLogic support forwarded this problem to EMC.
    I'm waiting for EMC...




Best Regards,

Jo=E3o Daniel






Bernd Zeimetz wrote:
> Hi,
>  =20
>>     I've tried: update OS, update drivers, update multipath, re-config=
urate=20
>> multipath...
>>  =20
>>    =20
> did you update to multipath >=3D 0.4.6 ?
>
>  =20
>>     What do you think I should try now ?
>>  =20
>>    =20
> Probably I've missed it - but how do you access the CX? Via a switch?
> direct? How many HBAs do you use? Are they all allowed to connect to th=
e
> machine?
>
> Did you try it without any multipath.conf at all? The defaults in 0.4.6
> work well.
>
>  =20
>> LUN_TESTES (360060160256014006adcbf64a644da11)
>>
>> [size=3D458 GB][features=3D"0"][hwhandler=3D"0"]
>>
>> \_ round-robin 0 [active]
>>
>>  \_ 3:0:0:0 sdc 8:32 [failed][faulty]
>>
>>  \_ 3:0:1:0 sdd 8:48 [failed][faulty]
>>
>>  \_ 3:0:2:0 sde 8:64 [active][ready]
>>
>>  \_ 3:0:3:0 sdf 8:80 [active][ready]
>>  =20
>>    =20
> although sdc and sdd are faulty you should be able to access the LUN -
> you have 2 active and ready paths to it. Look for LUN_TESTES in your
> /dev directory.
>
> Do you have the right udev rules for multipath? As all distros do handl=
e
> this on a different way - which distro and udev version are you using?
>
> Make sure dm events are not discarded.
> On debian sarge for example you ahve to change this in udev.rules:
>
> #KERNEL=3D"dm-[0-9]*",    OPTIONS=3D"ignore_device"
> KERNEL=3D"dm-[0-9]*", PROGRAM=3D"/sbin/devmap_name %M %m", NAME=3D"%k",
> SYMLINK=3D"%c"
>
> Are the multipath rules for udev installed? Do you have any errors from
> udev in your log?
>
>
> I hope I could give you some more hints.
>
>
> Best regards,
>
> Bernd
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>
>  =20
