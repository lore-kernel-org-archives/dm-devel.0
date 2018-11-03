From: Helen Koike <helen.koike@collabora.com>
Subject: [PATCH v10 0/2] dm: boot a mapped device without an initramfs
Date: Sat,  3 Nov 2018 00:53:39 -0300
Message-ID: <20181103035341.16893-1-helen.koike@collabora.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: agk@redhat.com, snitzer@redhat.com, linux-kernel@vger.kernel.org, enric.balletbo@collabora.com, wad@chromium.org, linux-doc@vger.kernel.org, linux-lvm@redhat.com, kernel@collabora.com, richard.weinberger@gmail.com, keescook@chromium.org
List-Id: dm-devel.ids

As mentioned in the discussion from the previous version of this patch, Android
and Chrome OS do not use initramfs mostly due to boot time and size liability.
A practical example as mentioned by Kees is that Chrome OS has a limited amount
of storage available for the boot image as it is covered by the static root of
trust signature.

So instead of bringing up userspace to perform the required configuration for
mapped devices, this patchset allows them to be configured in the kernel command
line parameter for use early in the boot process, allowing booting from a mapped
device without an initramfs.

The syntax used in the boot param is based on the concise format from the dmsetup
tool as described in its man page http://man7.org/linux/man-pages/man8/dmsetup.8.html#CONCISE_FORMAT

Which is:
	dm=<name>,<uuid>,<minor>,<flags>,<table>[,<table>+][;<name>,<uuid>,<minor>,<flags>,<table>[,<table>+]+]

Where,
	<name>		::= The device name.
	<uuid>		::= xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | ""
	<minor>		::= The device minor number | ""
	<flags>		::= "ro" | "rw"
	<table>		::= <start_sector> <num_sectors> <target_type> <target_args>
	<target_type>	::= "verity" | "linear" | ...

Example, the following could be added in the boot parameters.
dm="lroot,,,rw, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0" root=/dev/dm-0

Please check patch 2/2 with the documentation on the format.

The idea to make it compatible with the dmsetup concise format is to make it
easier for users, allowing just copy & paste from the output of the command:

	sudo dmsetup table --concise /dev/mapper/lroot

The implementation consists basically in parsing the command line argument and
performing the ioctls that would be performed by userspace otherwise,
i.e. DM_DEV_CREATE, followed by DM_TABLE_LOAD then DM_DEV_SUSPEND.

Instead of performing the ioctls, we could by-pass it, calling the corresponding
functions directly, but the ioctls calls perform some checks and also the
implementation stays less invasive. Please let me know if you would prefer a
directly call instead of going thought the ioctls.

Changes since v9:
 - https://www.redhat.com/archives/linux-lvm/2018-September/msg00016.html
 - new file: drivers/md/dm-boot.c
 - most of the parsing code was moved from init/do_mounts_dm.c to drivers/md/dm-boot.c
 - parsing code was in essence replaced by the concise parser from dmsetup
 _create_concise function:
https://sourceware.org/git/?p=lvm2.git;a=blob;f=libdm/dm-tools/dmsetup.c;h=835fdcdc75e8f0f0f7c4ed46cc9788a6616f58b8;hb=7498f8383397a93db95655ca227257836cbcac82#l1265
 the main reason is that this code is already being used/tested by dmsetup, so
 we can have some level of confidence that it works as expected. Besides this,
 it also looks more efficient.
 - Not all targets are allowed to be used by dm=, as pointed previously, there
 are some risks in creating a mapped device without some validation from
 userspace (see documentation from the patch listing which targets are allowed).
 - Instead of using a simple singly linked list (for devices and tables), use
 the struct list_head. This occupies unnecessary space in the code, but it makes
 the code cleaner and easier to read and less prone to silly errors.
 - Documentation and comments were reviewed and refactored, e.g.:
	* "is to possible" was removed
	* s/specified as a simple string/specified as a string/
 - Added docs above __align function, make it clear that the second parameter @a
 must be a power of two.
 - Clean ups: removal of unnecessary includes, macros, variables, some redundant
 checks and warnings.
 - when calling ioctls, the code was allocating and freeing the same structure
 a couple of times. So instead of executing kzalloc/kfree 3 times, execute
 kmalloc once and reuse the structure after a memset, then finally kfree it once.
 - update commit message

Changes since v8:
 - https://www.redhat.com/archives/linux-lvm/2017-May/msg00055.html
 - Add minor number to make it compatible with dmsetup concise format

Changes since v7:
 - http://lkml.iu.edu/hypermail/linux/kernel/1705.2/02657.html
 - Fix build error due commit
    e516db4f67 (dm ioctl: add a new DM_DEV_ARM_POLL ioctl)

Changes since v6:
 - https://www.redhat.com/archives/dm-devel/2017-April/msg00316.html
 - Add a new function to issue the equivalent of a DM ioctl programatically.
 - Use the new ioctl interface to create the devices.
 - Use a comma-delimited and semi-colon delimited dmsetup-like commands.

Changes since v5:
 - https://www.redhat.com/archives/dm-devel/2016-February/msg00112.html

Enric Balletbo i Serra (1):
  dm ioctl: add a device mapper ioctl function.

Will Drewry (1):
  init: add support to directly boot to a mapped device

 .../admin-guide/kernel-parameters.rst         |   1 +
 .../admin-guide/kernel-parameters.txt         |   3 +
 Documentation/device-mapper/dm-boot.txt       |  87 ++++
 drivers/md/Makefile                           |   2 +-
 drivers/md/dm-boot.c                          | 433 ++++++++++++++++++
 drivers/md/dm-ioctl.c                         |  49 ++
 include/linux/device-mapper.h                 |  12 +
 init/Makefile                                 |   1 +
 init/do_mounts.c                              |   1 +
 init/do_mounts.h                              |  10 +
 init/do_mounts_dm.c                           |  46 ++
 11 files changed, 644 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/device-mapper/dm-boot.txt
 create mode 100644 drivers/md/dm-boot.c
 create mode 100644 init/do_mounts_dm.c

-- 
2.19.1
