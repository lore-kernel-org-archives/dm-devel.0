From: "goggin, edward" <egoggin@emc.com>
Subject: RE: Clariion CX600 automatic failback support
Date: Sun, 6 Nov 2005 13:29:05 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ADB3@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Date: Fri, 04 Nov 2005 21:55:20 +0100
Christophe Varoqui <christophe.varoqui@free.fr> wrote

> Subject: RE: [dm-devel] Clariion CX600 automatic failback support
> To: device-mapper development <dm-devel@redhat.com>
> Message-ID: <1131137721.7463.12.camel@zezette>
> Content-Type: text/plain; charset=3Dutf-8
>=20
>=20
> > > Yes, the test to determine if a switch is needed is sub-optimal :
> > > The no activated PG case (all Enabled for example=C3=83=C6=92) keep=
s=20
> > > triggering a switch.
> > > I checked-in a patch to solve that issue.
> >=20
> > I've dealt with this problem by patching the device mapper
> > multipath driver in the kernel.
> >=20
> > The patch below patches drivers/md/dm-mpath.c:multipath_status()
> > to return an active state for a path group which is either the
> > current path group or setup to be the next path group instead
> > of just returning an active state for a path group which is
> > currently active.
> >=20
> Right, it deserved to be done.
>=20
> I'm inclined to keep the tools patch anyway : it wastes an "int" per
> multipath but is brain-friendlier (as it avoids using mpp->nextpg to
> represent the current setting *and* the best-rated setting).
>=20
> Are interested parties ok with that ?

Good point.  This slightly modified patch fixes the "*and*" case by only
returning active if either the particular path group is the current activ=
e
or there is no current active but the particular path group is set to be
the next (first) deferred active path group.

*** ../base/linux-2.6.14-rc4/drivers/md/dm-mpath.c	Mon Oct 10 20:19:19
2005
--- drivers/md/dm-mpath.c	Sat Nov  5 03:02:50 2005
***************
*** 1158,1164 ****
  		list_for_each_entry(pg, &m->priority_groups, list) {
  			if (pg->bypassed)
  				state =3D 'D';	/* Disabled */
! 			else if (pg =3D=3D m->current_pg)
  				state =3D 'A';	/* Currently Active */
  			else
  				state =3D 'E';	/* Enabled */
--- 1158,1164 ----
  		list_for_each_entry(pg, &m->priority_groups, list) {
  			if (pg->bypassed)
  				state =3D 'D';	/* Disabled */
! 			else if ((pg =3D=3D m->current_pg) || ((!m->current_pg)
&&(pg =3D=3D m->next_pg)))
  				state =3D 'A';	/* Currently Active */
  			else
  				state =3D 'E';	/* Enabled */
