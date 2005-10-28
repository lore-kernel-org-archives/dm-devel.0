From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: query on device alias/black listing
Date: Fri, 28 Oct 2005 19:40:51 +0200
Message-ID: <1130521251.13850.68.camel@zezette>
References: <3456F611E9329441B12FBB24447B3FA002E39FA5@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3456F611E9329441B12FBB24447B3FA002E39FA5@bgeexc01.asiapacific.cpqcorp.net>
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

On ven, 2005-10-28 at 14:35 +0530, Murthy, Narasimha Doraswamy (STSD)
wrote:
> Blacklisting of the device is possible using =E2=80=9Cwwid <wwn>=E2=80=9D=
 in blacklist
> block in /etc/multipath.conf. Is there any way to blacklist the device
> created with alias? Giving an alias name in devnode or wwid doesn=E2=80=
=99t
> seem to work.
>=20
Yes, known limitation.

Do you request the feature ? I'm not fond of introducing this as we'll
have trouble keeping the blacklist in sync when aliases change ... are
you ?

>=20
> 3. As it is not encouraged dmsetup utility to be used for multipathing
> devices, features like suspend and resume will be useful in bringing
> down the device for maintenance purposes. Any thoughts?=20

Agreed.

The daemon, by design, is a good place to send "message-ioctls" like
these. Adding the daemon CLI command shouldn't be hard. I'll look into
it.

Regards,
cvaroqui
