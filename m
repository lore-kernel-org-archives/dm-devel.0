From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: multipath-tools licenses (was Re: [PATCH]
 multipath-tools: replace FSF address with a www pointer)
Date: Mon, 26 Mar 2018 11:07:05 -0500
Message-ID: <20180326160705.GM3103@octiron.msp.redhat.com>
References: <20180310205002.3318-1-xose.vazquez@gmail.com>
	<1521495458.3798.138.camel@suse.com>
	<1a0b44c5-c7a6-85fa-b2dd-1bd542efbb76@gmail.com>
	<1521837017.13100.106.camel@suse.com>
	<20180326130447.3114ef2f@pentland.suse.de>
	<1522067788.19335.55.camel@suse.com>
	<1522073719.19335.66.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1522073719.19335.66.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, fge@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 26, 2018 at 04:15:19PM +0200, Martin Wilck wrote:
> On Mon, 2018-03-26 at 14:36 +0200, Martin Wilck wrote:
> > =

> > The key question is whether we need *L*GPL at all. We only do if we
> > want to allow prioprietary code to link with our code. Because
> > libmultipath is no "library" intended for general use, rather a set
> > of
> > common code between multipath and multipathd, I don't see a strong
> > case
> > for *L*GPL for it. The parts of the code that might be interesting
> > for
> > external parties to use are libmpathcmd, libmpathpersist, and
> > libdmmp,
> > where the GPLv3 of the latter explicity forbids use by proprietary
> > code. libmpathcmd doesn't need to link libmultipath, but
> > libmpathpersist in its current form does.
> =

> I just realized that libdmmp doesn't link to libmultipath, either, just
> libmpathcmd. So there's _no_ linking problem here, and _no_ legal
> problem distributing libdmmp and libmultipath together. I'm sorry for
> distributing FUD.
> =

> Soooo, it's actually not so bad, after all, except that we (and
> external parties) have to realize that the COPYING file doesn't apply
> to libmultipath as a whole, just to those files that don't carry an
> explicit copyright notice, and that means very little. Because of the
> issues raised earlier, libmultipath.so and libmpathpersist.so are
> effectively under "GPLv2 only" license, and neither under any *L*GPL
> variant, nor under a "version $x or later" variant.
> =

> The COPYING file is therefore rather misleading.

It was always my intention that libmpathcmd was LGPL. It doesn't link to
any other multipath code, and as you point out, mpath_cmd.h has a LGPL
header.

All of the code that I have contributed to libmpathpersist, I am happy
to release under LGPL, but that doesn't amount to much.

I agree that libmultipath should not be LPGL'ed. I don't think anyone
should even be distributing .h files for it.  I certainly don't ever
worry about maintaining a consistent API in it, so nothing outside of
the multipath tools code base should ever rely on it.

As for what, if anything, to do with the libdmmp license, I belive that
it pretty much entirely up to Gris.

If we can limit the project to two (or if necessary 3) licenses, we can
just include all the license files, and explain what applies to what
in the README.  I haven't really looked at how other projects that have
multiple licenses for parts of their code do things, so perhaps there is
a more standard way.

-Ben

> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
