From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Shared snapshots
Date: Mon, 11 Jan 2010 11:40:22 +0200
Message-ID: <20100111094022.GR25902@reaktio.net>
References: <Pine.LNX.4.64.1001060927120.28095@hs20-bc2-1.build.redhat.com>
	<20100107084255.GP25902@reaktio.net>
	<Pine.LNX.4.64.1001110408350.3284@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1001110408350.3284@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 11, 2010 at 04:12:43AM -0500, Mikulas Patocka wrote:
> =

> =

> On Thu, 7 Jan 2010, Pasi K=E4rkk=E4inen wrote:
> =

> > On Wed, Jan 06, 2010 at 09:38:00AM -0500, Mikulas Patocka wrote:
> > > Hi
> > > =

> > > I uploaded new code for shared snapshots at
> > > http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/
> > > =

> > > Changes:
> > > - two queues, one for reads and one for writes, to improve read laten=
cy =

> > > when the device is write-congested
> > > - limit number of reallocations in flight (VM subsystem sends all wri=
tes =

> > > at once and without limit it creates big lags).
> > > - fixed one place where it didn't handle on-disk errors
> > > - simplified bitmap creation, removed some unneeded code
> > > - new macro for error reporting, as suggested by Zdenek
> > > - some comments added
> > > - DM_ prefix added to some macros
> > > =

> > > Userspace for lvm 2.02.53 is at
> > > http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm=
-2.02.54/
> > > =

> > > Please, someone, do offensive testing with this --- i.e. apply the =

> > > patches, try it, and try all possible lvm commands with it, try to st=
ress =

> > > and crash it in various ways, etc. If we wait with testing until Alas=
dair =

> > > reads the code, it won't get much testing...
> > > =

> > =

> > Sorry for a stupid question, but what does "shared" mean? Support for C=
LVM?
> > =

> > -- Pasi
> =

> No, it is not clustered.
>

Ok. Do you know if there has been work making snapshots work with CLVM? =


I remember there was some patches earlier, but no idea about the status
of those..

> It means that you can create more snapshots (actually 2^32), they have a =

> common snapshot store and data in this store are shared.
> =

> Normal snapshots get extremely ineffective when using multiple snapshots =

> --- for example, if you have 10 snapshots, data have to be written 10 =

> times and any writes to the origin are 10 times slower. Shared snapshots =

> write data only once.
> =

> A possible use for them is to take periodic snapshot, for example once pe=
r =

> 5 minutes, to record system activity.
> =

> Another possible use is to create one master image with system image and =

> take many snapshots, each snapshot for one virtual machine.
>

This sounds excellent! Thanks for explaining.

-- Pasi
