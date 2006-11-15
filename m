From: David Wysochanski <dave.wysochanski@redhat.com>
Subject: RE: patch to discovery.c to still get
	pathpriorityforpaths with path state of PATH_DOWN
Date: Wed, 15 Nov 2006 17:43:35 -0500
Message-ID: <1163630615.14577.4.camel@dhcp59-220.rdu.redhat.com>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1552@CORPUSMX40A.corp.emc.com>
	<1163630023.10466.141.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1163630023.10466.141.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com, Edward Goggin <egoggin@emc.com>
List-Id: dm-devel.ids

On Wed, 2006-11-15 at 23:33 +0100, Christophe Varoqui wrote:
> Le mercredi 15 novembre 2006 =C3=A0 14:48 -0500, Edward Goggin a =C3=A9=
crit :
> > On Wednesday, November 15, 2006 1:49 AM, Dave Wysochanski wrote
> >=20
> > > One other thought I had was the notion of a "priority valid"=20
> > > flag (or a
> > > special priority value) in the path for the case of=20
> > > group_by_prio.  Set
> > > it to invalid in alloc_path(), then just don't add the path to the
> > > multipath struct in coalesce_paths() if the priority value=20
> > > was invalid.
> > > Then over in checkerloop(), add the path to the multipath map when =
you
> > > get a valid priority.
> > >=20
> > > It is more complicated than that I'm sure (e.g. checkerloop() assum=
es
> > > pp->mpp is non-null in places, etc) but seemed like a half-decent
> > > approach to at least consider.
> > >=20
> > > This approach doesn't take into consideration the general case of a
> > > change in path priority though.
> >=20
> > I very much like the first part of your "priority valid" idea
> > mentioned above.
> >=20
> > I've enclosed a patch for the first part of your idea.  The patch
> > should address the concern you had about recalculating priority
> > for a path when its path state changes from not PATH_DOWN to
> > PATH_DOWN.  It now only retrieves the priority for PATH_DOWN
> > paths if the path's priority has never been successfully
> > retrieved before.
> >=20
> How about the following, clarifying PRIO values and avoiding the
> additional "struct path" element ?
>=20
> Please have a careful look at the multipath/main.c:update_paths change,
> because the (!pp->priority) that was there awfully looks like a bug (as
> 0 is not a defined prio value).
>=20

0 is the value you'll get though after alloc_path and before anyone
calls pathinfo right?

Your patch should be equivalent though and is clearer.


> Regards,
> cvaroqui
>=20
>=20
