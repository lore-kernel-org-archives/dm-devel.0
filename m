From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: add devname module aliases to allow module on-demand
	auto-loading
Date: Fri, 21 May 2010 19:23:25 +0100
Message-ID: <20100521182325.GO3991@agk-dp.fab.redhat.com>
References: <1274371640.302.5.camel@yio.site> <AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com> <AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com> <201005211909.29326.knikanth@suse.de> <AANLkTimGBgpqB7HEZrecv7uEis6L8b5Yv7jfD6iv_f4J@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimGBgpqB7HEZrecv7uEis6L8b5Yv7jfD6iv_f4J@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Nikanth Karthikesan <knikanth@suse.de>, Peter Rajnoha <prajnoha@redhat.com>, Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, Miklos Szeredi <miklos@szeredi.hu>, Chris Mason <chris.mason@oracle.com>, Tigran Aivazian <tigran@aivazian.fsnet.co.uk>, Ian Kent <raven@themaw.net>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, May 21, 2010 at 03:55:21PM +0200, Kay Sievers wrote:
> On Fri, May 21, 2010 at 15:39, Nikanth Karthikesan <knikanth@suse.de>=
 wrote:
> > On Friday 21 May 2010 18:41:38 Kay Sievers wrote:
> >> On Fri, May 21, 2010 at 13:51, Kay Sievers <kay.sievers@vrfy.org> =
wrote:
> >> > On Fri, May 21, 2010 at 13:34, Alasdair G Kergon <agk@redhat.com=
> wrote:
> >> >
> >> > There is no harm to make a well-know device node static, it just
> >> > solves a lot of problems, and also makes it possible to work off=
 of a
> >> > static /dev.

Well until now we've tried to make everything possible treat device num=
bers as
dynamic, so I'd like to see some compelling logic behind the change.

> >> To illustrate:
> >>
> >> On my box without this patch:
> >> =A0 dmsetup version
> >> =A0 Library version: =A0 1.02.42 (2010-01-14)
> >> =A0 /proc/misc: No entry for device-mapper found
> >> =A0 Is device-mapper driver missing from kernel?
> >> =A0 Failure to communicate with kernel device-mapper driver.

(Curiously this is not an issue I remember anyone raising with me as a =
problem
before.)

So what concepts are at stake here.
The module is available to the kernel but has not been loaded.
Some users do not need the module, so it should not be loaded by defaul=
t.
Users who *do* need it would like it to get loaded automatically.

The matter under discussion is what mechanism to use to load it automat=
ically.

The unique information is the module name so the mechanism should
ideally be tied directly to that.  Anything wanting to use dm already
knows that name.  The character device only becomes available later,
after the module is loaded, and userspace obtains it from /proc/misc.

The modprobe mechanism is tied to the name, so we should really look fo=
r
a solution based on that in the first instance.=20

A related matter - not yet mentioned or discussed between us - is how
the /dev/mapper/control node gets created and what it should be called,
as that name obviously goes against the udev standard of placing
everything in a flat /dev namespace with kernel-based names (so
something like '/dev/miscNNN' in this case) and creating symlinks from
the traditional filesystem locations like /dev/mapper/control.

Currently libdevmapper creates /dev/mapper/control as required based on
/proc/misc.  Presumably we should now hand that over to udev as a
special case of the way we transferred the entries for the actual
devices with similar waiting & notification.

Currently tools (not libdevmapper) take responsibility for checking and
autoloading.  E.g. lvm issues modprobes to autoload dm target modules.
(The kernel does also handle this but lvm doesn't use it because
it wants to know earlier that the operation would fail to avoid more
complex error-handling code.)

So I think we should first try to make an extension of the existing
mechanisms work.  Everything is keyed off a single piece of information=
,
the module name, shared between userspace and kernel.

Alasdair
