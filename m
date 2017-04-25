From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 4/5] kpartx: default to running in sync mode
Date: Tue, 25 Apr 2017 10:52:55 -0500
Message-ID: <20170425155255.GS19236@octiron.msp.redhat.com>
References: <1493073570-17167-1-git-send-email-bmarzins@redhat.com>
	<1493073570-17167-5-git-send-email-bmarzins@redhat.com>
	<d4cdb3c3-c815-998f-9794-150179c74411@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d4cdb3c3-c815-998f-9794-150179c74411@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Apr 25, 2017 at 12:12:25PM +0200, Steffen Maier wrote:
> =

> On 04/25/2017 12:39 AM, Benjamin Marzinski wrote:
> >When users run kpartx, they would naturally assume that when it
> >completes, the devices have been created. However, kpartx runs in async
> >mode by default.  This seems like it is likely to trip up users.  So,
> >switch the default to sync mode, add a -n option to enable async mode,
> >and set async mode when kpartx is called by the udev rules.
> >
> >Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >---
> > kpartx/kpartx.c     | 10 +++++++---
> > kpartx/kpartx.rules |  2 +-
> > 2 files changed, 8 insertions(+), 4 deletions(-)
> >
> >diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> >index 58e60ff..d1edd5e 100644
> >--- a/kpartx/kpartx.c
> >+++ b/kpartx/kpartx.c
> =

> >-int udev_sync =3D 0;
> >+int udev_sync =3D 1;
> =

> >-	printf("\t-s sync mode. Don't return until the partitions are created\=
n");
> >+	printf("\t-n nosync mode. Return before the partitions are created\n");
> >+	printf("\t-s sync mode. Don't return until the partitions are created.=
 Default.\n");
> =

> >+		case 'n':
> >+			udev_sync =3D 0;
> >+			break;
> =

> >diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
> >index 48a4d6c..a958791 100644
> >--- a/kpartx/kpartx.rules
> >+++ b/kpartx/kpartx.rules
> >@@ -40,6 +40,6 @@ ENV{DM_NR_VALID_PATHS}=3D=3D"0", GOTO=3D"kpartx_end"
> > ENV{ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!=3D"1", IMPORT{db}=3D"DM_SUBSYSTEM=
_UDEV_FLAG1"
> > ENV{DM_SUBSYSTEM_UDEV_FLAG1}=3D=3D"1", GOTO=3D"kpartx_end"
> > ENV{DM_STATE}!=3D"SUSPENDED", ENV{DM_UUID}=3D=3D"mpath-*", \
> >-	RUN+=3D"/sbin/kpartx -u -p -part /dev/$name"
> >+	RUN+=3D"/sbin/kpartx -un -p -part /dev/$name"
> =

> I understand this was async before and is now still async after the defau=
lt
> change in kpartx. However, I'm wondering in general how one would "wait" =
for
> kpartx mappings, since I suppose a "udevadm settle" would not suffice.
> Dracut probably does not care because it would loop until its required
> root-fs devices have appeared.

I'm pretty sure that it is inherently impossible in the general case.
There is no way to know when the uevent will occur, and until the uevent
occurs, there would be no way that udev settle could possibly help. You
can know that a dm device has been set up when the first change event
for that device occurs. So, if you knew a device was coming, you could
wait for the change event.  Multipathd currently listens for change
events to know when a multipath device has been fully initialized.

For partition devices explicitly, say you just manually ran multipath to
create a multipath device, and want to know that your partition devices
exist before going on. You could manually run kpartx in the now-default
sync mode, and when it returned, you would know that the devices were
there. However, your kpart call would be racing with the udev version,
so it's possible that kpartx would return with an error because it tried
to create the device and failed because the device already existed. The
good news is that it would continue to try with the rest of the devices,
so it really won't return until they all are there. If it is important
to you, we could add a flag to kpartx to not return an error if a create
fails because the device currently exists. =


-Ben

> =

> -- =

> Mit freundlichen Gr=FC=DFen / Kind regards
> Steffen Maier
> =

> Linux on z Systems Development
> =

> IBM Deutschland Research & Development GmbH
> Vorsitzende des Aufsichtsrats: Martina Koederitz
> Geschaeftsfuehrung: Dirk Wittkopp
> Sitz der Gesellschaft: Boeblingen
> Registergericht: Amtsgericht Stuttgart, HRB 243294
