From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Shared snapshots
Date: Mon, 11 Jan 2010 04:12:43 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1001110408350.3284@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1001060927120.28095@hs20-bc2-1.build.redhat.com>
	<20100107084255.GP25902@reaktio.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="279731514-2136982149-1263201163=:3284"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100107084255.GP25902@reaktio.net>
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

--279731514-2136982149-1263201163=:3284
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 7 Jan 2010, Pasi K=E4rkk=E4inen wrote:

> On Wed, Jan 06, 2010 at 09:38:00AM -0500, Mikulas Patocka wrote:
> > Hi
> >=20
> > I uploaded new code for shared snapshots at
> > http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/
> >=20
> > Changes:
> > - two queues, one for reads and one for writes, to improve read latency=
=20
> > when the device is write-congested
> > - limit number of reallocations in flight (VM subsystem sends all write=
s=20
> > at once and without limit it creates big lags).
> > - fixed one place where it didn't handle on-disk errors
> > - simplified bitmap creation, removed some unneeded code
> > - new macro for error reporting, as suggested by Zdenek
> > - some comments added
> > - DM_ prefix added to some macros
> >=20
> > Userspace for lvm 2.02.53 is at
> > http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm-2=
=2E02.54/
> >=20
> > Please, someone, do offensive testing with this --- i.e. apply the=20
> > patches, try it, and try all possible lvm commands with it, try to stre=
ss=20
> > and crash it in various ways, etc. If we wait with testing until Alasda=
ir=20
> > reads the code, it won't get much testing...
> >=20
>=20
> Sorry for a stupid question, but what does "shared" mean? Support for CLV=
M?
>=20
> -- Pasi

No, it is not clustered.

It means that you can create more snapshots (actually 2^32), they have a=20
common snapshot store and data in this store are shared.

Normal snapshots get extremely ineffective when using multiple snapshots=20
--- for example, if you have 10 snapshots, data have to be written 10=20
times and any writes to the origin are 10 times slower. Shared snapshots=20
write data only once.

A possible use for them is to take periodic snapshot, for example once per=
=20
5 minutes, to record system activity.

Another possible use is to create one master image with system image and=20
take many snapshots, each snapshot for one virtual machine.

Mikulas
--279731514-2136982149-1263201163=:3284
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--279731514-2136982149-1263201163=:3284--
