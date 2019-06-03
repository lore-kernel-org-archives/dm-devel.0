From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH v12] dm: add support to directly boot to a mapped device
Date: Mon, 03 Jun 2019 16:02:59 -0700
Message-ID: <5cf5a724.1c69fb81.1e8f0.08fb@mx.google.com>
References: <20190221203334.24504-1-helen.koike@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190221203334.24504-1-helen.koike@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Helen Koike <helen.koike@collabora.com>, dm-devel@redhat.com
Cc: wad@chromium.org, keescook@chromium.org, snitzer@redhat.com, linux-doc@vger.kernel.org, richard.weinberger@gmail.com, linux-kernel@vger.kernel.org, linux-lvm@redhat.com, enric.balletbo@collabora.com, kernel@collabora.com, agk@redhat.com
List-Id: dm-devel.ids

Quoting Helen Koike (2019-02-21 12:33:34)
> Add a "create" module parameter, which allows device-mapper targets to be
> configured at boot time. This enables early use of dm targets in the boot
> process (as the root device or otherwise) without the need of an initramf=
s.
>=20
> The syntax used in the boot param is based on the concise format from the
> dmsetup tool to follow the rule of least surprise:
>=20
>         sudo dmsetup table --concise /dev/mapper/lroot
>=20
> Which is:
>         dm-mod.create=3D<name>,<uuid>,<minor>,<flags>,<table>[,<table>+][=
;<name>,<uuid>,<minor>,<flags>,<table>[,<table>+]+]
>=20
> Where,
>         <name>          ::=3D The device name.
>         <uuid>          ::=3D xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | ""
>         <minor>         ::=3D The device minor number | ""
>         <flags>         ::=3D "ro" | "rw"
>         <table>         ::=3D <start_sector> <num_sectors> <target_type> =
<target_args>
>         <target_type>   ::=3D "verity" | "linear" | ...
>=20
> For example, the following could be added in the boot parameters:
> dm-mod.create=3D"lroot,,,rw, 0 4096 linear 98:16 0, 4096 4096 linear 98:3=
2 0" root=3D/dev/dm-0
>=20
> Only the targets that were tested are allowed and the ones that doesn't
> change any block device when the dm is create as read-only. For example,
> mirror and cache targets are not allowed. The rationale behind this is
> that if the user makes a mistake, choosing the wrong device to be the
> mirror or the cache can corrupt data.
>=20
> The only targets allowed are:
> * crypt
> * delay
> * linear
> * snapshot-origin
> * striped
> * verity
>=20
> Co-developed-by: Will Drewry <wad@chromium.org>
> Co-developed-by: Kees Cook <keescook@chromium.org>
> Co-developed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
>=20
> ---
>=20

I'm trying to boot a mainline linux kernel on a chromeos device with dm
verity and a USB stick but it's not working for me even with this patch.
I've had to hack around two problems:

 1) rootwait isn't considered

 2) verity doesn't seem to accept UUID for <hash_dev> or <dev>

For the first problem, it happens every boot for me because I'm trying
to boot off of a USB stick and it's behind a hub that takes a few
seconds to enumerate. If I hack up the code to call dm_init_init() after
the 'rootdelay' cmdline parameter is used then I can make this work. It
would be much nicer if the whole mechanism didn't use a late initcall
though. If it used a hook from prepare_namespace() and then looped
waiting for devices to create when rootwait was specified it would work.

The second problem is that in chromeos we have the bootloader fill out
the UUID of the kernel partition (%U) and then we have another parameter
that indicates the offset from that kernel partition to add to the
kernel partition (typically 1, i.e. PARTNROFF=3D1) to find the root
filesystem partition. The way verity seems to work here is that we need
to specify a path like /dev/sda3 or the major:minor number of the device
on the commandline to make this work. It would be better if we could add
in support for the PARTNROFF style that name_to_dev_t() handles so we
can specify the root partition like we're currently doing. I suspect we
should be able to add support for this into the device mapper layer so
that we can specify devices this way.

If it helps, an example commandline I've been using to test out a usb
stick is as follows:

dm-mod.create=3D"vroot,,0,ro, 0 4710400 verity 0 8:19 8:19 4096 4096 588800=
 588800 sha1 9b0a223aedbf74b06442b0f05fbff33c55edd010 414b21fba60a1901e23ae=
c373e994942e991d6762631e54a39bc42411f244bd2"

Also, the documentation (Documentation/device-mapper/dm-init.txt) says
we can use a way that doesn't specify so many arguments, but dm verity
complains about not enough arguments (10) when following the example:

  vroot,,,ro,
  0 1740800 verity 254:0 254:0 1740800 sha1
  76e9be054b15884a9fa85973e9cb274c93afadb6
  5b3549d54d6c7a3837b9b81ed72e49463a64c03680c47835bef94d768e5646fe;   =20

So the documentation needs an update?
