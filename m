From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath-tools: improve processing
 efficiency for addition and deletion of multipath devices
Date: Thu, 16 Feb 2017 23:38:36 -0600
Message-ID: <20170217053836.GV22981@octiron.msp.redhat.com>
References: <1487228041-1228-1-git-send-email-tang.junhui@zte.com.cn>
	<1487279855.4629.8.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1487279855.4629.8.camel@suse.com>
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
Cc: tang.wenjun3@zte.com.cn, tang.junhui@zte.com.cn, zhang.kai16@zte.com.cn, dm-devel@redhat.com, bart.vanassche@sandisk.com
List-Id: dm-devel.ids

On Thu, Feb 16, 2017 at 10:17:35PM +0100, Martin Wilck wrote:
> Hello Tang,
> =

> I'm sorry to reply so late. Thanks a lot for your work, I agree with
> Ben that the patch is in pretty good shape now. But I have some
> remarks=A0left, please see below. =

>  =

> > +bool
> > +uevent_can_discard(struct uevent *uev)
> > +{
> > +	char *tmp;
> > +	char a[11], b[11];
> > +	struct config * conf;
> > +
> > +	/*
> > +	=A0* keep only block devices, discard partitions
> > +	=A0*/
> > +	tmp =3D strstr(uev->devpath, "/block/");
> > +	if (tmp =3D=3D NULL){
> > +		condlog(4, "no /block/ in '%s'", uev->devpath);
> > +		return true;
> > +	}
> > +	if (sscanf(tmp, "/block/%10s", a) !=3D 1 ||
> > +	=A0=A0=A0=A0sscanf(tmp, "/block/%10[^/]/%10s", a, b) =3D=3D 2) {
> > +		condlog(4, "discard event on %s", uev->devpath);
> > +		return true;
> > +	}
> =

> I'd like the following better for this check. It uses much less cycles.
> =

> static bool
> can_discard_by_devpath(const char *devpath)
> {
> 	static const char BLOCK[] =3D "/block/";
> 	const char *p;
> =

> 	p =3D strstr(pathstr, BLOCK);
> 	if (p =3D=3D NULL)
> 		/* not a block device */
> 		return true;
> 	p +=3D sizeof(BLOCK) - 1;
> 	p =3D strchr(p, '/');
> 	if (p =3D=3D NULL)
> 		/* exactly one path element after "/block/" */
> 		return false;
> 	/* If there are more path elements, it's a partition */
> 	return true;
> }
> =

> > +bool
> > +uevent_can_filter(struct uevent *earlier, struct uevent *later)
> > +{
> > +
> > +	/*
> > +	=A0* filter earlier uvents if path has removed later. Eg:
> > +	=A0* "add path1 |chang path1 |add path2 |remove path1"
> > +	=A0* can filter as:
> > +	=A0* "add path2 |remove path1"
> > +	=A0* uevents "add path1" and "chang path1" are filtered out
> > +	=A0*/
> > +	if (!strcmp(earlier->kernel, later->kernel) &&
> > +		!strcmp(later->action, "remove") &&
> > +		strncmp(later->kernel, "dm-", 3)) {
> > +		return true;
> > +	}
> > +
> > +	/*
> > +	=A0* filter change uvents if add uevents exist. Eg:
> > +	=A0* "change path1| add path1 |add path2"
> > +	=A0* can filter as:
> > +	=A0* "add path1 |add path2"
> > +	=A0* uevent "chang path1" is filtered out
> > +	=A0*/
> > +	if (!strcmp(earlier->kernel, later->kernel) &&
> > +		!strcmp(earlier->action, "change") &&
> > +		!strcmp(later->action, "add") &&
> > +		strncmp(later->kernel, "dm-", 3)) {
> > +		return true;
> > +	}
> > +
> > +	return false;
> > +}
> =

> This would be better readable and faster if you'd put the "kernel"
> tests first so that you need to check only "action" later:
> =

> 	if (!strncmp(later->kernel, "dm-", 3) ||
> 	=A0=A0=A0=A0strcmp(earlier->kernel, later->kernel))
> 		return false;
> =

> > +
> > +bool
> > +merge_need_stop(struct uevent *earlier, struct uevent *later)
> > +{
> > +	/*
> > +	=A0* dm uevent do not try to merge with left uevents
> > +	=A0*/
> > +	if (!strncmp(later->kernel, "dm-", 3))
> > +		return true;
> > +
> > +	/*
> > +	=A0* we can not make a jugement without wwid,
> > +	=A0* so it is sensible to stop merging
> > +	=A0*/
> > +	if (!earlier->wwid || !later->wwid)
> > +		return true;
> > +	/*
> > +	=A0* uevents merging stoped
> > +	=A0* when we meet an opposite action uevent from the same LUN
> > to AVOID
> > +	=A0* "add path1 |remove path1 |add path2 |remove path2 |add
> > path3"
> > +	=A0* to merge as "remove path1, path2" and "add path1, path2,
> > path3"
> > +	=A0* OR
> > +	=A0* "remove path1 |add path1 |remove path2 |add path2 |remove
> > path3"
> > +	=A0* to merge as "add path1, path2" and "remove path1, path2,
> > path3"
> > +	=A0* SO
> > +	=A0* when we meet a non-change uevent from the same LUN
> > +	=A0* with the same wwid and different action
> > +	=A0* it would be better to stop merging.
> > +	=A0*/
> > +	if (!strcmp(earlier->wwid, later->wwid) &&
> > +	=A0=A0=A0=A0strcmp(earlier->action, later->action) &&
> > +	=A0=A0=A0=A0strcmp(earlier->action, "change") &&
> > +	=A0=A0=A0=A0strcmp(later->action, "change"))
> > +		return true;
> > +
> > +	return false;
> > +}
> =

> I know you discussed this with Ben before, but still have some trouble
> with it.=A0
> =

> The first case should have been reduced to "remove path1 | remove path2
> | add path3" by filtering beforehand.=A0I suppose you want to avoid this
> sequence because it could leave us without paths temporarily, causing
> multipathd to destroy the map. But I don't understand what "stop
> merging" buys you here - if you process the events one-by-one, you may
> also have 0 paths at some point. =


Well, because of the filtering , you will never actually stop merging
in this case, like you mentioned.

> In the second case, we know all events in the sequence have the same
> WWID; in this case I think it would be safe to filter away "remove"
> events by subsequent "add" events, ending up with "add path1| add
> path2| remove path3". But I may be overlooking something here.

We can't filter out the remove path events in this case. If you have

add sdb | remove sdb

You know that sdb in the remove event is referring to the same device as
sdb in the add event. If you have

remove sdb | add sdb

There is no guarantee that sdb in the add event is referring to the same
LUN as sdb in the remove event. Once the device gets removed that name
can get reused for anything.

> =

> The dangerous thing if you have simultaneous remove and add events for
> the same LUN is that processing the "add" events is likely to fail in
> domap(). If you get "add path1 | remove path2", once you process "add
> path1", "path2" may not exist in the kernel any more, and "domap" will
> fail if you try to set up both; you may end up removing the map
> completely. IMHO the only safe way to process events in this situation
> is to merge the events into a single domap() call.
> =

> I know you want to avoid that in this patch, but I think it will be a
> logical further improvement.
> =

> Anyway, AFAICS your patch doesn't introduce a regression wrt the
> current code here; unless I'm overlooking something, my arguments would
> apply to sequential event processing as well.
> =

> Regards
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
