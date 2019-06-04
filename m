From: Ezequiel Garcia <ezequiel@collabora.com>
Subject: Re: [PATCH v12] dm: add support to directly boot to a mapped device
Date: Tue, 04 Jun 2019 16:21:10 -0300
Message-ID: <9460817290d5846a34b81470b15ac36d88a08aad.camel@collabora.com>
References: <20190221203334.24504-1-helen.koike@collabora.com>
         <5cf5a724.1c69fb81.1e8f0.08fb@mx.google.com>
         <d6b4fb26-9a1b-0acd-ce4a-e48322a17e7d@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d6b4fb26-9a1b-0acd-ce4a-e48322a17e7d@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Helen Koike <helen.koike@collabora.com>, Stephen Boyd <swboyd@chromium.org>, dm-devel@redhat.com
Cc: wad@chromium.org, keescook@chromium.org, snitzer@redhat.com, linux-doc@vger.kernel.org, richard.weinberger@gmail.com, linux-kernel@vger.kernel.org, linux-lvm@redhat.com, enric.balletbo@collabora.com, kernel@collabora.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Stephen,

On Tue, 2019-06-04 at 14:38 -0300, Helen Koike wrote:
> Hi Stephen,
> 
> On 6/3/19 8:02 PM, Stephen Boyd wrote:
> > Quoting Helen Koike (2019-02-21 12:33:34)
> > > Add a "create" module parameter, which allows device-mapper targets to be
> > > configured at boot time. This enables early use of dm targets in the boot
> > > process (as the root device or otherwise) without the need of an initramfs.
> > > 
> > > The syntax used in the boot param is based on the concise format from the
> > > dmsetup tool to follow the rule of least surprise:
> > > 
> > >         sudo dmsetup table --concise /dev/mapper/lroot
> > > 
> > > Which is:
> > >         dm-mod.create=<name>,<uuid>,<minor>,<flags>,<table>[,<table>+][;<name>,<uuid>,<minor>,<flags>,<table>[,<table>+]+]
> > > 
> > > Where,
> > >         <name>          ::= The device name.
> > >         <uuid>          ::= xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | ""
> > >         <minor>         ::= The device minor number | ""
> > >         <flags>         ::= "ro" | "rw"
> > >         <table>         ::= <start_sector> <num_sectors> <target_type> <target_args>
> > >         <target_type>   ::= "verity" | "linear" | ...
> > > 
> > > For example, the following could be added in the boot parameters:
> > > dm-mod.create="lroot,,,rw, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0" root=/dev/dm-0
> > > 
> > > Only the targets that were tested are allowed and the ones that doesn't
> > > change any block device when the dm is create as read-only. For example,
> > > mirror and cache targets are not allowed. The rationale behind this is
> > > that if the user makes a mistake, choosing the wrong device to be the
> > > mirror or the cache can corrupt data.
> > > 
> > > The only targets allowed are:
> > > * crypt
> > > * delay
> > > * linear
> > > * snapshot-origin
> > > * striped
> > > * verity
> > > 
> > > Co-developed-by: Will Drewry <wad@chromium.org>
> > > Co-developed-by: Kees Cook <keescook@chromium.org>
> > > Co-developed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> > > Signed-off-by: Helen Koike <helen.koike@collabora.com>
> > > 
> > > ---
> > > 
> > 
> > I'm trying to boot a mainline linux kernel on a chromeos device with dm
> > verity and a USB stick but it's not working for me even with this patch.
> > I've had to hack around two problems:
> > 
> >  1) rootwait isn't considered
> > 
> >  2) verity doesn't seem to accept UUID for <hash_dev> or <dev>
> > 
> > For the first problem, it happens every boot for me because I'm trying
> > to boot off of a USB stick and it's behind a hub that takes a few
> > seconds to enumerate. If I hack up the code to call dm_init_init() after
> > the 'rootdelay' cmdline parameter is used then I can make this work. It
> > would be much nicer if the whole mechanism didn't use a late initcall
> > though. If it used a hook from prepare_namespace() and then looped
> > waiting for devices to create when rootwait was specified it would work.
> 
> The patch was implemented with late initcall partially to be contained
> in drivers/md/*, but to support rootwait, adding a hook from
> prepare_namespace seems the way to go indeed.
> 

Thanks for bringing this up.

Helen and I have been looking at this code, and we think it's possible
to move things around and add some helpers, so we can implement rootwait
behavior, without actually cluttering init/do_mounts.c.

And along the way, we might get the chance to clean-up this code even
further.

Regards,
Eze
