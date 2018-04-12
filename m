From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v4 09/20] libmultipath: functions to indicate
 mapping failure in /dev/shm
Date: Thu, 12 Apr 2018 16:27:23 -0500
Message-ID: <20180412212723.GZ3103@octiron.msp.redhat.com>
References: <20180404161627.6244-1-mwilck@suse.com>
	<20180404161627.6244-10-mwilck@suse.com>
	<20180412183302.GL3103@octiron.msp.redhat.com>
	<1523563633.4346.25.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1523563633.4346.25.camel@suse.com>
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

On Thu, Apr 12, 2018 at 10:07:13PM +0200, Martin Wilck wrote:
> On Thu, 2018-04-12 at 13:33 -0500, Benjamin Marzinski wrote:
> > On Wed, Apr 04, 2018 at 06:16:16PM +0200, Martin Wilck wrote:
> > > Create a simple API that indicates failure to create a map for a
> > > certain WWID. This will allow multipathd to indicate to other tools
> > > (in particular, "multipath -u" during udev processing) that
> > > an attempt to create a map for a certain wwid failed.
> > > =

> > > The indicator is simply the existence of a file under
> > > /dev/shm/multipath/failed_wwids.
> > =

> > I'm a little confused about the necessity of a lock file here.  What
> > it
> > the race that you are worried about? If two processes try to create a
> > file at the same time, surely one of them will succeed. If two
> > processes
> > try to delete a file at the same time, it will get deleted.  If one
> > process is trying to create a file and one is trying to remove it,
> > the
> > outcome depends on the who wins the race. But this is true whether
> > you
> > add a lock file to make those actions atomic or not. The same goes
> > with
> > stating a file that's being created or removed. As far a I can tell,
> > this should work if you simply create an empty file without any
> > locking.
> > Are you worried about some odd errno due to a race?
> =

> My thinking was that it's generally a good thing to make file system
> operations like this atomic, and the well-tested and mature open_file()
> API was there ready to be used, thus I did.
> =

> You're probably right that the locking not strictly necessary. I don't
> think it hurts, performance-wise the impact is quite low.
> Do you require me to change this, or can we change it later?

That's fine. I don't see how it can hurt.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
