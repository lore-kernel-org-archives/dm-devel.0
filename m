From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v11] dm: add support to directly boot to a mapped device
Date: Thu, 21 Feb 2019 10:50:32 -0500
Message-ID: <20190221155032.GA3155@redhat.com>
References: <20190218181819.20524-1-helen.koike@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190218181819.20524-1-helen.koike@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Helen Koike <helen.koike@collabora.com>
Cc: dm-devel@redhat.com, wad@chromium.org, keescook@chromium.org, linux-doc@vger.kernel.org, richard.weinberger@gmail.com, linux-kernel@vger.kernel.org, linux-lvm@redhat.com, enric.balletbo@collabora.com, kernel@collabora.com, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Feb 18 2019 at  1:18pm -0500,
Helen Koike <helen.koike@collabora.com> wrote:

> Add a dm-mod.create= kernel module parameter.
> It allows device-mapper targets to be configured at boot time for use early
> in the boot process (as the root device or otherwise).
> 
> Signed-off-by: Will Drewry <wad@chromium.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> [rework to use dm_ioctl calls]
> Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> [refactored for upstream]
> Signed-off-by: Helen Koike <helen.koike@collabora.com>

Can I get confirmation from Will and Kees that this v11 is safe to carry
their Signed-off-by?  Are you guys "happy" with this patch?

Helen, the patch header is severly lacking.  All the detail you've
provided is outside of the proposed patch header.  That needs fixing.  I
can write a proper header but if you were to beat me to it, say
today.. hint hint ;)  I'd greatly appreciate it.  What follows below is
actually quite good (I tweaked slightly to be more suitable, but
hopefully you get the idea, less "name dropping" is still needed though):

> The need to create an initramfs adds another layer of complexity when
> performing tests or preparing a BSP for a board.
> Taking care of initramfs is always a bit painful, it also occupies space and is
> another level of complexity in the stack.
> A practical example as mentioned by Kees is that Chrome OS has a limited amount
> of storage available for the boot image as it is covered by the static root of
> trust signature.
> This feature is already used by Android and Chrome OS in devices already shipped
> to the market/end-users.
> 
> Fix this by allowing dm devices to be configured in the kernel command
> line parameter for use early in the boot process without an initramfs.
> 
> One of the main difference in this version is that instead of using "dm=",
> I'm using a parameter in the module "dm-mod.create=" (thanks Ezequiel for
> the idea).
> 
> The syntax used in the boot param is based on the concise format from the dmsetup
> tool as described in its man page http://man7.org/linux/man-pages/man8/dmsetup.8.html#CONCISE_FORMAT
> 
> Which is:
>         dm-mod.create=<name>,<uuid>,<minor>,<flags>,<table>[,<table>+][;<name>,<uuid>,<minor>,<flags>,<table>[,<table>+]+]
> 
> Where,
>         <name>          ::= The device name.
>         <uuid>          ::= xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | ""
>         <minor>         ::= The device minor number | ""
>         <flags>         ::= "ro" | "rw"
>         <table>         ::= <start_sector> <num_sectors> <target_type> <target_args>
>         <target_type>   ::= "verity" | "linear" | ...
> 
> Example, the following could be added in the boot parameters.
> dm-mod.create="lroot,,,rw, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0" root=/dev/dm-0
> 
> Please check the patch with the documentation on the format.
> 
> The idea to make it compatible with the dmsetup concise format is to make it
> easier for users, allowing just copy & paste from the output of the command:
> 
>        dmsetup table --concise /dev/mapper/lroot
> 
> I refactored the code for this version, instead of pretending to be
> userspace and performing ioctls, the code just parse the cmd line
> argument and create the device directly, which simplified and reduced a
> lot the code (and it is much easier to read).
> 
> Also, not all dm targets are allowed. Only the ones that I tested were
> allowed and the ones that doesn't change any block device when the dm is
> create as read-only, i.e. mirror and cache are not allowed, because if
> the user makes a mistake and chose the wrong device to be the mirror or
> choose the wrong device to be the cache, it can corrupt data.
> 
> So the only targets allowed are:
> * crypt
> * delay
> * linear
> * snapshot-origin
> * striped
> * verity
> 
> I wrote a script to perform several tests using qemu that can be found at
> https://gitlab.collabora.com/koike/dm-cmdline-test
> 
> And you can see the result of the tests at:
> https://people.collabora.com/~koike/dm-test-module-param-logs.txt
> At the end of this file:
> "Total successes: 52. Total failures: 0"
> 
> And the output of qemu for each run:
> https://people.collabora.com/~koike/dm-test-module-param-logs.tar.gz
> 
> I think it would nice to integrate these tests in some CI (maybe kernel
> CI?)
> 
> Please let me know your comments.
> 
> Changes in v11:
>  - Configure the device directly instead of performing in IOCTL (this
>  removed a lot of parsing code)
>  - Just enable the targets that were tested.
>  - Simplify/refactor parsing, as a consequence, escaping characters is not
>  allowed (but it wans't properly used in the previous version anyway)
>  - don't use sscanf, the size wans't being limited and we could have a
>  buffer overflow.
>  - change constrained targets list
>  - remove code from init/
>  - use a module parameter instead of a kernel comand line parameter in
>  init/
>  - rename dm-boot to dm-init
> 
> Changes in v10:
>  - https://lore.kernel.org/patchwork/project/lkml/list/?series=371523
>  - new file: drivers/md/dm-boot.c
>  - most of the parsing code was moved from init/do_mounts_dm.c to drivers/md/dm-boot.c
>  - parsing code was in essence replaced by the concise parser from dmsetup
>  _create_concise function:
> https://sourceware.org/git/?p=lvm2.git;a=blob;f=libdm/dm-tools/dmsetup.c;h=835fdcdc75e8f0f0f7c4ed46cc9788a6616f58b8;hb=7498f8383397a93db95655ca227257836cbcac82#l1265
>  the main reason is that this code is already being used/tested by dmsetup, so
>  we can have some level of confidence that it works as expected. Besides this,
>  it also looks more efficient.
>  - Not all targets are allowed to be used by dm=, as pointed previously, there
>  are some risks in creating a mapped device without some validation from
>  userspace (see documentation from the patch listing which targets are allowed).
>  - Instead of using a simple singly linked list (for devices and tables), use
>  the struct list_head. This occupies unnecessary space in the code, but it makes
>  the code cleaner and easier to read and less prone to silly errors.
>  - Documentation and comments were reviewed and refactored, e.g.:
>         * "is to possible" was removed
>         * s/specified as a simple string/specified as a string/
>  - Added docs above __align function, make it clear that the second parameter @a
>  must be a power of two.
>  - Clean ups: removal of unnecessary includes, macros, variables, some redundant
>  checks and warnings.
>  - when calling ioctls, the code was allocating and freeing the same structure
>  a couple of times. So instead of executing kzalloc/kfree 3 times, execute
>  kmalloc once and reuse the structure after a memset, then finally kfree it once.
>  - update commit message
> 
> Changes in v9:
>  - https://www.redhat.com/archives/linux-lvm/2018-September/msg00016.html
>  - Add minor number to make it compatible with dmsetup concise format
> 
> Changes in v8:
>  - https://www.redhat.com/archives/linux-lvm/2017-May/msg00055.html
>  - Fix build error due commit
>     e516db4f67 (dm ioctl: add a new DM_DEV_ARM_POLL ioctl)
> 
> Changes in v7:
>  - http://lkml.iu.edu/hypermail/linux/kernel/1705.2/02657.html
>  - Add a new function to issue the equivalent of a DM ioctl programatically.
>  - Use the new ioctl interface to create the devices.
>  - Use a comma-delimited and semi-colon delimited dmsetup-like commands.
> 
> Changes in v6:
>  - https://www.redhat.com/archives/dm-devel/2017-April/msg00316.html
> 
> Changes in v5:
>  - https://www.redhat.com/archives/dm-devel/2016-February/msg00112.html
> 
>  Documentation/device-mapper/dm-init.txt | 114 +++++++++
>  drivers/md/Kconfig                      |  10 +
>  drivers/md/Makefile                     |   4 +
>  drivers/md/dm-init.c                    | 308 ++++++++++++++++++++++++
>  drivers/md/dm-ioctl.c                   | 103 ++++++++
>  include/linux/device-mapper.h           |   9 +
>  6 files changed, 548 insertions(+)
>  create mode 100644 Documentation/device-mapper/dm-init.txt
>  create mode 100644 drivers/md/dm-init.c
> 
> diff --git a/Documentation/device-mapper/dm-init.txt b/Documentation/device-mapper/dm-init.txt
> new file mode 100644
> index 000000000000..8464ee7c01b8
> --- /dev/null
> +++ b/Documentation/device-mapper/dm-init.txt
> @@ -0,0 +1,114 @@
> +Early creation of mapped devices
> +====================================
> +
> +It is possible to configure a device-mapper device to act as the root device for
> +your system in two ways.
> +
> +The first is to build an initial ramdisk which boots to a minimal userspace
> +which configures the device, then pivot_root(8) in to it.
> +
> +The second is to create one or more device-mappers using the module parameter
> +"dm-mod.create=" through the kernel boot command line argument.
> +
> +The format is specified as a string of data separated by commas and optionally
> +semi-colons, where:
> + - a comma is used to separate fields like name, uuid, flags and table
> +   (specifies one device)
> + - a semi-colon is used to separate devices.
> +
> +So the format will look like this:
> +
> + dm-mod.create=<name>,<uuid>,<minor>,<flags>,<table>[,<table>+][;<name>,<uuid>,<minor>,<flags>,<table>[,<table>+]+]
> +
> +Where,
> +	<name>		::= The device name.
> +	<uuid>		::= xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | ""
> +	<minor>		::= The device minor number | ""
> +	<flags>		::= "ro" | "rw"
> +	<table>		::= <start_sector> <num_sectors> <target_type> <target_args>
> +	<target_type>	::= "verity" | "linear" | ... (see list below)
> +
> +The dm line should be equivalent to the one used by the dmsetup tool with the
> +--concise argument.
> +
> +Target types
> +============
> +
> +Not all target types are available as there are serious risks in allowing
> +activation of certain DM targets without first using userspace tools to check
> +the validity of associated metadata.
> +
> +	"cache":		constrained, userspace should verify cache device
> +	"crypt":		allowed
> +	"delay":		allowed
> +	"era":			constrained, userspace should verify metadata device
> +	"flakey":		constrained, meant for test
> +	"linear":		allowed
> +	"log-writes":		constrained, userspace should verify metadata device
> +	"mirror":		constrained, userspace should verify main/mirror device
> +	"raid":			constrained, userspace should verify metadata device
> +	"snapshot":		constrained, userspace should verify src/dst device
> +	"snapshot-origin":	allowed
> +	"snapshot-merge":	constrained, userspace should verify src/dst device
> +	"striped":		allowed
> +	"switch":		constrained, userspace should verify dev path
> +	"thin":			constrained, requires dm target message from userspace
> +	"thin-pool":		constrained, requires dm target message from userspace
> +	"verity":		allowed
> +	"writecache":		constrained, userspace should verify cache device
> +	"zero":			constrained, not meant for rootfs
> +
> +If the target is not listed above, it is constrained by default (not tested).
> +
> +Examples
> +========
> +An example of booting to a linear array made up of user-mode linux block
> +devices:
> +
> +  dm-mod.create="lroot,,,rw, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0" root=/dev/dm-0
> +
> +This will boot to a rw dm-linear target of 8192 sectors split across two block
> +devices identified by their major:minor numbers.  After boot, udev will rename
> +this target to /dev/mapper/lroot (depending on the rules). No uuid was assigned.
> +
> +An example of multiple device-mappers, with the dm-mod.create="..." contents is shown here
> +split on multiple lines for readability:
> +
> +  vroot,,,ro,
> +    0 1740800 verity 254:0 254:0 1740800 sha1
> +      76e9be054b15884a9fa85973e9cb274c93afadb6
> +      5b3549d54d6c7a3837b9b81ed72e49463a64c03680c47835bef94d768e5646fe;
> +  vram,,,rw,
> +    0 32768 linear 1:0 0,
> +    32768 32768 linear 1:1 0
> +
> +Other examples (per target):
> +
> +"crypt":
> +  dm-crypt,,8,ro,
> +    0 1048576 crypt aes-xts-plain64
> +    babebabebabebabebabebabebabebabebabebabebabebabebabebabebabebabe 0
> +    /dev/sda 0 1 allow_discards
> +
> +"delay":
> +  dm-delay,,4,ro,0 409600 delay /dev/sda1 0 500
> +
> +"linear":
> +  dm-linear,,,rw,
> +    0 32768 linear /dev/sda1 0,
> +    32768 1024000 linear /dev/sda2 0,
> +    1056768 204800 linear /dev/sda3 0,
> +    1261568 512000 linear /dev/sda4 0
> +
> +"snapshot-origin":
> +  dm-snap-orig,,4,ro,0 409600 snapshot-origin 8:2
> +
> +"striped":
> +  dm-striped,,4,ro,0 1638400 striped 4 4096
> +  /dev/sda1 0 /dev/sda2 0 /dev/sda3 0 /dev/sda4 0
> +
> +"verity":
> +  dm-verity,,4,ro,
> +    0 1638400 verity 1 8:1 8:2 4096 4096 204800 1 sha256
> +    fb1a5a0f00deb908d8b53cb270858975e76cf64105d412ce764225d53b8f3cfd
> +    51934789604d1b92399c52e7cb149d1b3a1b74bbbcb103b2a0aaacbed5c08584
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 3db222509e44..644e868cc2eb 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -436,6 +436,16 @@ config DM_DELAY
>  
>  	If unsure, say N.
>  
> +config DM_INIT
> +	bool "DM \"dm-mod.create=\" parameter support"
> +	depends on BLK_DEV_DM=y
> +	---help---
> +	Enable "dm-mod.create=" parameter to create mapped devices at init time.
> +	This option is useful to allow mounting rootfs without requiring an
> +	initramfs.
> +	See Documentation/device-mapper/dm-init.txt for dm-mod.create="..."
> +	format
> +
>  config DM_UEVENT
>  	bool "DM uevents"
>  	depends on BLK_DEV_DM
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index 822f4e8753bc..a52b703e588e 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -69,6 +69,10 @@ obj-$(CONFIG_DM_INTEGRITY)	+= dm-integrity.o
>  obj-$(CONFIG_DM_ZONED)		+= dm-zoned.o
>  obj-$(CONFIG_DM_WRITECACHE)	+= dm-writecache.o
>  
> +ifeq ($(CONFIG_DM_INIT),y)
> +dm-mod-objs			+= dm-init.o
> +endif
> +
>  ifeq ($(CONFIG_DM_UEVENT),y)
>  dm-mod-objs			+= dm-uevent.o
>  endif
> diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
> new file mode 100644
> index 000000000000..24ea75911c7c
> --- /dev/null
> +++ b/drivers/md/dm-init.c
> @@ -0,0 +1,308 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * dm-init.c
> + * Copyright (C) 2017 The Chromium OS Authors <chromium-os-dev@chromium.org>
> + *
> + * This file is released under the GPLv2.
> + */
> +
> +#include <linux/ctype.h>
> +#include <linux/device.h>
> +#include <linux/device-mapper.h>
> +#include <linux/init.h>
> +#include <linux/list.h>
> +#include <linux/moduleparam.h>
> +
> +#define DM_MSG_PREFIX "dm"
> +#define DM_MAX_DEVICES 256
> +#define DM_MAX_TARGETS 256
> +#define DM_MAX_STR_SIZE 4096
> +
> +static char *create;
> +
> +/*
> + * Format: dm-mod.create=<name>,<uuid>,<minor>,<flags>,<table>[,<table>+][;<name>,<uuid>,<minor>,<flags>,<table>[,<table>+]+]
> + * Table format: <start_sector> <num_sectors> <target_type> <target_args>
> + *
> + * See Documentation/device-mapper/dm-init.txt for dm-mod.create="..." format
> + * details.
> + */
> +
> +struct dm_device {
> +	struct dm_ioctl dmi;
> +	struct dm_target_spec *table[DM_MAX_TARGETS];
> +	char *target_args_array[DM_MAX_TARGETS];
> +	struct list_head list;
> +};
> +
> +const char *dm_allowed_targets[] __initconst = {
> +	"crypt",
> +	"delay",
> +	"linear",
> +	"snapshot-origin",
> +	"striped",
> +	"verity",
> +};
> +
> +static int __init dm_verify_target_type(const char *target)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(dm_allowed_targets); i++) {
> +		if (!strcmp(dm_allowed_targets[i], target))
> +			return 0;
> +	}
> +	return -EINVAL;
> +}
> +
> +static void __init dm_setup_cleanup(struct list_head *devices)
> +{
> +	struct dm_device *dev, *tmp;
> +	unsigned int i;
> +
> +	list_for_each_entry_safe(dev, tmp, devices, list) {
> +		list_del(&dev->list);
> +		for (i = 0; i < dev->dmi.target_count; i++) {
> +			kfree(dev->table[i]);
> +			kfree(dev->target_args_array[i]);
> +		}
> +		kfree(dev);
> +	}
> +}
> +
> +/**
> + * str_field_delimit - delimit a string based on a separator char.
> + * @str: the pointer to the string to delimit.
> + * @separator: char that delimits the field
> + *
> + * Find a @separator and replace it by '\0'.
> + * Remove leading and trailing spaces.
> + * Return the remainder string after the @separator.
> + */
> +static char __init *str_field_delimit(char **str, char separator)
> +{
> +	char *s;
> +
> +	/* TODO: add support for escaped characters */
> +	*str = skip_spaces(*str);
> +	s = strchr(*str, separator);
> +	/* Delimit the field and remove trailing spaces */
> +	if (s)
> +		*s = '\0';
> +	*str = strim(*str);
> +	return s ? ++s : NULL;
> +}
> +
> +/**
> + * dm_parse_table_entry - parse a table entry
> + * @dev: device to store the parsed information.
> + * @str: the pointer to a string with the format:
> + *	<start_sector> <num_sectors> <target_type> <target_args>[, ...]
> + *
> + * Return the remainder string after the table entry, i.e, after the comma which
> + * delimits the entry or NULL if reached the end of the string.
> + */
> +static char __init *dm_parse_table_entry(struct dm_device *dev, char *str)
> +{
> +	const unsigned int n = dev->dmi.target_count - 1;
> +	struct dm_target_spec *sp;
> +	unsigned int i;
> +	/* fields:  */
> +	char *field[4];
> +	char *next;
> +
> +	field[0] = str;
> +	/* Delimit first 3 fields that are separated by space */
> +	for (i = 0; i < ARRAY_SIZE(field) - 1; i++) {
> +		field[i + 1] = str_field_delimit(&field[i], ' ');
> +		if (!field[i + 1])
> +			return ERR_PTR(-EINVAL);
> +	}
> +	/* Delimit last field that can be terminated by comma */
> +	next = str_field_delimit(&field[i], ',');
> +
> +	sp = kzalloc(sizeof(*sp), GFP_KERNEL);
> +	if (!sp)
> +		return ERR_PTR(-ENOMEM);
> +	dev->table[n] = sp;
> +
> +	/* start_sector */
> +	if (kstrtoull(field[0], 0, &sp->sector_start))
> +		return ERR_PTR(-EINVAL);
> +	/* num_sector */
> +	if (kstrtoull(field[1], 0, &sp->length))
> +		return ERR_PTR(-EINVAL);
> +	/* target_type */
> +	strscpy(sp->target_type, field[2], sizeof(sp->target_type));
> +	if (dm_verify_target_type(sp->target_type)) {
> +		DMERR("invalid type \"%s\"", sp->target_type);
> +		return ERR_PTR(-EINVAL);
> +	}
> +	/* target_args */
> +	dev->target_args_array[n] = kstrndup(field[3], GFP_KERNEL,
> +					     DM_MAX_STR_SIZE);
> +	if (!dev->target_args_array[n])
> +		return ERR_PTR(-ENOMEM);
> +
> +	return next;
> +}
> +
> +/**
> + * dm_parse_table - parse "dm-mod.create=" table field
> + * @dev: device to store the parsed information.
> + * @str: the pointer to a string with the format:
> + *	<table>[,<table>+]
> + */
> +static int __init dm_parse_table(struct dm_device *dev, char *str)
> +{
> +	char *table_entry = str;
> +
> +	while (table_entry) {
> +		DMDEBUG("parsing table \"%s\"", str);
> +		if (++dev->dmi.target_count >= DM_MAX_TARGETS) {
> +			DMERR("too many targets %u > %d",
> +			      dev->dmi.target_count, DM_MAX_TARGETS);
> +			return -EINVAL;
> +		}
> +		table_entry = dm_parse_table_entry(dev, table_entry);
> +		if (IS_ERR(table_entry)) {
> +			DMERR("couldn't parse table");
> +			return PTR_ERR(table_entry);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * dm_parse_device_entry - parse a device entry
> + * @dev: device to store the parsed information.
> + * @str: the pointer to a string with the format:
> + *	name,uuid,minor,flags,table[; ...]
> + *
> + * Return the remainder string after the table entry, i.e, after the semi-colon
> + * which delimits the entry or NULL if reached the end of the string.
> + */
> +static char __init *dm_parse_device_entry(struct dm_device *dev, char *str)
> +{
> +	/* There are 5 fields: name,uuid,minor,flags,table; */
> +	char *field[5];
> +	unsigned int i;
> +	char *next;
> +
> +	field[0] = str;
> +	/* Delimit first 4 fields that are separated by comma */
> +	for (i = 0; i < ARRAY_SIZE(field) - 1; i++) {
> +		field[i+1] = str_field_delimit(&field[i], ',');
> +		if (!field[i+1])
> +			return ERR_PTR(-EINVAL);
> +	}
> +	/* Delimit last field that can be delimited by semi-colon */
> +	next = str_field_delimit(&field[i], ';');
> +
> +	/* name */
> +	strscpy(dev->dmi.name, field[0], sizeof(dev->dmi.name));
> +	/* uuid */
> +	strscpy(dev->dmi.uuid, field[1], sizeof(dev->dmi.uuid));
> +	/* minor */
> +	if (strlen(field[2])) {
> +		if (kstrtoull(field[2], 0, &dev->dmi.dev))
> +			return ERR_PTR(-EINVAL);
> +		dev->dmi.flags |= DM_PERSISTENT_DEV_FLAG;
> +	}
> +	/* flags */
> +	if (!strcmp(field[3], "ro"))
> +		dev->dmi.flags |= DM_READONLY_FLAG;
> +	else if (strcmp(field[3], "rw"))
> +		return ERR_PTR(-EINVAL);
> +	/* table */
> +	if (dm_parse_table(dev, field[4]))
> +		return ERR_PTR(-EINVAL);
> +
> +	return next;
> +}
> +
> +/**
> + * dm_parse_devices - parse "dm-mod.create=" argument
> + * @devices: list of struct dm_device to store the parsed information.
> + * @str: the pointer to a string with the format:
> + *	<device>[;<device>+]
> + */
> +static int __init dm_parse_devices(struct list_head *devices, char *str)
> +{
> +	unsigned long ndev = 0;
> +	struct dm_device *dev;
> +	char *device = str;
> +
> +	DMDEBUG("parsing \"%s\"", str);
> +	while (device) {
> +		dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +		if (!dev)
> +			return -ENOMEM;
> +		list_add_tail(&dev->list, devices);
> +
> +		if (++ndev >= DM_MAX_DEVICES) {
> +			DMERR("too many targets %u > %d",
> +			      dev->dmi.target_count, DM_MAX_TARGETS);
> +			return -EINVAL;
> +		}
> +
> +		device = dm_parse_device_entry(dev, device);
> +		if (IS_ERR(device)) {
> +			DMERR("couldn't parse device");
> +			return PTR_ERR(device);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * dm_init_init - parse "dm-mod.create=" argument and configure drivers
> + */
> +static int __init dm_init_init(void)
> +{
> +	struct dm_device *dev;
> +	LIST_HEAD(devices);
> +	char *str;
> +	int r;
> +
> +	if (!create)
> +		return 0;
> +
> +	if (strlen(create) >= DM_MAX_STR_SIZE) {
> +		DMERR("Argument is too big. Limit is %d\n", DM_MAX_STR_SIZE);
> +		return -EINVAL;
> +	}
> +	str = kstrndup(create, GFP_KERNEL, DM_MAX_STR_SIZE);
> +	if (!str)
> +		return -ENOMEM;
> +
> +	r = dm_parse_devices(&devices, str);
> +	if (r)
> +		goto out;
> +
> +	DMINFO("waiting for all devices to be available before creating mapped devices\n");
> +	wait_for_device_probe();
> +
> +	list_for_each_entry(dev, &devices, list) {
> +		if (dm_early_create(&dev->dmi, dev->table,
> +				    dev->target_args_array))
> +			break;
> +	}
> +out:
> +	kfree(str);
> +	dm_setup_cleanup(&devices);
> +	return r;
> +}
> +
> +late_initcall(dm_init_init);
> +
> +module_param(create, charp, 0);
> +MODULE_PARM_DESC(create, "Create a mapped device when the module is loaded using this argument\n"
> +			 "This is mostly useful in early boot to allow mounting rootfs without requiring an initramfs\n"
> +			 "Format: <name>,<uuid>,<minor>,<flags>,<table>[,<table>+][;<name>,<uuid>,<minor>,<flags>,<table>[,<table>+]+]\n"
> +			 "Table format: <start_sector> <num_sectors> <target_type> <target_args>\n"
> +			 "Examples:\n"
> +			 "dm-mod.create=\"lroot,,,rw, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0\"\n");
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index f666778ad237..c740153b4e52 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -2018,3 +2018,106 @@ int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid)
>  
>  	return r;
>  }
> +
> +
> +/**
> + * dm_early_create - create a mapped device in early boot.
> + *
> + * @dmi: Contains main information of the device mapping to be created.
> + * @spec_array: array of pointers to struct dm_target_spec. Describes the
> + * mapping table of the device.
> + * @target_params_array: array of strings with the parameters to a specific
> + * target.
> + *
> + * Instead of having the struct dm_target_spec and the parameters for every
> + * target embedded at the end of struct dm_ioctl (as performed in a normal
> + * ioctl), pass them as arguments, so the caller doesn't need to serialize them.
> + * The size of the spec_array and target_params_array is given by
> + * @dmi->target_count.
> + * This function is supposed to be called in early boot, so locking mechanisms
> + * to protect against concurrent loads are not required.
> + */
> +int __init dm_early_create(struct dm_ioctl *dmi,
> +			   struct dm_target_spec **spec_array,
> +			   char **target_params_array)
> +{
> +	int r, m = DM_ANY_MINOR;
> +	struct dm_table *t, *old_map;
> +	struct mapped_device *md;
> +	unsigned int i;
> +
> +	if (!dmi->target_count)
> +		return -EINVAL;
> +
> +	r = check_name(dmi->name);
> +	if (r)
> +		return r;
> +
> +	if (dmi->flags & DM_PERSISTENT_DEV_FLAG)
> +		m = MINOR(huge_decode_dev(dmi->dev));
> +
> +	/* alloc dm device */
> +	r = dm_create(m, &md);
> +	if (r)
> +		return r;
> +
> +	/* hash insert */
> +	r = dm_hash_insert(dmi->name, *dmi->uuid ? dmi->uuid : NULL, md);
> +	if (r)
> +		goto err_destroy_dm;
> +
> +	/* alloc table */
> +	r = dm_table_create(&t, get_mode(dmi), dmi->target_count, md);
> +	if (r)
> +		goto err_destroy_dm;
> +
> +	/* add targets */
> +	for (i = 0; i < dmi->target_count; i++) {
> +		r = dm_table_add_target(t, spec_array[i]->target_type,
> +					(sector_t) spec_array[i]->sector_start,
> +					(sector_t) spec_array[i]->length,
> +					target_params_array[i]);
> +		if (r) {
> +			DMWARN("error adding target to table");
> +			goto err_destroy_table;
> +		}
> +	}
> +
> +	/* finish table */
> +	r = dm_table_complete(t);
> +	if (r)
> +		goto err_destroy_table;
> +
> +	md->type = dm_table_get_type(t);
> +	/* setup md->queue to reflect md's type (may block) */
> +	r = dm_setup_md_queue(md, t);
> +	if (r) {
> +		DMWARN("unable to set up device queue for new table.");
> +		goto err_destroy_table;
> +	}
> +
> +	/* Set new map */
> +	dm_suspend(md, 0);
> +	old_map = dm_swap_table(md, t);
> +	if (IS_ERR(old_map)) {
> +		r = PTR_ERR(old_map);
> +		goto err_destroy_table;
> +	}
> +	set_disk_ro(dm_disk(md), !!(dmi->flags & DM_READONLY_FLAG));
> +
> +	/* resume device */
> +	r = dm_resume(md);
> +	if (r)
> +		goto err_destroy_table;
> +
> +	DMINFO("%s (%s) is ready", md->disk->disk_name, dmi->name);
> +	dm_put(md);
> +	return 0;
> +
> +err_destroy_table:
> +	dm_table_destroy(t);
> +err_destroy_dm:
> +	dm_put(md);
> +	dm_destroy(md);
> +	return r;
> +}
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index e528baebad69..8fa618381e78 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -10,6 +10,7 @@
>  
>  #include <linux/bio.h>
>  #include <linux/blkdev.h>
> +#include <linux/dm-ioctl.h>
>  #include <linux/math64.h>
>  #include <linux/ratelimit.h>
>  
> @@ -431,6 +432,14 @@ void dm_remap_zone_report(struct dm_target *ti, sector_t start,
>  			  struct blk_zone *zones, unsigned int *nr_zones);
>  union map_info *dm_get_rq_mapinfo(struct request *rq);
>  
> +/*
> + * Device mapper functions to parse and create devices specified by the
> + * parameter "dm-mod.create="
> + */
> +int __init dm_early_create(struct dm_ioctl *dmi,
> +			   struct dm_target_spec **spec_array,
> +			   char **target_params_array);
> +
>  struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
>  
>  /*
> -- 
> 2.20.1
> 
