From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v3 02/19] libmultipath: fix tur checker
 double locking
Date: Fri, 5 Oct 2018 12:10:54 -0500
Message-ID: <20181005171054.GE3172@octiron.msp.redhat.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
	<1537571127-10143-3-git-send-email-bmarzins@redhat.com>
	<3bad257069d68444b0b2743d4b38ba6b6d15501d.camel@suse.com>
	<20181004164521.GB3172@octiron.msp.redhat.com>
	<fc2465f686f1cc33b2923f8cd44dabf55ce1c5a4.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <fc2465f686f1cc33b2923f8cd44dabf55ce1c5a4.camel@suse.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, mwilck+gmail@suse.de, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 05, 2018 at 12:25:15PM +0200, Martin Wilck wrote:
> On Thu, 2018-10-04 at 11:45 -0500,  Benjamin Marzinski  wrote:
> > On Mon, Oct 01, 2018 at 10:09:41PM +0200, Martin Wilck wrote:
> > > On Fri, 2018-09-21 at 18:05 -0500, Benjamin Marzinski wrote:
> > > > tur_devt() locks ct->lock. However, it is ocassionally called
> > > > while
> > > > ct->lock is already locked. In reality, there is no reason why we
> > > > need
> > > > to lock all the accesses to ct->devt. The tur checker only needs
> > > > to
> > > > write to this variable one time, when it first gets the file
> > > > descripter
> > > > that it is checking.  It also never uses ct->devt directly.
> > > > Instead,
> > > > it
> > > > always graps the major and minor, and turns them into a string.
> > > > This
> > > > patch changes ct->devt into that string, and sets it in
> > > > libcheck_init()
> > > > when it is first initializing the checker context. After that,
> > > > ct-
> > > > > devt
> > > > =

> > > > is only ever read.
> > > =

> > > I like the lock removal a lot, but not so much the conversion into
> > > a
> > > string. Why not keep the dev_t? =

> > =

> > Because we will simply convert it into a string every time we use it,
> > instead of doing the work one time. It's 24 more bytes in the
> > tur_checker_context, but the code is easier to read, and we're not
> > doing
> > the same work again and again.
> =

> Well, IMO snprintf(buf, N, "%d:%d", major(x), minor(x)) is not _that_
> much work, and it looks a lot cleaner, to me at least.
> =

> But OK, I'm not insisting on this. So, if you re-post, I'm going to ack
> the patch.
> =

> My thought for long term is is this actually this: ct->dev_t is only
> needed for creating messages to be stored in the checker->message
> string, which I don't like either.
> =

> Why don't we replace the "message" field with an "int msgid", and
> add a =

> =

>      char* (*get_message)(int msgid)
> =

> to the checker API?

I would not have a problem with a patch that did this.

-Ben

> =

> msgid could actually be another "uatomic" field. We could even go one
> step further, create a field for the checker status in struct checker,
> and use like one byte for the general path status and the rest of the
> field for the msgid, which usually represents just some checker-
> specific extra information wrt the status.
> =

> > > =

> > > Or maybe even easier, the other way around: why don't we make it a
> > > char* and simply set checker->dev_t =3D &pp->dev_t?
> > =

> > The whole reason we have tur_checker_context->holders is that it's
> > possible for a path to be removed (or orphaned) while the thread is
> > still running. The tur_checker_context needs to keep all its own
> > storage, so that it never as to worry about pointing to freed memory.
> =

> Yeah, I got that meanwhile, as posted before. Sorry.
> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
