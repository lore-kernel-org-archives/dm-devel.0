From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: RE: directio / readsector0
Date: Tue, 03 Jul 2007 23:08:14 +0200
Message-ID: <1183496894.8402.18.camel@localhost.localdomain>
References: <1183411769.8402.12.camel@localhost.localdomain>
	<9F94CC89AA0F524CBA8A619D43C4AED80B0731@XYUS-EX22.xyus.xyratex.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9F94CC89AA0F524CBA8A619D43C4AED80B0731@XYUS-EX22.xyus.xyratex.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Koutoupis <Peter_Koutoupis@us.xyratex.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Le lundi 02 juillet 2007 =C3=A0 16:39 -0700, Peter Koutoupis a =C3=A9crit=
 :
> Christophe,
>=20
> My only concern is that we have an application that works on top of
> device-mapper and multipath-tools; and in the multipath.conf file
> under friendly user names we specify the readsector0 due to certain
> limitations with our recent line of RAID products. That means many
> customers hold those settings. If it is preferred to remove the
> readsector0 completely, we can possibly send patches to customers to
> have that parameter altered. Although, please excuse my ignorance but
> what is to stop from implementing directio, still leaving the
> readsector0 intact?
>=20
What really matters is your testing for regressions with the directio
checker.

readsector0 phasing out could be made smooth, by making the
configuration term point to the directio checker.

The incentive there is to not have redundant (and thus confusing)
checkers to maintain.

Regards,
cvaroqui
