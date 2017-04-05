From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: uid_attrs (was Re: [PATCH 04/11] multipathd: add
 need_do_map to indicate whether need calling domap() in ev_add_path())
Date: Wed, 5 Apr 2017 18:19:09 -0500
Message-ID: <20170405231909.GK19236@octiron.msp.redhat.com>
References: <1484200347-11188-1-git-send-email-tang.junhui@zte.com.cn>
	<1484200347-11188-5-git-send-email-tang.junhui@zte.com.cn>
	<20170116213829.GV2732@octiron.msp.redhat.com>
	<OF705BD11C.F27A9FC2-ON482580AB.00205EED-482580AB.002903CF@zte.com.cn>
	<20170117161401.GX2732@octiron.msp.redhat.com>
	<1491398766.15890.15.camel@suse.com>
	<20170405184523.GF19236@octiron.msp.redhat.com>
	<1491423393.15890.26.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1491423393.15890.26.camel@suse.com>
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
Cc: tang.junhui@zte.com.cn, tang.wenjun3@zte.com.cn, zhang.kai16@zte.com.cn, dm-devel@redhat.com, bart.vanassche@sandisk.com
List-Id: dm-devel.ids

On Wed, Apr 05, 2017 at 10:16:33PM +0200, Martin Wilck wrote:
> On Wed, 2017-04-05 at 13:45 -0500, Benjamin Marzinski wrote:
> > On Wed, Apr 05, 2017 at 03:26:06PM +0200, Martin Wilck wrote: =

> =

> > > >From the end user point of view, "uid_attrs" seems to simply
> > duplicate
> > > the functionality of "uid_attribute", just in more awkward syntax,
> > and
> > > with higher priority. As a side effect, it enables uevent merging,
> > > which is documented in the man page but unexpected from the name of
> > the
> > > option.
> > =

> > It should probably do a better job of masking "uid_attribute". The
> > places in the code that currently use "uid_attribute" should all
> > switch
> > to using "uid_attrs" if it is set and applies to the device. =

> > If they
> > don't, we could be in a situation where "uid_attrs" and
> > "uid_attribute"
> > are set to give different wwids, and a path's wwid could change based
> > on
> > whether or not ID_SERIAL was filled in when multipath got
> =

> I'm not quite sure what you mean. The way it's currently implemented is
> in select_getuid(), pp->uid_attribute will be set from uid_attrs if it
> exists and matches the device name, and will henceforth be used
> everywhere where uid_attribute for this path is referenced.
> I don't see how this could lead to inconsistent settings.
> =

> Even for RBD devices, uid_attrs would take precedence if users could =

> uid_attrs=3D"rbd:SOME_VARIABLE". (Btw, why do we hardcode the WWID
> generation for RBD rather than writing rbd udev rules and using the
> udev attributes created by them)?
> =


That's what I get for responding without double-checking the code. I
forgot that uid_attrs was wired into select_getuid and thought that if
the path got set to INIT_MISSING_UDEV when it was initially discovered,
it would use uid_attribute. My bad.

> > > Anyway, I wonder if it would still be possible to change this at
> > > this
> > > point in time (i.e. after "uid_attrs" was merged).
> > =

> > It's always possible to change things.=A0=A0As far as Red Hat goes, we
> > haven't pulled in these changes yet, but I'm planning on rebasing
> > Fedora
> > to upstream shortly.
> =

> We're planning the same for openSUSE Factory. Currently we've left out
> Tang's patch, but the plan is to pull in upstream cleanly.
> =

> > =A0=A0So, it won't cause me any problems if uid_attrs
> > goes away as long as it does so in the near future. I have no idea if
> > other distributions have pulled this in. If so, then uid_attrs
> > probably
> > needs to remain accepted as a valid option by multipath.=A0=A0But since
> > all
> > correct configurations have it give the same answers as
> > uid_attribute,
> > we could probably just make the option do nothing.
> > =

> > Of course, all this depends on your solution actually being enough
> > better than Tang's to justify pulling his version out.
> =

> Point taken :-) I don't have patches at this time. However, let me make
> a suggestion. Does "uid_attrs" really have to be user-configurable? IMO
> configuring this is asked too much from 99% of users. I'd suggest to
> hard-code the value of uid_attrs and use a boolean configuration option
> in the defaults section ("auto_uid_attribute", say) which would control
> whether WWID attributes should be configured "the uid_attrs way" or the
> "traditional way" (traditional being the fallback if uid_attrs didn't
> match, like now). Hard-coding this would have the advantage that we
> wouldn't be bound to the "sd:..." syntax. Rather, we could explore more
> intelligent ways to autodetect the uid_attribute depending on path
> properties which are known early on.

The idea behind making it configurable was to allow people to change
this in the same way that they can change uid_attribute, under the
assumption that if users need to be able to change uid_attribute, then
they would equally need to be able to change uid_attrs. Of course, I
don't know of any real use-case for this, and it's pretty hard to defend
adding user-visible complexity to fix a problem that nobody has. So,
sure I'm fine with your suggestion.

-Ben

> Uevent merging could be controlled by a separate config option which
> would depend on the "auto_uid_attribute" option. This would mainly be
> done for clarity.
>
> Regards
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
