From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 4/5] kpartx: default to running in sync mode
Date: Thu, 11 May 2017 12:46:35 -0500
Message-ID: <20170511174635.GI22856@octiron.msp.redhat.com>
References: <1493073570-17167-1-git-send-email-bmarzins@redhat.com>
	<1493073570-17167-5-git-send-email-bmarzins@redhat.com>
	<1494506528.6093.19.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1494506528.6093.19.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, May 11, 2017 at 02:42:08PM +0200, Martin Wilck wrote:
> Hi Ben,
> =

> On Mon, 2017-04-24 at 17:39 -0500, Benjamin Marzinski wrote:
> =

> > When users run kpartx, they would naturally assume that when it
> > completes, the devices have been created. However, kpartx runs in
> > async
> > mode by default.=A0=A0This seems like it is likely to trip up users.=A0
> =

> Is this just likely, or do you have evidence that it really did
> irritate users? You introduced "sync mode", together with the "-s"
> flag, yourself in 2010, and unless I'm mistaken, kpartx operated in
> "async" mode before that, too, because there was no "sync" mode.=A0

Yes. I made this patch after the second time a customer complained that
kpartx wasn't working correctly, when the real issue was that their
scripts were assuming that after the kpartx command completed, those
partition device nodes would be present. Obviously, 2 isn't a huge
number, but it certainly has caused confusion in some cases.

> I'm not too fond of the idea to change a default which has been
> established for such a long time just because user mistakes are
> "likely". For one thing, such changes are difficult to document in a
> way that doesn't cause confusion. Also, if someone writes a script in
> which she wants kpartx to run asynchronously, it will be difficult to
> do so in a manner which is portable between distributions if some
> distributions include this patch and some don't.

I see your point, but assuming that I am correct that most users do
assume that kpartx runs synchronously, I feel like we shouldn't keep a
bad default forever, simply because it's always been that way. lvm and
dmsetup wait for udev by default (well, on lvm IIRC it is a compile-time
setting, but here is some SUSE documentation showing that it uses udev
synchronization by default
https://www.suse.com/documentation/sles-12/stor_admin/data/sec_lvm_cli.html)
kpartx does seem to be the odd one out.

> As an alternative, we might simply warn about the default asynchronous
> behavior in a prominent place in the man page.

We could, and if you are opposed to this patch, that would probably help
cut down any confusion (assuming that when customers see things go wrong
they read the documentation before calling support).

-Ben

> Cheers,
> Martin
> =

> > =A0So,
> > switch the default to sync mode, add a -n option to enable async
> > mode,
> > and set async mode when kpartx is called by the udev rules.
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0kpartx/kpartx.c=A0=A0=A0=A0=A0| 10 +++++++---
> > =A0kpartx/kpartx.rules |=A0=A02 +-
> > =A02 files changed, 8 insertions(+), 4 deletions(-)
> > =

> > diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> > index 58e60ff..d1edd5e 100644
> > --- a/kpartx/kpartx.c
> > +++ b/kpartx/kpartx.c
> > @@ -58,7 +58,7 @@ struct pt {
> > =A0} pts[MAXTYPES];
> > =A0
> > =A0int ptct =3D 0;
> > -int udev_sync =3D 0;
> > +int udev_sync =3D 1;
> > =A0
> > =A0static void
> > =A0addpts(char *t, ptreader f)
> > @@ -86,7 +86,7 @@ initpts(void)
> > =A0	addpts("ps3", read_ps3_pt);
> > =A0}
> > =A0
> > -static char short_opts[] =3D "rladfgvp:t:su";
> > +static char short_opts[] =3D "rladfgvp:t:snu";
> > =A0
> > =A0/* Used in gpt.c */
> > =A0int force_gpt=3D0;
> > @@ -105,7 +105,8 @@ usage(void) {
> > =A0	printf("\t-g force GUID partition table (GPT)\n");
> > =A0	printf("\t-f force devmap create\n");
> > =A0	printf("\t-v verbose\n");
> > -	printf("\t-s sync mode. Don't return until the partitions
> > are created\n");
> > +	printf("\t-n nosync mode. Return before the partitions are
> > created\n");
> > +	printf("\t-s sync mode. Don't return until the partitions
> > are created. Default.\n");
> > =A0	return 1;
> > =A0}
> > =A0
> > @@ -291,6 +292,9 @@ main(int argc, char **argv){
> > =A0		case 's':
> > =A0			udev_sync =3D 1;
> > =A0			break;
> > +		case 'n':
> > +			udev_sync =3D 0;
> > +			break;
> > =A0		case 'u':
> > =A0			what =3D UPDATE;
> > =A0			break;
> > diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
> > index 48a4d6c..a958791 100644
> > --- a/kpartx/kpartx.rules
> > +++ b/kpartx/kpartx.rules
> > @@ -40,6 +40,6 @@ ENV{DM_NR_VALID_PATHS}=3D=3D"0", GOTO=3D"kpartx_end"
> > =A0ENV{ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!=3D"1",
> > IMPORT{db}=3D"DM_SUBSYSTEM_UDEV_FLAG1"
> > =A0ENV{DM_SUBSYSTEM_UDEV_FLAG1}=3D=3D"1", GOTO=3D"kpartx_end"
> > =A0ENV{DM_STATE}!=3D"SUSPENDED", ENV{DM_UUID}=3D=3D"mpath-*", \
> > -	RUN+=3D"/sbin/kpartx -u -p -part /dev/$name"
> > +	RUN+=3D"/sbin/kpartx -un -p -part /dev/$name"
> > =A0
> > =A0LABEL=3D"kpartx_end"
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
