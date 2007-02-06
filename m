From: "Srinivas Ramani" <sramani@pillardata.com>
Subject: RE: Changes hwtable.c to Support New Pillar Hardware
Date: Mon, 5 Feb 2007 16:08:22 -0800
Message-ID: <35D744B011AD9A4A86B5962E85181C781091B950@caex02.trans.corp>
References: <1170715904.20348.6.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-reply-to: <1170715904.20348.6.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com, dmo@osdl.org, lmb@suse.de
List-Id: dm-devel.ids

Hi Chris;

Extended regexp here. Can we settle on "Axiom.*" ?=20

>>Yes that is fine will work.

I'm wondering : "%d" or "/dev/%n" should work as mpath_prio_alua
parameter. Does "%n" does too ?

>> Yes %n works and fixes the following bug .

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=3D215505

215505: DM multipath devices are not created - for the luns with dev_t
minor numbers > 256


Thanks and Best Regards

Srini


-----Original Message-----
From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]=20
Sent: Monday, February 05, 2007 2:52 PM
To: Srinivas Ramani
Cc: dm-devel@redhat.com; bmarzins@redhat.com; lmb@suse.de; dmo@osdl.org;
mbroz@redhat.com
Subject: Re: Changes hwtable.c to Support New Pillar Hardware


>=20
> I am submitting code changes to support  the=20
> new Pillar  Axiom 300 and Axiom 550 arrays .
> I request the following change to hwtable.c file .
> This change has been tested at Pillar Data Systems  on RHEL 4 and 5
> beta.
> If you have any comments or  suggestions please let me know.
>=20
> =20
>=20
> /*
>=20
>        * Pillar Data controller family
>=20
>        *
>=20
>        * Maintainer : Srinivasan Ramani
>=20
>        * Mail : sramani@pillardata.com
>=20
>        */
>=20
>       {
>=20
>             .vendor        =3D "Pillar",
>=20
>             .product       =3D "*",
>=20
Extended regexp here. Can we settle on "Axiom.*" ?

>             .getuid        =3D DEFAULT_GETUID,
>=20
>             .getprio       =3D "mpath_prio_alua %n",

I'm wondering : "%d" or "/dev/%n" should work as mpath_prio_alua
parameter. Does "%n" does too ?

Regards,
cvaroqui
