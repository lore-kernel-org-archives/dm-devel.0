From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 2/2] multipath: attempt at common
	multipath.rules
Date: Fri, 30 Jun 2017 11:48:25 -0500
Message-ID: <20170630164825.GS2940@octiron.msp.redhat.com>
References: <1492035310-27525-1-git-send-email-bmarzins@redhat.com>
	<1492035310-27525-3-git-send-email-bmarzins@redhat.com>
	<1498599692.27347.26.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1498599692.27347.26.camel@suse.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 27, 2017 at 11:41:32PM +0200, Martin Wilck wrote:
> Hello Ben,
> =

> Thanks again for your effort on this issue.
> I finally found time to look into this proposal more deeply, sorry that
> it took so long.
> =

> Please find my comments below.
> =

> Best regards,
> Martin
> =

> On Wed, 2017-04-12 at 17:15 -0500, Benjamin Marzinski wrote:
> > This is a proposal to try and bring the Redhat and SuSE
> > multipath.rules
> > closer. There are a couple of changes that I'd like some input on.
> > =

> > The big change is moving the kpartx call into the multipath
> > rules.  Half
> > of the current kpartx.rules file is about creating symlinks for
> > multiple
> > types of dm devices. The other half auto-creates kpartx devices on
> > top
> > of multipath devices. Since it is only creating kpartx devices on top
> > of
> > multipath devices, I've moved the these rules into multipath.rules,
> > or
> > rather, I've replaced them with the redhat rules in multipath.rules. =

> =

> I don't like the move of the rules too much, for two reasons:
> =

> 1) Even if multipath is the only use case today, I see no deeper reason
> why kpartx would be used only for multipath devices. It could be used
> to create partitions on top of other dm targets as well.
> =

> 2) multipath.rules now consists of two completely unrelated parts, one
> for detecting paths that are part of multipath maps, and one for
> running kpartx on the maps themselves. That's confusing and sort of
> against the "spirit" of udev rules, as far as I understand it.
> Logically, if you really want to merge this into another .rules file,
> the kpartx part would rather belong into 11-dm-mpath.rules (which deals
> with multipath maps) than in 56-multipath.rules (which deals with
> paths).

That's a fair complaint.  I'm not sure if the kpartx rules belong in
11-dm-mpath.rules. That works a lot line 11-dm-lvm.rules. Both are just
setting up flags for the other udev rules to use.  Perhaps the best
answer is to move what is the kpartx part of my multipath.rules to
kpartx.rules, and move the generic dm device labelling stuff from
kpartx.rules to some other rules file.
 =

> > The
> > biggest difference is the kpartx isn't run on every reload.  It works
> > with the 11-dm-mpath.rules code to not run kpartx on multipathd
> > generated reloads or when there aren't any working paths. It does
> > remember if it didn't get to run kpartx when it was supposed to
> > (because
> > there were no valid paths or the device was suspended) and will make
> > sure to run it on the next possible uevent.
> =

> I like this part, but i have some suggestions, see below.
> =

> > The other change is the redhat multipath rules remove the partition
> > device nodes for devices claimed by multipath. The udev rule will
> > only
> > do this one time (both to keep from running partx on every event, and
> > so
> > that if users manually reread the partition table, we don't keep
> > removing them when clearly they are wanted). Redhat does this because
> > we
> > had multiple customer issues where they were using the scsi
> > partitions
> > instead of the kpartx devices. Obviously, with setting the partition
> > devices to not ready and clearing their fs_type, this isn't
> > essential,
> > but it has helped make customers do the right thing.
> =

> Isn't this racy? You call "partx -d" on the parent device (e.g. sda).
> At this point in time, the kernel will already have detected the
> partitions and "add" uevents for them are likely to follow up quickly.
> You generate "remove" events that may race with the "add" - or am I
> overlooking something?

Yes this is racey. However, when the partition devices do come up, the
are marked with ENV{SYSTEMD_READY}=3D"0" and ENV{ID_FS_TYPE}=3D"none". This
means that systemd isn't going to do anything with them. So the devices
may appear for an instant, and then get pulled, but nothing should
auto-anything on top of them.

 =

> I'd feel better if we'd call "partx -d" while processing the "add"
> uevent for the _partitions_, ideally late in that process. That would
> make (almost) sure that "add" was finished when "remove" was generated.
> See below.

My goal was to pull them before they ever appeared at all.  I should
point out that although my way is racey insofar as the partition device
may appear for a brief moment or not. The partition device will always
get removed, regardless of whether the "partx -d" call comes before or
after it appears.

-Ben

> > =

> > Cc: Martin Wilck <mwilck@suse.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  kpartx/kpartx.rules       |  8 --------
> >  multipath/multipath.rules | 27 ++++++++++++++++++++++++---
> >  2 files changed, 24 insertions(+), 11 deletions(-)
> > =

> > diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
> > index 48a4d6c..906e320 100644
> > --- a/kpartx/kpartx.rules
> > +++ b/kpartx/kpartx.rules
> > @@ -34,12 +34,4 @@ ENV{ID_FS_LABEL_ENC}=3D=3D"?*",
> > IMPORT{db}=3D"ID_FS_LABEL_ENC"
> >  ENV{ID_FS_USAGE}=3D=3D"filesystem|other", ENV{ID_FS_LABEL_ENC}=3D=3D"?=
*", \
> >  	SYMLINK+=3D"disk/by-label/$env{ID_FS_LABEL_ENC}"
> >  =

> > -# Create dm tables for partitions
> > -ENV{DM_ACTION}=3D=3D"PATH_FAILED|PATH_REINSTATED", GOTO=3D"kpartx_end"
> > -ENV{DM_NR_VALID_PATHS}=3D=3D"0", GOTO=3D"kpartx_end"
> > -ENV{ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!=3D"1",
> > IMPORT{db}=3D"DM_SUBSYSTEM_UDEV_FLAG1"
> > -ENV{DM_SUBSYSTEM_UDEV_FLAG1}=3D=3D"1", GOTO=3D"kpartx_end"
> > -ENV{DM_STATE}!=3D"SUSPENDED", ENV{DM_UUID}=3D=3D"mpath-*", \
> > -	RUN+=3D"/sbin/kpartx -u -p -part /dev/$name"
> > -
> >  LABEL=3D"kpartx_end"
> > diff --git a/multipath/multipath.rules b/multipath/multipath.rules
> > index 86defc0..10b9b2b 100644
> > --- a/multipath/multipath.rules
> > +++ b/multipath/multipath.rules
> > @@ -1,13 +1,13 @@
> >  # Set DM_MULTIPATH_DEVICE_PATH if the device should be handled by
> > multipath
> >  SUBSYSTEM!=3D"block", GOTO=3D"end_mpath"
> >  ACTION!=3D"add|change", GOTO=3D"end_mpath"
> > -KERNEL!=3D"sd*|dasd*", GOTO=3D"end_mpath"
> > -
> > +KERNEL!=3D"sd*|dasd*|rbd*|dm-*", GOTO=3D"end_mpath"
> >  IMPORT{cmdline}=3D"nompath"
> >  ENV{nompath}=3D=3D"?*", GOTO=3D"end_mpath"
> >  IMPORT{cmdline}=3D"multipath"
> >  ENV{multipath}=3D=3D"off", GOTO=3D"end_mpath"
> >  =

> > +KERNEL=3D=3D"dm-*", GOTO=3D"check_kpartx"
> >  ENV{DEVTYPE}!=3D"partition", GOTO=3D"test_dev"
> >  IMPORT{parent}=3D"DM_MULTIPATH_DEVICE_PATH"
> >  ENV{DM_MULTIPATH_DEVICE_PATH}=3D=3D"1", ENV{ID_FS_TYPE}=3D"none", \
> > @@ -21,7 +21,28 @@ TEST!=3D"$env{MPATH_SBIN_PATH}/multipath",
> > ENV{MPATH_SBIN_PATH}=3D"/usr/sbin"
> >  =

> >  ENV{DM_MULTIPATH_DEVICE_PATH}!=3D"1", \
> >  	PROGRAM=3D=3D"$env{MPATH_SBIN_PATH}/multipath -u %k", \
> > -	ENV{DM_MULTIPATH_DEVICE_PATH}=3D"1", ENV{ID_FS_TYPE}=3D"none", \
> > +	ENV{DM_MULTIPATH_DEVICE_PATH}=3D"1",
> > ENV{ID_FS_TYPE}=3D"mpath_member", \
> >  	ENV{SYSTEMD_READY}=3D"0"
> >  =

> > +ENV{DM_MULTIPATH_DEVICE_PATH}!=3D"1", GOTO=3D"end_mpath"
> > +
> > +IMPORT{db}=3D"DM_MULTIPATH_WIPE_PARTS"
> > +ENV{DM_MULTIPATH_WIPE_PARTS}!=3D"1", ENV{DM_MULTIPATH_WIPE_PARTS}=3D"1=
",
> > \
> > +	RUN+=3D"/sbin/partx -d --nr 1-1024 $env{DEVNAME}"
> > +GOTO=3D"end_mpath"
> =

> I could imagine that this functionality, in general, might be useful
> for members of other dm targets besides multipath as well. I suggest to
> create a new, separate rules file for it. Moreover, I think it would be
> better to act on the partitions rather than on disks (see above).
> =

> Here's a draft attempt at such a new rules file, please tell me what
> you think:
> =

> # 68-del-parts.rules
> # Delete partitions on disks which are members of dm (multipath) maps
> =

> SUBSYSTEM!=3D"block", GOTO=3D"end_del_parts"
> ACTION!=3D"add", GOTO=3D"end_del_parts"
> KERNEL!=3D"sd*|dasd*|rbd*", GOTO=3D"end_del_parts"
> =

> # possibly add other DM member types here
> ENV{DM_MULTIPATH_DEVICE_PATH}=3D=3D"1", GOTO=3D"wipe_parts"
> GOTO=3D"end_del_parts"
> =

> LABEL=3D"wipe_parts"
> ENV{DEVTYPE}=3D=3D"partition", GOTO=3D"del_partition"
> ENV{DEVTYPE}!=3D"disk", GOTO=3D"end_del_parts"
> =

> # Handle disks
> # DM_WIPE_PARTS is set to "1" at first processing, "2" later
> # Only if it's "1", partitions will be deleted
> IMPORT{db}=3D"DM_WIPE_PARTS"
> ENV{DM_WIPE_PARTS}=3D=3D"1", ENV{DM_WIPE_PARTS}=3D"2"
> ENV{DM_WIPE_PARTS}!=3D"?*", ENV{DM_WIPE_PARTS}=3D"1"
> GOTO=3D"end_del_parts"
> =

> LABEL=3D"del_partition"
> IMPORT{parent}=3D"DM_WIPE_PARTS"
> ENV{DM_WIPE_PARTS}=3D=3D"1", ENV{SYSTEMD_READY}=3D"0", RUN+=3D"/sbin/part=
x -d $env{DEVNAME}", OPTIONS:=3D"nowatch"
> =

> LABEL=3D"end_del_parts"
> # end 68-del-parts.rules
> =

> > +LABEL=3D"check_kpartx"
> > +
> > +IMPORT{db}=3D"DM_MULTIPATH_NEED_KPARTX"
> As remarked above, I'd vote for removing "MULTIPATH" from this property
> name.
> =

> > +ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!=3D"1",
> > IMPORT{db}=3D"DM_SUBSYSTEM_UDEV_FLAG1"
> > +ENV{DM_SUBSYSTEM_UDEV_FLAG1}=3D=3D"1", GOTO=3D"end_mpath"
> > +ACTION!=3D"change", GOTO=3D"end_mpath"
> > +ENV{DM_UUID}!=3D"mpath-?*", GOTO=3D"end_mpath"
> > +ENV{DM_ACTIVATION}=3D=3D"1", ENV{DM_MULTIPATH_NEED_KPARTX}=3D"1"
> > +ENV{DM_SUSPENDED}=3D=3D"1", GOTO=3D"end_mpath"
> > +ENV{DM_ACTION}=3D=3D"PATH_FAILED", GOTO=3D"end_mpath"
> =

> The previous code had ENV{DM_ACTION}=3D=3D"PATH_FAILED|PATH_REINSTATED",
> why did you drop the latter? =

> Anyway, I think both aren't needed because in 11-dm-mpath.rules,
> "DM_ACTIVATION" is set to "0" in the "reload if paths are
> lost/recovered" case. I think the cleaner way to express the logic here
> would be:
> =

> # don't rerun kpartx on "reload" events (see 11-dm-mpath.rules)
> ENV{DM_ACTIVATION}=3D=3D"0", GOTO=3D"end_mpath"
> # don't run kpartx when there are no paths
> ENV{MPATH_DEVICE_READY}=3D=3D"0", GOTO=3D"end_mpath"
> =

> > +ENV{DM_ACTIVATION}!=3D"1", ENV{DM_MULTIPATH_NEED_KPARTX}!=3D"1",
> > GOTO=3D"end_mpath"
> > +RUN+=3D"/sbin/kpartx -u -p -part /dev/$name"
> > +ENV{DM_MULTIPATH_NEED_KPARTX}=3D""
> > +
> >  LABEL=3D"end_mpath"
> =

> In general, it seems to me that both the addition and removal of
> partition device nodes is not specific to multipath and, once we agree
> on a set of rules, we should forward this to the udev and libdevmapper
> community (reading this already? thanks!).
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
