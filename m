From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Not able to create a device mapper target node
Date: Thu, 27 Jun 2013 10:02:14 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1306270937450.23378@file01.intranet.prod.int.rdu2.redhat.com>
References: <CABmd-rm-6P-+bkoHVAK25pEVgVBNswELepV5qvweTUd1J2Poag@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="185206533-1123065246-1372340422=:23378"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABmd-rm-6P-+bkoHVAK25pEVgVBNswELepV5qvweTUd1J2Poag@mail.gmail.com>
Content-ID: <alpine.LRH.2.02.1306270940250.23378@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: monica g <monica.knmt@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185206533-1123065246-1372340422=:23378
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-ID: <alpine.LRH.2.02.1306270940251.23378@file01.intranet.prod.int.rdu2.redhat.com>
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx3-phx2.redhat.com id r5RE2GDi013063



On Mon, 24 Jun 2013, monica g wrote:

> Hi,
>=20
> I wrote a basic device mapper driver which caches reads.
>=20
> I gave dm msg prefix as below
> =A0#define DM_MSG_PREFIX "cacheread".
>=20
> When i try to create a device mapper node using the below command
> echo "0 `blockdev --getsize /dev/sda2` cacheread /dev/sda2 0" | dmsetup
> create cacheread
>=20
> the system hangs.I am not getting any error messages.
>=20
> When i try to create a device mapper node for linear target(this target=
 is
> already present with the device mapper code) using below command
>=20
> echo "0 `blockdev --getsize /dev/sda2` linear /dev/sda2 0" | dmsetup cr=
eate
> linear
> it succeeds and creates device node linear in /dev/mapper directory.
>=20
> I am stuck with this issue and not able to proceed furthur.
>=20
> Please let me know if you have any suggestions.
>=20
> Any help is truely appreciated.
>=20
> Thanks in advance.
>=20
> Regards,
> Monica

Hi

How to debug hangs:

If the system is still responsive, just the process that loads your devic=
e=20
mapper target hangs, switch to console and use Alt-Sysrq-W (or run
echo w >/proc/sysrq-trigger;dmesg ). It should display a stacktrace, and=20
from the stacktrace you can find where did it hang.

Otherwise (if you can't get the stacktrace or you don't find the reason=20
for the hang from the stacktrace), find a function that is the most likel=
y=20
cause (in your case, it would be the constructor of your device mapper=20
target, if you don't find the hang in the constructor, try other=20
functions, such as a map routine) and put statements such as=20
printk("step1\n") ... printk("step2\n") ... printk("step3\n") ... etc at=20
various places in that function. Switch to console (don't do it in=20
x-window), load your target and from the messages printed on the console,=
=20
you can find out where did the hang happen - for example, if it prints=20
"step1" and "step2" and doesn't print "step3", you know that the hang=20
happened between step2 and step3.

Mikulas
--185206533-1123065246-1372340422=:23378
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--185206533-1123065246-1372340422=:23378--
