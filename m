From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 0/2] multipath: change default devnode
	blacklist
Date: Mon, 8 Jun 2020 10:04:26 -0500
Message-ID: <20200608150426.GC5894@octiron.msp.redhat.com>
References: <1591317060-25484-1-git-send-email-bmarzins@redhat.com>
	<9db7560136de15dad358e2832f236ae131e145ef.camel@suse.com>
	<20200605222730.GB5894@octiron.msp.redhat.com>
	<3442de794faf5c0d1efc7fd95e4fc0e968bbc5e1.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3442de794faf5c0d1efc7fd95e4fc0e968bbc5e1.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "nkshirsa@redhat.com" <nkshirsa@redhat.com>
List-Id: dm-devel.ids

On Sat, Jun 06, 2020 at 07:23:28PM +0000, Martin Wilck wrote:
> On Fri, 2020-06-05 at 17:27 -0500, Benjamin Marzinski wrote:
> > On Fri, Jun 05, 2020 at 07:20:26PM +0000, Martin Wilck wrote:
> > > Hi Ben,
> > >=20
> > > On Thu, 2020-06-04 at 19:30 -0500, Benjamin Marzinski wrote:
> > > > I recently got a request to add the Oracle ASM filer driver
> > > > devices
> > > > to
> > > > multipath's builtin devnode blacklist.  However, instead of
> > > > having to
> > > > do
> > > > always this for each device type individually, I decided to make
> > > > multipath blacklist all non scsi, nvme, and dasd devnodes by
> > > > default.
> > > > This is what the multipath udev rules already do. If people don't
> > > > like
> > > > this solution, the alternative is to add another line to the
> > > > default
> > > > devnode blacklist like "^(asm/|oracleafd/|ofsctl)".
> > >=20
> > > Thanks, this looks ok. But I'd like to propose an alternative idea:
> > > Extend the RE syntax in our config file to allow negated regular=20
> > > expressions. Like this:
> > >=20
> > > blacklist {
> > >     devnode "!(^(sd[a-z]|dasd[a-z]|nvme[0-9]))"
> > > }
> > >=20
> > > The "!(${RE})" construct would mean "everything that does not match
> > > ${RE}".
> > > This logic would only be applied to an entire regex.
> > > If a user needs a RE matching with "!(" and ending with ")", she
> > > can escape=20
> > > the exclamation mark "\!(like this)".
> > >=20
> > > AFAICS this could be implemented quite easily (by adding a "bool
> > > negate" field
> > > in struct blentry and some simple parser logic), and could be
> > > applied to other=20
> > > REs in the config file as well. We could print this with "multipath
> > > -t", and=20
> > > we wouldn't need to document an exception.
> > >=20
> > > It's also pretty much backwards-compatible, I don't think many
> > > people use
> > > regexes starting with "!(" for multipath these days.
> >=20
> > Sure, but since we can only really support negating the whole regular
> > expression, and c regular expressions don't treat '!' as a special
> > character, why do we need the prentheses around the regular
> > expression?
> > It seems like we can just treat regular expressions starting with '!'
> > as
> > negated, and ones starting with "\!" as starting with a literal '!'.
> >=20
> > Do you think that there is much chance that users have blacklist
> > strings
> > that start with '!'? There are no devnodes, udev properties, or
> > protocols that start with that.  I don't know of a UUID format that
> > has
> > an exclamation point, and while it's possible that a product string
> > starts with one, it seems really unlikely.
> >=20
>=20
> Sure, just using "!" would be fine, too, and simpler. Does this mean
> you agree with my proposal in general?

yeah. I'll be posting a v2 shortly.

-Ben
=20
> Martin
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
