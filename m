From: Hannes Reinecke <hare@suse.de>
Subject: Re: Re: Round Robin vs Active/Passive
Date: Thu, 05 Jun 2008 09:20:31 +0200
Message-ID: <484793BF.3050303@suse.de>
References: <ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com>	<ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>	<483468AD.7@linpro.no>	<000301c8bbe5$4f1091d0$cf42e3c1@pitagora.it>	<20080523071654.GB380@pentland.suse.de>	<4836798F.4060100@linpro.no><000401c8bcc0$d29e94d0$cf42e3c1@pitagora.it>	<4836A075.9090008@linpro.no>	<01d601c8bd1a$c5fd99b0$0201a8c0@zeug>
	<48478DBF.3060709@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <48478DBF.3060709@linpro.no>
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

Hi Tore,

Tore Anderson wrote:
[ .. ]
> What I need to do is this:
>=20
> # My new CX3-40f which supports ALUA (preferred) as well as PNR
> device {
> 	vendor DGC
> 	product *
> 	product_blacklist LUNZ
> 	alua_capable yes
> 	[..ALUA optimised settings...]
> }
>=20
> # My old CX200, only supports PNR
> device {
> 	vendor DGC
> 	product *
> 	product_blacklist LUNZ
> 	alua_capable no
> 	[..PNR optimised settings...]
> }
>=20
> ...but there's no such thing as the "alua_capable" setting or any other
> setting that can be used to distinguish between the two CLARiiONs, as
> far as I know, so I have to use both arrays in PNR mode even though the
> newest one of them supports ALUA.
>=20
No need. I did some patch once ago which allowed you to set the hardware
handler in the multipaths section.
For exactly this scenario. Can you test if it works?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
