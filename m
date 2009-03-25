From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: Shell Scripts or Arbitrary Priority Callouts?
Date: Wed, 25 Mar 2009 12:19:44 -0400
Message-ID: <1237997984.6560.230.camel@jaspav.missionsit.net.missionsit.net>
References: <20090324073935.GK5528@edu.joroinen.fi>
	<1237892561.6560.19.camel@jaspav.missionsit.net.missionsit.net>
	<20090324115708.GM5528@edu.joroinen.fi>
	<1237897305.6560.26.camel@jaspav.missionsit.net.missionsit.net>
	<20090324150104.GO5528@edu.joroinen.fi>
	<1237909400.6560.80.camel@jaspav.missionsit.net.missionsit.net>
	<20090324163603.GQ5528@edu.joroinen.fi>
	<1237915811.6560.135.camel@jaspav.missionsit.net.missionsit.net>
	<20090324181735.GR5528@edu.joroinen.fi>
	<1237952692.6560.207.camel@jaspav.missionsit.net.missionsit.net>
	<20090325155251.GF24960@edu.joroinen.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090325155251.GF24960@edu.joroinen.fi>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Ross S. W. Walker" <rwalker@medallion.com>
List-Id: dm-devel.ids

On Wed, 2009-03-25 at 17:52 +0200, Pasi K=C3=A4rkk=C3=A4inen wrote:
> On Tue, Mar 24, 2009 at 11:44:52PM -0400, John A. Sullivan III wrote:
> > <snip>
> > Ah, there is one more question. If latency is such an issue, as it ha=
s
> > proved to be, would it improve performance to put the file system
> > journal on local disk rather than the iSCSI disks? - John
>=20
> I have never tried this.. so can't help with that unfortunately.=20
>=20
> Try it? :)
>=20
> -- Pasi
<snip>
Ross was, once again, most helpful here and mentioned he has tried it
and it is a bad idea.  It can apparently cause problems if there is a
network disconnect - John
--=20
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
