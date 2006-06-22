From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: device-mapper-multipath
Date: Thu, 22 Jun 2006 23:58:06 +0200
Message-ID: <1151013487.8923.9.camel@localhost.localdomain>
References: <449AEF1D.3080701@unibas.ch>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <449AEF1D.3080701@unibas.ch>
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

Le jeudi 22 juin 2006 =C3=A0 21:27 +0200, URZ- AG a =C3=A9crit :
> Hi,
>=20
> I would like to ask if somebody knows when Redhat is going to merge the=
=20
> different dm-multipath patches into their device-mapper-multipath packa=
ge.
> A while ago I've figured out a bug with C. Varoqui, he made a patch=20
> which worked, but after several weeks the patch is still not included=20
> into the latest RH4 version.
> I will need this latest version since multipath will not get the right=20
> size of the volume.
> Should I use a self build version? In that case for what do I pay licen=
ses?
>=20
> Thanks for any comment / remark / hint
> Ars=C3=A8ne
>=20
For reference, cea2dae4c8cb2584fb0de7cd6066862671b66d4b is the said
commit.

Regards,
cvaroqui
