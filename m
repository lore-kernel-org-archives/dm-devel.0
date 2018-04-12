From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v4 10/20] libmultipath: indicate wwid failure
 in dm_addmap_create()
Date: Thu, 12 Apr 2018 16:32:11 -0500
Message-ID: <20180412213211.GA3103@octiron.msp.redhat.com>
References: <20180404161627.6244-1-mwilck@suse.com>
	<20180404161627.6244-11-mwilck@suse.com>
	<20180412183343.GM3103@octiron.msp.redhat.com>
	<1523564202.4346.29.camel@suse.com>
	<1523564539.4346.34.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1523564539.4346.34.camel@suse.com>
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
Cc: dm-devel@redhat.com, Julian Andres Klode <julian.klode@canonical.com>
List-Id: dm-devel.ids

On Thu, Apr 12, 2018 at 10:22:19PM +0200, Martin Wilck wrote:
> On Thu, 2018-04-12 at 22:16 +0200, Martin Wilck wrote:
> > On Thu, 2018-04-12 at 13:33 -0500, Benjamin Marzinski wrote:
> > > On Wed, Apr 04, 2018 at 06:16:17PM +0200, Martin Wilck wrote:
> > > > dm_addmap_create() is where we actually try to set up a new
> > > > multipath map. Depending on the result, mark the wwid as
> > > > failed (or not), and re-trigger an uevent if necessary.
> > > > If a path changes from multipath to non-multipath, use an "add"
> > > > event to make sure LVM2 rules pick it up. Increase log level
> > > > of this event to 3.
> > > > =

> > > =

> > > By only looking at domap, we will miss instances of multipathd
> > > failing
> > > to create maps earlier in the process. This isn't necessarily
> > > wrong.
> > > It
> > > just means that we can't rely on checking
> > > /dev/shm/multipath/failed_wwids to definitively tell us whether
> > > multipathd has tried and failed to create the device.
> > =

> > Sorry, I can't follow you. Where else except in the =

> > domap->dm_addmap_create->dm_addmap() code path do we create maps?
> > I'm feeling stupid, I really can't see it.
> =

> If you were referring to other instances of multipathd which have
> already terminated (e.g. multipathd which ran in initramfs): these
> leave the failed markers under /dev/shm when they quit. That's the
> whole point of this patch. A failed marker will only be removed if a)
> the system is rebooted, or b) another attempt to create the map
> succeeds, or c) a user removes the marker manually.
> =

> But I suppose I'm still missing your point.

Any failure in ev_add_path() before the call to domap() could cause
multipath device creation to fail, without triggering this. For instance
add_map_with_path() or setup_map() can fail for a host of reasons.

> =

> Cheers,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
