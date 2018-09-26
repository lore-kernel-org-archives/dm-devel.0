From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 2/2] init: add support to directly boot to a mapped device
Date: Wed, 26 Sep 2018 09:09:45 -0700
Message-ID: <c0da1483-4d82-0e13-d03b-9ee8ea6a9d84@infradead.org>
References: <cover.1537936397.git.helen.koike@collabora.com>
 <2c01b2a43a46fab760208d7af3a7af37eec8c41a.1537936397.git.helen.koike@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2c01b2a43a46fab760208d7af3a7af37eec8c41a.1537936397.git.helen.koike@collabora.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Helen Koike <helen.koike@collabora.com>, dm-devel@redhat.com
Cc: agk@redhat.com, snitzer@redhat.com, linux-kernel@vger.kernel.org, enric.balletbo@collabora.com, wad@chromium.org, linux-doc@vger.kernel.org, linux-lvm@redhat.com, kernel@collabora.com
List-Id: dm-devel.ids

On 9/25/18 10:00 PM, Helen Koike wrote:
> From: Will Drewry <wad@chromium.org>
> 
> Add a dm= kernel parameter modeled after the md= parameter from
> do_mounts_md. It allows for device-mapper targets to be configured at
> boot time for use early in the boot process (as the root device or
> otherwise).
> 
> Signed-off-by: Will Drewry <wad@chromium.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> [rework to use dm_ioctl calls]
> Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> [rework to use concise format | rework for upstream]
> Signed-off-by: Helen Koike <helen.koike@collabora.com>

Hi,

A few small comments inline...

> ---
>  .../admin-guide/kernel-parameters.rst         |   1 +
>  .../admin-guide/kernel-parameters.txt         |   3 +
>  Documentation/device-mapper/dm-boot.txt       |  63 +++
>  init/Makefile                                 |   1 +
>  init/do_mounts.c                              |   1 +
>  init/do_mounts.h                              |  10 +
>  init/do_mounts_dm.c                           | 475 ++++++++++++++++++
>  7 files changed, 554 insertions(+)
>  create mode 100644 Documentation/device-mapper/dm-boot.txt
>  create mode 100644 init/do_mounts_dm.c

> diff --git a/Documentation/device-mapper/dm-boot.txt b/Documentation/device-mapper/dm-boot.txt
> new file mode 100644
> index 000000000000..f598f102c980
> --- /dev/null
> +++ b/Documentation/device-mapper/dm-boot.txt
> @@ -0,0 +1,63 @@
> +Boot time creation of mapped devices
> +====================================
> +
> +It is possible to configure a device mapper device to act as the root
> +device for your system in two ways.
> +
> +The first is to build an initial ramdisk which boots to a minimal
> +userspace which configures the device, then pivot_root(8) in to it.
> +
> +The second is to possible when the device-mapper and any targets are

parse error:  ^^^^^^^^^^^^^^

> +compiled into the kernel (not a module), one or more device-mappers may
> +be created and used as the root device at boot time with the parameters
> +given with the boot line dm=...
> +
> +The format is specified as a simple string of data separated by commas and

for some definition of "simple".

> +optionally semi-colons, where:
> + - a comma is used to separate fields like name, uuid, flags and table (specifies
> +   one device)
> + - a semi-colon is used to separate devices.
> +
> +So the format will look like this:
> +
> + dm=<name>,<uuid>,<minor>,<flags>,<table>[,<table>+][;<dev_name>,<uuid>,<minor>,<flags>,<table>[,<table>+]]
> +
> +Where,
> +	<dev_name>	::= The device name.
> +	<uuid>		::= xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | ""
> +	<minor>		::= The device minor number.
> +	<flags>		::= "ro" | "rw"
> +	<table>		::= <start> <length> <type> <options>
> +	<type>		::= "verity" | "bootcache" | ...
> +
> +The dm line may be as normal when using the dmsetup tool when using the
> +--concise argument.
> +
> +Examples
> +========
> +An example of booting to a linear array made up of user-mode linux block
> +devices:
> +
> +  dm="lroot,,,rw, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0" \
> +  root=/dev/dm-0
> +
> +This will boot to a rw dm-linear target of 8192 sectors split across two
> +block devices identified by their major:minor numbers.  After boot, udev
> +will rename this target to /dev/mapper/lroot (depending on the rules).
> +No uuid was assigned.
> +
> +An example of multiple device-mappers, with the dm="..." contents shown
> +here split on multiple lines for readability:
> +
> +    vboot,,ro,
> +      0 1768000 bootcache
> +        aa55b119-2a47-8c45-946a-5ac57765011f+1
> +        76e9be054b15884a9fa85973e9cb274c93afadb6
> +        1768000 100000 23 20000;
> +    vroot,,ro,
> +      0 1740800 verity 254:0 254:0 1740800 sha1
> +        76e9be054b15884a9fa85973e9cb274c93afadb6
> +        5b3549d54d6c7a3837b9b81ed72e49463a64c03680c47835bef94d768e5646fe;
> +    vram,,rw,
> +      0 32768 linear 1:0 0,
> +      32768 32768 linear 1:1 0

> diff --git a/init/do_mounts_dm.c b/init/do_mounts_dm.c
> new file mode 100644
> index 000000000000..507ae31808ef
> --- /dev/null
> +++ b/init/do_mounts_dm.c
> @@ -0,0 +1,475 @@
> +// SPDX-License-Identifier: <SPDX License Expression>
> +
> +/*
> + * do_mounts_dm.c
> + * Copyright (C) 2017 The Chromium OS Authors <chromium-os-dev@chromium.org>
> + * Based on do_mounts_md.c
> + *
> + * This file is released under the GPLv2.
> + */
> +#include <linux/async.h>
> +#include <linux/ctype.h>
> +#include <linux/device-mapper.h>
> +#include <linux/fs.h>
> +#include <linux/string.h>
> +#include <linux/delay.h>
> +
> +#include "do_mounts.h"
> +
> +#define DM_MAX_DEVICES 256
> +#define DM_MAX_NAME 32
> +#define DM_MAX_UUID 129
> +
> +#define DM_MSG_PREFIX "init"
> +
> +#define is_even(a) (((a) & 1) == 0)
> +
> +/* See Documentation/device-mapper/dm-boot.txt for dm="..." format details. */
> +
> +struct target {
> +	sector_t start;
> +	sector_t length;
> +	char *type;
> +	char *params;
> +	/* simple singly linked list */
> +	struct target *next;
> +};
> +
> +struct dm_device {
> +	int minor;
> +	int ro;
> +	char name[DM_MAX_NAME];
> +	char uuid[DM_MAX_UUID];
> +	struct target *table;
> +	int table_count;
> +	/* simple singly linked list */
> +	struct dm_device *next;
> +};
> +
> +static struct {
> +	unsigned long num_devices;
> +	char *str;
> +} dm_setup_args __initdata;
> +
> +static int dm_early_setup __initdata;
> +

// @a: must be a power of 2

> +static void __init *_align(void *ptr, unsigned int a)
> +{
> +	register unsigned long agn = --a;
> +
> +	return (void *) (((unsigned long) ptr + agn) & ~agn);
> +}


thanks.
-- 
~Randy
