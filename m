From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: multipath-0.5.0 still provides broken udev rules
Date: Wed, 27 Apr 2016 17:46:01 -0500
Message-ID: <20160427224601.GG26117@octiron.msp.redhat.com>
References: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
	<571DF852.6030604@redhat.com>
	<CAE+k_gKQcx+QR9bfEp1Wy8BawD14L2G5O0Yw-d0=CffBHqYbrA@mail.gmail.com>
	<571E0E7A.4050703@redhat.com>
	<CABr-GnfxOKz8gxDju20Hx3T9Tn74Zz9FhjF1dBk8weEBJMOmLg@mail.gmail.com>
	<1986ca6b-d281-4faf-2b50-11c3dc132463@gmail.com>
	<571F026C.5040102@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <571F026C.5040102@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Peter Volkov <peter.volkov@gmail.com>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Tue, Apr 26, 2016 at 07:53:48AM +0200, Hannes Reinecke wrote:
> On 04/25/2016 10:14 PM, Xose Vazquez Perez wrote:
> > On 04/25/2016 02:56 PM, Christophe Varoqui wrote:
> > =

> >> Those example udev rules are indeed unmaintained and should be
> >> removed not to confuse distributors.
> >>
> >> Distributors can't be asked to agree on a common udev ruleset.
> >> Ben, Hannes, Xos=E9, Peter are you ok with my deleting the udev rules =
example ?
> > =

> > Fine with me.
> > =

> > Btw, are these relevant ?

For all that I didn't comment on, I feel the same way as Hannes.

> > getuid/usb_id
> Huh? What is that doing there?
> It should really have been moved to the udev package ...
> =

> > kpartx/kpartx_id
> > kpartx/kpartx.rules
> See above. Yes, they are relevant (at least for us)

Like I said, Red Hat doesn't use them. I'll post our multipath.rules
shortly.

> > multipath/01_udev
> > multipath/02_multipath
> Not used anymore with systemd/dracut
> =

> > multipath/11-dm-mpath.rules
> Yep. Absolutely required.
> =

> > multipath.conf.annotated
> > multipath.conf.defaults
> > multipath.conf.synthetic
> Actually, I never saw the need for those.
> Can we at least have them merged?

I don't think they are being kept up to date anymore.  The 'defaults'
information can be gotten from a running system, and it includes the
changes from the config files, so it's much more useful. I have no idea
what people would use 'synthetic' for besides an example of what a
config would look like. And the 'annotated' information is all in the
multipath.conf manpage. Red Hat doesn't ship these files anymore. I'd be
happy to see them go.
 =

> > multipathd/multipathd.init.debian
> > multipathd/multipathd.init.redhat
> > multipathd/multipathd.init.suse
> Old init scripts; doubtful value.
> =

> > multipathd/multipathd.service
> > multipathd/multipathd.socket
> systemd service definitions. Yes, required.

Red Hat has a slightly different multipathd.service file, and we don't
ship the socket file.  Since multipathd should always be running, I
don't really see the need. Also, if you start multipathd manually
(instead of through udev) this causes problems with multipathd not
getting messages.

For those interested, here's a diff of our multipath.service

diff --git a/multipathd/multipathd.service
b/multipathd/multipathd.service
index d5f8606..1e5dfab 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -2,9 +2,10 @@
 Description=3DDevice-Mapper Multipath Device Controller
 Before=3Discsi.service iscsid.service lvm2-activation-early.service
 Before=3Dlocal-fs-pre.target
-After=3Dmultipathd.socket
+ConditionPathExists=3D/etc/multipath.conf
+ConditionKernelCommandLine=3D!nompath
 DefaultDependencies=3Dno
-Wants=3Dlocal-fs-pre.target multipathd.socket blk-availability.service
+Wants=3Dlocal-fs-pre.target blk-availability.service
 Conflicts=3Dshutdown.target
 =

 [Service]
@@ -12,9 +13,9 @@ Type=3Dnotify
 NotifyAccess=3Dmain
 LimitCORE=3Dinfinity
 ExecStartPre=3D/sbin/modprobe dm-multipath
+ExecStartPre=3D-/sbin/multipath -A
 ExecStart=3D/sbin/multipathd -d -s
 ExecReload=3D/sbin/multipathd reconfigure
 =

 [Install]
 WantedBy=3Dsysinit.target
-Also=3Dmultipathd.socket


Aside from dropping the socket, it checks that /etc/multipath.conf
exists, and that the kernel wasn't started with "nompath". Also it runs
"multipath -A" this reads the kernel commandline from /proc/cmdline, and
adds any wwids listed as part of any mpath.wwid=3D<wwid> parameters.
Hannes NACKed this patch, so the option isn't present upsteam.

 =

> > multipath/multipath.init.suse
> Old init script; not used anymore.
> =

> > multipath/multipath.rules
> Yep. used for udev.
> =

> > multipath-tools.spec.in
> > =

> Well; due to our buildservice we have to keep a separate spec file
> anyway. So ATM we don't use it.
> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
