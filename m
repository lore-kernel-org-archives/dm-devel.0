From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v12] dm: add support to directly boot to a mapped device
Date: Thu, 21 Feb 2019 14:42:47 -0800
Message-ID: <CAGXu5jL2xQL9rgwQsqfraGQwzOd2+yr-2qkKvZYNwXYGTV8TZA@mail.gmail.com>
References: <20190221203334.24504-1-helen.koike@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190221203334.24504-1-helen.koike@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Helen Koike <helen.koike@collabora.com>
Cc: device-mapper development <dm-devel@redhat.com>, Will Drewry <wad@chromium.org>, Mike Snitzer <snitzer@redhat.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, richard -rw- weinberger <richard.weinberger@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-lvm@redhat.com, Enric Balletbo i Serra <enric.balletbo@collabora.com>, kernel@collabora.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 21, 2019 at 12:33 PM Helen Koike <helen.koike@collabora.com> wrote:
>
> Add a "create" module parameter, which allows device-mapper targets to be
> configured at boot time. This enables early use of dm targets in the boot
> process (as the root device or otherwise) without the need of an initramfs.
>
> The syntax used in the boot param is based on the concise format from the
> dmsetup tool to follow the rule of least surprise:
>
>         sudo dmsetup table --concise /dev/mapper/lroot
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
> For example, the following could be added in the boot parameters:
> dm-mod.create="lroot,,,rw, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0" root=/dev/dm-0
>
> Only the targets that were tested are allowed and the ones that doesn't
> change any block device when the dm is create as read-only. For example,
> mirror and cache targets are not allowed. The rationale behind this is
> that if the user makes a mistake, choosing the wrong device to be the
> mirror or the cache can corrupt data.
>
> The only targets allowed are:
> * crypt
> * delay
> * linear
> * snapshot-origin
> * striped
> * verity
>
> Co-developed-by: Will Drewry <wad@chromium.org>
> Co-developed-by: Kees Cook <keescook@chromium.org>
> Co-developed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> Signed-off-by: Helen Koike <helen.koike@collabora.com>

Thanks! This appears to have everything Chrome OS needs. I've asked a
few other folks to look at it too.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
