From: Hannes Reinecke <hare@suse.de>
Subject: Re: memory consumption of multipathd after Upgrade SLES
	10	SP2 -> SLES 11
Date: Mon, 19 Oct 2009 08:16:51 +0200
Message-ID: <4ADC0453.9010406@suse.de>
References: <200910161720.42414.sebastia@l00-bugdead-prods.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200910161720.42414.sebastia@l00-bugdead-prods.de>
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

Sebastian Reitenbach wrote:
> Hi,
>=20
> I use multipath tools to manage the multiple ways through the SAN conne=
cted=20
> via FC. The server sees two paths per LUN. There are 15 LUNs presented =
to the=20
> server.
>=20
> I upgraded two server to SLES 11, installed latest patches, running ker=
nel:
> Linux server1 2.6.27.29-0.1-xen #1 SMP 2009-08-15 17:53:59 +0200 x86_64=
 x86_64=20
> x86_64 GNU/Linux
>=20
> multipath-tools-0.4.8-40.4.1
>=20
> There I recognized a fairly large amount of memory used by multipathd:
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  5367 root      RT   0  238m 140m 2804 S    0 28.1   0:34.70 multipathd
>=20
> I see the huge memory consumption on both of the servers.=20
>=20
>=20
> On a different server, not yet upgraded, running SLES 10 SP2, with diff=
erent=20
> SAN storages applied, there I run kernel:
> Linux server2 2.6.16.60-0.34-xen #1 SMP Fri Jan 16 14:59:01 UTC 2009 x8=
6_64=20
> x86_64 x86_64 GNU/Linux
> with multipath tools:
> multipath-tools-0.4.7-34.40
> There I have 20 LUNs presented, and the server sees 4 paths per LUN, I =
in top=20
> a much fewer memory consumption:
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  4796 root      RT   0 11928 4808 2220 S    0  1.6   0:01.37 multipathd
>=20
>=20
> However, both of the servers running SLES 11 work fine so far, no "erro=
rs"=20
> recognized. I still wonder whether the large memory consumption is corr=
ect, as=20
> I expected sth. similar as on the SLES10 SP2 hosts.=20
> Below the configuration file I use on the SLES 11 servers.
>=20
This is a known regression with SLES11. Please update to the latest
maintenance release.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
