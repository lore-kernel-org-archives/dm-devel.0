From: Edward Goggin <egoggin@emc.com>
Subject: RE: patch for handling clariion I/O to
Date: Thu, 5 Oct 2006 13:58:32 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1419@CORPUSMX40A.corp.emc.com>
References: <1160066793.15916.35.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1160066793.15916.35.camel@localhost.localdomain>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

=20

> -----Original Message-----
> From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]=20
> Sent: Thursday, October 05, 2006 12:47 PM
> To: goggin, edward
> Cc: dm-devel@redhat.com
> Subject: RE: patch for handling clariion I/O to
>=20
> > >=20
> > > I don't see you ever reseting "allfailpaths". Isn't it a problem ?
> > >
> > =20
> > I'm counting on the MALLOC macro, (defined in memory.h and=20
> called from
> > alloc_multipath) to call zalloc to zero/reset all fields of=20
> struct multipath.
> >=20
> I meant reseting the toggle to 0 some time after a switch to 1, not at
> allocation time.
>=20
> I had in mind a situation of return to operational state, which seems
> not possible with the current patch.

You are right.  I'll take care of this also.  Thanks!

>=20
> Regards,
> cvaroqui
>=20
>=20
