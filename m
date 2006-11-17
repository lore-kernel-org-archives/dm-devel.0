From: Edward Goggin <egoggin@emc.com>
Subject: RE: patch to discovery.c to stillgetpathpriorityforpaths
	with path state of PATH_DOWN
Date: Fri, 17 Nov 2006 08:49:27 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D155C@CORPUSMX40A.corp.emc.com>
References: <1163632199.8310.15.camel@linux-cxyg.rtp.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1163632199.8310.15.camel@linux-cxyg.rtp.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dave.wysochanski@redhat.com
Cc: dm-devel@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

On Wednesday, November 15, 2006 6:10 PM, Dave Wysochanski wrote:

> On Wed, 2006-11-15 at 17:48 -0500, Edward Goggin wrote:
> > OK.  I was trying not to have to introduce another
> > prio state because that approach just seems prone
> > to error.
> >=20
> > I'll give it a try tomorrow.
> >=20
>=20
> Ed has a point.
>=20
> An effect of using the special value approach over the flag is a
> potential conflict with the callouts using the same values.  The flag
> approach isolates his initialization case better.

That's OK I think.  I like this approach better since it seems cleaner
as long as the callouts stay away from PRIO_UNDEF literal (-1).

I tested with inactive snapshots and just have one minor (but important)
adjustment to what is in source control at the moment.

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f21e5bc..6f2059a 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -706,7 +706,7 @@ pathinfo (struct path *pp, vector hwtabl
 	  * been successfully obtained before.
 	  */
 	if (mask & DI_PRIO &&
-	    (pp->state !=3D PATH_DOWN || pp->priority !=3D PRIO_UNDEF))
+	    (pp->state !=3D PATH_DOWN || pp->priority =3D=3D PRIO_UNDEF))
 		get_prio(pp);
=20
 	if (mask & DI_WWID && !strlen(pp->wwid))
