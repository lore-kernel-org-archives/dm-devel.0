From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH v12] dm: add support to directly boot to a mapped device
Date: Tue, 04 Jun 2019 12:35:01 -0700
Message-ID: <5cf6c7e6.1c69fb81.e1551.8ac4@mx.google.com>
References: <20190221203334.24504-1-helen.koike@collabora.com> <5cf5a724.1c69fb81.1e8f0.08fb@mx.google.com> <d6b4fb26-9a1b-0acd-ce4a-e48322a17e7d@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d6b4fb26-9a1b-0acd-ce4a-e48322a17e7d@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Helen Koike <helen.koike@collabora.com>, dm-devel@redhat.com
Cc: wad@chromium.org, keescook@chromium.org, snitzer@redhat.com, linux-doc@vger.kernel.org, richard.weinberger@gmail.com, linux-kernel@vger.kernel.org, linux-lvm@redhat.com, enric.balletbo@collabora.com, kernel@collabora.com, agk@redhat.com
List-Id: dm-devel.ids

Quoting Helen Koike (2019-06-04 10:38:59)
> On 6/3/19 8:02 PM, Stephen Boyd wrote:
> >=20
> > I'm trying to boot a mainline linux kernel on a chromeos device with dm
> > verity and a USB stick but it's not working for me even with this patch.
> > I've had to hack around two problems:
> >=20
> >  1) rootwait isn't considered
> >=20
> >  2) verity doesn't seem to accept UUID for <hash_dev> or <dev>
> >=20
> > For the first problem, it happens every boot for me because I'm trying
> > to boot off of a USB stick and it's behind a hub that takes a few
> > seconds to enumerate. If I hack up the code to call dm_init_init() after
> > the 'rootdelay' cmdline parameter is used then I can make this work. It
> > would be much nicer if the whole mechanism didn't use a late initcall
> > though. If it used a hook from prepare_namespace() and then looped
> > waiting for devices to create when rootwait was specified it would work.
>=20
> The patch was implemented with late initcall partially to be contained
> in drivers/md/*, but to support rootwait, adding a hook from
> prepare_namespace seems the way to go indeed.

Alright, great.

>=20
> >=20
> > The second problem is that in chromeos we have the bootloader fill out
> > the UUID of the kernel partition (%U) and then we have another parameter
> > that indicates the offset from that kernel partition to add to the
> > kernel partition (typically 1, i.e. PARTNROFF=3D1) to find the root
> > filesystem partition. The way verity seems to work here is that we need
> > to specify a path like /dev/sda3 or the major:minor number of the device
> > on the commandline to make this work. It would be better if we could add
> > in support for the PARTNROFF style that name_to_dev_t() handles so we
> > can specify the root partition like we're currently doing. I suspect we
> > should be able to add support for this into the device mapper layer so
> > that we can specify devices this way.
>=20
> hmm, I didn't test this yet but at least from what I can see in the
> code, verity_ctr() calls dm_get_device() that ends up calling
> name_to_dev_t() which should take care of PARTNROFF, this requires a bit
> more investigation.
>=20

Ok, thanks for pointing that out. Sorry I totally missed this codepath
and I should have investigated more. It works for me with the PARTNROFF
syntax that we've been using, so the problem is the rootwait stuff.
