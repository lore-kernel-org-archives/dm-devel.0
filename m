From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath-tools Makefile
Date: Tue, 19 Jun 2007 23:15:28 +0200
Message-ID: <1182287728.20149.255.camel@localhost.localdomain>
References: <20070618225947.26450.qmail@sourceware.org>
	<1182214679.5301.88.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1182214679.5301.88.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com
Cc: dm-cvs@sourceware.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Le lundi 18 juin 2007 =C3=A0 17:57 -0700, Chandra Seetharaman a =C3=A9cri=
t :
> Hi,
>=20
> Sorry about the late response. I just realized that pp_rdac has been
> added to the multipath tree.
>=20
> pp_rdac is not needed to support lsi-rdac devices. pp_tpc performs
> equally good. I repeated my tests with pp_tpc and they did work well.
>=20
rdac has superseded the tpc checker in the upstream tree.

This checker is currently the only one usable with LSI Engenio hardware
integrated by either IBM or SGI. As such I don't plan on removing it
from the tree, if it's ok with you.

Regards,
cvaroqui
