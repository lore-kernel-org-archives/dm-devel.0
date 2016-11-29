From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Tue, 29 Nov 2016 13:21:54 -0600
Message-ID: <20161129192153.GC3099@octiron.msp.redhat.com>
References: <OF6C4379F8.661B1ACE-ON48258079.000B15EB-48258079.000CBE4F@zte.com.cn>
	<1480328936.23852.10.camel@suse.com>
	<20161128173124.GE1972@octiron.msp.redhat.com>
	<1480405937.7926.3.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1480405937.7926.3.camel@suse.com>
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
Cc: tang.junhui@zte.com.cn, zhang.kai16@zte.com.cn, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Tue, Nov 29, 2016 at 08:52:17AM +0100, Martin Wilck wrote:
> On Mon, 2016-11-28 at 11:31 -0600, Benjamin Marzinski wrote:
> > On Mon, Nov 28, 2016 at 11:28:56AM +0100, Martin Wilck wrote:
> > > On Mon, 2016-11-28 at 10:19 +0800, tang.junhui@zte.com.cn wrote:
> > > > =

> > > > 4. =A0 =A0 =A0 =A0Proposal=A0
> > > > Other than processing uevents one by one, uevents which coming
> > > > from
> > > > the=A0
> > > > same LUN devices can be mergered to one, and then uevent
> > > > processing=A0
> > > > thread only needs to process it once, and it only produces one DM
> > > > addition=A0
> > > > uevent which could reduce system resource consumption.=A0
> > > > =

> > > =

> > > Here comes an idea how to achieve this without a lot of additional
> > > code:
> > > =

> > > libmultipath already has code to check whether any maps need to be
> > > updated (in coalesce_paths()). Instead of recording uevents,
> > > merging
> > > them, and calling ev_add_path() for every affected WWID, it might
> > > be
> > > sufficient to set daemon state to DAEMON_CONFIGURE and wake up the
> > > main
> > > multipathd thread to call reconfigure(). Then we only need to make
> > > sure
> > > that coalesce_paths() really reloads or creates maps only when
> > > necessary. I have some patches here that I made for that purpose,
> > > for a
> > > different scenario (multipathd to avoid RELOAD ioctls when it's
> > > started
> > > in a scenario where most paths are already set up by udev).
> > =

> > There is a long standing multipath issue that this will likely make a
> > lot worse.=A0=A0Currently, multipathd can drop paths that it doesn't ha=
ve
> > access to on reconfigure. This is wrong. When the path comes back, it
> > won't issue another add uevent. This means that multipathd won't be
> > able
> > to re-enable it (since it stopped monitoring it during the
> > reconfigure).
> > In fact the only way to get the path back is to either manually
> > intervene or to have the path actually get removed from the system
> > and
> > come back.
> =

> Thanks for pointing this out. But don't you think it can be dealt with
> by fixing the reconfigure() path? =


Sure. We should fix that even if we don't make calls to reconfigure more
common. I was just pointing out that by going this route, we make fixing
that issue much more of a priority.

> My point is: any code that merges uevents and tries to figure out the
> correct "minimal" set DM operations to put the changes in place re-
> implement at least parts of the logic of coalesce_paths(), and face
> similar problems.

Yeah. But reconfigure does a lot of stuff that we probably shouldn't be
doing when we are simply adding and removing paths, such as reload the
configuration (and everything that goes along with that, such as
remaking the pathvec to deal with changes in which devices are
blacklisted). We could try breaking out just what needs to be done to
deal with changes to a seperate function, but I'm pretty certain that to
catch all the possibilities of batched events, we will end up doing more
work than necessary in many cases.  In fact, we may find that this takes
long enough that we actually take a performance hit unless we have a
large batch. =


-Ben

> Regards
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
