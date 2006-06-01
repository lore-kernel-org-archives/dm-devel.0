From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [multipath-tools] [patch] fix select_alias weirdness
Date: Thu, 01 Jun 2006 20:38:42 +0200
Message-ID: <1149187122.8452.81.camel@localhost.localdomain>
References: <20060601010913.GA25695@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060601010913.GA25695@ether.msp.redhat.com>
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

Le mercredi 31 mai 2006 =C3=A0 20:09 -0500, Benjamin Marzinski a =C3=A9cr=
it :
> In select_alias, the code that tries to pull the alias from dm_get_name=
()
> sets mp->alias. So even if it fails,  mp->alias will never get set to m=
p->wwid.=20
>=20
> This patch fixes that.
>=20
Right. Applied.

Regards,
cvaroqui
