From: Busby <chaimvy@gmail.com>
Subject: Re: [PATCH v6 1/4] dm-replicator: documentation and
	module registry
Date: Tue, 9 Feb 2010 09:48:30 +0800
Message-ID: <b8091bb41002081748k432b7e12t416bb0b52c3c2de6@mail.gmail.com>
References: <1261151073-25962-1-git-send-email-heinzm@redhat.com>
	<1261151073-25962-2-git-send-email-heinzm@redhat.com>
	<b8091bb41001070218m604497en5cffa0bdad76271f@mail.gmail.com>
	<1262979877.27554.40.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8715731182062541392=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1262979877.27554.40.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8715731182062541392==
Content-Type: multipart/alternative; boundary=0050450294e3693b80047f211d74

--0050450294e3693b80047f211d74
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Hi ,
    I have some questions about this replicator module after deployed on my
systems:
    1.when the connection to the  RD failed at the moment reading or writin=
g
data to the D_link, the D_link will fail? can't D_link & LD be well in this
situation? (one LD and one RD, yes, RD can be RDs such as RAID1, however,
all of the RDs disconnected, the D_link also will fail?it will affect on th=
e
user's applications, in gernal speaking, RD can be fail, but the LD (D_link
for user )should be ok at this situation. )
    2.Any deals with the data initiation of the LD and RD in this repl
module, not using 'dd' cmds. is there any interface to do it in the
architecture design of this system (roadmap)?
    3.While doing the repl, sometime, the RD or LD failed, is there any
function to resync th RD and LD when the LD or RD system come back and then
continue to do the repl?
    4.Any design when LD fails, the LD come back,  the RD to restore the LD=
?
not use 'dd' cmd. (as 3rd question said, but this situation just take
attention to the restore repl from the RD.)
     I am very interest in this repl module, sorry for asking so many
questions.
     DRBD of HA feild is a good tool for HA, but not for repl. Is there
other idea of replication design in Linux system?
     Thank you very much.

 Regards,
 Busby
2010/1/9 Heinz Mauelshagen <heinzm@redhat.com>

> On Thu, 2010-01-07 at 18:18 +0800, =D5=C5=D3=EE wrote:
> > Is there any command-line example to explain how to use this  patch?
>
> Look at Documentation/device-mapper/replicator.txt and at comments above
> replicator_ctr() and _replicator_dev_ctr() in dm-repl.c for mapping
> table syntax and examples.
>
> > I have compiled it and loaded the modules, the '<start><length>'
> > target parameters in both replicator ant replicator-dev targets means
> > what?
>
> replicator doesn't provide a direct mapping of its own, so <length> is
> arbitrary and <start> shal be 0.
>
> > how can I construct these target?
>
> See documentation hints above.
>
> > I haven't read the source code in detail till now, sorry.
>
> You will now ;-)
>
> Regards,
> Heinz
>
> >
> >
> > 2009/12/18 <heinzm@redhat.com>
> >         From: Heinz Mauelshagen <heinzm@redhat.com>
> >
> >         The dm-registry module is a general purpose registry for
> >         modules.
> >
> >         The remote replicator utilizes it to register its ringbuffer
> >         log and
> >         site link handlers in order to avoid duplicating registry code
> >         and logic.
> >
> >
> >         Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> >         Reviewed-by: Jon Brassow <jbrassow@redhat.com>
> >         Tested-by: Jon Brassow <jbrassow@redhat.com>
> >         ---
> >          Documentation/device-mapper/replicator.txt |  203
> >         +++++++++++++++++++++++++
> >          drivers/md/Kconfig                         |    8 +
> >          drivers/md/Makefile                        |    1 +
> >          drivers/md/dm-registry.c                   |  224
> >         ++++++++++++++++++++++++++++
> >          drivers/md/dm-registry.h                   |   38 +++++
> >          5 files changed, 474 insertions(+), 0 deletions(-)
> >          create mode 100644 Documentation/device-mapper/replicator.txt
> >          create mode 100644 drivers/md/dm-registry.c
> >          create mode 100644 drivers/md/dm-registry.h
> >
> >         diff --git
> >         2.6.33-rc1.orig/Documentation/device-mapper/replicator.txt
> >         2.6.33-rc1/Documentation/device-mapper/replicator.txt
> >         new file mode 100644
> >         index 0000000..1d408a6
> >         --- /dev/null
> >         +++ 2.6.33-rc1/Documentation/device-mapper/replicator.txt
> >         @@ -0,0 +1,203 @@
> >         +dm-replicator
> >         +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >         +
> >         +Device-mapper replicator is designed to enable redundant
> >         copies of
> >         +storage devices to be made - preferentially, to remote
> >         locations.
> >         +RAID1 (aka mirroring) is often used to maintain redundant
> >         copies of
> >         +storage for fault tolerance purposes.  Unlike RAID1, which
> >         often
> >         +assumes similar device characteristics, dm-replicator is
> >         designed to
> >         +handle devices with different latency and bandwidth
> >         characteristics
> >         +which are often the result of the geograhic disparity of
> >         multi-site
> >         +architectures.  Simply put, you might choose RAID1 to protect
> >         from
> >         +a single device failure, but you would choose remote
> >         replication
> >         +via dm-replicator for protection against a site failure.
> >         +
> >         +dm-replicator works by first sending write requests to the
> >         "replicator
> >         +log".  Not to be confused with the device-mapper dirty log,
> >         this
> >         +replicator log behaves similarly to that of a journal.  Write
> >         requests
> >         +go to this log first and then are copied to all the replicate
> >         devices
> >         +at their various locations.  Requests are cleared from the
> >         log once all
> >         +replicate devices confirm the data is received/copied.  This
> >         architecture
> >         +allows dm-replicator to be flexible in terms of device
> >         characteristics.
> >         +If one device should fall behind the others - perhaps due to
> >         high latency -
> >         +the slack is picked up by the log.  The user has a great deal
> >         of
> >         +flexibility in specifying to what degree a particular site is
> >         allowed to
> >         +fall behind - if at all.
> >         +
> >         +Device-Mapper's dm-replicator has two targets, "replicator"
> >         and
> >         +"replicator-dev".  The "replicator" target is used to setup
> >         the
> >         +aforementioned log and allow the specification of site link
> >         properties.
> >         +Through the "replicator" target, the user might specify that
> >         writes
> >         +that are copied to the local site must happen synchronously
> >         (i.e the
> >         +writes are complete only after they have passed through the
> >         log device
> >         +and have landed on the local site's disk).  They may also
> >         specify that
> >         +a remote link should asynchronously complete writes, but that
> >         the remote
> >         +link should never fall more than 100MB behind in terms of
> >         processing.
> >         +Again, the "replicator" target is used to define the
> >         replicator log and
> >         +the characteristics of each site link.
> >         +
> >         +The "replicator-dev" target is used to define the devices
> >         used and
> >         +associate them with a particular replicator log.  You might
> >         think of
> >         +this stage in a similar way to setting up RAID1 (mirroring).
> >          You
> >         +define a set of devices which will be copies of each other,
> >         but
> >         +access the device through the mirror virtual device which
> >         takes care
> >         +of the copying.  The user accessible replicator device is
> >         analogous
> >         +to the mirror virtual device, while the set of devices being
> >         copied
> >         +to are analogous to the mirror images (sometimes called
> >         'legs').
> >         +When creating a replicator device via the "replicator-dev"
> >         target,
> >         +it must be associated with the replicator log (created with
> >         the
> >         +aforementioned "replicator" target).  When each redundant
> >         device
> >         +is specified as part of the replicator device, it is
> >         associated with
> >         +a site link whose properties were defined when the
> >         "replicator"
> >         +target was created.
> >         +
> >         +The user can go farther than simply replicating one device.
> >          They
> >         +can continue to add replicator devices - associating them
> >         with a
> >         +particular replicator log.  Writes that go through the
> >         replicator
> >         +log are guarenteed to have their write ordering preserved.
> >          So, if
> >         +you associate more than one replicator device to a particular
> >         +replicator log, you are preserving write ordering across
> >         multiple
> >         +devices.  This might be useful if you had a database that
> >         spanned
> >         +multiple disks and write ordering must be preserved or any
> >         transaction
> >         +accounting scheme would be foiled.  (You can imagine this
> >         like
> >         +preserving write ordering across a number of mirrored
> >         devices, where
> >         +each mirror has images/legs in different geographic
> >         locations.)
> >         +
> >         +dm-replicator has a modular architecture.  Future
> >         implementations for
> >         +the replicator log and site link modules are allowed.  The
> >         current
> >         +replication log is ringbuffer - utilized to store all writes
> >         being
> >         +subject to replication and enforce write ordering.  The
> >         current site
> >         +link code is based on accessing block devices (iSCSI, FC,
> >         etc) and
> >         +does device recovery including (initial) resynchronization.
> >         +
> >         +
> >         +Picture of a 2 site configuration with 3 local devices (LDs)
> >         in a
> >         +primary site being resycnhronied to 3 remotes sites with 3
> >         remote
> >         +devices (RDs) each via site links (SLINK) 1-2 with site link
> >         0
> >         +as a special case to handle the local devices:
> >         +
> >         +                                           |
> >         +    Local (primary) site                   |      Remote
> >         sites
> >         +    --------------------                   |
> >          ------------
> >         +                                           |
> >         +    D1   D2     Dn                         |
> >         +     |   |       |                         |
> >         +     +---+- ... -+                         |
> >         +         |                                 |
> >         +       REPLOG-----------------+- SLINK1 ------------+
> >         +         |                    |            |        |
> >         +       SLINK0 (special case)  |            |        |
> >         +         |                    |            |        |
> >         +     +-----+   ...  +         |            |   +----+- ... -+
> >         +     |     |        |         |            |   |    |       |
> >         +    LD1   LD2      LDn        |            |  RD1  RD2
> >         RDn
> >         +                              |            |
> >         +                              +-- SLINK2------------+
> >         +                              |            |        |
> >         +                              |            |   +----+- ... -+
> >         +                              |            |   |    |       |
> >         +                              |            |  RD1  RD2
> >         RDn
> >         +                              |            |
> >         +                              |            |
> >         +                              |            |
> >         +                              +- SLINKm ------------+
> >         +                                           |        |
> >         +                                           |   +----+- ... -+
> >         +                                           |   |    |       |
> >         +                                           |  RD1  RD2
> >         RDn
> >         +
> >         +
> >         +
> >         +
> >         +The following are descriptions of the device-mapper tables
> >         used to
> >         +construct the "replicator" and "replicator-dev" targets.
> >         +
> >         +"replicator" target parameters:
> >         +-------------------------------
> >         +<start> <length> replicator \
> >         +       <replog_type> <#replog_params> <replog_params> \
> >         +       [<slink_type_0> <#slink_params_0>
> >         <slink_params_0>]{1..N}
> >         +
> >         +<replog_type>    =3D "ringbuffer" is currently the only
> >         available type
> >         +<#replog_params> =3D # of args following this one intended for
> >         the replog (2 or 4)
> >         +<replog_params>  =3D <dev_path> <dev_start> [auto/create/open
> >         <size>]
> >         +       <dev_path>  =3D device path of replication log (REPLOG)
> >         backing store
> >         +       <dev_start> =3D offset to REPLOG header
> >         +       create      =3D The replication log will be initialized
> >         if not active
> >         +                     and sized to "size".  (If already
> >         active, the create
> >         +                     will fail.)  Size is always in sectors.
> >         +       open        =3D The replication log must be initialized
> >         and valid or
> >         +                     the constructor will fail.
> >         +       auto        =3D If a valid replication log header is
> >         found on the
> >         +                     replication device, this will behave
> >         like 'open'.
> >         +                     Otherwise, this option behaves like
> >         'create'.
> >         +
> >         +<slink_type>    =3D "blockdev" is currently the only available
> >         type
> >         +<#slink_params> =3D 1/2/4
> >         +<slink_params>  =3D <slink_nr> [<slink_policy> [<fall_behind>
> >         <N>]]
> >         +       <slink_nr>     =3D This is a unique number that is used
> >         to identify a
> >         +                        particular site/location.  '0' is
> >         always used to
> >         +                        identify the local site, while
> >         increasing integers
> >         +                        are used to identify remote sites.
> >         +       <slink_policy> =3D The policy can be either 'sync' or
> >         'async'.
> >         +                        'sync' means write requests will not
> >         return until
> >         +                        the data is on the storage device.
> >          'async' allows
> >         +                        a device to "fall behind"; that is,
> >         outstanding
> >         +                        write requests are waiting in the
> >         replication log
> >         +                        to be processed for this site, but it
> >         is not delaying
> >         +                        the writes of other sites.
> >         +       <fall_behind>  =3D This field is used to specify how fa=
r
> >         the user is
> >         +                        willing to allow write requests to
> >         this specific site
> >         +                        to "fall behind" in processing before
> >         switching to
> >         +                        a 'sync' policy.  This "fall behind"
> >         threshhold can
> >         +                        be specified in three ways: ios,
> >         size, or timeout.
> >         +                        'ios' is the number of pending I/Os
> >         allowed (e.g.
> >         +                        "ios 10000").  'size' is the amount
> >         of pending data
> >         +                        allowed (e.g. "size 200m").  Size
> >         labels include:
> >         +                        s (sectors), k, m, g, t, p, and e.
> >          'timeout' is
> >         +                        the amount of time allowed for writes
> >         to be
> >         +                        outstanding.  Time labels include: s,
> >         m, h, and d.
> >         +
> >         +
> >         +"replicator-dev" target parameters:
> >         +-----------------------------------
> >         +start> <length> replicator-dev
> >         +       <replicator_device> <dev_nr> \
> >         +       [<slink_nr> <#dev_params> <dev_params>
> >         +        <dlog_type> <#dlog_params> <dlog_params>]{1..N}
> >         +
> >         +<replicator_device> =3D device previously constructed via
> >         "replication" target
> >         +<dev_nr>           =3D An integer that is used to 'tag' write
> >         requests as
> >         +                     belonging to a particular set of devices
> >         - specifically,
> >         +                     the devices that follow this argument
> >         (i.e. the site
> >         +                     link devices).
> >         +<slink_nr>         =3D This number identifies the site/locatio=
n
> >         where the next
> >         +                     device to be specified comes from.  It
> >         is exactly the
> >         +                     same number used to identify the
> >         site/location (and its
> >         +                     policies) in the "replicator" target.
> >          Interestingly,
> >         +                     while one might normally expect a
> >         "dev_type" argument
> >         +                     here, it can be deduced from the site
> >         link number and
> >         +                     the 'slink_type' given in the
> >         "replication" target.
> >         +<#dev_params>      =3D '1'  (The number of allowed parameters
> >         actually depends
> >         +                     on the 'slink_type' given in the
> >         "replication" target.
> >         +                     Since our only option there is
> >         "blockdev", the only
> >         +                     allowable number here is currently '1'.)
> >         +<dev_params>       =3D 'dev_path'  (Again, since "blockdev" is
> >         the only
> >         +                     'slink_type' available, the only
> >         allowable argument here
> >         +                     is the path to the device.)
> >         +<dlog_type>        =3D Not to be confused with the "replicator
> >         log", this is
> >         +                     the type of dirty log associated with
> >         this particular
> >         +                     device.  Dirty logs are used for
> >         synchronization, during
> >         +                     initialization or fall behind
> >         conditions, to bring devices
> >         +                     into a coherent state with its peers -
> >         analogous to
> >         +                     rebuilding a RAID1 (mirror) device.
> >          Available dirty
> >         +                     log types include: 'nolog', 'core', and
> >         'disk'
> >         +<#dlog_params>     =3D The number of arguments required for a
> >         particular log
> >         +                     type - 'nolog' =3D 0, 'core' =3D 1/2, 'di=
sk'
> >         =3D 2/3.
> >         +<dlog_params>      =3D 'nolog' =3D> ~no arguments~
> >         +                     'core'  =3D> <region_size> [sync | nosync=
]
> >         +                     'disk'  =3D> <dlog_dev_path> <region_size=
>
> >         [sync | nosync]
> >         +       <region_size>   =3D This sets the granularity at which
> >         the dirty log
> >         +                         tracks what areas of the device is
> >         in-sync.
> >         +       [sync | nosync] =3D Optionally specify whether the sync
> >         should be forced
> >         +                         or avoided initially.
> >         diff --git 2.6.33-rc1.orig/drivers/md/Kconfig
> >         2.6.33-rc1/drivers/md/Kconfig
> >         index acb3a4e..62c9766 100644
> >         --- 2.6.33-rc1.orig/drivers/md/Kconfig
> >         +++ 2.6.33-rc1/drivers/md/Kconfig
> >         @@ -313,6 +313,14 @@ config DM_DELAY
> >
> >                If unsure, say N.
> >
> >         +config DM_REPLICATOR
> >         +       tristate "Replication target (EXPERIMENTAL)"
> >         +       depends on BLK_DEV_DM && EXPERIMENTAL
> >         +       ---help---
> >         +       A target that supports replication of local devices to
> >         remote sites.
> >         +
> >         +       If unsure, say N.
> >         +
> >          config DM_UEVENT
> >                bool "DM uevents (EXPERIMENTAL)"
> >                depends on BLK_DEV_DM && EXPERIMENTAL
> >         diff --git 2.6.33-rc1.orig/drivers/md/Makefile
> >         2.6.33-rc1/drivers/md/Makefile
> >         index e355e7f..be05b39 100644
> >         --- 2.6.33-rc1.orig/drivers/md/Makefile
> >         +++ 2.6.33-rc1/drivers/md/Makefile
> >         @@ -44,6 +44,7 @@ obj-$(CONFIG_DM_SNAPSHOT)     +=3D
> >         dm-snapshot.o
> >          obj-$(CONFIG_DM_MIRROR)                +=3D dm-mirror.o
> >         dm-log.o dm-region-hash.o
> >          obj-$(CONFIG_DM_LOG_USERSPACE) +=3D dm-log-userspace.o
> >          obj-$(CONFIG_DM_ZERO)          +=3D dm-zero.o
> >         +obj-$(CONFIG_DM_REPLICATOR)    +=3D dm-log.o dm-registry.o
> >
> >          quiet_cmd_unroll =3D UNROLL  $@
> >               cmd_unroll =3D $(AWK) -f$(srctree)/$(src)/unroll.awk -vN=
=3D
> >         $(UNROLL) \
> >         diff --git 2.6.33-rc1.orig/drivers/md/dm-registry.c
> >         2.6.33-rc1/drivers/md/dm-registry.c
> >         new file mode 100644
> >         index 0000000..fb8abbf
> >         --- /dev/null
> >         +++ 2.6.33-rc1/drivers/md/dm-registry.c
> >         @@ -0,0 +1,224 @@
> >         +/*
> >         + * Copyright (C) 2009 Red Hat, Inc. All rights reserved.
> >         + *
> >         + * Module Author: Heinz Mauelshagen (heinzm@redhat.com)
> >         + *
> >         + * Generic registry for arbitrary structures
> >         + * (needs dm_registry_type structure upfront each registered
> >         structure).
> >         + *
> >         + * This file is released under the GPL.
> >         + *
> >         + * FIXME: use as registry for e.g. dirty log types as well.
> >         + */
> >         +
> >         +#include <linux/init.h>
> >         +#include <linux/module.h>
> >         +#include <linux/moduleparam.h>
> >         +
> >         +#include "dm-registry.h"
> >         +
> >         +#define        DM_MSG_PREFIX   "dm-registry"
> >         +
> >         +static const char *version =3D "0.001";
> >         +
> >         +/* Sizable class registry. */
> >         +static unsigned num_classes;
> >         +static struct list_head *_classes;
> >         +static rwlock_t *_locks;
> >         +
> >         +void *
> >         +dm_get_type(const char *type_name, enum dm_registry_class
> >         class)
> >         +{
> >         +       struct dm_registry_type *t;
> >         +
> >         +       read_lock(_locks + class);
> >         +       list_for_each_entry(t, _classes + class, list) {
> >         +               if (!strcmp(type_name, t->name)) {
> >         +                       if (!t->use_count && !
> >         try_module_get(t->module)) {
> >         +                               read_unlock(_locks + class);
> >         +                               return ERR_PTR(-ENOMEM);
> >         +                       }
> >         +
> >         +                       t->use_count++;
> >         +                       read_unlock(_locks + class);
> >         +                       return t;
> >         +               }
> >         +       }
> >         +
> >         +       read_unlock(_locks + class);
> >         +       return ERR_PTR(-ENOENT);
> >         +}
> >         +EXPORT_SYMBOL(dm_get_type);
> >         +
> >         +void
> >         +dm_put_type(void *type, enum dm_registry_class class)
> >         +{
> >         +       struct dm_registry_type *t =3D type;
> >         +
> >         +       read_lock(_locks + class);
> >         +       if (!--t->use_count)
> >         +               module_put(t->module);
> >         +
> >         +       read_unlock(_locks + class);
> >         +}
> >         +EXPORT_SYMBOL(dm_put_type);
> >         +
> >         +/* Add a type to the registry. */
> >         +int
> >         +dm_register_type(void *type, enum dm_registry_class class)
> >         +{
> >         +       struct dm_registry_type *t =3D type, *tt;
> >         +
> >         +       if (unlikely(class >=3D num_classes))
> >         +               return -EINVAL;
> >         +
> >         +       tt =3D dm_get_type(t->name, class);
> >         +       if (unlikely(!IS_ERR(tt))) {
> >         +               dm_put_type(t, class);
> >         +               return -EEXIST;
> >         +       }
> >         +
> >         +       write_lock(_locks + class);
> >         +       t->use_count =3D 0;
> >         +       list_add(&t->list, _classes + class);
> >         +       write_unlock(_locks + class);
> >         +
> >         +       return 0;
> >         +}
> >         +EXPORT_SYMBOL(dm_register_type);
> >         +
> >         +/* Remove a type from the registry. */
> >         +int
> >         +dm_unregister_type(void *type, enum dm_registry_class class)
> >         +{
> >         +       struct dm_registry_type *t =3D type;
> >         +
> >         +       if (unlikely(class >=3D num_classes)) {
> >         +               DMERR("Attempt to unregister invalid class");
> >         +               return -EINVAL;
> >         +       }
> >         +
> >         +       write_lock(_locks + class);
> >         +
> >         +       if (unlikely(t->use_count)) {
> >         +               write_unlock(_locks + class);
> >         +               DMWARN("Attempt to unregister a type that is
> >         still in use");
> >         +               return -ETXTBSY;
> >         +       } else
> >         +               list_del(&t->list);
> >         +
> >         +       write_unlock(_locks + class);
> >         +       return 0;
> >         +}
> >         +EXPORT_SYMBOL(dm_unregister_type);
> >         +
> >         +/*
> >         + * Return kmalloc'ed NULL terminated pointer
> >         + * array of all type names of the given class.
> >         + *
> >         + * Caller has to kfree the array!.
> >         + */
> >         +const char **dm_types_list(enum dm_registry_class class)
> >         +{
> >         +       unsigned i =3D 0, count =3D 0;
> >         +       const char **r;
> >         +       struct dm_registry_type *t;
> >         +
> >         +       /* First count the registered types in the class. */
> >         +       read_lock(_locks + class);
> >         +       list_for_each_entry(t, _classes + class, list)
> >         +               count++;
> >         +       read_unlock(_locks + class);
> >         +
> >         +       /* None registered in this class. */
> >         +       if (!count)
> >         +               return NULL;
> >         +
> >         +       /* One member more for array NULL termination. */
> >         +       r =3D kzalloc((count + 1) * sizeof(*r), GFP_KERNEL);
> >         +       if (!r)
> >         +               return ERR_PTR(-ENOMEM);
> >         +
> >         +       /*
> >         +        * Go with the counted ones.
> >         +        * Any new added ones after we counted will be
> >         ignored!
> >         +        */
> >         +       read_lock(_locks + class);
> >         +       list_for_each_entry(t, _classes + class, list) {
> >         +               r[i++] =3D t->name;
> >         +               if (!--count)
> >         +                       break;
> >         +       }
> >         +       read_unlock(_locks + class);
> >         +
> >         +       return r;
> >         +}
> >         +EXPORT_SYMBOL(dm_types_list);
> >         +
> >         +int __init
> >         +dm_registry_init(void)
> >         +{
> >         +       unsigned n;
> >         +
> >         +       BUG_ON(_classes);
> >         +       BUG_ON(_locks);
> >         +
> >         +       /* Module parameter given ? */
> >         +       if (!num_classes)
> >         +               num_classes =3D DM_REGISTRY_CLASS_END;
> >         +
> >         +       n =3D num_classes;
> >         +       _classes =3D kmalloc(n * sizeof(*_classes), GFP_KERNEL)=
;
> >         +       if (!_classes) {
> >         +               DMERR("Failed to allocate classes registry");
> >         +               return -ENOMEM;
> >         +       }
> >         +
> >         +       _locks =3D kmalloc(n * sizeof(*_locks), GFP_KERNEL);
> >         +       if (!_locks) {
> >         +               DMERR("Failed to allocate classes locks");
> >         +               kfree(_classes);
> >         +               _classes =3D NULL;
> >         +               return -ENOMEM;
> >         +       }
> >         +
> >         +       while (n--) {
> >         +               INIT_LIST_HEAD(_classes + n);
> >         +               rwlock_init(_locks + n);
> >         +       }
> >         +
> >         +       DMINFO("initialized %s for max %u classes", version,
> >         num_classes);
> >         +       return 0;
> >         +}
> >         +
> >         +void __exit
> >         +dm_registry_exit(void)
> >         +{
> >         +       BUG_ON(!_classes);
> >         +       BUG_ON(!_locks);
> >         +
> >         +       kfree(_classes);
> >         +       _classes =3D NULL;
> >         +       kfree(_locks);
> >         +       _locks =3D NULL;
> >         +       DMINFO("exit %s", version);
> >         +}
> >         +
> >         +/* Module hooks */
> >         +module_init(dm_registry_init);
> >         +module_exit(dm_registry_exit);
> >         +module_param(num_classes, uint, 0);
> >         +MODULE_PARM_DESC(num_classes, "Maximum number of classes");
> >         +MODULE_DESCRIPTION(DM_NAME "device-mapper registry");
> >         +MODULE_AUTHOR("Heinz Mauelshagen <heinzm@redhat.com>");
> >         +MODULE_LICENSE("GPL");
> >         +
> >         +#ifndef MODULE
> >         +static int __init num_classes_setup(char *str)
> >         +{
> >         +       num_classes =3D simple_strtol(str, NULL, 0);
> >         +       return num_classes ? 1 : 0;
> >         +}
> >         +
> >         +__setup("num_classes=3D", num_classes_setup);
> >         +#endif
> >         diff --git 2.6.33-rc1.orig/drivers/md/dm-registry.h
> >         2.6.33-rc1/drivers/md/dm-registry.h
> >         new file mode 100644
> >         index 0000000..1cb0ce8
> >         --- /dev/null
> >         +++ 2.6.33-rc1/drivers/md/dm-registry.h
> >         @@ -0,0 +1,38 @@
> >         +/*
> >         + * Copyright (C) 2009 Red Hat, Inc. All rights reserved.
> >         + *
> >         + * Module Author: Heinz Mauelshagen (heinzm@redhat.com)
> >         + *
> >         + * Generic registry for arbitrary structures.
> >         + * (needs dm_registry_type structure upfront each registered
> >         structure).
> >         + *
> >         + * This file is released under the GPL.
> >         + */
> >         +
> >         +#include "dm.h"
> >         +
> >         +#ifndef DM_REGISTRY_H
> >         +#define DM_REGISTRY_H
> >         +
> >         +enum dm_registry_class {
> >         +       DM_REPLOG =3D 0,
> >         +       DM_SLINK,
> >         +       DM_LOG,
> >         +       DM_REGION_HASH,
> >         +       DM_REGISTRY_CLASS_END,
> >         +};
> >         +
> >         +struct dm_registry_type {
> >         +       struct list_head list;  /* Linked list of types in
> >         this class. */
> >         +       const char *name;
> >         +       struct module *module;
> >         +       unsigned int use_count;
> >         +};
> >         +
> >         +void *dm_get_type(const char *type_name, enum
> >         dm_registry_class class);
> >         +void dm_put_type(void *type, enum dm_registry_class class);
> >         +int dm_register_type(void *type, enum dm_registry_class
> >         class);
> >         +int dm_unregister_type(void *type, enum dm_registry_class
> >         class);
> >         +const char **dm_types_list(enum dm_registry_class class);
> >         +
> >         +#endif
> >         --
> >         1.6.2.5
> >
> >         --
> >         dm-devel mailing list
> >         dm-devel@redhat.com
> >         https://www.redhat.com/mailman/listinfo/dm-devel
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--0050450294e3693b80047f211d74
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div>Hi ,</div>
<div>&nbsp;&nbsp;&nbsp; I have some questions about this replicator module =
after deployed on my systems:</div>
<div>&nbsp;&nbsp;&nbsp; 1.when the connection to the&nbsp; RD failed&nbsp;a=
t the moment&nbsp;reading or writing data to the D_link, the D_link will fa=
il? can&#39;t&nbsp;D_link &amp; LD&nbsp;be well in this situation? (one LD =
and one RD, yes, RD can be RDs such as RAID1, however, all of the RDs disco=
nnected, the D_link also will fail?it will affect on the user&#39;s applica=
tions, in gernal speaking, RD can be fail, but the LD (D_link for user )sho=
uld be ok at this situation.&nbsp;)</div>

<div>&nbsp;&nbsp;&nbsp; 2.Any deals with the&nbsp;data initiation of the LD=
 and RD in this repl module, not using &#39;dd&#39; cmds. is there any inte=
rface to&nbsp;do it in the architecture design of this system (roadmap)?&nb=
sp;<br>&nbsp;&nbsp;&nbsp; 3.While doing the repl, sometime, the RD or LD fa=
iled, is there any function to resync th RD and LD when the LD&nbsp;or RD s=
ystem come back and then continue to do the repl?</div>

<div>&nbsp;&nbsp;&nbsp; 4.Any design when LD fails,&nbsp;the LD come back, =
&nbsp;the RD to restore the LD? not use &#39;dd&#39; cmd. (as 3rd question =
said, but this situation just take attention to the restore repl from the R=
D.)</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp; I am very interest in this repl module, sorry=
 for asking so many questions.</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp; DRBD of HA feild is a good tool for HA, but n=
ot for repl. Is there other idea of replication&nbsp;design in Linux system=
?</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp; Thank&nbsp;you very much.&nbsp;</div>
<div>&nbsp;</div>
<div>&nbsp;Regards,<br>&nbsp;Busby<br></div>
<div class=3D"gmail_quote">2010/1/9 Heinz Mauelshagen <span dir=3D"ltr">&lt=
;<a href=3D"mailto:heinzm@redhat.com">heinzm@redhat.com</a>&gt;</span><br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On Thu, 2010-01-07 at 18:18 +0800, =D5=C5=D3=EE wrote:<br=
>&gt; Is there any command-line example to explain how to use this &nbsp;pa=
tch?<br><br></div>Look at Documentation/device-mapper/replicator.txt and at=
 comments above<br>
replicator_ctr() and _replicator_dev_ctr() in dm-repl.c for mapping<br>tabl=
e syntax and examples.<br>
<div class=3D"im"><br>&gt; I have compiled it and loaded the modules, the &=
#39;&lt;start&gt;&lt;length&gt;&#39;<br>&gt; target parameters in both repl=
icator ant replicator-dev targets means<br>&gt; what?<br><br></div>replicat=
or doesn&#39;t provide a direct mapping of its own, so &lt;length&gt; is<br=
>
arbitrary and &lt;start&gt; shal be 0.<br>
<div class=3D"im"><br>&gt; how can I construct these target?<br><br></div>S=
ee documentation hints above.<br>
<div class=3D"im"><br>&gt; I haven&#39;t read the source code in detail til=
l now, sorry.<br><br></div>You will now ;-)<br><br>Regards,<br>Heinz<br>
<div>
<div></div>
<div class=3D"h5"><br>&gt;<br>&gt;<br>&gt; 2009/12/18 &lt;<a href=3D"mailto=
:heinzm@redhat.com">heinzm@redhat.com</a>&gt;<br>&gt; &nbsp; &nbsp; &nbsp; =
&nbsp; From: Heinz Mauelshagen &lt;<a href=3D"mailto:heinzm@redhat.com">hei=
nzm@redhat.com</a>&gt;<br>
&gt;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; The dm-registry module is a genera=
l purpose registry for<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; modules.<br>&gt;=
<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; The remote replicator utilizes it to r=
egister its ringbuffer<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; log and<br>&gt; =
&nbsp; &nbsp; &nbsp; &nbsp; site link handlers in order to avoid duplicatin=
g registry code<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; and logic.<br>&gt;<br>&gt;<br>&gt; &nbsp; =
&nbsp; &nbsp; &nbsp; Signed-off-by: Heinz Mauelshagen &lt;<a href=3D"mailto=
:heinzm@redhat.com">heinzm@redhat.com</a>&gt;<br>&gt; &nbsp; &nbsp; &nbsp; =
&nbsp; Reviewed-by: Jon Brassow &lt;<a href=3D"mailto:jbrassow@redhat.com">=
jbrassow@redhat.com</a>&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Tested-by: Jon Brassow &lt;<a href=3D"mail=
to:jbrassow@redhat.com">jbrassow@redhat.com</a>&gt;<br>&gt; &nbsp; &nbsp; &=
nbsp; &nbsp; ---<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Documentation/de=
vice-mapper/replicator.txt | &nbsp;203<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; =
+++++++++++++++++++++++++<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;drivers/md/Kconfig &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | &nbsp;=
 &nbsp;8 +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;drivers/md/Makefile &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;| &nbsp; &nbsp;1 +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;drivers/=
md/dm-registry.c &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; | &nbsp;224<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; ++++++++++++++++++++++=
++++++<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;drivers/md/dm-registry.h &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | &nbsp; 38 +++++<br>&g=
t; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;5 files changed, 474 insertions(+), 0 =
deletions(-)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;create mode 100644 D=
ocumentation/device-mapper/replicator.txt<br>&gt; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp;create mode 100644 drivers/md/dm-registry.c<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;create mode 100644 drivers/md/dm-reg=
istry.h<br>&gt;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; diff --git<br>&gt; &nbs=
p; &nbsp; &nbsp; &nbsp; 2.6.33-rc1.orig/Documentation/device-mapper/replica=
tor.txt<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; 2.6.33-rc1/Documentation/device=
-mapper/replicator.txt<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; new file mode 100644<br>&gt; &nbsp; &nbsp;=
 &nbsp; &nbsp; index 0000000..1d408a6<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; -=
-- /dev/null<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +++ 2.6.33-rc1/Documentati=
on/device-mapper/replicator.txt<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; @@ -0,0=
 +1,203 @@<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +dm-replicator<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<b=
r>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +D=
evice-mapper replicator is designed to enable redundant<br>&gt; &nbsp; &nbs=
p; &nbsp; &nbsp; copies of<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +storage dev=
ices to be made - preferentially, to remote<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; locations.<br>&gt; &nbsp; &nbsp; &nbsp; &n=
bsp; +RAID1 (aka mirroring) is often used to maintain redundant<br>&gt; &nb=
sp; &nbsp; &nbsp; &nbsp; copies of<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +sto=
rage for fault tolerance purposes. &nbsp;Unlike RAID1, which<br>&gt; &nbsp;=
 &nbsp; &nbsp; &nbsp; often<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +assumes similar device characteristics, d=
m-replicator is<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; designed to<br>&gt; &nb=
sp; &nbsp; &nbsp; &nbsp; +handle devices with different latency and bandwid=
th<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; characteristics<br>&gt; &nbsp; &nbsp=
; &nbsp; &nbsp; +which are often the result of the geograhic disparity of<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; multi-site<br>&gt; &nbsp; &nbsp; &nbsp; &n=
bsp; +architectures. &nbsp;Simply put, you might choose RAID1 to protect<br=
>&gt; &nbsp; &nbsp; &nbsp; &nbsp; from<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; =
+a single device failure, but you would choose remote<br>&gt; &nbsp; &nbsp;=
 &nbsp; &nbsp; replication<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +via dm-replicator for protection against =
a site failure.<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp;=
 &nbsp; &nbsp; +dm-replicator works by first sending write requests to the<=
br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &quot;replicator<br>&gt; &nbsp; &nbsp; =
&nbsp; &nbsp; +log&quot;. &nbsp;Not to be confused with the device-mapper d=
irty log,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; this<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +=
replicator log behaves similarly to that of a journal. &nbsp;Write<br>&gt; =
&nbsp; &nbsp; &nbsp; &nbsp; requests<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +g=
o to this log first and then are copied to all the replicate<br>&gt; &nbsp;=
 &nbsp; &nbsp; &nbsp; devices<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +at their various locations. &nbsp;Request=
s are cleared from the<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; log once all<br>=
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +replicate devices confirm the data is rec=
eived/copied. &nbsp;This<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; architecture<b=
r>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +allows dm-replicator to be flexible in =
terms of device<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; characteristics.<br>&gt; &nbsp; &nbsp; &nb=
sp; &nbsp; +If one device should fall behind the others - perhaps due to<br=
>&gt; &nbsp; &nbsp; &nbsp; &nbsp; high latency -<br>&gt; &nbsp; &nbsp; &nbs=
p; &nbsp; +the slack is picked up by the log. &nbsp;The user has a great de=
al<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; of<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +fl=
exibility in specifying to what degree a particular site is<br>&gt; &nbsp; =
&nbsp; &nbsp; &nbsp; allowed to<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +fall b=
ehind - if at all.<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nb=
sp; &nbsp; &nbsp; +Device-Mapper&#39;s dm-replicator has two targets, &quot=
;replicator&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; and<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +&=
quot;replicator-dev&quot;. &nbsp;The &quot;replicator&quot; target is used =
to setup<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; the<br>&gt; &nbsp; &nbsp; &nbs=
p; &nbsp; +aforementioned log and allow the specification of site link<br>&=
gt; &nbsp; &nbsp; &nbsp; &nbsp; properties.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +Through the &quot;replicator&quot; target=
, the user might specify that<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; writes<br=
>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +that are copied to the local site must h=
appen synchronously<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; (i.e the<br>&gt; &n=
bsp; &nbsp; &nbsp; &nbsp; +writes are complete only after they have passed =
through the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; log device<br>&gt; &nbsp; &nbsp; &nbsp; &n=
bsp; +and have landed on the local site&#39;s disk). &nbsp;They may also<br=
>&gt; &nbsp; &nbsp; &nbsp; &nbsp; specify that<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; +a remote link should asynchronously complete writes, but that<br>&=
gt; &nbsp; &nbsp; &nbsp; &nbsp; the remote<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +link should never fall more than 100MB be=
hind in terms of<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; processing.<br>&gt; &n=
bsp; &nbsp; &nbsp; &nbsp; +Again, the &quot;replicator&quot; target is used=
 to define the<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; replicator log and<br>&g=
t; &nbsp; &nbsp; &nbsp; &nbsp; +the characteristics of each site link.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +The=
 &quot;replicator-dev&quot; target is used to define the devices<br>&gt; &n=
bsp; &nbsp; &nbsp; &nbsp; used and<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +ass=
ociate them with a particular replicator log. &nbsp;You might<br>&gt; &nbsp=
; &nbsp; &nbsp; &nbsp; think of<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +this stage in a similar way to setting up=
 RAID1 (mirroring).<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;You<br>&gt; &=
nbsp; &nbsp; &nbsp; &nbsp; +define a set of devices which will be copies of=
 each other,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; but<br>&gt; &nbsp; &nbsp; =
&nbsp; &nbsp; +access the device through the mirror virtual device which<br=
>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; takes care<br>&gt; &nbsp; &nbsp; &nbsp; &n=
bsp; +of the copying. &nbsp;The user accessible replicator device is<br>&gt=
; &nbsp; &nbsp; &nbsp; &nbsp; analogous<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;=
 +to the mirror virtual device, while the set of devices being<br>&gt; &nbs=
p; &nbsp; &nbsp; &nbsp; copied<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +to are analogous to the mirror images (so=
metimes called<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &#39;legs&#39;).<br>&gt;=
 &nbsp; &nbsp; &nbsp; &nbsp; +When creating a replicator device via the &qu=
ot;replicator-dev&quot;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; target,<br>&gt;=
 &nbsp; &nbsp; &nbsp; &nbsp; +it must be associated with the replicator log=
 (created with<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; the<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +a=
forementioned &quot;replicator&quot; target). &nbsp;When each redundant<br>=
&gt; &nbsp; &nbsp; &nbsp; &nbsp; device<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;=
 +is specified as part of the replicator device, it is<br>&gt; &nbsp; &nbsp=
; &nbsp; &nbsp; associated with<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +a site link whose properties were defined=
 when the<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &quot;replicator&quot;<br>&gt=
; &nbsp; &nbsp; &nbsp; &nbsp; +target was created.<br>&gt; &nbsp; &nbsp; &n=
bsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +The user can go farther =
than simply replicating one device.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;They<br>&gt; &nbsp; &nbsp; &nbsp; &n=
bsp; +can continue to add replicator devices - associating them<br>&gt; &nb=
sp; &nbsp; &nbsp; &nbsp; with a<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +partic=
ular replicator log. &nbsp;Writes that go through the<br>&gt; &nbsp; &nbsp;=
 &nbsp; &nbsp; replicator<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +log are guar=
enteed to have their write ordering preserved.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;So, if<br>&gt; &nbsp; &nbsp; &nbsp; =
&nbsp; +you associate more than one replicator device to a particular<br>&g=
t; &nbsp; &nbsp; &nbsp; &nbsp; +replicator log, you are preserving write or=
dering across<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; multiple<br>&gt; &nbsp; &=
nbsp; &nbsp; &nbsp; +devices. &nbsp;This might be useful if you had a datab=
ase that<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; spanned<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp=
; +multiple disks and write ordering must be preserved or any<br>&gt; &nbsp=
; &nbsp; &nbsp; &nbsp; transaction<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +acc=
ounting scheme would be foiled. &nbsp;(You can imagine this<br>&gt; &nbsp; =
&nbsp; &nbsp; &nbsp; like<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +preserving write ordering across a number=
 of mirrored<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; devices, where<br>&gt; &nb=
sp; &nbsp; &nbsp; &nbsp; +each mirror has images/legs in different geograph=
ic<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; locations.)<br>&gt; &nbsp; &nbsp; &n=
bsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +dm-replicator has a modu=
lar architecture. &nbsp;Future<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; implementations for<br>&gt; &nbsp; &nbsp; =
&nbsp; &nbsp; +the replicator log and site link modules are allowed. &nbsp;=
The<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; current<br>&gt; &nbsp; &nbsp; &nbsp=
; &nbsp; +replication log is ringbuffer - utilized to store all writes<br>&=
gt; &nbsp; &nbsp; &nbsp; &nbsp; being<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +subject to replication and enforce write =
ordering. &nbsp;The<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; current site<br>&gt=
; &nbsp; &nbsp; &nbsp; &nbsp; +link code is based on accessing block device=
s (iSCSI, FC,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; etc) and<br>&gt; &nbsp; &=
nbsp; &nbsp; &nbsp; +does device recovery including (initial) resynchroniza=
tion.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br=
>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +Picture of a 2 site configuration with 3=
 local devices (LDs)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; in a<br>&gt; &nbsp=
; &nbsp; &nbsp; &nbsp; +primary site being resycnhronied to 3 remotes sites=
 with 3<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; remote<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +devices (RDs) each via site links (SLINK)=
 1-2 with site link<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; 0<br>&gt; &nbsp; &n=
bsp; &nbsp; &nbsp; +as a special case to handle the local devices:<br>&gt; =
&nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp;Local (primary) site &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | &nbsp; &nbsp; &n=
bsp;Remote<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; sites<br>&gt; &nbsp; &nbsp; =
&nbsp; &nbsp; + &nbsp; &nbsp;-------------------- &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp;------------<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp;D1 &nbsp; D2 &nbsp; &nbsp; =
Dn &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; |<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; | &nbsp; =
| &nbsp; &nbsp; &nbsp; | &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &=
nbsp; &nbsp; +---+- ... -+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +=
 &nbsp; &nbsp; &nbsp; &nbsp; | &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; REPLOG-------------=
----+- SLINK1 ------------+<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &n=
bsp; &nbsp; &nbsp; | &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;| &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; &nbsp; &=
nbsp; &nbsp;|<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; SL=
INK0 (special case) &nbsp;| &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| &nbs=
p; &nbsp; &nbsp; &nbsp;|<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp=
; &nbsp; &nbsp; | &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp;| &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; &nbsp; &nbs=
p; &nbsp;|<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; +-----+ &nbsp; ... &nbsp;+=
 &nbsp; &nbsp; &nbsp; &nbsp; | &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| &=
nbsp; +----+- ... -+<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; | =
&nbsp; &nbsp; | &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; &nbsp; &nbsp; &nbsp; | =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; | &nbsp; &nbsp;| &nbsp; &=
nbsp; &nbsp; |<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp;LD1 &nbsp=
; LD2 &nbsp; &nbsp; &nbsp;LDn &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp;| &nbsp;RD1 &nbsp;RD2<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; RDn<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;|<b=
r>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;+-- SLINK=
2------------+<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp;| &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; &nbsp; &nbsp; &n=
bsp;|<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; +----+- ... -+<br>&gt; &nbsp; &nbs=
p; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp;| &nbsp; | &nbsp; &nbsp;| &nbsp; &nbsp; &nbsp; |<br>&gt; &n=
bsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp;| &nbsp;RD1 &nbsp;RD2<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; RDn<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;|<b=
r>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;|<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp;| &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;|<br=
>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;+- SLINKm =
------------+<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; | &nbsp; &nbsp; &nbsp; &nbsp;|<br>&gt; &nbs=
p; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; | &nbsp; +----+- ... -+<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; | &nbsp; | &nbsp; &nbsp;| &nbsp; &nbsp; &nbsp; |<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; | &nbsp;RD1 &nbsp;RD2<br>&gt; &nbsp; &nbsp;=
 &nbsp; &nbsp; RDn<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nb=
sp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &n=
bsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +The following are=
 descriptions of the device-mapper tables<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; used to<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp=
; +construct the &quot;replicator&quot; and &quot;replicator-dev&quot; targ=
ets.<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nb=
sp; +&quot;replicator&quot; target parameters:<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; +-------------------------------<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +&lt;start&gt; &lt;length&gt; replicator \=
<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &lt;replog_type=
&gt; &lt;#replog_params&gt; &lt;replog_params&gt; \<br>&gt; &nbsp; &nbsp; &=
nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; [&lt;slink_type_0&gt; &lt;#slink_params=
_0&gt;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;slink_params_0&gt;]{1..N}<br=
>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +&lt=
;replog_type&gt; &nbsp; &nbsp;=3D &quot;ringbuffer&quot; is currently the o=
nly<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; available type<br>&gt; &nbsp; &nbsp=
; &nbsp; &nbsp; +&lt;#replog_params&gt; =3D # of args following this one in=
tended for<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; the replog (2 or 4)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +&lt;replog_params&gt; &nbsp;=3D &lt;dev_p=
ath&gt; &lt;dev_start&gt; [auto/create/open<br>&gt; &nbsp; &nbsp; &nbsp; &n=
bsp; &lt;size&gt;]<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbs=
p; &lt;dev_path&gt; &nbsp;=3D device path of replication log (REPLOG)<br>&g=
t; &nbsp; &nbsp; &nbsp; &nbsp; backing store<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &lt;dev_start&gt; =
=3D offset to REPLOG header<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &n=
bsp; &nbsp; create &nbsp; &nbsp; &nbsp;=3D The replication log will be init=
ialized<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; if not active<br>&gt; &nbsp; &n=
bsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; and sized to &quot;size&quot;. &nbsp;(If already<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; active, the create<br>&gt; &nbsp; &nbsp; &=
nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; will fail.) &nbsp;Size is always in sectors.<br>&gt; &nbsp; &nbsp=
; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; open &nbsp; &nbsp; &nbsp; &nbsp;=3D =
The replication log must be initialized<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;=
 and valid or<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; the constructor will fail.<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; auto &nbsp; &nbsp; =
&nbsp; &nbsp;=3D If a valid replication log header is<br>&gt; &nbsp; &nbsp;=
 &nbsp; &nbsp; found on the<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; replication de=
vice, this will behave<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; like &#39;open&#=
39;.<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Otherwise, this option behaves like<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &#39;create&#39;.<br>&gt; &nbsp; &nbsp; &n=
bsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +&lt;slink_type&gt; &nbsp=
; &nbsp;=3D &quot;blockdev&quot; is currently the only available<br>&gt; &n=
bsp; &nbsp; &nbsp; &nbsp; type<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +&lt;#sl=
ink_params&gt; =3D 1/2/4<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +&lt;slink_par=
ams&gt; &nbsp;=3D &lt;slink_nr&gt; [&lt;slink_policy&gt; [&lt;fall_behind&g=
t;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;N&gt;]]<br>&gt; &nbsp; &nbsp; &nbsp; &=
nbsp; + &nbsp; &nbsp; &nbsp; &lt;slink_nr&gt; &nbsp; &nbsp; =3D This is a u=
nique number that is used<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; to identify a=
<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;particular site/location. &n=
bsp;&#39;0&#39; is<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; always used to<br>&gt; &nbsp; &nbsp; &nbsp=
; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp;identify the local site, while<br>&gt; &nbsp; &nbsp; &nb=
sp; &nbsp; increasing integers<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p;are used to identify remote sites.<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + =
&nbsp; &nbsp; &nbsp; &lt;slink_policy&gt; =3D The policy can be either &#39=
;sync&#39; or<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &#39;async&#39;.<br>&gt; &nbsp; &nbsp; &nb=
sp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp;&#39;sync&#39; means write requests will not<br>&gt; &=
nbsp; &nbsp; &nbsp; &nbsp; return until<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;=
 + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp;the data is on the storage device.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&#39;async&#39; allows<br>&gt; &nbsp=
; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp;a device to &quot;fall behind&quot;; that =
is,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; outstanding<br>&gt; &nbsp; &nbsp; &=
nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp;write requests are waiting in the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; replication log<br>&gt; &nbsp; &nbsp; &nbs=
p; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;to be processed for this site, but it<br>&gt; &nbsp; &n=
bsp; &nbsp; &nbsp; is not delaying<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;the writes of other sites.<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbs=
p; &nbsp; &nbsp; &lt;fall_behind&gt; &nbsp;=3D This field is used to specif=
y how far<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; the user is<br>&gt; &nbsp; &nbsp; &nbsp; &=
nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp;willing to allow write requests to<br>&gt; &nbsp; &nbsp; &n=
bsp; &nbsp; this specific site<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p;to &quot;fall behind&quot; in processing before<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; switching to<br>&gt; &nbsp; &nbsp; &nbsp; =
&nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp;a &#39;sync&#39; policy. &nbsp;This &quot;fall behind&quot=
;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; threshhold can<br>&gt; &nbsp; &nbsp; =
&nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp;be specified in three ways: ios,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; size, or timeout.<br>&gt; &nbsp; &nbsp; &n=
bsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp;&#39;ios&#39; is the number of pending I/Os<br>&gt; &=
nbsp; &nbsp; &nbsp; &nbsp; allowed (e.g.<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp=
; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp;&quot;ios 10000&quot;). &nbsp;&#39;size&#39; is the amount<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; of pending data<br>&gt; &nbsp; &nbsp; &nbs=
p; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;allowed (e.g. &quot;size 200m&quot;). &nbsp;Size<br>&gt=
; &nbsp; &nbsp; &nbsp; &nbsp; labels include:<br>&gt; &nbsp; &nbsp; &nbsp; =
&nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp;s (sectors), k, m, g, t, p, and e.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&#39;timeout&#39; is<br>&gt; &nbsp; =
&nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp;the amount of time allowed for writes<br>&gt=
; &nbsp; &nbsp; &nbsp; &nbsp; to be<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp;outstanding. &nbsp;Time labels include: s,<br>&gt; &nbsp; &nbsp; &nb=
sp; &nbsp; m, h, and d.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br=
>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +&quot;replicator-dev&quot; target parame=
ters:<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +--------------------------------=
---<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +start&gt; &lt;length&gt; replicato=
r-dev<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &lt;replic=
ator_device&gt; &lt;dev_nr&gt; \<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; [&lt;slink_nr&gt; &=
lt;#dev_params&gt; &lt;dev_params&gt;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +=
 &nbsp; &nbsp; &nbsp; &nbsp;&lt;dlog_type&gt; &lt;#dlog_params&gt; &lt;dlog=
_params&gt;]{1..N}<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nb=
sp; &nbsp; &nbsp; +&lt;replicator_device&gt; =3D device previously construc=
ted via<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &quot;replication&quot; target<br>&gt; &nb=
sp; &nbsp; &nbsp; &nbsp; +&lt;dev_nr&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 =3D An integer that is used to &#39;tag&#39; write<br>&gt; &nbsp; &nbsp; &=
nbsp; &nbsp; requests as<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; belonging to a pa=
rticular set of devices<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; - specifically,<br>&gt; &nbsp; &nbsp; &nbs=
p; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; the devices that follow this argument<br>&gt; &nbsp; &nbsp; &nbsp; &=
nbsp; (i.e. the site<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; link devices).<br>&gt=
; &nbsp; &nbsp; &nbsp; &nbsp; +&lt;slink_nr&gt; &nbsp; &nbsp; &nbsp; &nbsp;=
 =3D This number identifies the site/location<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; where the next<br>&gt; &nbsp; &nbsp; &nbsp=
; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; device to be specified comes from. &nbsp;It<br>&gt; &nbsp; &nbsp; &nb=
sp; &nbsp; is exactly the<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; same number used=
 to identify the<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; site/location (and its=
<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; policies) in the &quot;replicator&quot; targe=
t.<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Interestingly,<br>&gt; &nbsp; =
&nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; while one might normally expect a<br>&gt; &nbsp; &nbsp; &=
nbsp; &nbsp; &quot;dev_type&quot; argument<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; here, it can be deduced from the site<br>&gt;=
 &nbsp; &nbsp; &nbsp; &nbsp; link number and<br>&gt; &nbsp; &nbsp; &nbsp; &=
nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; the &#39;slink_type&#39; given in the<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp=
; &quot;replication&quot; target.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +&lt;#dev_params&gt; &nbsp; &nbsp; &nbsp;=
=3D &#39;1&#39; &nbsp;(The number of allowed parameters<br>&gt; &nbsp; &nbs=
p; &nbsp; &nbsp; actually depends<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; on the &=
#39;slink_type&#39; given in the<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &quot;=
replication&quot; target.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; Since our only option there is<br>&gt; &nbsp;=
 &nbsp; &nbsp; &nbsp; &quot;blockdev&quot;, the only<br>&gt; &nbsp; &nbsp; =
&nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; allowable number here is currently &#39;1&#39;.)<br>&gt; &nbsp; =
&nbsp; &nbsp; &nbsp; +&lt;dev_params&gt; &nbsp; &nbsp; &nbsp; =3D &#39;dev_=
path&#39; &nbsp;(Again, since &quot;blockdev&quot; is<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; the only<br>&gt; &nbsp; &nbsp; &nbsp; &nbs=
p; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&#39;slink_type&#39; available, the only<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp=
; allowable argument here<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; is the path to t=
he device.)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +&lt;dlog_type&gt; &nbsp; &=
nbsp; &nbsp; &nbsp;=3D Not to be confused with the &quot;replicator<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; log&quot;, this is<br>&gt; &nbsp; &nbsp; &=
nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; the type of dirty log associated with<br>&gt; &nbsp; &nbsp; &nbsp=
; &nbsp; this particular<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; device. &nbsp;Dir=
ty logs are used for<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; synchronization, d=
uring<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; initialization or fall behind<br>&gt; &nbsp; =
&nbsp; &nbsp; &nbsp; conditions, to bring devices<br>&gt; &nbsp; &nbsp; &nb=
sp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; into a coherent state with its peers -<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; analogous to<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; rebuilding a RAID1 (m=
irror) device.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Available dirty<br>&gt; &nbsp; &nbsp=
; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; log types include: &#39;nolog&#39;, &#39;core&#39;, and<br>&gt=
; &nbsp; &nbsp; &nbsp; &nbsp; &#39;disk&#39;<br>&gt; &nbsp; &nbsp; &nbsp; &=
nbsp; +&lt;#dlog_params&gt; &nbsp; &nbsp; =3D The number of arguments requi=
red for a<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; particular log<br>&gt; &nbsp; &nbsp; &nbsp=
; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; type - &#39;nolog&#39; =3D 0, &#39;core&#39; =3D 1/2, &#39;disk&#39;<=
br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; =3D 2/3.<br>&gt; &nbsp; &nbsp; &nbsp; &=
nbsp; +&lt;dlog_params&gt; &nbsp; &nbsp; &nbsp;=3D &#39;nolog&#39; =3D&gt; =
~no arguments~<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &#39;core&#39; &nbsp;=3D&gt; &lt;region_size&=
gt; [sync | nosync]<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &#39;disk&#39; &nbsp;=
=3D&gt; &lt;dlog_dev_path&gt; &lt;region_size&gt;<br>&gt; &nbsp; &nbsp; &nb=
sp; &nbsp; [sync | nosync]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &lt;region_size&gt;=
 &nbsp; =3D This sets the granularity at which<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; the dirty log<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; tracks=
 what areas of the device is<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; in-sync.<b=
r>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; [sync | nosync] =
=3D Optionally specify whether the sync<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; should be forced<br>&gt; &nbsp; &nbsp; &nb=
sp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; or avoided initially.<br>&gt; &nbsp; &nbsp; &nbsp; &n=
bsp; diff --git 2.6.33-rc1.orig/drivers/md/Kconfig<br>&gt; &nbsp; &nbsp; &n=
bsp; &nbsp; 2.6.33-rc1/drivers/md/Kconfig<br>&gt; &nbsp; &nbsp; &nbsp; &nbs=
p; index acb3a4e..62c9766 100644<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; --- 2.6.33-rc1.orig/drivers/md/Kconfig<br>=
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +++ 2.6.33-rc1/drivers/md/Kconfig<br>&gt; =
&nbsp; &nbsp; &nbsp; &nbsp; @@ -313,6 +313,14 @@ config DM_DELAY<br>&gt;<br=
>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;If unsure, say=
 N.<br>&gt;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +config DM_REPLICATOR<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; tristate &quot;Repl=
ication target (EXPERIMENTAL)&quot;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &=
nbsp; &nbsp; &nbsp; depends on BLK_DEV_DM &amp;&amp; EXPERIMENTAL<br>&gt; &=
nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; ---help---<br>&gt; &nbsp;=
 &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; A target that supports replica=
tion of local devices to<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; remote sites.<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; If uns=
ure, say N.<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp;config DM_UEVENT<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp;bool &quot;DM uevents (EXPERIMENTAL)&quot;<br>&gt; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;depends on BLK_DEV_DM =
&amp;&amp; EXPERIMENTAL<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; diff --git 2.6.33-rc1.orig/drivers/md/Make=
file<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; 2.6.33-rc1/drivers/md/Makefile<br>=
&gt; &nbsp; &nbsp; &nbsp; &nbsp; index e355e7f..be05b39 100644<br>&gt; &nbs=
p; &nbsp; &nbsp; &nbsp; --- 2.6.33-rc1.orig/drivers/md/Makefile<br>&gt; &nb=
sp; &nbsp; &nbsp; &nbsp; +++ 2.6.33-rc1/drivers/md/Makefile<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; @@ -44,6 +44,7 @@ obj-$(CONFIG_DM_SNAPSHOT=
) &nbsp; &nbsp; +=3D<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; dm-snapshot.o<br>&=
gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;obj-$(CONFIG_DM_MIRROR) &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;+=3D dm-mirror.o<br>&gt; &nbsp; &=
nbsp; &nbsp; &nbsp; dm-log.o dm-region-hash.o<br>&gt; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp;obj-$(CONFIG_DM_LOG_USERSPACE) +=3D dm-log-userspace.o<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;obj-$(CONFIG_DM_ZERO) &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;+=3D dm-zero.o<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +obj=
-$(CONFIG_DM_REPLICATOR) &nbsp; &nbsp;+=3D dm-log.o dm-registry.o<br>&gt;<b=
r>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;quiet_cmd_unroll =3D UNROLL &nbsp;=
$@<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; cmd_unroll =3D =
$(AWK) -f$(srctree)/$(src)/unroll.awk -vN=3D<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; $(UNROLL) \<br>&gt; &nbsp; &nbsp; &nbsp; &=
nbsp; diff --git 2.6.33-rc1.orig/drivers/md/dm-registry.c<br>&gt; &nbsp; &n=
bsp; &nbsp; &nbsp; 2.6.33-rc1/drivers/md/dm-registry.c<br>&gt; &nbsp; &nbsp=
; &nbsp; &nbsp; new file mode 100644<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; in=
dex 0000000..fb8abbf<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; --- /dev/null<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; +++ 2.6.33-rc1/drivers/md/dm-registry.c<br>&gt; &nbsp; &nbsp; &nbsp=
; &nbsp; @@ -0,0 +1,224 @@<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +/*<br>&gt; =
&nbsp; &nbsp; &nbsp; &nbsp; + * Copyright (C) 2009 Red Hat, Inc. All rights=
 reserved.<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + *<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + * Module Author: Heinz Mauelshagen (<a h=
ref=3D"mailto:heinzm@redhat.com">heinzm@redhat.com</a>)<br>&gt; &nbsp; &nbs=
p; &nbsp; &nbsp; + *<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + * Generic regist=
ry for arbitrary structures<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + * (needs =
dm_registry_type structure upfront each registered<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; structure).<br>&gt; &nbsp; &nbsp; &nbsp; &=
nbsp; + *<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + * This file is released und=
er the GPL.<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + *<br>&gt; &nbsp; &nbsp; &=
nbsp; &nbsp; + * FIXME: use as registry for e.g. dirty log types as well.<b=
r>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + */<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +#in=
clude &lt;linux/init.h&gt;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +#include &l=
t;linux/module.h&gt;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +#include &lt;linu=
x/moduleparam.h&gt;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &n=
bsp; &nbsp; &nbsp; +#include &quot;dm-registry.h&quot;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +#de=
fine &nbsp; &nbsp; &nbsp; &nbsp;DM_MSG_PREFIX &nbsp; &quot;dm-registry&quot=
;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;=
 +static const char *version =3D &quot;0.001&quot;;<br>&gt; &nbsp; &nbsp; &=
nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +/* Sizable class regist=
ry. */<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +static unsigned num_classes;<br>&gt; &nbs=
p; &nbsp; &nbsp; &nbsp; +static struct list_head *_classes;<br>&gt; &nbsp; =
&nbsp; &nbsp; &nbsp; +static rwlock_t *_locks;<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +void *<br>&gt; &nbsp; &nbsp;=
 &nbsp; &nbsp; +dm_get_type(const char *type_name, enum dm_registry_class<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; class)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp;=
 +{<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; struct dm_re=
gistry_type *t;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp;=
 &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; read_lock(_locks + class);<br>&gt; &n=
bsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; list_for_each_entry(t, _cl=
asses + class, list) {<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; if (!strcmp(type_name, t-&gt;name)) {<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; if (!t-&gt;use_count &amp;&amp; !<br>&gt; &nbsp; &nbsp; &nbsp; =
&nbsp; try_module_get(t-&gt;module)) {<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; =
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; read_unlock(_locks + class);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return ERR=
_PTR(-ENOMEM);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>&gt; &nbsp; &nb=
sp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t-&gt;use_count=
++;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; read_unlock(_locks + class);<br=
>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return t;<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; }<br>&gt; &nbsp;=
 &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; }<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; read_u=
nlock(_locks + class);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; =
&nbsp; return ERR_PTR(-ENOENT);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +}<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +EX=
PORT_SYMBOL(dm_get_type);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nb=
sp; &nbsp; &nbsp; &nbsp; +void<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +dm_put_=
type(void *type, enum dm_registry_class class)<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; +{<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; struc=
t dm_registry_type *t =3D type;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &n=
bsp; &nbsp; &nbsp; read_lock(_locks + class);<br>&gt; &nbsp; &nbsp; &nbsp; =
&nbsp; + &nbsp; &nbsp; &nbsp; if (!--t-&gt;use_count)<br>&gt; &nbsp; &nbsp;=
 &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; module_pu=
t(t-&gt;module);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp=
; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; read_unlock(_locks + class);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +}<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +EX=
PORT_SYMBOL(dm_put_type);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nb=
sp; &nbsp; &nbsp; &nbsp; +/* Add a type to the registry. */<br>&gt; &nbsp; =
&nbsp; &nbsp; &nbsp; +int<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +dm_register_=
type(void *type, enum dm_registry_class class)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +{<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &=
nbsp; &nbsp; &nbsp; struct dm_registry_type *t =3D type, *tt;<br>&gt; &nbsp=
; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp=
; &nbsp; if (unlikely(class &gt;=3D num_classes))<br>&gt; &nbsp; &nbsp; &nb=
sp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return -EINVA=
L;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; tt =3D dm_get_type(=
t-&gt;name, class);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nb=
sp; if (unlikely(!IS_ERR(tt))) {<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; dm_put_type(t, class);<br>&gt;=
 &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; return -EEXIST;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &n=
bsp; }<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &n=
bsp; &nbsp; &nbsp; write_lock(_locks + class);<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; + &nbsp; &nbsp; &nbsp; t-&gt;use_count =3D 0;<br>&gt; &nbsp; &nbsp;=
 &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; list_add(&amp;t-&gt;list, _classes + =
class);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; write_un=
lock(_locks + class);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &n=
bsp; &nbsp; &nbsp; return 0;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +}<br>&gt;=
 &nbsp; &nbsp; &nbsp; &nbsp; +EXPORT_SYMBOL(dm_register_type);<br>&gt; &nbs=
p; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +/* Remove a =
type from the registry. */<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +int<br>&gt;=
 &nbsp; &nbsp; &nbsp; &nbsp; +dm_unregister_type(void *type, enum dm_regist=
ry_class class)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +{<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &=
nbsp; &nbsp; &nbsp; struct dm_registry_type *t =3D type;<br>&gt; &nbsp; &nb=
sp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nb=
sp; if (unlikely(class &gt;=3D num_classes)) {<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; DMERR(&quot;Atte=
mpt to unregister invalid class&quot;);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; return -EINVAL;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp=
; &nbsp; }<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbs=
p; &nbsp; + &nbsp; &nbsp; &nbsp; write_lock(_locks + class);<br>&gt; &nbsp;=
 &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp;=
 &nbsp; if (unlikely(t-&gt;use_count)) {<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp=
; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; write_unlock(_locks + =
class);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; DMWARN(&quot;Attempt to unregister a type that is<br>&gt; &nbsp; &=
nbsp; &nbsp; &nbsp; still in use&quot;);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp=
; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return -ETXTBSY;<br>&g=
t; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; } else<br>&gt; &nbsp;=
 &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; li=
st_del(&amp;t-&gt;list);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &n=
bsp; &nbsp; &nbsp; write_unlock(_locks + class);<br>&gt; &nbsp; &nbsp; &nbs=
p; &nbsp; + &nbsp; &nbsp; &nbsp; return 0;<br>&gt; &nbsp; &nbsp; &nbsp; &nb=
sp; +}<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +EXPORT_SYMBOL(dm_unregister_typ=
e);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbs=
p; +/*<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + * Return kmalloc&#39;ed NULL t=
erminated pointer<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + * array of all type names of the given c=
lass.<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + *<br>&gt; &nbsp; &nbsp; &nbsp; =
&nbsp; + * Caller has to kfree the array!.<br>&gt; &nbsp; &nbsp; &nbsp; &nb=
sp; + */<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +const char **dm_types_list(en=
um dm_registry_class class)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +{<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &=
nbsp; &nbsp; &nbsp; unsigned i =3D 0, count =3D 0;<br>&gt; &nbsp; &nbsp; &n=
bsp; &nbsp; + &nbsp; &nbsp; &nbsp; const char **r;<br>&gt; &nbsp; &nbsp; &n=
bsp; &nbsp; + &nbsp; &nbsp; &nbsp; struct dm_registry_type *t;<br>&gt; &nbs=
p; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbs=
p; &nbsp; /* First count the registered types in the class. */<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; read_lock(_locks + =
class);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; list_for=
_each_entry(t, _classes + class, list)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; =
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; count++;<br>&gt; &nbsp; =
&nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; read_unlock(_locks + class);<br=
>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; /* None registered =
in this class. */<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp=
; if (!count)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; return NULL;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; =
+<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; /* One member =
more for array NULL termination. */<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; r =3D kzalloc((coun=
t + 1) * sizeof(*r), GFP_KERNEL);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nb=
sp; &nbsp; &nbsp; if (!r)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return ERR_PTR(-ENOMEM);<br>&gt; &nbs=
p; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbs=
p; &nbsp; /*<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nb=
sp;* Go with the counted ones.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp;* Any new add=
ed ones after we counted will be<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; ignore=
d!<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp;*/<br>&=
gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; read_lock(_locks + c=
lass);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; list_for_=
each_entry(t, _classes + class, list) {<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; r[i++] =3D t-&gt;name;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; if (!--count)<br>&gt; &nbsp; &n=
bsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; break;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; =
&nbsp; &nbsp; }<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; =
read_unlock(_locks + class);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &n=
bsp; &nbsp; &nbsp; return r;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +}<br>&gt;=
 &nbsp; &nbsp; &nbsp; &nbsp; +EXPORT_SYMBOL(dm_types_list);<br>&gt; &nbsp; =
&nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +int __init<br>&=
gt; &nbsp; &nbsp; &nbsp; &nbsp; +dm_registry_init(void)<br>&gt; &nbsp; &nbs=
p; &nbsp; &nbsp; +{<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; unsigned n;<br>&gt;=
 &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp;=
 &nbsp; &nbsp; BUG_ON(_classes);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbs=
p; &nbsp; &nbsp; BUG_ON(_locks);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&=
gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; /* Module parameter =
given ? */<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; if (!=
num_classes)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; num_classes =3D DM_REGISTRY_CLASS_END;<br>&gt; &nbsp; &nbsp; &nbsp=
; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; n =3D=
 num_classes;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; _c=
lasses =3D kmalloc(n * sizeof(*_classes), GFP_KERNEL);<br>&gt; &nbsp; &nbsp=
; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; if (!_classes) {<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; DMERR(&quot;Failed to allocate classes registry&quot;);<br>&gt; &n=
bsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; return -ENOMEM;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp=
; }<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbs=
p; + &nbsp; &nbsp; &nbsp; _locks =3D kmalloc(n * sizeof(*_locks), GFP_KERNE=
L);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; if (!_locks) {<br>&=
gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; DMERR(&quot;Failed to allocate classes locks&quot;);<br>&gt; &nbsp;=
 &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; kf=
ree(_classes);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; _classes =3D NULL;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; return -ENOMEM;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp=
; &nbsp; }<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbs=
p; &nbsp; + &nbsp; &nbsp; &nbsp; while (n--) {<br>&gt; &nbsp; &nbsp; &nbsp;=
 &nbsp; + &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; INIT_LIST_HEAD(_=
classes + n);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; rwlock_init(_locks + n);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; }<br>&gt; &nbsp; &n=
bsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &n=
bsp; DMINFO(&quot;initialized %s for max %u classes&quot;, version,<br>&gt;=
 &nbsp; &nbsp; &nbsp; &nbsp; num_classes);<br>&gt; &nbsp; &nbsp; &nbsp; &nb=
sp; + &nbsp; &nbsp; &nbsp; return 0;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +}=
<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +void __exit<br>&gt; &nbsp; &nbsp; &nbsp; =
&nbsp; +dm_registry_exit(void)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +{<br>&g=
t; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; BUG_ON(!_classes);<br=
>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; BUG_ON(!_locks);<b=
r>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + =
&nbsp; &nbsp; &nbsp; kfree(_classes);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; _classes =3D NULL;<=
br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; kfree(_locks);<b=
r>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; _locks =3D NULL;<=
br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; DMINFO(&quot;exi=
t %s&quot;, version);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +}<br>&gt; &nbsp;=
 &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +/* Module hook=
s */<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +module_init(dm_registry_init);<br>&gt; &n=
bsp; &nbsp; &nbsp; &nbsp; +module_exit(dm_registry_exit);<br>&gt; &nbsp; &n=
bsp; &nbsp; &nbsp; +module_param(num_classes, uint, 0);<br>&gt; &nbsp; &nbs=
p; &nbsp; &nbsp; +MODULE_PARM_DESC(num_classes, &quot;Maximum number of cla=
sses&quot;);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +MODULE_DESCRIPTION(DM_NAME &quot;device-m=
apper registry&quot;);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +MODULE_AUTHOR(&=
quot;Heinz Mauelshagen &lt;<a href=3D"mailto:heinzm@redhat.com">heinzm@redh=
at.com</a>&gt;&quot;);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +MODULE_LICENSE(=
&quot;GPL&quot;);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +#if=
ndef MODULE<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +static int __init num_clas=
ses_setup(char *str)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +{<br>&gt; &nbsp; =
&nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; num_classes =3D simple_strtol(s=
tr, NULL, 0);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; re=
turn num_classes ? 1 : 0;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +}<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<b=
r>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +__setup(&quot;num_classes=3D&quot;, num=
_classes_setup);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +#endif<br>&gt; &nbsp;=
 &nbsp; &nbsp; &nbsp; diff --git 2.6.33-rc1.orig/drivers/md/dm-registry.h<b=
r>&gt; &nbsp; &nbsp; &nbsp; &nbsp; 2.6.33-rc1/drivers/md/dm-registry.h<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; new file mode 100644<br>&gt; &nbsp; &nbsp;=
 &nbsp; &nbsp; index 0000000..1cb0ce8<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; -=
-- /dev/null<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +++ 2.6.33-rc1/drivers/md/=
dm-registry.h<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; @@ -0,0 +1,38 @@<br>&gt; =
&nbsp; &nbsp; &nbsp; &nbsp; +/*<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + * Cop=
yright (C) 2009 Red Hat, Inc. All rights reserved.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + *<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + =
* Module Author: Heinz Mauelshagen (<a href=3D"mailto:heinzm@redhat.com">he=
inzm@redhat.com</a>)<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + *<br>&gt; &nbsp;=
 &nbsp; &nbsp; &nbsp; + * Generic registry for arbitrary structures.<br>&gt=
; &nbsp; &nbsp; &nbsp; &nbsp; + * (needs dm_registry_type structure upfront=
 each registered<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; structure).<br>&gt; &nbsp; &nbsp; &nbsp; &=
nbsp; + *<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + * This file is released und=
er the GPL.<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + */<br>&gt; &nbsp; &nbsp; =
&nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +#include &quot;dm.h&qu=
ot;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbs=
p; +#ifndef DM_REGISTRY_H<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; +#define DM_REGISTRY_H<br>&gt; &nbsp; &nbs=
p; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +enum dm_registry_cl=
ass {<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; DM_REPLOG =
=3D 0,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; DM_SLINK,=
<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; DM_LOG,<br>&gt;=
 &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; DM_REGION_HASH,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; DM_REGISTRY_CLASS_E=
ND,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +};<br>&gt; &nbsp; &nbsp; &nbsp; &n=
bsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +struct dm_registry_type {<br>&g=
t; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; struct list_head list=
; &nbsp;/* Linked list of types in<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; this=
 class. */<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; const char *name;<b=
r>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; struct module *mo=
dule;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; unsigned i=
nt use_count;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +};<br>&gt; &nbsp; &nbsp;=
 &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +void *dm_get_type(con=
st char *type_name, enum<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; dm_registry_class class);<br>&gt; &nbsp; &=
nbsp; &nbsp; &nbsp; +void dm_put_type(void *type, enum dm_registry_class cl=
ass);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +int dm_register_type(void *type,=
 enum dm_registry_class<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; class);<br>&gt;=
 &nbsp; &nbsp; &nbsp; &nbsp; +int dm_unregister_type(void *type, enum dm_re=
gistry_class<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; class);<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp=
; +const char **dm_types_list(enum dm_registry_class class);<br>&gt; &nbsp;=
 &nbsp; &nbsp; &nbsp; +<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; +#endif<br>&gt;=
 &nbsp; &nbsp; &nbsp; &nbsp; --<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; 1.6.2.5=
<br>&gt;<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; --<br>&gt; &nbsp; &nbsp; &nbsp=
; &nbsp; dm-devel mailing list<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; <a href=3D"mailto:dm-devel@redhat.com">dm-=
devel@redhat.com</a><br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; <a href=3D"https:/=
/www.redhat.com/mailman/listinfo/dm-devel" target=3D"_blank">https://www.re=
dhat.com/mailman/listinfo/dm-devel</a><br>
&gt;<br>&gt; --<br>&gt; dm-devel mailing list<br>&gt; <a href=3D"mailto:dm-=
devel@redhat.com">dm-devel@redhat.com</a><br>&gt; <a href=3D"https://www.re=
dhat.com/mailman/listinfo/dm-devel" target=3D"_blank">https://www.redhat.co=
m/mailman/listinfo/dm-devel</a><br>
<br>--<br>dm-devel mailing list<br><a href=3D"mailto:dm-devel@redhat.com">d=
m-devel@redhat.com</a><br><a href=3D"https://www.redhat.com/mailman/listinf=
o/dm-devel" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-de=
vel</a></div>
</div></blockquote></div><br>

--0050450294e3693b80047f211d74--


--===============8715731182062541392==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8715731182062541392==--
