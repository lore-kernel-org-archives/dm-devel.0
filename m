From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 22/57] multipath: use option '-i' when called
	from udev
Date: Tue, 3 May 2016 09:14:12 -0500
Message-ID: <20160503141412.GA26117@octiron.msp.redhat.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-23-git-send-email-hare@suse.de>
	<20160502153124.GP26117@octiron.msp.redhat.com>
	<57283ABF.4080304@suse.de>
	<CABr-GncAsFSouftGFZgnMR5FLsF+U3GYYLtbe8MTY3LG3g7=rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABr-GncAsFSouftGFZgnMR5FLsF+U3GYYLtbe8MTY3LG3g7=rw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, May 03, 2016 at 08:37:08AM +0200, Christophe Varoqui wrote:
>    Ben,
>    does this patch actually break the Red Hat integration ?
>    I'm inclined to merge it if not.

Like we talked about earlier, RedHat uses a completely different
multipath.rules file, which includes some command options that were
NAK'ed for inclusion. We can sort that out. Either we will or we won't
come to an agreement on how multipath should interact with udev. If we
don't we can probably just keep different rules files for the different
distributions. But having a mostly-but-not-quite working version of the
SUSE rules file really benefits nobody. I'm in favor of this going it.

-Ben

>    Thanks,
>    Christophe
>    On Tue, May 3, 2016 at 7:44 AM, Hannes Reinecke <[1]hare@suse.de> wrot=
e:
> =

>      On 05/02/2016 05:31 PM, Benjamin Marzinski wrote:
>      > On Wed, Apr 27, 2016 at 01:10:23PM +0200, Hannes Reinecke wrote:
>      >> multipath should be using the option '-i' to ignore the wwids
>      >> file when called from udev. Otherwise we might run into a race
>      >> condition with systemd and the system might not boot up correctly.
>      >
>      > The race condition being? Are you talking about the udev rules not
>      > claiming a path for multipath, but then having multipathd create a
>      > multipath device using that path? I agree that this can be an issu=
e.
>      > Another way to solve it is to run mutipathd with the -n option in =
the
>      > initramfs (see commit a8efa5838cf215febd853f282c26af62c0daa862). T=
hat
>      > commit solves the race by making mutipathd ignore devices that are=
n't
>      > already in the wwids file.=A0 This also keeps the initramfs from p=
icking
>      a
>      > different user_friendly_name than will be picked in late boot (but
>      > hopefully that issue has been sorted out by other patches already).
>      >
>      This is in fact SUSE-specific, as we do _not_ require any a-priory
>      configuration. So we will start out with a system without any wwid f=
ile,
>      _but_ expect multipath to start up properly.
>      As the wwid file will only be created by multipathd the udev check w=
ill
>      always being false, and none of the multipath devices will be create=
d.
>      > I'm not NAKing this. The question of what to do about the differnc=
es
>      in
>      > the distribution's systemd and udev configurations can be hashed o=
ut
>      > outside of patch reviewing. I just want to make sure I understand =
the
>      > race this is solving.
>      >
>      This is in fact a good question.
>      We should be coming up with a common approach which would suit both
>      needs.
> =

>      Cheers,
> =

>      Hannes
>      --
>      Dr. Hannes Reinecke=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0zSeries & =
Storage
>      [2]hare@suse.de=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [=
3]+49 911 74053 688
>      SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
>      GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
> =

> References
> =

>    Visible links
>    1. mailto:hare@suse.de
>    2. mailto:hare@suse.de
>    3. file:///tmp/tel:%2B49%20911%2074053%20688
