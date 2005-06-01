From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: path state change
Date: Wed, 01 Jun 2005 21:30:15 +0200
Message-ID: <1117654215.15294.67.camel@zezette>
References: <3456F611E9329441B12FBB24447B3FA00204663B@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3456F611E9329441B12FBB24447B3FA00204663B@bgeexc01.asiapacific.cpqcorp.net>
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
Cc: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
List-Id: dm-devel.ids

On mar, 2005-05-31 at 21:28 +0530, Murthy, Narasimha Doraswamy (STSD)
wrote:

> Kindly explain me what the two states for each path infer. Like
> [ready][active] or [faulty][active] or [faulty][failed] or
> [ready][failed]. Also let me know how to failover to other path
> (/dev/sdd) as it shows [ready][failed] status. If I execute just
> =E2=80=9Cmultipath=E2=80=9D tool  from the command prompt the states ge=
t updated
> properly as
>=20
1st state : ready/faulty, shows the path state as seen by the checkers

2nd state : active/failed, shows the path state as seen by the devmapper
kernel driver

Your observations mean is that either the multipathd daemon does not run
or it runs but doesn't work :/

Either way, it's the daemon responsability the reinstate paths. In
recent snapshots it also fails paths in the devmapper the keep the
checkers view in sync with the kernel view.
>=20

> After this I will be able to do IO using =E2=80=9Cdd=E2=80=9D.  I suspe=
ct that I
> haven=E2=80=99t configured my hotplug to call =E2=80=9Cmultipath=E2=80=9D=
 tool as the path is
> made available/unavailable.  I am not sure on where I get hotplug
> script for multipath and how to configure hotplug for calling the
> =E2=80=9Cmultipath=E2=80=9D tool. I appreciate if anyone can help me ou=
t in this
> regard.
>=20
No need

Regards,
--=20
christophe varoqui <christophe.varoqui@free.fr>
