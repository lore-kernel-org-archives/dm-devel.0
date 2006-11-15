From: Edward Goggin <egoggin@emc.com>
Subject: RE: patch to discovery.c to still getpathpriorityforpaths
	with path state of PATH_DOWN
Date: Wed, 15 Nov 2006 17:48:05 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1554@CORPUSMX40A.corp.emc.com>
References: <1163630023.10466.141.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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
To: christophe.varoqui@free.fr
Cc: dm-devel@redhat.com, dave.wysochanski@redhat.com
List-Id: dm-devel.ids

OK.  I was trying not to have to introduce another
prio state because that approach just seems prone
to error.

I'll give it a try tomorrow.

> -----Original Message-----
> From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]=20
> Sent: Wednesday, November 15, 2006 5:34 PM
> To: goggin, edward
> Cc: dave.wysochanski@redhat.com; dm-devel@redhat.com
> Subject: RE: [dm-devel] patch to discovery.c to still=20
> getpathpriorityforpaths with path state of PATH_DOWN
>=20
> Le mercredi 15 novembre 2006 =E0 14:48 -0500, Edward Goggin a =E9crit :
> > On Wednesday, November 15, 2006 1:49 AM, Dave Wysochanski wrote
> >=20
> > > One other thought I had was the notion of a "priority valid"=20
> > > flag (or a
> > > special priority value) in the path for the case of=20
> > > group_by_prio.  Set
> > > it to invalid in alloc_path(), then just don't add the path to the
> > > multipath struct in coalesce_paths() if the priority value=20
> > > was invalid.
> > > Then over in checkerloop(), add the path to the multipath=20
> map when you
> > > get a valid priority.
> > >=20
> > > It is more complicated than that I'm sure (e.g.=20
> checkerloop() assumes
> > > pp->mpp is non-null in places, etc) but seemed like a half-decent
> > > approach to at least consider.
> > >=20
> > > This approach doesn't take into consideration the general=20
> case of a
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
> Please have a careful look at the=20
> multipath/main.c:update_paths change,
> because the (!pp->priority) that was there awfully looks like=20
> a bug (as
> 0 is not a defined prio value).
>=20
> Regards,
> cvaroqui
>=20
>=20
>=20
