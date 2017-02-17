From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath-tools: improve processing
 efficiency for addition and deletion of multipath devices
Date: Fri, 17 Feb 2017 09:36:44 -0600
Message-ID: <20170217153644.GY22981@octiron.msp.redhat.com>
References: <1487228041-1228-1-git-send-email-tang.junhui@zte.com.cn>
	<1487279855.4629.8.camel@suse.com>
	<20170217053836.GV22981@octiron.msp.redhat.com>
	<20170217062158.GW22981@octiron.msp.redhat.com>
	<1487324924.4629.14.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1487324924.4629.14.camel@suse.com>
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
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn, tang.wenjun3@zte.com.cn, bart.vanassche@sandisk.com
List-Id: dm-devel.ids

On Fri, Feb 17, 2017 at 10:48:44AM +0100, Martin Wilck wrote:
> On Fri, 2017-02-17 at 00:21 -0600, Benjamin Marzinski wrote:
> > On Thu, Feb 16, 2017 at 11:38:36PM -0600, Benjamin Marzinski wrote:
> > > > > +
> > > > > +bool
> > > > > +merge_need_stop(struct uevent *earlier, struct uevent *later)
> > > > > +{
> > > > > +	/*
> > > > > +	=A0* dm uevent do not try to merge with left uevents
> > > > > +	=A0*/
> > > > > +	if (!strncmp(later->kernel, "dm-", 3))
> > > > > +		return true;
> > > > > +
> > > > > +	/*
> > > > > +	=A0* we can not make a jugement without wwid,
> > > > > +	=A0* so it is sensible to stop merging
> > > > > +	=A0*/
> > > > > +	if (!earlier->wwid || !later->wwid)
> > > > > +		return true;
> > > > > +	/*
> > > > > +	=A0* uevents merging stoped
> > > > > +	=A0* when we meet an opposite action uevent from the
> > > > > same LUN
> > > > > to AVOID
> > > > > +	=A0* "add path1 |remove path1 |add path2 |remove path2
> > > > > |add
> > > > > path3"
> > > > > +	=A0* to merge as "remove path1, path2" and "add path1,
> > > > > path2,
> > > > > path3"
> > > > > +	=A0* OR
> > > > > +	=A0* "remove path1 |add path1 |remove path2 |add path2
> > > > > |remove
> > > > > path3"
> > > > > +	=A0* to merge as "add path1, path2" and "remove path1,
> > > > > path2,
> > > > > path3"
> > > > > +	=A0* SO
> > > > > +	=A0* when we meet a non-change uevent from the same LUN
> > > > > +	=A0* with the same wwid and different action
> > > > > +	=A0* it would be better to stop merging.
> > > > > +	=A0*/
> > > > > +	if (!strcmp(earlier->wwid, later->wwid) &&
> > > > > +	=A0=A0=A0=A0strcmp(earlier->action, later->action) &&
> > > > > +	=A0=A0=A0=A0strcmp(earlier->action, "change") &&
> > > > > +	=A0=A0=A0=A0strcmp(later->action, "change"))
> > > > > +		return true;
> > > > > +
> > > > > +	return false;
> > > > > +}
> > > > =

> > > > I know you discussed this with Ben before, but still have some
> > > > trouble
> > > > with it.=A0
> > > > =

> > > > The first case should have been reduced to "remove path1 | remove
> > > > path2
> > > > > add path3" by filtering beforehand.=A0I suppose you want to avoid
> > > > > this
> > > > =

> > > > sequence because it could leave us without paths temporarily,
> > > > causing
> > > > multipathd to destroy the map. But I don't understand what "stop
> > > > merging" buys you here - if you process the events one-by-one,
> > > > you may
> > > > also have 0 paths at some point.=A0
> > > =

> > > Well, because of the filtering , you will never actually stop
> > > merging
> > > in this case, like you mentioned.
> > =

> > Or, if I actually read better, I would see that you will stop
> > merging.
> > I can't think of any problems in theory with merging adds after
> > removes
> > in the simple case at least.
> > =

> > > > In the second case, we know all events in the sequence have the
> > > > same
> > > > WWID; in this case I think it would be safe to filter away
> > > > "remove"
> > > > events by subsequent "add" events, ending up with "add path1| add
> > > > path2| remove path3". But I may be overlooking something here.
> > > =

> > > We can't filter out the remove path events in this case. If you
> > > have
> > > =

> > > add sdb | remove sdb
> > > =

> > > You know that sdb in the remove event is referring to the same
> > > device as
> > > sdb in the add event. If you have
> > > =

> > > remove sdb | add sdb
> > > =

> > > There is no guarantee that sdb in the add event is referring to the
> > > same
> > > LUN as sdb in the remove event. Once the device gets removed that
> > > name
> > > can get reused for anything.
> > =

> > Or you could change the filtering code to verify that the wwids
> > matched.
> =

> AFAICS this is already the case in this code path. merge_needs_stop()
> is run after determining the WWID, and will only ever act on devices
> with the same WWID.
>  =


I was talking about filtering out the remove events.  The filtering code
simply looks at kernel names, which is fine if you don't filter out
removes.

> > However, while the device would be for the same LUN, it might be a
> > different I_T Nexus, so you still don't want to filter the remove of
> > that
> > specific device.=A0
> =

> I figure this could be handled in uev_add_path() by not simply
> returning if an add event for an already existing device was
> encountered. But I agree that would be another, separate, patch.
> =


Assume a device like this (except not a scsi debug one).

mpathi (353333330000007d0) dm-10 Linux   ,scsi_debug      =

size=3D1.0G features=3D'0' hwhandler=3D'0' wp=3Drw
|-+- policy=3D'service-time 0' prio=3D1 status=3Dactive
| `- 10:0:0:0 sdh 8:112 active ready running
|-+- policy=3D'service-time 0' prio=3D1 status=3Denabled
| `- 11:0:0:0 sdi 8:128 active ready running
|-+- policy=3D'service-time 0' prio=3D1 status=3Denabled
| `- 13:0:0:0 sdk 8:160 active ready running
`-+- policy=3D'service-time 0' prio=3D1 status=3Denabled
  `- 12:0:0:0 sdj 8:144 active ready running

Now imagine that path sdk (13:0:0:0) had already gone away.  After this
you get a string of events that look liek

remove sdj | add sdj

Except the sdj that got removed was (12:0:0:0) and the one the got added
was (13:0:0:0). In this case, skipping the completely and not adding the
new device could get you a bad configuration, since (12:0:0:0) might
have a different priority than (13:0:0:0).  Skipping the remove and also
adding the new device is also wrong because then you still have
(12:0:0:0) in the multipath device, when it doesn't really exist.

I'm pretty sure that we can't ever filter out remove events.

-Ben

> Regards
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
