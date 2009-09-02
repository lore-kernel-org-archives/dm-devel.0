From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches from Ryo to
 track async bios.
Date: Wed, 02 Sep 2009 18:52:51 +0900 (JST)
Message-ID: <20090902.185251.193693849.ryov@valinux.co.jp>
References: <e98e18940908311651s26de5b70ye6f4a82402956309@mail.gmail.com>
	<20090901.160004.226800357.ryov@valinux.co.jp>
	<20090901141142.GA13709@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751319AbZIBJwu@vger.kernel.org>
In-Reply-To: <20090901141142.GA13709@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: nauman@google.com, riel@redhat.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, containers@lists.linux-foundation.org, dm-devel@redhat.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu
List-Id: dm-devel.ids

Hi Vivek,

> > > > - The primary use case of tracking async context seems be that =
if a
> > > > =A0process T1 in group G1 mmaps a big file and then another pro=
cess T2 in
> > > > =A0group G2, asks for memory and triggers reclaim and generates=
 writes of
> > > > =A0the file pages mapped by T1, then these writes should not be=
 charged to
> > > > =A0T2, hence blkio_cgroup pages.
> > > >
> > > > =A0But the flip side of this might be that group G2 is a low we=
ight group
> > > > =A0and probably too busy also right now, which will delay the w=
rite out
> > > > =A0and possibly T2 will wait longer for memory to be allocated.
> >=20
> > In order to avoid this wait, dm-ioband issues IO which has a page w=
ith
> > PG_Reclaim as early as possible.
> >=20
>=20
> So in above case IO is still charged to G2 but you keep a track if pa=
ge is
> PG_Reclaim then releae the this bio before other bios queued up in th=
e
> group?

Yes, the bio with PG_Reclaim page is given priority over the other bios=
=2E

> > > > - At one point of time Andrew mentioned that buffered writes ar=
e generally a
> > > > =A0big problem and one needs to map these to owner's group. Tho=
ugh I am not
> > > > =A0very sure what specific problem he was referring to. Can we =
attribute
> > > > =A0buffered writes to pdflush threads and move all pdflush thre=
ads in a
> > > > =A0cgroup to limit system wide write out activity?
> >=20
> > I think that buffered writes also should be controlled per cgroup a=
s
> > well as synchronous writes.
> >=20
>=20
> But it is hard to achieve fairness for buffered writes becase we don'=
t
> create complete parallel IO paths and not necessarily higher weight
> process dispatches more buffered writes to IO scheduler. (Due to page
> cache buffered write logic).
>=20
> So in some cases we might see buffered write fairness and in other ca=
ses
> not. For example, run two dd processes in two groups doing buffered w=
rites
> and it is hard to achieve fairness between these.
>=20
> That's why the idea that if we can't ensure Buffered write vs Buffere=
d
> write fairness in all the cases, then does it make sense to attribute
> buffered writes to pdflush and put pdflush threads into a separate gr=
oup
> to limit system wide write out activity.=20

If all buffered writes are treated as system wide activities, it does
not mean that bandwidth is being controlled. It is true that pdflush
doesn't do I/O according to weight, but bandwidth (including for
bufferd writes) should be reserved for each cgroup.

> > > > - Somebody also gave an example where there is a memory hogging=
 process and
> > > > =A0possibly pushes out some processes to swap. It does not soun=
d fair to
> > > > =A0charge those proccess for that swap writeout. These processe=
s never
> > > > =A0requested swap IO.
> >=20
> > I think that swap writeouts should be charged to the memory hogging
> > process, because the process consumes more resources and it should =
get
> > a penalty.
> >=20
>=20
> A process requesting memory gets IO penalty? IMHO, swapping is a kern=
el=20
> mechanism and kernel's way of providing extended RAM. If we want to s=
olve
> the issue of memory hogging by a process then right way to solve is t=
o use
> memory controller and not by charging the process for IO activity.
> Instead, proabably a more suitable way is to charge swap activity to =
root
> group (where by default all the kernel related activity goes).  =20

No. In the current blkio-cgroup, a process which uses a large amount
of memory gets penalty, not a memory requester.

As you wrote, using both io-controller and memory controller are
required to prevent swap-out caused by memory consumption on another
cgroup.

> > > > - If there are multiple buffered writers in the system, then th=
ose writers
> > > > =A0can also be forced to writeout some pages to disk before the=
y are
> > > > =A0allowed to dirty more pages. As per the page cache design, a=
ny writer
> > > > =A0can pick any inode and start writing out pages. So it can ha=
ppen a
> > > > =A0weight group task is writting out pages dirtied by a lower w=
eight group
> > > > =A0task. If, async bio is mapped to owner's group, it might hap=
pen that
> > > > =A0higher weight group task might be made to sleep on lower wei=
ght group
> > > > =A0task because request descriptors are all consumed up.
> >=20
> > As mentioned above, in dm-ioband, the bio is charged to the page ow=
ner
> > and issued immediately.
>=20
> But you are doing it only for selected pages and not for all buffered
> writes?

I'm sorry, I wrote wrong on the previous mail, IO for writing out
page-cache pages is not issued immediately, it is throttled by
dm-ioband.

Anyway, there is a case where a higher weight group task is made
to sleep, but if we reserve the memory for each cgroup by memory
controller in advance, we can avoid the task put to sleep.

Thanks,
Ryo Tsuruta
