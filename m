From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: dm-multipath: syncing path states
Date: Wed, 22 Feb 2006 00:08:40 +0100
Message-ID: <1140563320.5370.0.camel@localhost.localdomain>
References: <20060221223708.GB5670@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060221223708.GB5670@ether.msp.redhat.com>
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

Le mardi 21 f=C3=A9vrier 2006 =C3=A0 16:37 -0600, Benjamin Marzinski a =C3=
=A9crit :
> Occasionally, the path states for multipathd and device mapper are out =
of sync.
> This happens either when multipathd starts, or after a multipath map is
> created or reloaded (what a path is added or removed, or a map is added=
).
> The attached patch syncs the paths' dmstate with it's state after one o=
f
> these actions happens.
>=20
Applied, thanks.

Regards,
cvaroqui
