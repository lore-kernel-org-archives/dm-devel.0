From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Problems with multipathing
Date: Mon, 17 Apr 2006 11:43:59 +0200
Message-ID: <4443635F.5000401@free.fr>
References: <443BF12E.50900@ludd.luth.se>	<443BF87A.10804@free.fr>	<443C19E6.8000607@ludd.luth.se>	<443E870E.1070902@ludd.luth.se>	<443EB907.1070600@free.fr>
	<4442E2ED.7020405@ludd.luth.se>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4442E2ED.7020405@ludd.luth.se>
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

Roger H=E5kansson a =E9crit :
>>> but it seems assymmetrical.
>>>      =20
>
> I guess that you with "asymmetrical" means that paths are only presente=
d
> on one controller at a time, more on that later.
>
>  =20
Yes, and the "transparent path switching with a penalty" family, which=20
your hardware seems to be part of. Those usually don't need a hardware=20
handler.

>>> Most hardware in this familly need a hardware
>>> handler, and some need the "queue_if_no_path" feature set too.
>>>
>>> You'll have to find how your array works and try to figure if some
>>> existing hardware handler does the good thing.
>>>      =20
>
> I've done some testing and it seems that multibus works fine, but when =
a
> controller fails and the secondary controller takes over, the
> scsi-devices are seen as "dead" and if I, before multipath determines
> both paths to be permanently faulty, do a "echo 1 >
> /sys/class/scsi_device/1:0:0:0/device/rescan", multipath will not fail
> the device.
>
>  =20
Do failover device nodes get reassigned during the rescan ?
Like, for example, a configured path sda gets removed and a new path sdb=20
appears ?
If so, the FC transport class is in charge of the timeout triggering the=20
dead devices removal.
A hardware handler wouldn't help here.

Can you paste a before/after scsi rescan "multipath -l" output ?

Regards,
cvaroqui
