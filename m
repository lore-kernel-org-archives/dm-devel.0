From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Shared snapshots
Date: Mon, 11 Jan 2010 04:49:52 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1001110447510.3284@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1001060927120.28095@hs20-bc2-1.build.redhat.com>
	<20100107084255.GP25902@reaktio.net>
	<Pine.LNX.4.64.1001110408350.3284@hs20-bc2-1.build.redhat.com>
	<20100111094022.GR25902@reaktio.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="279731514-1290902614-1263203392=:3284"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100111094022.GR25902@reaktio.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--279731514-1290902614-1263203392=:3284
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 11 Jan 2010, Pasi K=E4rkk=E4inen wrote:

> On Mon, Jan 11, 2010 at 04:12:43AM -0500, Mikulas Patocka wrote:
> >=20
> >=20
> > On Thu, 7 Jan 2010, Pasi K=E4rkk=E4inen wrote:
> >=20
> > > On Wed, Jan 06, 2010 at 09:38:00AM -0500, Mikulas Patocka wrote:
> > > > Hi
> > > >=20
> > > > I uploaded new code for shared snapshots at
> > > > http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/deve=
l/
> > > >=20
> > > > Changes:
> > > > - two queues, one for reads and one for writes, to improve read lat=
ency=20
> > > > when the device is write-congested
> > > > - limit number of reallocations in flight (VM subsystem sends all w=
rites=20
> > > > at once and without limit it creates big lags).
> > > > - fixed one place where it didn't handle on-disk errors
> > > > - simplified bitmap creation, removed some unneeded code
> > > > - new macro for error reporting, as suggested by Zdenek
> > > > - some comments added
> > > > - DM_ prefix added to some macros
> > > >=20
> > > > Userspace for lvm 2.02.53 is at
> > > > http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/l=
vm-2.02.54/
> > > >=20
> > > > Please, someone, do offensive testing with this --- i.e. apply the=
=20
> > > > patches, try it, and try all possible lvm commands with it, try to =
stress=20
> > > > and crash it in various ways, etc. If we wait with testing until Al=
asdair=20
> > > > reads the code, it won't get much testing...
> > > >=20
> > >=20
> > > Sorry for a stupid question, but what does "shared" mean? Support for=
 CLVM?
> > >=20
> > > -- Pasi
> >=20
> > No, it is not clustered.
> >
>=20
> Ok. Do you know if there has been work making snapshots work with CLVM?=
=20
>=20
> I remember there was some patches earlier, but no idea about the status
> of those..

There is kernel support, see=20
http://people.redhat.com/mpatocka/patches/kernel/all/series.html (the last=
=20
section, "Mikulas' clustering"). The patches are old, they may need=20
conflict resolving.

But there is no userspace support. So, if you set it up manually with=20
dmsetup and pass it a correct locking ID, it may work.

Mikulas
--279731514-1290902614-1263203392=:3284
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--279731514-1290902614-1263203392=:3284--
