From: Edward Goggin <egoggin@emc.com>
Subject: RE: patch to discovery.c to still get path priority
	forpaths with path state of PATH_DOWN
Date: Mon, 13 Nov 2006 15:47:35 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1540@CORPUSMX40A.corp.emc.com>
References: <1163448272.5006.48.camel@linux-cxyg.rtp.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1163448272.5006.48.camel@linux-cxyg.rtp.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

Dave,

Sorry for the confusion.

I realize that at first glance the patch may not make sense, but it
is an attempt to avoid the case of not being able to properly assign
path groups with a group_by_priority path grouping policy if any of
the paths respond successfully to scsi_id(8) and mpath_prio_* but not
their multipath path checker.  Such is the case for LUNZ and inactive
snapshot logical units on CLARiiON.

Ed

> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Dave Wysochanski
> Sent: Monday, November 13, 2006 3:05 PM
> To: device-mapper development
> Cc: christophe.varoqui@free.fr
> Subject: Re: [dm-devel] patch to discovery.c to still get=20
> path priority forpaths with path state of PATH_DOWN
>=20
> Ed, I am looking through your patches and in particular this change,
> which reverts a previous change I submitted a little while back.
>=20
> Maybe we can do something better like clarify states.  Looking through
> the code now and will have more feedback.
>=20
>=20
>=20
> On Fri, 2006-11-10 at 18:01 -0500, Edward Goggin wrote:
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
>=20
