From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: RE: regarding DM device for a single path.
Date: Sun, 07 Aug 2005 00:18:16 +0200
Message-ID: <1123366696.21778.71.camel@zezette>
References: <E8C532D801BE5B479B28B626184E8CDD07C7F2FB@tayexc14.americas.cpqcorp.net>
	<1123264699.21778.57.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1123264699.21778.57.camel@zezette>
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

On ven, 2005-08-05 at 19:58 +0200, christophe varoqui wrote:
> =20
> >=20
> >      1. I tested your latest user space tools with 2.6.9-11.41 kernel=
.
> >         Used the default created devices for multipathing. The path
> >         status is getting updated appropriately for HSV200 arrays.
> >          However the failback functionality is not working for me. I
> >         have configure value for =E2=80=9Cfailback=E2=80=9D variable
> >         in /etc/multipath.conf as zero for immediate failback, but
> >         when the failed path in the original path group comes back
> >         online, the IO is not failed back the old pathgroup.
> >=20
> I'll look into that when I return from vacation in 2 weeks.
> I think I'll have the appropriate HW at hand.
> =20
Well, preparing my laptop for vacation, I took the time to verify that :

1) /sbin/multipath works with usb keys (modulo a brain-dead
getuid_callout like "/bin/echo myonlykey") :/

2) single path maps effectivelly get created

Leaving for 2 weeks now.
Regards,
--=20
christophe varoqui <christophe.varoqui@free.fr>
