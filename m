From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches
 from Ryo to track async bios.
Date: Wed, 2 Sep 2009 09:59:12 +0900
Message-ID: <20090902095912.cdf8a55e.kamezawa.hiroyu@jp.fujitsu.com>
References: <4A9C09BE.4060404@redhat.com> <20090831185640.GF3758@redhat.com>
	<e98e18940908311651s26de5b70ye6f4a82402956309@mail.gmail.com>
	<20090901.160004.226800357.ryov@valinux.co.jp>
	<20090901141142.GA13709@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090901141142.GA13709@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: paolo.valente@unimore.it, jmarchan@redhat.com, dhaval@linux.vnet.ibm.com, riel@redhat.com, fernando@oss.ntt.co.jp, jmoyer@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, fchecconi@gmail.com, dm-devel@redhat.com, jens.axboe@oracle.com, mingo@elte.hu, righi.andrea@gmail.com, torvalds@linux-foundation.org, containers@lists.linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Tue, 1 Sep 2009 10:11:42 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > - Somebody also gave an example where there is a memory hogging p=
rocess and
> > > > =C2=A0possibly pushes out some processes to swap. It does not sou=
nd fair to
> > > > =C2=A0charge those proccess for that swap writeout. These process=
es never
> > > > =C2=A0requested swap IO.
> >=20
> > I think that swap writeouts should be charged to the memory hogging
> > process, because the process consumes more resources and it should ge=
t
> > a penalty.
> >=20
>=20
> A process requesting memory gets IO penalty? IMHO, swapping is a kernel=
=20
> mechanism and kernel's way of providing extended RAM. If we want to sol=
ve
> the issue of memory hogging by a process then right way to solve is to =
use
> memory controller and not by charging the process for IO activity.
> Instead, proabably a more suitable way is to charge swap activity to ro=
ot
> group (where by default all the kernel related activity goes).  =20
>=20

I agree. It't memcg's job.
(Support dirty_ratio in memcg is necessary, I think)

background-write-out-to-swap-for-memory-shortage should be handled
as kernel I/O. If swap-out-by-memcg bacause of its limit is a problem,
dirty_ratio for memcg should be implemetned.

Thanks,
-Kame
