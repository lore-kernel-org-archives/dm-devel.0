From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 5/5] multipathd: RFC add new polling
 dmevents waiter thread
Date: Tue, 13 Feb 2018 10:49:26 -0600
Message-ID: <20180213164926.GB14513@octiron.msp.redhat.com>
References: <1518239251-29392-1-git-send-email-bmarzins@redhat.com>
	<1518239251-29392-6-git-send-email-bmarzins@redhat.com>
	<1518292553.2937.44.camel@suse.com>
	<20180212231802.GA14513@octiron.msp.redhat.com>
	<1518511819.8040.8.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1518511819.8040.8.camel@suse.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Feb 13, 2018 at 09:50:19AM +0100, Martin Wilck wrote:
> Hi Ben,
> =

> On Mon, 2018-02-12 at 17:18 -0600, Benjamin Marzinski wrote:
> > On Sat, Feb 10, 2018 at 08:55:53PM +0100, Martin Wilck wrote:
> > > Hi Ben,
> > > =

> > > thanks a lot for this. I have only a few minor nitpicks (see
> > > below).
> > > I suppose you've tested this already?
> > =

> > Yes. I do plan on doing some more testing after I look into making
> > libdevmapper support re-arming the polling interface and grabbing the
> > event number from the names listing, before I repost this without the
> > RFC tag. I was also thinking of trying out cmocka by mocking up a
> > device-mapper interface that let me test this code in isolation.
> =

> Great idea.
> =

> Am I understanding correctly that you are working on libdevmapper in
> parallel? If yes, would it make sense to have libmultipath use the
> newly developed libdevmapper API right away, rather than using a
> custom-made ioctl interface until libdevmapper is ready?

I haven't been working on adding the re-arming support to libdevmapper.
I just started looking into that now that I have all of these multipath
patches posted.

I'm not sure I understand you suggestion. There's a large amount of code
that can get executed when you call dm_task_run(). But the core bit of
code that it would execute for the DM_DEV_ARM_POLL command is that
ioctl. Also, the calculation to find the offset of the event number in
the dm_names structure will be the same when libdevmapper does them. I
have no problem with moving the functions I wrote (arm_dev_event_poll
and dm_event_nr) to libmultipath/devmapper.c, where they will eventually
use libdevmapper to do their work, but the actual code they will execute
as part of libdevmapper will be functionally the same.
 =

> > > > I haven't touched any of the existing event waiting code, since
> > > > event
> > > > polling was only added to device-mapper in version
> > > > 4.37.0.  multipathd
> > > > checks this version, and defaults to using the polling code if
> > > > device-mapper supports it. This can be overridden by running
> > > > multipathd
> > > > with "-w", to force it to use the old event waiting code.
> > > =

> > > Why use a command line option here rather than a config file
> > > option?
> > =

> > Mostly because it was faster, and I wanted to get to testing it. The
> > other reason is that I don't see any benefit for the work involved in
> > making this be changeable in
> > =

> > # multipathd reconfigure
> > =

> > However, we already have configuration settings that can't get
> > changed
> > on reconfigure, so making this another one is not a big deal. I agree
> > that it is easier for users to change if it is a configuration
> > setting,
> > but I'm hoping that this change will be invisible to users. If you
> > would
> > prefer it as a configuration setting, I have no problem with changing
> > that
> > .
> =

> Right. It doesn't need to be user-configurable. We may want to leave a
> compile-time option to disable it for the time being.
> =


I'm fine with adding a compile-time option.  When this option is
compiled in, we do want to make multipathd able to use either method,
since not everyone will be running on a recent enough kernel.  Since we
are doing that, I do want to keep some way to force the old method, even
if it is just for testing and debuging purposes. So I would like to keep
the -w option.

> > > > =

> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > ---
> > > >  multipathd/Makefile   |   3 +-
> > > >  multipathd/dmevents.c | 396
> > > > ++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  multipathd/dmevents.h |  13 ++
> > > >  multipathd/main.c     |  58 +++++++-
> > > >  4 files changed, 461 insertions(+), 9 deletions(-)
> > > >  create mode 100644 multipathd/dmevents.c
> > > >  create mode 100644 multipathd/dmevents.h
> > > > =

> > > > diff --git a/multipathd/Makefile b/multipathd/Makefile
> > > > index 85f29a7..4c438f0 100644
> > > > --- a/multipathd/Makefile
> > > > +++ b/multipathd/Makefile
> > > > @@ -22,7 +22,8 @@ ifdef SYSTEMD
> > > >  	endif
> > > >  endif
> > > >  =

> > > > -OBJS =3D main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o
> > > > waiter.o
> > > > +OBJS =3D main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o
> > > > waiter.o \
> > > > +       dmevents.o
> > > >  =

> > > >  EXEC =3D multipathd
> > > >  =

> > > > diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
> > > > new file mode 100644
> > > > index 0000000..a56c055
> > > > --- /dev/null
> > > > +++ b/multipathd/dmevents.c
> > > > =

> =

> > > > +
> > > > +
> > > > +int alloc_dmevent_waiter(struct vectors *vecs)
> > > > +{
> > > > +	if (!vecs) {
> > > > =

> > > Nitpick: conventionally, an "alloc"-type function would return the
> > > pointer, and NULL on failure.
> > =

> > Is this a naming complaint, or an interface complaint?  I'm fine with
> > changing the names so they follow the lead of checkers and prio, i.e.
> > init_dmevents_waiter() and cleanup_dmevents_waiter(). The init and
> > cleanup functions for checkers and prio have the same returns as the
> > dmevent functions (well the init functions return 1 for failure, and
> > I
> > can do that as well)
> =

> I'm fine with simply changing the names.

Sure. I can do that.

> Regards
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
