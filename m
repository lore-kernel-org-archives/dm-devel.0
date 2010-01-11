From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Shared snapshots
Date: Mon, 11 Jan 2010 04:14:54 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1001110413580.3284@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1001060927120.28095@hs20-bc2-1.build.redhat.com>
	<20100107084255.GP25902@reaktio.net>
	<70f06bad1001070105u3e459695r462ebed9a0c88153@mail.gmail.com>
	<b8091bb41001070208h6f6240e5o4da469789ccea343@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="279731514-233431947-1263201294=:3284"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b8091bb41001070208h6f6240e5o4da469789ccea343@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?GB2312?B?1cXT7g==?= <chaimvy@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--279731514-233431947-1263201294=:3284
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 7 Jan 2010, =D5=C5=D3=EE wrote:

> both of the origin device and the snapshot device can't be resized
> dynamically?

You can extend the origin. You can't reduce the origin.
You can extend the shared snapshot store and you can't reduce it.
You can both extend and reduce individual snapshots.

Mikulas

> 2010/1/7 haad <haaaad@gmail.com>
>=20
> >  On Thu, Jan 7, 2010 at 9:42 AM, Pasi K=E4rkk=E4inen <pasik@iki.fi> wro=
te:
> > > On Wed, Jan 06, 2010 at 09:38:00AM -0500, Mikulas Patocka wrote:
> > >> Hi
> > >>
> > >> I uploaded new code for shared snapshots at
> > >> http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel=
/
> > >>
> > >> Changes:
> > >> - two queues, one for reads and one for writes, to improve read late=
ncy
> > >> when the device is write-congested
> > >> - limit number of reallocations in flight (VM subsystem sends all wr=
ites
> > >> at once and without limit it creates big lags).
> > >> - fixed one place where it didn't handle on-disk errors
> > >> - simplified bitmap creation, removed some unneeded code
> > >> - new macro for error reporting, as suggested by Zdenek
> > >> - some comments added
> > >> - DM_ prefix added to some macros
> > >>
> > >> Userspace for lvm 2.02.53 is at
> > >>
> > http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm-2=
=2E02.54/
> > >>
> > >> Please, someone, do offensive testing with this --- i.e. apply the
> > >> patches, try it, and try all possible lvm commands with it, try to
> > stress
> > >> and crash it in various ways, etc. If we wait with testing until
> > Alasdair
> > >> reads the code, it won't get much testing...
> > >>
> > >
> > > Sorry for a stupid question, but what does "shared" mean? Support for
> > CLVM?
> >
> > No all snapshots share one, common exception store I think.
> >
> >
> >
> > --
> >
> >
> > Regards.
> >
> > Adam
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
>=20
--279731514-233431947-1263201294=:3284
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--279731514-233431947-1263201294=:3284--
