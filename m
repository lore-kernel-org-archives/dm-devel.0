From: =?GB2312?B?1cXT7g==?= <chaimvy@gmail.com>
Subject: Re: [PATCH v6 1/4] dm-replicator: documentation and
	module registry
Date: Thu, 7 Jan 2010 18:18:10 +0800
Message-ID: <b8091bb41001070218m604497en5cffa0bdad76271f@mail.gmail.com>
References: <1261151073-25962-1-git-send-email-heinzm@redhat.com>
	<1261151073-25962-2-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0765147422350775691=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1261151073-25962-2-git-send-email-heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0765147422350775691==
Content-Type: multipart/alternative; boundary=00504502b46855211d047c9063b6

--00504502b46855211d047c9063b6
Content-Type: text/plain; charset=ISO-8859-1

Is there any command-line example to explain how to use this  patch?
I have compiled it and loaded the modules, the '<start><length>' target
parameters in both replicator ant replicator-dev targets means what?
how can I construct these target?
I haven't read the source code in detail till now, sorry.

2009/12/18 <heinzm@redhat.com>

> From: Heinz Mauelshagen <heinzm@redhat.com>
>
> The dm-registry module is a general purpose registry for modules.
>
> The remote replicator utilizes it to register its ringbuffer log and
> site link handlers in order to avoid duplicating registry code and logic.
>
>
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> Reviewed-by: Jon Brassow <jbrassow@redhat.com>
> Tested-by: Jon Brassow <jbrassow@redhat.com>
> ---
>  Documentation/device-mapper/replicator.txt |  203
> +++++++++++++++++++++++++
>  drivers/md/Kconfig                         |    8 +
>  drivers/md/Makefile                        |    1 +
>  drivers/md/dm-registry.c                   |  224
> ++++++++++++++++++++++++++++
>  drivers/md/dm-registry.h                   |   38 +++++
>  5 files changed, 474 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/device-mapper/replicator.txt
>  create mode 100644 drivers/md/dm-registry.c
>  create mode 100644 drivers/md/dm-registry.h
>
> diff --git 2.6.33-rc1.orig/Documentation/device-mapper/replicator.txt
> 2.6.33-rc1/Documentation/device-mapper/replicator.txt
> new file mode 100644
> index 0000000..1d408a6
> --- /dev/null
> +++ 2.6.33-rc1/Documentation/device-mapper/replicator.txt
> @@ -0,0 +1,203 @@
> +dm-replicator
> +=============
> +
> +Device-mapper replicator is designed to enable redundant copies of
> +storage devices to be made - preferentially, to remote locations.
> +RAID1 (aka mirroring) is often used to maintain redundant copies of
> +storage for fault tolerance purposes.  Unlike RAID1, which often
> +assumes similar device characteristics, dm-replicator is designed to
> +handle devices with different latency and bandwidth characteristics
> +which are often the result of the geograhic disparity of multi-site
> +architectures.  Simply put, you might choose RAID1 to protect from
> +a single device failure, but you would choose remote replication
> +via dm-replicator for protection against a site failure.
> +
> +dm-replicator works by first sending write requests to the "replicator
> +log".  Not to be confused with the device-mapper dirty log, this
> +replicator log behaves similarly to that of a journal.  Write requests
> +go to this log first and then are copied to all the replicate devices
> +at their various locations.  Requests are cleared from the log once all
> +replicate devices confirm the data is received/copied.  This architecture
> +allows dm-replicator to be flexible in terms of device characteristics.
> +If one device should fall behind the others - perhaps due to high latency
> -
> +the slack is picked up by the log.  The user has a great deal of
> +flexibility in specifying to what degree a particular site is allowed to
> +fall behind - if at all.
> +
> +Device-Mapper's dm-replicator has two targets, "replicator" and
> +"replicator-dev".  The "replicator" target is used to setup the
> +aforementioned log and allow the specification of site link properties.
> +Through the "replicator" target, the user might specify that writes
> +that are copied to the local site must happen synchronously (i.e the
> +writes are complete only after they have passed through the log device
> +and have landed on the local site's disk).  They may also specify that
> +a remote link should asynchronously complete writes, but that the remote
> +link should never fall more than 100MB behind in terms of processing.
> +Again, the "replicator" target is used to define the replicator log and
> +the characteristics of each site link.
> +
> +The "replicator-dev" target is used to define the devices used and
> +associate them with a particular replicator log.  You might think of
> +this stage in a similar way to setting up RAID1 (mirroring).  You
> +define a set of devices which will be copies of each other, but
> +access the device through the mirror virtual device which takes care
> +of the copying.  The user accessible replicator device is analogous
> +to the mirror virtual device, while the set of devices being copied
> +to are analogous to the mirror images (sometimes called 'legs').
> +When creating a replicator device via the "replicator-dev" target,
> +it must be associated with the replicator log (created with the
> +aforementioned "replicator" target).  When each redundant device
> +is specified as part of the replicator device, it is associated with
> +a site link whose properties were defined when the "replicator"
> +target was created.
> +
> +The user can go farther than simply replicating one device.  They
> +can continue to add replicator devices - associating them with a
> +particular replicator log.  Writes that go through the replicator
> +log are guarenteed to have their write ordering preserved.  So, if
> +you associate more than one replicator device to a particular
> +replicator log, you are preserving write ordering across multiple
> +devices.  This might be useful if you had a database that spanned
> +multiple disks and write ordering must be preserved or any transaction
> +accounting scheme would be foiled.  (You can imagine this like
> +preserving write ordering across a number of mirrored devices, where
> +each mirror has images/legs in different geographic locations.)
> +
> +dm-replicator has a modular architecture.  Future implementations for
> +the replicator log and site link modules are allowed.  The current
> +replication log is ringbuffer - utilized to store all writes being
> +subject to replication and enforce write ordering.  The current site
> +link code is based on accessing block devices (iSCSI, FC, etc) and
> +does device recovery including (initial) resynchronization.
> +
> +
> +Picture of a 2 site configuration with 3 local devices (LDs) in a
> +primary site being resycnhronied to 3 remotes sites with 3 remote
> +devices (RDs) each via site links (SLINK) 1-2 with site link 0
> +as a special case to handle the local devices:
> +
> +                                           |
> +    Local (primary) site                   |      Remote sites
> +    --------------------                   |      ------------
> +                                           |
> +    D1   D2     Dn                         |
> +     |   |       |                         |
> +     +---+- ... -+                         |
> +         |                                 |
> +       REPLOG-----------------+- SLINK1 ------------+
> +         |                    |            |        |
> +       SLINK0 (special case)  |            |        |
> +         |                    |            |        |
> +     +-----+   ...  +         |            |   +----+- ... -+
> +     |     |        |         |            |   |    |       |
> +    LD1   LD2      LDn        |            |  RD1  RD2     RDn
> +                              |            |
> +                              +-- SLINK2------------+
> +                              |            |        |
> +                              |            |   +----+- ... -+
> +                              |            |   |    |       |
> +                              |            |  RD1  RD2     RDn
> +                              |            |
> +                              |            |
> +                              |            |
> +                              +- SLINKm ------------+
> +                                           |        |
> +                                           |   +----+- ... -+
> +                                           |   |    |       |
> +                                           |  RD1  RD2     RDn
> +
> +
> +
> +
> +The following are descriptions of the device-mapper tables used to
> +construct the "replicator" and "replicator-dev" targets.
> +
> +"replicator" target parameters:
> +-------------------------------
> +<start> <length> replicator \
> +       <replog_type> <#replog_params> <replog_params> \
> +       [<slink_type_0> <#slink_params_0> <slink_params_0>]{1..N}
> +
> +<replog_type>    = "ringbuffer" is currently the only available type
> +<#replog_params> = # of args following this one intended for the replog (2
> or 4)
> +<replog_params>  = <dev_path> <dev_start> [auto/create/open <size>]
> +       <dev_path>  = device path of replication log (REPLOG) backing store
> +       <dev_start> = offset to REPLOG header
> +       create      = The replication log will be initialized if not active
> +                     and sized to "size".  (If already active, the create
> +                     will fail.)  Size is always in sectors.
> +       open        = The replication log must be initialized and valid or
> +                     the constructor will fail.
> +       auto        = If a valid replication log header is found on the
> +                     replication device, this will behave like 'open'.
> +                     Otherwise, this option behaves like 'create'.
> +
> +<slink_type>    = "blockdev" is currently the only available type
> +<#slink_params> = 1/2/4
> +<slink_params>  = <slink_nr> [<slink_policy> [<fall_behind> <N>]]
> +       <slink_nr>     = This is a unique number that is used to identify a
> +                        particular site/location.  '0' is always used to
> +                        identify the local site, while increasing integers
> +                        are used to identify remote sites.
> +       <slink_policy> = The policy can be either 'sync' or 'async'.
> +                        'sync' means write requests will not return until
> +                        the data is on the storage device.  'async' allows
> +                        a device to "fall behind"; that is, outstanding
> +                        write requests are waiting in the replication log
> +                        to be processed for this site, but it is not
> delaying
> +                        the writes of other sites.
> +       <fall_behind>  = This field is used to specify how far the user is
> +                        willing to allow write requests to this specific
> site
> +                        to "fall behind" in processing before switching to
> +                        a 'sync' policy.  This "fall behind" threshhold
> can
> +                        be specified in three ways: ios, size, or timeout.
> +                        'ios' is the number of pending I/Os allowed (e.g.
> +                        "ios 10000").  'size' is the amount of pending
> data
> +                        allowed (e.g. "size 200m").  Size labels include:
> +                        s (sectors), k, m, g, t, p, and e.  'timeout' is
> +                        the amount of time allowed for writes to be
> +                        outstanding.  Time labels include: s, m, h, and d.
> +
> +
> +"replicator-dev" target parameters:
> +-----------------------------------
> +start> <length> replicator-dev
> +       <replicator_device> <dev_nr> \
> +       [<slink_nr> <#dev_params> <dev_params>
> +        <dlog_type> <#dlog_params> <dlog_params>]{1..N}
> +
> +<replicator_device> = device previously constructed via "replication"
> target
> +<dev_nr>           = An integer that is used to 'tag' write requests as
> +                     belonging to a particular set of devices -
> specifically,
> +                     the devices that follow this argument (i.e. the site
> +                     link devices).
> +<slink_nr>         = This number identifies the site/location where the
> next
> +                     device to be specified comes from.  It is exactly the
> +                     same number used to identify the site/location (and
> its
> +                     policies) in the "replicator" target.  Interestingly,
> +                     while one might normally expect a "dev_type" argument
> +                     here, it can be deduced from the site link number and
> +                     the 'slink_type' given in the "replication" target.
> +<#dev_params>      = '1'  (The number of allowed parameters actually
> depends
> +                     on the 'slink_type' given in the "replication"
> target.
> +                     Since our only option there is "blockdev", the only
> +                     allowable number here is currently '1'.)
> +<dev_params>       = 'dev_path'  (Again, since "blockdev" is the only
> +                     'slink_type' available, the only allowable argument
> here
> +                     is the path to the device.)
> +<dlog_type>        = Not to be confused with the "replicator log", this is
> +                     the type of dirty log associated with this particular
> +                     device.  Dirty logs are used for synchronization,
> during
> +                     initialization or fall behind conditions, to bring
> devices
> +                     into a coherent state with its peers - analogous to
> +                     rebuilding a RAID1 (mirror) device.  Available dirty
> +                     log types include: 'nolog', 'core', and 'disk'
> +<#dlog_params>     = The number of arguments required for a particular log
> +                     type - 'nolog' = 0, 'core' = 1/2, 'disk' = 2/3.
> +<dlog_params>      = 'nolog' => ~no arguments~
> +                     'core'  => <region_size> [sync | nosync]
> +                     'disk'  => <dlog_dev_path> <region_size> [sync |
> nosync]
> +       <region_size>   = This sets the granularity at which the dirty log
> +                         tracks what areas of the device is in-sync.
> +       [sync | nosync] = Optionally specify whether the sync should be
> forced
> +                         or avoided initially.
> diff --git 2.6.33-rc1.orig/drivers/md/Kconfig 2.6.33-rc1/drivers/md/Kconfig
> index acb3a4e..62c9766 100644
> --- 2.6.33-rc1.orig/drivers/md/Kconfig
> +++ 2.6.33-rc1/drivers/md/Kconfig
> @@ -313,6 +313,14 @@ config DM_DELAY
>
>        If unsure, say N.
>
> +config DM_REPLICATOR
> +       tristate "Replication target (EXPERIMENTAL)"
> +       depends on BLK_DEV_DM && EXPERIMENTAL
> +       ---help---
> +       A target that supports replication of local devices to remote
> sites.
> +
> +       If unsure, say N.
> +
>  config DM_UEVENT
>        bool "DM uevents (EXPERIMENTAL)"
>        depends on BLK_DEV_DM && EXPERIMENTAL
> diff --git 2.6.33-rc1.orig/drivers/md/Makefile
> 2.6.33-rc1/drivers/md/Makefile
> index e355e7f..be05b39 100644
> --- 2.6.33-rc1.orig/drivers/md/Makefile
> +++ 2.6.33-rc1/drivers/md/Makefile
> @@ -44,6 +44,7 @@ obj-$(CONFIG_DM_SNAPSHOT)     += dm-snapshot.o
>  obj-$(CONFIG_DM_MIRROR)                += dm-mirror.o dm-log.o
> dm-region-hash.o
>  obj-$(CONFIG_DM_LOG_USERSPACE) += dm-log-userspace.o
>  obj-$(CONFIG_DM_ZERO)          += dm-zero.o
> +obj-$(CONFIG_DM_REPLICATOR)    += dm-log.o dm-registry.o
>
>  quiet_cmd_unroll = UNROLL  $@
>       cmd_unroll = $(AWK) -f$(srctree)/$(src)/unroll.awk -vN=$(UNROLL) \
> diff --git 2.6.33-rc1.orig/drivers/md/dm-registry.c
> 2.6.33-rc1/drivers/md/dm-registry.c
> new file mode 100644
> index 0000000..fb8abbf
> --- /dev/null
> +++ 2.6.33-rc1/drivers/md/dm-registry.c
> @@ -0,0 +1,224 @@
> +/*
> + * Copyright (C) 2009 Red Hat, Inc. All rights reserved.
> + *
> + * Module Author: Heinz Mauelshagen (heinzm@redhat.com)
> + *
> + * Generic registry for arbitrary structures
> + * (needs dm_registry_type structure upfront each registered structure).
> + *
> + * This file is released under the GPL.
> + *
> + * FIXME: use as registry for e.g. dirty log types as well.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +
> +#include "dm-registry.h"
> +
> +#define        DM_MSG_PREFIX   "dm-registry"
> +
> +static const char *version = "0.001";
> +
> +/* Sizable class registry. */
> +static unsigned num_classes;
> +static struct list_head *_classes;
> +static rwlock_t *_locks;
> +
> +void *
> +dm_get_type(const char *type_name, enum dm_registry_class class)
> +{
> +       struct dm_registry_type *t;
> +
> +       read_lock(_locks + class);
> +       list_for_each_entry(t, _classes + class, list) {
> +               if (!strcmp(type_name, t->name)) {
> +                       if (!t->use_count && !try_module_get(t->module)) {
> +                               read_unlock(_locks + class);
> +                               return ERR_PTR(-ENOMEM);
> +                       }
> +
> +                       t->use_count++;
> +                       read_unlock(_locks + class);
> +                       return t;
> +               }
> +       }
> +
> +       read_unlock(_locks + class);
> +       return ERR_PTR(-ENOENT);
> +}
> +EXPORT_SYMBOL(dm_get_type);
> +
> +void
> +dm_put_type(void *type, enum dm_registry_class class)
> +{
> +       struct dm_registry_type *t = type;
> +
> +       read_lock(_locks + class);
> +       if (!--t->use_count)
> +               module_put(t->module);
> +
> +       read_unlock(_locks + class);
> +}
> +EXPORT_SYMBOL(dm_put_type);
> +
> +/* Add a type to the registry. */
> +int
> +dm_register_type(void *type, enum dm_registry_class class)
> +{
> +       struct dm_registry_type *t = type, *tt;
> +
> +       if (unlikely(class >= num_classes))
> +               return -EINVAL;
> +
> +       tt = dm_get_type(t->name, class);
> +       if (unlikely(!IS_ERR(tt))) {
> +               dm_put_type(t, class);
> +               return -EEXIST;
> +       }
> +
> +       write_lock(_locks + class);
> +       t->use_count = 0;
> +       list_add(&t->list, _classes + class);
> +       write_unlock(_locks + class);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(dm_register_type);
> +
> +/* Remove a type from the registry. */
> +int
> +dm_unregister_type(void *type, enum dm_registry_class class)
> +{
> +       struct dm_registry_type *t = type;
> +
> +       if (unlikely(class >= num_classes)) {
> +               DMERR("Attempt to unregister invalid class");
> +               return -EINVAL;
> +       }
> +
> +       write_lock(_locks + class);
> +
> +       if (unlikely(t->use_count)) {
> +               write_unlock(_locks + class);
> +               DMWARN("Attempt to unregister a type that is still in
> use");
> +               return -ETXTBSY;
> +       } else
> +               list_del(&t->list);
> +
> +       write_unlock(_locks + class);
> +       return 0;
> +}
> +EXPORT_SYMBOL(dm_unregister_type);
> +
> +/*
> + * Return kmalloc'ed NULL terminated pointer
> + * array of all type names of the given class.
> + *
> + * Caller has to kfree the array!.
> + */
> +const char **dm_types_list(enum dm_registry_class class)
> +{
> +       unsigned i = 0, count = 0;
> +       const char **r;
> +       struct dm_registry_type *t;
> +
> +       /* First count the registered types in the class. */
> +       read_lock(_locks + class);
> +       list_for_each_entry(t, _classes + class, list)
> +               count++;
> +       read_unlock(_locks + class);
> +
> +       /* None registered in this class. */
> +       if (!count)
> +               return NULL;
> +
> +       /* One member more for array NULL termination. */
> +       r = kzalloc((count + 1) * sizeof(*r), GFP_KERNEL);
> +       if (!r)
> +               return ERR_PTR(-ENOMEM);
> +
> +       /*
> +        * Go with the counted ones.
> +        * Any new added ones after we counted will be ignored!
> +        */
> +       read_lock(_locks + class);
> +       list_for_each_entry(t, _classes + class, list) {
> +               r[i++] = t->name;
> +               if (!--count)
> +                       break;
> +       }
> +       read_unlock(_locks + class);
> +
> +       return r;
> +}
> +EXPORT_SYMBOL(dm_types_list);
> +
> +int __init
> +dm_registry_init(void)
> +{
> +       unsigned n;
> +
> +       BUG_ON(_classes);
> +       BUG_ON(_locks);
> +
> +       /* Module parameter given ? */
> +       if (!num_classes)
> +               num_classes = DM_REGISTRY_CLASS_END;
> +
> +       n = num_classes;
> +       _classes = kmalloc(n * sizeof(*_classes), GFP_KERNEL);
> +       if (!_classes) {
> +               DMERR("Failed to allocate classes registry");
> +               return -ENOMEM;
> +       }
> +
> +       _locks = kmalloc(n * sizeof(*_locks), GFP_KERNEL);
> +       if (!_locks) {
> +               DMERR("Failed to allocate classes locks");
> +               kfree(_classes);
> +               _classes = NULL;
> +               return -ENOMEM;
> +       }
> +
> +       while (n--) {
> +               INIT_LIST_HEAD(_classes + n);
> +               rwlock_init(_locks + n);
> +       }
> +
> +       DMINFO("initialized %s for max %u classes", version, num_classes);
> +       return 0;
> +}
> +
> +void __exit
> +dm_registry_exit(void)
> +{
> +       BUG_ON(!_classes);
> +       BUG_ON(!_locks);
> +
> +       kfree(_classes);
> +       _classes = NULL;
> +       kfree(_locks);
> +       _locks = NULL;
> +       DMINFO("exit %s", version);
> +}
> +
> +/* Module hooks */
> +module_init(dm_registry_init);
> +module_exit(dm_registry_exit);
> +module_param(num_classes, uint, 0);
> +MODULE_PARM_DESC(num_classes, "Maximum number of classes");
> +MODULE_DESCRIPTION(DM_NAME "device-mapper registry");
> +MODULE_AUTHOR("Heinz Mauelshagen <heinzm@redhat.com>");
> +MODULE_LICENSE("GPL");
> +
> +#ifndef MODULE
> +static int __init num_classes_setup(char *str)
> +{
> +       num_classes = simple_strtol(str, NULL, 0);
> +       return num_classes ? 1 : 0;
> +}
> +
> +__setup("num_classes=", num_classes_setup);
> +#endif
> diff --git 2.6.33-rc1.orig/drivers/md/dm-registry.h
> 2.6.33-rc1/drivers/md/dm-registry.h
> new file mode 100644
> index 0000000..1cb0ce8
> --- /dev/null
> +++ 2.6.33-rc1/drivers/md/dm-registry.h
> @@ -0,0 +1,38 @@
> +/*
> + * Copyright (C) 2009 Red Hat, Inc. All rights reserved.
> + *
> + * Module Author: Heinz Mauelshagen (heinzm@redhat.com)
> + *
> + * Generic registry for arbitrary structures.
> + * (needs dm_registry_type structure upfront each registered structure).
> + *
> + * This file is released under the GPL.
> + */
> +
> +#include "dm.h"
> +
> +#ifndef DM_REGISTRY_H
> +#define DM_REGISTRY_H
> +
> +enum dm_registry_class {
> +       DM_REPLOG = 0,
> +       DM_SLINK,
> +       DM_LOG,
> +       DM_REGION_HASH,
> +       DM_REGISTRY_CLASS_END,
> +};
> +
> +struct dm_registry_type {
> +       struct list_head list;  /* Linked list of types in this class. */
> +       const char *name;
> +       struct module *module;
> +       unsigned int use_count;
> +};
> +
> +void *dm_get_type(const char *type_name, enum dm_registry_class class);
> +void dm_put_type(void *type, enum dm_registry_class class);
> +int dm_register_type(void *type, enum dm_registry_class class);
> +int dm_unregister_type(void *type, enum dm_registry_class class);
> +const char **dm_types_list(enum dm_registry_class class);
> +
> +#endif
> --
> 1.6.2.5
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--00504502b46855211d047c9063b6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Is there any command-line example to explain how to use this=A0 patch?=
</div>
<div>I have compiled it and loaded the modules,=A0the &#39;&lt;start&gt;&lt=
;length&gt;&#39; target parameters in both replicator ant replicator-dev ta=
rgets means what?</div>
<div>how can I construct these target?</div>
<div>I haven&#39;t read the source code=A0in detail till now, sorry.=A0<br>=
<br></div>
<div class=3D"gmail_quote">2009/12/18 <span dir=3D"ltr">&lt;<a href=3D"mail=
to:heinzm@redhat.com">heinzm@redhat.com</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">From: Heinz Mauelshagen &lt;<a h=
ref=3D"mailto:heinzm@redhat.com">heinzm@redhat.com</a>&gt;<br><br>The dm-re=
gistry module is a general purpose registry for modules.<br>
<br>The remote replicator utilizes it to register its ringbuffer log and<br=
>site link handlers in order to avoid duplicating registry code and logic.<=
br><br><br>Signed-off-by: Heinz Mauelshagen &lt;<a href=3D"mailto:heinzm@re=
dhat.com">heinzm@redhat.com</a>&gt;<br>
Reviewed-by: Jon Brassow &lt;<a href=3D"mailto:jbrassow@redhat.com">jbrasso=
w@redhat.com</a>&gt;<br>Tested-by: Jon Brassow &lt;<a href=3D"mailto:jbrass=
ow@redhat.com">jbrassow@redhat.com</a>&gt;<br>---<br>=A0Documentation/devic=
e-mapper/replicator.txt | =A0203 +++++++++++++++++++++++++<br>
=A0drivers/md/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0=
 =A08 +<br>=A0drivers/md/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0| =A0 =A01 +<br>=A0drivers/md/dm-registry.c =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 | =A0224 ++++++++++++++++++++++++++++<br>=A0drivers/md/dm-regis=
try.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 38 +++++<br>
=A05 files changed, 474 insertions(+), 0 deletions(-)<br>=A0create mode 100=
644 Documentation/device-mapper/replicator.txt<br>=A0create mode 100644 dri=
vers/md/dm-registry.c<br>=A0create mode 100644 drivers/md/dm-registry.h<br>=
<br>
diff --git 2.6.33-rc1.orig/Documentation/device-mapper/replicator.txt 2.6.3=
3-rc1/Documentation/device-mapper/replicator.txt<br>new file mode 100644<br=
>index 0000000..1d408a6<br>--- /dev/null<br>+++ 2.6.33-rc1/Documentation/de=
vice-mapper/replicator.txt<br>
@@ -0,0 +1,203 @@<br>+dm-replicator<br>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D<br>+<br>+Device-mapper replicator is designed to enable redundant co=
pies of<br>+storage devices to be made - preferentially, to remote location=
s.<br>+RAID1 (aka mirroring) is often used to maintain redundant copies of<=
br>
+storage for fault tolerance purposes. =A0Unlike RAID1, which often<br>+ass=
umes similar device characteristics, dm-replicator is designed to<br>+handl=
e devices with different latency and bandwidth characteristics<br>+which ar=
e often the result of the geograhic disparity of multi-site<br>
+architectures. =A0Simply put, you might choose RAID1 to protect from<br>+a=
 single device failure, but you would choose remote replication<br>+via dm-=
replicator for protection against a site failure.<br>+<br>+dm-replicator wo=
rks by first sending write requests to the &quot;replicator<br>
+log&quot;. =A0Not to be confused with the device-mapper dirty log, this<br=
>+replicator log behaves similarly to that of a journal. =A0Write requests<=
br>+go to this log first and then are copied to all the replicate devices<b=
r>
+at their various locations. =A0Requests are cleared from the log once all<=
br>+replicate devices confirm the data is received/copied. =A0This architec=
ture<br>+allows dm-replicator to be flexible in terms of device characteris=
tics.<br>
+If one device should fall behind the others - perhaps due to high latency =
-<br>+the slack is picked up by the log. =A0The user has a great deal of<br=
>+flexibility in specifying to what degree a particular site is allowed to<=
br>
+fall behind - if at all.<br>+<br>+Device-Mapper&#39;s dm-replicator has tw=
o targets, &quot;replicator&quot; and<br>+&quot;replicator-dev&quot;. =A0Th=
e &quot;replicator&quot; target is used to setup the<br>+aforementioned log=
 and allow the specification of site link properties.<br>
+Through the &quot;replicator&quot; target, the user might specify that wri=
tes<br>+that are copied to the local site must happen synchronously (i.e th=
e<br>+writes are complete only after they have passed through the log devic=
e<br>
+and have landed on the local site&#39;s disk). =A0They may also specify th=
at<br>+a remote link should asynchronously complete writes, but that the re=
mote<br>+link should never fall more than 100MB behind in terms of processi=
ng.<br>
+Again, the &quot;replicator&quot; target is used to define the replicator =
log and<br>+the characteristics of each site link.<br>+<br>+The &quot;repli=
cator-dev&quot; target is used to define the devices used and<br>+associate=
 them with a particular replicator log. =A0You might think of<br>
+this stage in a similar way to setting up RAID1 (mirroring). =A0You<br>+de=
fine a set of devices which will be copies of each other, but<br>+access th=
e device through the mirror virtual device which takes care<br>+of the copy=
ing. =A0The user accessible replicator device is analogous<br>
+to the mirror virtual device, while the set of devices being copied<br>+to=
 are analogous to the mirror images (sometimes called &#39;legs&#39;).<br>+=
When creating a replicator device via the &quot;replicator-dev&quot; target=
,<br>
+it must be associated with the replicator log (created with the<br>+aforem=
entioned &quot;replicator&quot; target). =A0When each redundant device<br>+=
is specified as part of the replicator device, it is associated with<br>+a =
site link whose properties were defined when the &quot;replicator&quot;<br>
+target was created.<br>+<br>+The user can go farther than simply replicati=
ng one device. =A0They<br>+can continue to add replicator devices - associa=
ting them with a<br>+particular replicator log. =A0Writes that go through t=
he replicator<br>
+log are guarenteed to have their write ordering preserved. =A0So, if<br>+y=
ou associate more than one replicator device to a particular<br>+replicator=
 log, you are preserving write ordering across multiple<br>+devices. =A0Thi=
s might be useful if you had a database that spanned<br>
+multiple disks and write ordering must be preserved or any transaction<br>=
+accounting scheme would be foiled. =A0(You can imagine this like<br>+prese=
rving write ordering across a number of mirrored devices, where<br>+each mi=
rror has images/legs in different geographic locations.)<br>
+<br>+dm-replicator has a modular architecture. =A0Future implementations f=
or<br>+the replicator log and site link modules are allowed. =A0The current=
<br>+replication log is ringbuffer - utilized to store all writes being<br>
+subject to replication and enforce write ordering. =A0The current site<br>=
+link code is based on accessing block devices (iSCSI, FC, etc) and<br>+doe=
s device recovery including (initial) resynchronization.<br>+<br>+<br>+Pict=
ure of a 2 site configuration with 3 local devices (LDs) in a<br>
+primary site being resycnhronied to 3 remotes sites with 3 remote<br>+devi=
ces (RDs) each via site links (SLINK) 1-2 with site link 0<br>+as a special=
 case to handle the local devices:<br>+<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |<br>
+ =A0 =A0Local (primary) site =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0=
 =A0Remote sites<br>+ =A0 =A0-------------------- =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 | =A0 =A0 =A0------------<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |<br>+ =A0 =A0D1 =A0 D2=
 =A0 =A0 Dn =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |<br>
+ =A0 =A0 | =A0 | =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 |<br>+ =A0 =A0 +---+- ... -+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 |<br>+ =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 |<br>+ =A0 =A0 =A0 REPLOG-----------------+- SLINK1=
 ------------+<br>+ =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0| =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0|<br>
+ =A0 =A0 =A0 SLINK0 (special case) =A0| =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =
=A0 =A0|<br>+ =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =
=A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0|<br>+ =A0 =A0 +-----+ =A0 ... =A0+=
 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0| =A0 +----+- ... -+<br>+ =A0 =A0=
 | =A0 =A0 | =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0| =
=A0 | =A0 =A0| =A0 =A0 =A0 |<br>
+ =A0 =A0LD1 =A0 LD2 =A0 =A0 =A0LDn =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 =
=A0| =A0RD1 =A0RD2 =A0 =A0 RDn<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 =A0|<br>+ =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+-- SLINK2------------+<br>+ =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 =
=A0| =A0 =A0 =A0 =A0|<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =
=A0 =A0 =A0| =A0 +----+- ... -+<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 =A0| =A0 | =A0 =A0| =A0 =A0 =
=A0 |<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
 =A0 =A0 =A0 =A0 =A0| =A0RD1 =A0RD2 =A0 =A0 RDn<br>+ =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =A0 =A0 =A0|<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0 =A0 =
=A0 =A0 =A0|<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0| =A0 =A0 =A0 =A0 =A0 =A0|<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0+- SLINKm ------------+<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0|=
<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 | =A0 +----+- ... -+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 | =A0 | =A0 =A0| =A0 =A0 =A0 |<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0RD1 =A0RD2 =
=A0 =A0 RDn<br>+<br>+<br>+<br>+<br>+The following are descriptions of the d=
evice-mapper tables used to<br>
+construct the &quot;replicator&quot; and &quot;replicator-dev&quot; target=
s.<br>+<br>+&quot;replicator&quot; target parameters:<br>+-----------------=
--------------<br>+&lt;start&gt; &lt;length&gt; replicator \<br>+ =A0 =A0 =
=A0 &lt;replog_type&gt; &lt;#replog_params&gt; &lt;replog_params&gt; \<br>
+ =A0 =A0 =A0 [&lt;slink_type_0&gt; &lt;#slink_params_0&gt; &lt;slink_param=
s_0&gt;]{1..N}<br>+<br>+&lt;replog_type&gt; =A0 =A0=3D &quot;ringbuffer&quo=
t; is currently the only available type<br>+&lt;#replog_params&gt; =3D # of=
 args following this one intended for the replog (2 or 4)<br>
+&lt;replog_params&gt; =A0=3D &lt;dev_path&gt; &lt;dev_start&gt; [auto/crea=
te/open &lt;size&gt;]<br>+ =A0 =A0 =A0 &lt;dev_path&gt; =A0=3D device path =
of replication log (REPLOG) backing store<br>+ =A0 =A0 =A0 &lt;dev_start&gt=
; =3D offset to REPLOG header<br>
+ =A0 =A0 =A0 create =A0 =A0 =A0=3D The replication log will be initialized=
 if not active<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 and sized to &q=
uot;size&quot;. =A0(If already active, the create<br>+ =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 will fail.) =A0Size is always in sectors.<br>
+ =A0 =A0 =A0 open =A0 =A0 =A0 =A0=3D The replication log must be initializ=
ed and valid or<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 the constructo=
r will fail.<br>+ =A0 =A0 =A0 auto =A0 =A0 =A0 =A0=3D If a valid replicatio=
n log header is found on the<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r=
eplication device, this will behave like &#39;open&#39;.<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Otherwise, this option behaves li=
ke &#39;create&#39;.<br>+<br>+&lt;slink_type&gt; =A0 =A0=3D &quot;blockdev&=
quot; is currently the only available type<br>+&lt;#slink_params&gt; =3D 1/=
2/4<br>+&lt;slink_params&gt; =A0=3D &lt;slink_nr&gt; [&lt;slink_policy&gt; =
[&lt;fall_behind&gt; &lt;N&gt;]]<br>
+ =A0 =A0 =A0 &lt;slink_nr&gt; =A0 =A0 =3D This is a unique number that is =
used to identify a<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0part=
icular site/location. =A0&#39;0&#39; is always used to<br>+ =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0identify the local site, while increasing i=
ntegers<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0are used to identify remot=
e sites.<br>+ =A0 =A0 =A0 &lt;slink_policy&gt; =3D The policy can be either=
 &#39;sync&#39; or &#39;async&#39;.<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0&#39;sync&#39; means write requests will not return until<br=
>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0the data is on the storage=
 device. =A0&#39;async&#39; allows<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0a device to &quot;fall behind&quot;; that is, outstanding<br>+ =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0write requests are waiting i=
n the replication log<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0to be processed for this s=
ite, but it is not delaying<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0the writes of other sites.<br>+ =A0 =A0 =A0 &lt;fall_behind&gt; =A0=
=3D This field is used to specify how far the user is<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0willing to allow write req=
uests to this specific site<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0to &quot;fall behind&quot; in processing before switching to<br>+ =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0a &#39;sync&#39; policy. =A0=
This &quot;fall behind&quot; threshhold can<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0be specified in three ways=
: ios, size, or timeout.<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0&#39;ios&#39; is the number of pending I/Os allowed (e.g.<br>+ =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&quot;ios 10000&quot;). =A0&#39;size=
&#39; is the amount of pending data<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0allowed (e.g. &quot;size 2=
00m&quot;). =A0Size labels include:<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0s (sectors), k, m, g, t, p, and e. =A0&#39;timeout&#39; is<b=
r>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0the amount of time allow=
ed for writes to be<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0outstanding. =A0Time label=
s include: s, m, h, and d.<br>+<br>+<br>+&quot;replicator-dev&quot; target =
parameters:<br>+-----------------------------------<br>+start&gt; &lt;lengt=
h&gt; replicator-dev<br>
+ =A0 =A0 =A0 &lt;replicator_device&gt; &lt;dev_nr&gt; \<br>+ =A0 =A0 =A0 [=
&lt;slink_nr&gt; &lt;#dev_params&gt; &lt;dev_params&gt;<br>+ =A0 =A0 =A0 =
=A0&lt;dlog_type&gt; &lt;#dlog_params&gt; &lt;dlog_params&gt;]{1..N}<br>+<b=
r>+&lt;replicator_device&gt; =3D device previously constructed via &quot;re=
plication&quot; target<br>
+&lt;dev_nr&gt; =A0 =A0 =A0 =A0 =A0 =3D An integer that is used to &#39;tag=
&#39; write requests as<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 belong=
ing to a particular set of devices - specifically,<br>+ =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 the devices that follow this argument (i.e. the site<b=
r>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 link devices).<br>+&lt;slink_nr&g=
t; =A0 =A0 =A0 =A0 =3D This number identifies the site/location where the n=
ext<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 device to be specified com=
es from. =A0It is exactly the<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
same number used to identify the site/location (and its<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 policies) in the &quot;replicator=
&quot; target. =A0Interestingly,<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 while one might normally expect a &quot;dev_type&quot; argument<br>+ =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 here, it can be deduced from the si=
te link number and<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 the &#39;slink_type&#39; given in=
 the &quot;replication&quot; target.<br>+&lt;#dev_params&gt; =A0 =A0 =A0=3D=
 &#39;1&#39; =A0(The number of allowed parameters actually depends<br>+ =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 on the &#39;slink_type&#39; given in t=
he &quot;replication&quot; target.<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Since our only option there is &q=
uot;blockdev&quot;, the only<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 a=
llowable number here is currently &#39;1&#39;.)<br>+&lt;dev_params&gt; =A0 =
=A0 =A0 =3D &#39;dev_path&#39; =A0(Again, since &quot;blockdev&quot; is the=
 only<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &#39;slink_type&#39; available, t=
he only allowable argument here<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 is the path to the device.)<br>+&lt;dlog_type&gt; =A0 =A0 =A0 =A0=3D No=
t to be confused with the &quot;replicator log&quot;, this is<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 the type of dirty log associated =
with this particular<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 device. =
=A0Dirty logs are used for synchronization, during<br>+ =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 initialization or fall behind conditions, to bring dev=
ices<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 into a coherent state with its pe=
ers - analogous to<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rebuilding =
a RAID1 (mirror) device. =A0Available dirty<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 log types include: &#39;nolog&#39;, &#39;core&#39;, and &#3=
9;disk&#39;<br>
+&lt;#dlog_params&gt; =A0 =A0 =3D The number of arguments required for a pa=
rticular log<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 type - &#39;nolog=
&#39; =3D 0, &#39;core&#39; =3D 1/2, &#39;disk&#39; =3D 2/3.<br>+&lt;dlog_p=
arams&gt; =A0 =A0 =A0=3D &#39;nolog&#39; =3D&gt; ~no arguments~<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &#39;core&#39; =A0=3D&gt; &lt;reg=
ion_size&gt; [sync | nosync]<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &=
#39;disk&#39; =A0=3D&gt; &lt;dlog_dev_path&gt; &lt;region_size&gt; [sync | =
nosync]<br>+ =A0 =A0 =A0 &lt;region_size&gt; =A0 =3D This sets the granular=
ity at which the dirty log<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tracks what areas of the =
device is in-sync.<br>+ =A0 =A0 =A0 [sync | nosync] =3D Optionally specify =
whether the sync should be forced<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 or avoided initially.<br>diff --git 2.6.33-rc1.orig/drivers/md/=
Kconfig 2.6.33-rc1/drivers/md/Kconfig<br>
index acb3a4e..62c9766 100644<br>--- 2.6.33-rc1.orig/drivers/md/Kconfig<br>=
+++ 2.6.33-rc1/drivers/md/Kconfig<br>@@ -313,6 +313,14 @@ config DM_DELAY<b=
r><br>=A0 =A0 =A0 =A0If unsure, say N.<br><br>+config DM_REPLICATOR<br>+ =
=A0 =A0 =A0 tristate &quot;Replication target (EXPERIMENTAL)&quot;<br>
+ =A0 =A0 =A0 depends on BLK_DEV_DM &amp;&amp; EXPERIMENTAL<br>+ =A0 =A0 =
=A0 ---help---<br>+ =A0 =A0 =A0 A target that supports replication of local=
 devices to remote sites.<br>+<br>+ =A0 =A0 =A0 If unsure, say N.<br>+<br>=
=A0config DM_UEVENT<br>=A0 =A0 =A0 =A0bool &quot;DM uevents (EXPERIMENTAL)&=
quot;<br>
=A0 =A0 =A0 =A0depends on BLK_DEV_DM &amp;&amp; EXPERIMENTAL<br>diff --git =
2.6.33-rc1.orig/drivers/md/Makefile 2.6.33-rc1/drivers/md/Makefile<br>index=
 e355e7f..be05b39 100644<br>--- 2.6.33-rc1.orig/drivers/md/Makefile<br>+++ =
2.6.33-rc1/drivers/md/Makefile<br>
@@ -44,6 +44,7 @@ obj-$(CONFIG_DM_SNAPSHOT) =A0 =A0 +=3D dm-snapshot.o<br>=
=A0obj-$(CONFIG_DM_MIRROR) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D dm-mirror.o =
dm-log.o dm-region-hash.o<br>=A0obj-$(CONFIG_DM_LOG_USERSPACE) +=3D dm-log-=
userspace.o<br>=A0obj-$(CONFIG_DM_ZERO) =A0 =A0 =A0 =A0 =A0+=3D dm-zero.o<b=
r>
+obj-$(CONFIG_DM_REPLICATOR) =A0 =A0+=3D dm-log.o dm-registry.o<br><br>=A0q=
uiet_cmd_unroll =3D UNROLL =A0$@<br>=A0 =A0 =A0 cmd_unroll =3D $(AWK) -f$(s=
rctree)/$(src)/unroll.awk -vN=3D$(UNROLL) \<br>diff --git 2.6.33-rc1.orig/d=
rivers/md/dm-registry.c 2.6.33-rc1/drivers/md/dm-registry.c<br>
new file mode 100644<br>index 0000000..fb8abbf<br>--- /dev/null<br>+++ 2.6.=
33-rc1/drivers/md/dm-registry.c<br>@@ -0,0 +1,224 @@<br>+/*<br>+ * Copyrigh=
t (C) 2009 Red Hat, Inc. All rights reserved.<br>+ *<br>+ * Module Author: =
Heinz Mauelshagen (<a href=3D"mailto:heinzm@redhat.com">heinzm@redhat.com</=
a>)<br>
+ *<br>+ * Generic registry for arbitrary structures<br>+ * (needs dm_regis=
try_type structure upfront each registered structure).<br>+ *<br>+ * This f=
ile is released under the GPL.<br>+ *<br>+ * FIXME: use as registry for e.g=
. dirty log types as well.<br>
+ */<br>+<br>+#include &lt;linux/init.h&gt;<br>+#include &lt;linux/module.h=
&gt;<br>+#include &lt;linux/moduleparam.h&gt;<br>+<br>+#include &quot;dm-re=
gistry.h&quot;<br>+<br>+#define =A0 =A0 =A0 =A0DM_MSG_PREFIX =A0 &quot;dm-r=
egistry&quot;<br>
+<br>+static const char *version =3D &quot;0.001&quot;;<br>+<br>+/* Sizable=
 class registry. */<br>+static unsigned num_classes;<br>+static struct list=
_head *_classes;<br>+static rwlock_t *_locks;<br>+<br>+void *<br>+dm_get_ty=
pe(const char *type_name, enum dm_registry_class class)<br>
+{<br>+ =A0 =A0 =A0 struct dm_registry_type *t;<br>+<br>+ =A0 =A0 =A0 read_=
lock(_locks + class);<br>+ =A0 =A0 =A0 list_for_each_entry(t, _classes + cl=
ass, list) {<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!strcmp(type_name, t-&gt;=
name)) {<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!t-&gt;use_co=
unt &amp;&amp; !try_module_get(t-&gt;module)) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 read_unlock(_=
locks + class);<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 return ERR_PTR(-ENOMEM);<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 }<br>+<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 t-&gt;use_c=
ount++;<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 read_unlock(_locks=
 + class);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return t;<br>+ =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 }<br>+ =A0 =A0 =A0 }<br>+<br>+ =A0 =A0 =A0 read_unlock(_loc=
ks + class);<br>+ =A0 =A0 =A0 return ERR_PTR(-ENOENT);<br>+}<br>+EXPORT_SYM=
BOL(dm_get_type);<br>+<br>+void<br>+dm_put_type(void *type, enum dm_registr=
y_class class)<br>
+{<br>+ =A0 =A0 =A0 struct dm_registry_type *t =3D type;<br>+<br>+ =A0 =A0 =
=A0 read_lock(_locks + class);<br>+ =A0 =A0 =A0 if (!--t-&gt;use_count)<br>=
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 module_put(t-&gt;module);<br>+<br>+ =A0 =A0 =
=A0 read_unlock(_locks + class);<br>+}<br>
+EXPORT_SYMBOL(dm_put_type);<br>+<br>+/* Add a type to the registry. */<br>=
+int<br>+dm_register_type(void *type, enum dm_registry_class class)<br>+{<b=
r>+ =A0 =A0 =A0 struct dm_registry_type *t =3D type, *tt;<br>+<br>+ =A0 =A0=
 =A0 if (unlikely(class &gt;=3D num_classes))<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;<br>+<br>+ =A0 =A0 =A0 tt =3D =
dm_get_type(t-&gt;name, class);<br>+ =A0 =A0 =A0 if (unlikely(!IS_ERR(tt)))=
 {<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 dm_put_type(t, class);<br>+ =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 return -EEXIST;<br>+ =A0 =A0 =A0 }<br>+<br>
+ =A0 =A0 =A0 write_lock(_locks + class);<br>+ =A0 =A0 =A0 t-&gt;use_count =
=3D 0;<br>+ =A0 =A0 =A0 list_add(&amp;t-&gt;list, _classes + class);<br>+ =
=A0 =A0 =A0 write_unlock(_locks + class);<br>+<br>+ =A0 =A0 =A0 return 0;<b=
r>+}<br>+EXPORT_SYMBOL(dm_register_type);<br>
+<br>+/* Remove a type from the registry. */<br>+int<br>+dm_unregister_type=
(void *type, enum dm_registry_class class)<br>+{<br>+ =A0 =A0 =A0 struct dm=
_registry_type *t =3D type;<br>+<br>+ =A0 =A0 =A0 if (unlikely(class &gt;=
=3D num_classes)) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR(&quot;Attempt to unregister invalid cla=
ss&quot;);<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;<br>+ =A0 =A0 =
=A0 }<br>+<br>+ =A0 =A0 =A0 write_lock(_locks + class);<br>+<br>+ =A0 =A0 =
=A0 if (unlikely(t-&gt;use_count)) {<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 write=
_unlock(_locks + class);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMWARN(&quot;Attempt to unregister a type tha=
t is still in use&quot;);<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ETXTBSY;=
<br>+ =A0 =A0 =A0 } else<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&amp;t-&=
gt;list);<br>+<br>+ =A0 =A0 =A0 write_unlock(_locks + class);<br>
+ =A0 =A0 =A0 return 0;<br>+}<br>+EXPORT_SYMBOL(dm_unregister_type);<br>+<b=
r>+/*<br>+ * Return kmalloc&#39;ed NULL terminated pointer<br>+ * array of =
all type names of the given class.<br>+ *<br>+ * Caller has to kfree the ar=
ray!.<br>
+ */<br>+const char **dm_types_list(enum dm_registry_class class)<br>+{<br>=
+ =A0 =A0 =A0 unsigned i =3D 0, count =3D 0;<br>+ =A0 =A0 =A0 const char **=
r;<br>+ =A0 =A0 =A0 struct dm_registry_type *t;<br>+<br>+ =A0 =A0 =A0 /* Fi=
rst count the registered types in the class. */<br>
+ =A0 =A0 =A0 read_lock(_locks + class);<br>+ =A0 =A0 =A0 list_for_each_ent=
ry(t, _classes + class, list)<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 count++;<br>=
+ =A0 =A0 =A0 read_unlock(_locks + class);<br>+<br>+ =A0 =A0 =A0 /* None re=
gistered in this class. */<br>+ =A0 =A0 =A0 if (!count)<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;<br>+<br>+ =A0 =A0 =A0 /* One mem=
ber more for array NULL termination. */<br>+ =A0 =A0 =A0 r =3D kzalloc((cou=
nt + 1) * sizeof(*r), GFP_KERNEL);<br>+ =A0 =A0 =A0 if (!r)<br>+ =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 return ERR_PTR(-ENOMEM);<br>
+<br>+ =A0 =A0 =A0 /*<br>+ =A0 =A0 =A0 =A0* Go with the counted ones.<br>+ =
=A0 =A0 =A0 =A0* Any new added ones after we counted will be ignored!<br>+ =
=A0 =A0 =A0 =A0*/<br>+ =A0 =A0 =A0 read_lock(_locks + class);<br>+ =A0 =A0 =
=A0 list_for_each_entry(t, _classes + class, list) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 r[i++] =3D t-&gt;name;<br>+ =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 if (!--count)<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
break;<br>+ =A0 =A0 =A0 }<br>+ =A0 =A0 =A0 read_unlock(_locks + class);<br>=
+<br>+ =A0 =A0 =A0 return r;<br>+}<br>+EXPORT_SYMBOL(dm_types_list);<br>
+<br>+int __init<br>+dm_registry_init(void)<br>+{<br>+ =A0 =A0 =A0 unsigned=
 n;<br>+<br>+ =A0 =A0 =A0 BUG_ON(_classes);<br>+ =A0 =A0 =A0 BUG_ON(_locks)=
;<br>+<br>+ =A0 =A0 =A0 /* Module parameter given ? */<br>+ =A0 =A0 =A0 if =
(!num_classes)<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_classes =3D DM_REGISTRY=
_CLASS_END;<br>
+<br>+ =A0 =A0 =A0 n =3D num_classes;<br>+ =A0 =A0 =A0 _classes =3D kmalloc=
(n * sizeof(*_classes), GFP_KERNEL);<br>+ =A0 =A0 =A0 if (!_classes) {<br>+=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR(&quot;Failed to allocate classes registr=
y&quot;);<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;<br>
+ =A0 =A0 =A0 }<br>+<br>+ =A0 =A0 =A0 _locks =3D kmalloc(n * sizeof(*_locks=
), GFP_KERNEL);<br>+ =A0 =A0 =A0 if (!_locks) {<br>+ =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 DMERR(&quot;Failed to allocate classes locks&quot;);<br>+ =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 kfree(_classes);<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 _clas=
ses =3D NULL;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;<br>+ =A0 =A0 =A0 }<br>+<br>+ =
=A0 =A0 =A0 while (n--) {<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_LIST_HEAD(_=
classes + n);<br>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 rwlock_init(_locks + n);<br>=
+ =A0 =A0 =A0 }<br>+<br>+ =A0 =A0 =A0 DMINFO(&quot;initialized %s for max %=
u classes&quot;, version, num_classes);<br>
+ =A0 =A0 =A0 return 0;<br>+}<br>+<br>+void __exit<br>+dm_registry_exit(voi=
d)<br>+{<br>+ =A0 =A0 =A0 BUG_ON(!_classes);<br>+ =A0 =A0 =A0 BUG_ON(!_lock=
s);<br>+<br>+ =A0 =A0 =A0 kfree(_classes);<br>+ =A0 =A0 =A0 _classes =3D NU=
LL;<br>+ =A0 =A0 =A0 kfree(_locks);<br>
+ =A0 =A0 =A0 _locks =3D NULL;<br>+ =A0 =A0 =A0 DMINFO(&quot;exit %s&quot;,=
 version);<br>+}<br>+<br>+/* Module hooks */<br>+module_init(dm_registry_in=
it);<br>+module_exit(dm_registry_exit);<br>+module_param(num_classes, uint,=
 0);<br>+MODULE_PARM_DESC(num_classes, &quot;Maximum number of classes&quot=
;);<br>
+MODULE_DESCRIPTION(DM_NAME &quot;device-mapper registry&quot;);<br>+MODULE=
_AUTHOR(&quot;Heinz Mauelshagen &lt;<a href=3D"mailto:heinzm@redhat.com">he=
inzm@redhat.com</a>&gt;&quot;);<br>+MODULE_LICENSE(&quot;GPL&quot;);<br>+<b=
r>
+#ifndef MODULE<br>+static int __init num_classes_setup(char *str)<br>+{<br=
>+ =A0 =A0 =A0 num_classes =3D simple_strtol(str, NULL, 0);<br>+ =A0 =A0 =
=A0 return num_classes ? 1 : 0;<br>+}<br>+<br>+__setup(&quot;num_classes=3D=
&quot;, num_classes_setup);<br>
+#endif<br>diff --git 2.6.33-rc1.orig/drivers/md/dm-registry.h 2.6.33-rc1/d=
rivers/md/dm-registry.h<br>new file mode 100644<br>index 0000000..1cb0ce8<b=
r>--- /dev/null<br>+++ 2.6.33-rc1/drivers/md/dm-registry.h<br>@@ -0,0 +1,38=
 @@<br>
+/*<br>+ * Copyright (C) 2009 Red Hat, Inc. All rights reserved.<br>+ *<br>=
+ * Module Author: Heinz Mauelshagen (<a href=3D"mailto:heinzm@redhat.com">=
heinzm@redhat.com</a>)<br>+ *<br>+ * Generic registry for arbitrary structu=
res.<br>
+ * (needs dm_registry_type structure upfront each registered structure).<b=
r>+ *<br>+ * This file is released under the GPL.<br>+ */<br>+<br>+#include=
 &quot;dm.h&quot;<br>+<br>+#ifndef DM_REGISTRY_H<br>+#define DM_REGISTRY_H<=
br>
+<br>+enum dm_registry_class {<br>+ =A0 =A0 =A0 DM_REPLOG =3D 0,<br>+ =A0 =
=A0 =A0 DM_SLINK,<br>+ =A0 =A0 =A0 DM_LOG,<br>+ =A0 =A0 =A0 DM_REGION_HASH,=
<br>+ =A0 =A0 =A0 DM_REGISTRY_CLASS_END,<br>+};<br>+<br>+struct dm_registry=
_type {<br>+ =A0 =A0 =A0 struct list_head list; =A0/* Linked list of types =
in this class. */<br>
+ =A0 =A0 =A0 const char *name;<br>+ =A0 =A0 =A0 struct module *module;<br>=
+ =A0 =A0 =A0 unsigned int use_count;<br>+};<br>+<br>+void *dm_get_type(con=
st char *type_name, enum dm_registry_class class);<br>+void dm_put_type(voi=
d *type, enum dm_registry_class class);<br>
+int dm_register_type(void *type, enum dm_registry_class class);<br>+int dm=
_unregister_type(void *type, enum dm_registry_class class);<br>+const char =
**dm_types_list(enum dm_registry_class class);<br>+<br>+#endif<br>--<br>
1.6.2.5<br><font color=3D"#888888"><br>--<br>dm-devel mailing list<br><a hr=
ef=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br><a href=3D"htt=
ps://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_blank">https://ww=
w.redhat.com/mailman/listinfo/dm-devel</a><br>
</font></blockquote></div><br>

--00504502b46855211d047c9063b6--


--===============0765147422350775691==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0765147422350775691==--
