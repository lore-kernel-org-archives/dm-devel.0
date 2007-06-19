From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath-tools Makefile
Date: Tue, 19 Jun 2007 23:34:25 +0200
Message-ID: <1182288865.20149.259.camel@localhost.localdomain>
References: <20070618225947.26450.qmail@sourceware.org>
	<1182214679.5301.88.camel@linuxchandra>
	<1182287728.20149.255.camel@localhost.localdomain>
	<1182288343.5301.111.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1182288343.5301.111.camel@linuxchandra>
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

Le mardi 19 juin 2007 =C3=A0 14:25 -0700, Chandra Seetharaman a =C3=A9cri=
t :
> On Tue, 2007-06-19 at 23:15 +0200, Christophe Varoqui wrote:
> > Le lundi 18 juin 2007 =C3=A0 17:57 -0700, Chandra Seetharaman a =C3=A9=
crit :
> > > Hi,
> > >=20
> > > Sorry about the late response. I just realized that pp_rdac has bee=
n
> > > added to the multipath tree.
> > >=20
> > > pp_rdac is not needed to support lsi-rdac devices. pp_tpc performs
> > > equally good. I repeated my tests with pp_tpc and they did work wel=
l.
> > >=20
> > rdac has superseded the tpc checker in the upstream tree.
> >=20
>=20
> (A):
> > This checker is currently the only one usable with LSI Engenio hardwa=
re
> > integrated by either IBM or SGI. As such I don't plan on removing it
> > from the tree, if it's ok with you.
> >=20
>=20
> I am little confused here.
>=20
> Background info:
> ------
> (1) When I said we do _not_ need pp_rdac, I am referring to path
> priority callout code(the code I submitted on May 21st). Code under the
> directory path_priority/pp_rdac.
>=20
> (2) The path checker code I submitted on March 23rd is needed to suppor=
t
> the LSI Engenio hardware. This code resides in libcheckers/rdac.c
> ------
>=20
> (2) is needed and I presume you are referring to that at (A)=20
>=20
> (1) is not needed and we can achieve the same with
> path_priority/pp_tpc/mpath_prio_tpc
>=20

The confusion was on my side, thank you for pointing it.
I'll get back to my homework then.
