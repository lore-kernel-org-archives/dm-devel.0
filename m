From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Sat, 11 Jul 2009 19:56:52 -0700
Message-ID: <e9c3a7c20907111956s6cc5d643s6007670a4b86a67@mail.gmail.com>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<19002.60755.876186.489524@notabene.brown>
	<1245407630.12264.66.camel@o>
	<19006.8756.925105.737041@notabene.brown>
	<1245697837.7390.456.camel@o> <1246539130.20207.12.camel@o>
	<19025.28110.236108.810671@notabene.brown>
	<83EE3995-729F-47B6-A03E-768A97D8031E@redhat.com>
	<1247239403.27788.28.camel@o>
	<4E23AE19-2E8A-460D-8DE6-7E23A06775BC@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4E23AE19-2E8A-460D-8DE6-7E23A06775BC@redhat.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, heinzm@redhat.com, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

On Sat, Jul 11, 2009 at 5:44 AM, Doug Ledford<dledford@redhat.com> wrote:
> Thanks. =A0This isn't too far off from what I would expect. =A0I would =
say that
> real world loads fall all along a spectrum from "create lots of writes,=
 but
> do little to no work" to "does lots of work, and only sporadically writ=
es".
> =A0It's the later end of this spectrum that is most likely to be helped=
 by the
> cache avoiding routines, while the former is not. =A0So, one of the tes=
ts I
> had in mind was to use something like timing a complete kernel build, o=
r
> doing a database load/report cycle, or some other things like that. =A0=
Things
> that do actual work in the foreground while the raid is kept busy in th=
e
> background. =A0Of course, testing all the various points along the spec=
trum is
> needed, so this test gets us the first.

This reminds of the testing I did when quantifying the benefit of
hardware accelerated raid5.  I played with kernel builds while
resyncing to show the cache and cpu-utilization savings, but never got
that to settle on a solid number.  I took a look at Con Kolivas'
"contest" benchmark [1], but ultimately just published plain iozone
data [2].  The interesting bit is that cpu limited random writes saw
more throughput improvement than streaming writes because the i/o
processing did not need to compete with management of the stripe
cache.

--
Dan

[1]: http://users.on.net/~ckolivas/contest/
[2]: http://sourceforge.net/projects/xscaleiop/files/MD RAID
Acceleration/iop-iozone-graphs-20061010.tar.bz2/download
