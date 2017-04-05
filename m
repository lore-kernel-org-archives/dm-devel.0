From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: uid_attrs (was Re: [PATCH 04/11] multipathd: add
 need_do_map to indicate whether need calling domap() in ev_add_path())
Date: Wed, 5 Apr 2017 13:45:23 -0500
Message-ID: <20170405184523.GF19236@octiron.msp.redhat.com>
References: <1484200347-11188-1-git-send-email-tang.junhui@zte.com.cn>
	<1484200347-11188-5-git-send-email-tang.junhui@zte.com.cn>
	<20170116213829.GV2732@octiron.msp.redhat.com>
	<OF705BD11C.F27A9FC2-ON482580AB.00205EED-482580AB.002903CF@zte.com.cn>
	<20170117161401.GX2732@octiron.msp.redhat.com>
	<1491398766.15890.15.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1491398766.15890.15.camel@suse.com>
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

On Wed, Apr 05, 2017 at 03:26:06PM +0200, Martin Wilck wrote:
> Hi Ben & Tang,
> =

> On Tue, 2017-01-17 at 10:14 -0600, Benjamin Marzinski wrote:
> > On Tue, Jan 17, 2017 at 03:28:06PM +0800, tang.junhui@zte.com.cn
> > wrote:
> > > =A0=A0=A0Hello Ben
> > > =

> > > =A0=A0=A0Thank you for your patience again.
> > > =

> > > =A0=A0=A0I'll modify code according to your suggestion as this:
> > > =A0=A0=A01) add configuration in the defaults section
> > > =A0=A0=A0=A0 =A0uid_attrs "sd:ID_SERIAL dasd:ID_UID"
> > > =A0=A0=A0=A0 =A0it would override any other configurations if this
> > > =A0=A0=A0=A0 =A0filed is configured and matched;
> > > =

> > > =A0=A0=A02) In uevent processing thread, we will assign merge_id
> > > =A0=A0=A0=A0 =A0according the label in uevents by this configuration;
> > > =

> > > =A0=A0=A03) this patch will take back:
> > > =A0=A0=A0=A0 =A0[PATCH 12/12] libmultipath: use existing wwid when
> > > =A0=A0=A0=A0 =A0wwid has already been existed in uevent
> > > =

> > > =A0=A0=A04) if this field is not configured, only do filtering and
> > > =A0=A0=A0=A0 =A0no merging works.
> > > =

> > > =A0=A0=A0Please confirm whether this modification is feasible.
> > =

> > Yes. This is perfectly reasonable solution.=A0=A0Thanks for doing all t=
he
> > work on this.
> =

> I'm sorry to jump upon this old discussion again. I've just recently
> realized that with the introduction of "uid_attrs", the section on
> "WWID generation" in multipath.conf(5) needs to be corrected. Looking
> into that, I find it unfortunate that this new option was introduced.
> It makes an already complex configuration exercise even more confusing
> (try to rewrite that man page paragraph in an easily understandable way
> and I think you'll know what I mean).
> =

> >From the end user point of view, "uid_attrs" seems to simply duplicate
> the functionality of "uid_attribute", just in more awkward syntax, and
> with higher priority. As a side effect, it enables uevent merging,
> which is documented in the man page but unexpected from the name of the
> option.

It should probably do a better job of masking "uid_attribute". The
places in the code that currently use "uid_attribute" should all switch
to using "uid_attrs" if it is set and applies to the device. If they
don't, we could be in a situation where "uid_attrs" and "uid_attribute"
are set to give different wwids, and a path's wwid could change based on
whether or not ID_SERIAL was filled in when multipath got the uevent. Of
course, this could only happen due to user error, so it's not that
urgent of an issue. But I completely agree with you that it is totally
non-obvious that the way to stop uevent merging is to unset uid_attrs.
 =

> I went through Ben's reasoning from Jan 16th again:
> =

> > In general, the code to set need_do_map if the wwid and merge_id
> > don't
> > match only works if either none of the device in a merged set have
> > wwids
> > that match the merge_id, or if the last device has a wwid that
> > matches
> > the merge_id. If there are devices with wwids that match the
> > merge_id,
> > but the last device in the set isn't one of them, then some devices
> > will
> > not get a multipath device created for them.
> > =

> [...]
> The easy way to fix it is to use the other possibility that I
> mentioned
> > before, which is to not have the merge_id, and just use the udev
> > provided wwid, instead of fetching it from pathinfo.=A0=A0Like I
> > mentioned,
> > if you do this, you want to make sure that you only try to grab the
> > wwid
> > from the udev events for devices with the correct kernel name:
> > ID_SERIAL
> > only for "sd.*" devices, and ID_UID only for "dasd.*" devices. I also
> > think that this should be configurable.
> > =

> > Otherwise, you can either go through the messy work of calling domap
> > correctly when the last device of a set has a wwid that doesn't match
> > the merge_id, or we can decide that this won't acutally cause
> > problems
> > with any known device, and punt fixing it for now. And if it causes
> > problems with some future devices, we can deal with it then.
> =

> It appears that Tang chose Ben's proposed "easy way" to fix the problem
> described. The key point appears to be to "use the udev provided wwid,
> instead of fetching it from pathinfo". But the end result may be
> confusing for users.
> =

> I didn't react at the time, but in hindsight I'd find it much better if
> multipath's standard WWID generation procedure had been used for uevent
> merging. I admit I don't fully grok why that's harder to implement than
> the solution that got merged, probably because I didn't try yet :-)=A0

The issue is that you can't use the standard WWID generation code and
choose to merge uevents as early as tang wanted to. So you are left
with, noticing that your uevents shouldn't be merged after the fact, and
trying to untable them.

IIRC, I originally described a solution that involved a larger rewrite
of the multipathd code, where we just processed path events
individually, but never reloaded any devices until we had finished
processing all the queued events, and then went back through the paths
we changed, and made the appropriate map changes all at once.  This way
would allow you to process paths just like we always did. But I didn't
feel strongly enough about it to actually write the code myself, when
Tang was already working his idea.

> Anyway, I wonder if it would still be possible to change this at this
> point in time (i.e. after "uid_attrs" was merged).

It's always possible to change things.  As far as Red Hat goes, we
haven't pulled in these changes yet, but I'm planning on rebasing Fedora
to upstream shortly.  So, it won't cause me any problems if uid_attrs
goes away as long as it does so in the near future. I have no idea if
other distributions have pulled this in. If so, then uid_attrs probably
needs to remain accepted as a valid option by multipath.  But since all
correct configurations have it give the same answers as uid_attribute,
we could probably just make the option do nothing.

Of course, all this depends on your solution actually being enough
better than Tang's to justify pulling his version out.

-Ben

> Cheers,
> Martin
> =

> PS: And while I'm nitpicking anyway:=A0The description of "uid_attrs" in
> the man page talks about "type of device", while what's really matched
> against is the kernel devnode name such as /dev/sdX or /dev/dasdY. The
> reader is left clueless what to do for devices other than sd or dasd (I
> suspect that that's actually unsupported, but the man page doesn't say
> anything about that).
> =

> I can provide a patches for this (and for "WWID generation") but I'd
> like to discuss the main topic of this email first.
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
