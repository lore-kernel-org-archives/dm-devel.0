From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] Fix priorities handling for multipathing
Date: Wed, 08 Nov 2006 22:54:52 +0100
Message-ID: <1163022892.27042.35.camel@localhost.localdomain>
References: <4551B673.7030107@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4551B673.7030107@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Le mercredi 08 novembre 2006 =C3=A0 11:50 +0100, Hannes Reinecke a =C3=A9=
crit :
> Hi Christophe,
>=20
> rr_weight=3Dpriorities is currently broken as the 'minio' parameter is=20
> incremented for each path. So when we have enough paths the minio=20
> parameter will eventually overflow and generate an invalid map.
> And we don't disassemble such a map properly, either.
>=20
> Please apply.
>=20
My pleasure.
Applied.

cvaroqui
