From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] Fixup return code for 'multipath -l'
Date: Mon, 04 Sep 2006 00:39:47 +0200
Message-ID: <1157323188.13005.15.camel@localhost.localdomain>
References: <44F7E2FC.1090806@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44F7E2FC.1090806@suse.de>
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

Le vendredi 01 septembre 2006 =C3=A0 09:36 +0200, Hannes Reinecke a =C3=A9=
crit :
> Hi Christophe,
>=20
> 'multipath -l' should really set the return code to '0' if no error=20
> occurred.
>=20
> Please apply.
>=20
Done.
The 4 previous patches are also merged.

Thanks,
cvaroqui
