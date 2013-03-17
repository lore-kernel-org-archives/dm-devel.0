From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DM RAID:  Add message/status support for changing sync
 action
Date: Mon, 18 Mar 2013 09:35:23 +1100
Message-ID: <20130318093523.60bc52ac@notabene.brown>
References: <1363380503.5163.2.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wYm.twq1uU2MGGBwxAN_SKe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1363380503.5163.2.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, agk@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

--Sig_/wYm.twq1uU2MGGBwxAN_SKe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Mar 2013 15:48:23 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> DM RAID:  Add message/status support for changing sync action
>=20
> This patch adds a message interface to dm-raid to allow the user to more
> finely control the sync actions being performed by the MD driver.  This
> gives the user the ability to initiate "check" and "repair" (i.e. scrubbi=
ng).
> Two additional fields have been added to the status output to provide more
> information about the type of sync action occurring and the results of th=
ose
> actions, specifically: <sync_action> and <mismatch_cnt>.  This is essenti=
ally
> the device-mapper way of doing what MD controls through the 'sync_action'
> sysfs file and shows through the 'mismatch_cnt' sysfs file.
>=20
> This is a first patch and I still have two concerns:
> 1) in 'raid_messages', reap_sync_thread() is not called when "frozen" or
>    "idle" is issued like it would be in  md.c:action_store() because it is
>    not available to dm-raid.c.  This hasn't prevented the thread from
>    shutting down properly in my tests, but there may be something I'm
>    not considering.

I think the only real need for the reap_sync_thread() call is to make the
change synchronous.  i.e. after "echo frozen > sync_action" completes, you
know that the array actually is frozen, rather that it should be frozen very
soon.  This can be important for code which wants to set 'frozen', then
manipulate the array in a way that would be prevented if it was still
undergoing a resync/recovery/check/etc.

I'm don't know how much I actually depend on that property, but it sounds
like a good one to have.
I would probably be OK to export reap_sync_thread() so that dm-raid can use
it.


> 2) (and this is more of an LVM problem)  The "in-sync ratio" field of the
>    status output has generally been used to determine the progress of the
>    initial synchronization or of rebuilding a device.  "check" and "repai=
r"
>    have not been available options until now.  So, if this ratio also
>    shows the progress of a "check", older versions of LVM would seem to
>    indicate (through the 'sync%' field) that the array is not in-sync, wh=
en
>    in fact it is.  Thus, this change might be perceived as a break to
>    backwards compatability.  (However, the old LVM tools would not be able
>    to /issue/ a "check" command and should never run into this.)  I don't
>    see this as a problem for this patch, but I thought it should be
>    brought up and considered.   Obviously, code in LVM will need to be
>    changed to adjust to this - perhaps to show the different types of sync
>    actions that might be occurring.

I see your point.  I don't have any opinion on whether it is a real problem
or just a theoretical one though.

In general, the patch looks good - particular as it includes documentation
changes!  When you get a very you are happy with I'll apply it.

Thanks,
NeilBrown



--Sig_/wYm.twq1uU2MGGBwxAN_SKe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUUZFKznsnt1WYoG5AQJHJw/8C4RGRR3vmmgIsGF3NIkCDAKt/UoNomKa
HytHKWlHrkoXMOrCoA8iuFxeLzjUfRipvs9/BHld186gaW6G2hDSfmqd9gHRllSC
DV2VtXsNwFgfmw+hdMISEJMzi1zi8NuXneEOLHn85FTCnn9TCXFKg9/Yrpp3wbib
BmBL/omdP2SkrsuXelmzJcTSpVxC0ha46rtGLlPT6zxU4ZHFI3omQL8dhTpvzKYE
HBt/fuZxdYHdt/tDJSKVI405VMdpMZ8139/WD093rfPTte7PEJw/AGrx8Gi7ayiq
ODcCQzOWX5X3GgvS44qKG+Ajjhvc9QkzrbUYddjF8yp9KFqvC1sBO1K/n2nj9h35
ga5j8XSBMUsG34JRqbPmDRB5WSTPmqI2d4BFeMds33HofCbM3eA0+d/SDUDZktCm
gVsxByV5jD5akiw8BtXM2yShpIUBGOHH/RDQ6dmyV2VC8xqCewvsQRXW/zyXaQMt
6iyoE81OaSWyCbspg5rAnigukrZ2HRRiPA9tQNOrkkRNLz5cdJUgSE1dNSyFb3W9
j5adG+AdIjJzZTzfHss2eyEMqd6MplZo6ORgsZ0Vq5NqnU+fdE2FtDD0TtHlmYuu
lQ5LA24BczcL48AsXRqt626C++hm7JsE4tR8e783u1XIk7PiwPAQI+cBszcmQWwP
q29ebw7SOs8=
=X9x7
-----END PGP SIGNATURE-----

--Sig_/wYm.twq1uU2MGGBwxAN_SKe--
