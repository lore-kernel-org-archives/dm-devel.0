From: "goggin, edward" <egoggin@emc.com>
Subject: RE: Clariion CX600 automatic failback support
Date: Fri, 4 Nov 2005 14:36:01 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ADAC@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
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

On Date: Fri, 4 Nov 2005 10:47:51 +0100
Christophe Varoqui <christophe.varoqui@free.fr> wrote

> On Fri, Nov 04, 2005 at 09:19:06AM +0100, Bernd Zeimetz wrote:
> > Hi,
> >=20
> > > Looks good, except the call to extract_hwe_from_path in=20
> setup_multipath
> > > must be before the call to select_pgfailback.
> > >
> >=20
> > We have a ton of these log messages now.
> > >From the last about 2 hours:
> >=20
> > 580x multipathd: 3600601f4a20c000099dc229956b0d711: switch=20
> to path group #1
> > 714x multipathd: 3600601f4a20c000096dc229956b0d711: switch=20
> to path group #1
> > 714x multipathd: 3600601f2a20c0000fb13caa656b0d711: switch=20
> to path group #1
> >   45x kernel: device-mapper: dm-emc: emc_pg_init: sending=20
> switch-over command
> >=20
> > It happens only for these 3 of 8 luns.
> >=20
> > Kernel is 2.6.13.4, devmapper 1.01, latest multipath-tools=20
> from git, evms=20
> > 2.5.3
> >=20
> > zeus-1:/# cat /etc/multipath.conf
> > defaults {
> >         failback                                immediate
> > }
> >=20
> >=20
> > Since we had a lot of trouble with our CX400 (Hardware=20
> problems, but they're=20
> > supposed to be fixed) I'm wondering what these messages=20
> mean, and if we still=20
> > have hardware/software bugs somewhere.
> >=20
> Yes, the test to determine if a switch is needed is sub-optimal :
> The no activated PG case (all Enabled for example=C3) keeps=20
> triggering a switch.
> I checked-in a patch to solve that issue.

I've dealt with this problem by patching the device mapper
multipath driver in the kernel.

The patch below patches drivers/md/dm-mpath.c:multipath_status()
to return an active state for a path group which is either the
current path group or setup to be the next path group instead
of just returning an active state for a path group which is
currently active.

*** ../base/linux-2.6.14-rc4/drivers/md/dm-mpath.c	Mon Oct 10 20:19:19
2005
--- drivers/md/dm-mpath.c	Thu Nov  3 04:17:48 2005
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
! 			else if ((pg =3D=3D m->current_pg) || (pg =3D=3D
m->next_pg))
  				state =3D 'A';	/* Currently Active */
  			else
  				state =3D 'E';	/* Enabled */
