From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2] multipath -u: test socket connection in
 non-blocking mode
Date: Mon, 29 Apr 2019 16:38:38 -0500
Message-ID: <20190429213837.GC5210@octiron.msp.redhat.com>
References: <20190424090759.29796-1-mwilck@suse.com>
	<fa3ea599bf6424587fec45b5eb3549b3200ac5e9.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <fa3ea599bf6424587fec45b5eb3549b3200ac5e9.camel@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Apr 25, 2019 at 09:33:03PM +0200, Martin Wilck wrote:
> On Wed, 2019-04-24 at 11:07 +0200, Martin Wilck wrote:
> > Since commit d7188fcd "multipathd: start daemon after udev trigger",
> > multipathd startup is delayed during boot until after "udev settle"
> > terminates. But "multipath -u" is run by udev workers for storage
> > devices,
> > and attempts to connect to the multipathd socket. This causes a start
> > job
> > for multipathd to be scheduled by systemd, but that job won't be
> > started
> > until "udev settle" finishes. This is not a problem on systems with
> > 129 or
> > less storage units, because the connect() call of "multipath -u" will
> > succeed anyway. But on larger systems, the listen backlog of the
> > systemd
> > socket can be exceeded, which causes connect() calls for the socket
> > to
> > block until multipathd starts up and begins calling accept(). This
> > creates
> > a deadlock situation, because "multipath -u" (called by udev workers)
> > blocks, and thus "udev settle" doesn't finish, delaying multipathd
> > startup. This situation then persists until either the workers or
> > "udev
> > settle" time out. In the former case, path devices might be
> > misclassified
> > as non-multipath devices by "multipath -u".
> > =

> > Fix this by using a non-blocking socket fd for connect() and
> > interpret the
> > errno appropriately.
> > =

> > This patch reverts most of the changes from commit 8cdf6661
> > "multipath:
> > check on multipathd without starting it". Instead, "multipath -u"
> > does
> > access the socket and start multipath again (which is what we want
> > IMO),
> > but it is now able to detect and handle the "full backlog" situation.
> > =

> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > =

> > V2:
> > =

> > Use same error reporting convention in __mpath_connect() as in
> > mpath_connect() (Hannes Reinecke). We can't easily change the latter,
> > because it's part of the "public" libmpathcmd API. =

> =

> FTR, our customer reported that this patch fixed his problem.
> =

> @Ben, I'd be grateful if you could try it (or have the user try it)
> in your problem case as well.

Unfortunately, I don't have a 129+ path system handy that the person who
does isn't around right now.  The code makes sense, and assuming that I
can verify that it fixes the problem I'm seeing, I'm fine with going
this route.

-Ben

> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
