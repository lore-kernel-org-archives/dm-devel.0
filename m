From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches
	from Ryo to track async bios.
Date: Tue, 1 Sep 2009 10:11:42 -0400
Message-ID: <20090901141142.GA13709@redhat.com>
References: <4A9C09BE.4060404@redhat.com> <20090831185640.GF3758@redhat.com>
	<e98e18940908311651s26de5b70ye6f4a82402956309@mail.gmail.com>
	<20090901.160004.226800357.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090901.160004.226800357.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Tue, Sep 01, 2009 at 04:00:04PM +0900, Ryo Tsuruta wrote:
> Hi,
>=20
> > > Hi Rik,
> > >
> > > Thanks for reviewing the patches. I wanted to have better understan=
ding of
> > > where all does it help to associate a bio to the group of process w=
ho
> > > created/owned the page. Hence few thoughts.
> > >
> > > When a bio is submitted to IO scheduler, it needs to determine the =
group
> > > bio belongs to and group which should be charged to. There seem to =
be two
> > > methods.
> > >
> > > - Attribute the bio to cgroup submitting process belongs to.
> > > - For async requests, track the original owner hence cgroup of the =
page
> > > =A0and charge that group for the bio.
> > >
> > > One can think of pros/cons of both the approaches.
> > >
> > > - The primary use case of tracking async context seems be that if a
> > > =A0process T1 in group G1 mmaps a big file and then another process=
 T2 in
> > > =A0group G2, asks for memory and triggers reclaim and generates wri=
tes of
> > > =A0the file pages mapped by T1, then these writes should not be cha=
rged to
> > > =A0T2, hence blkio_cgroup pages.
> > >
> > > =A0But the flip side of this might be that group G2 is a low weight=
 group
> > > =A0and probably too busy also right now, which will delay the write=
 out
> > > =A0and possibly T2 will wait longer for memory to be allocated.
>=20
> In order to avoid this wait, dm-ioband issues IO which has a page with
> PG_Reclaim as early as possible.
>=20

So in above case IO is still charged to G2 but you keep a track if page i=
s
PG_Reclaim then releae the this bio before other bios queued up in the
group?

> > > - At one point of time Andrew mentioned that buffered writes are ge=
nerally a
> > > =A0big problem and one needs to map these to owner's group. Though =
I am not
> > > =A0very sure what specific problem he was referring to. Can we attr=
ibute
> > > =A0buffered writes to pdflush threads and move all pdflush threads =
in a
> > > =A0cgroup to limit system wide write out activity?
>=20
> I think that buffered writes also should be controlled per cgroup as
> well as synchronous writes.
>=20

But it is hard to achieve fairness for buffered writes becase we don't
create complete parallel IO paths and not necessarily higher weight
process dispatches more buffered writes to IO scheduler. (Due to page
cache buffered write logic).

So in some cases we might see buffered write fairness and in other cases
not. For example, run two dd processes in two groups doing buffered write=
s
and it is hard to achieve fairness between these.

That's why the idea that if we can't ensure Buffered write vs Buffered
write fairness in all the cases, then does it make sense to attribute
buffered writes to pdflush and put pdflush threads into a separate group
to limit system wide write out activity.=20

> > > - Somebody also gave an example where there is a memory hogging pro=
cess and
> > > =A0possibly pushes out some processes to swap. It does not sound fa=
ir to
> > > =A0charge those proccess for that swap writeout. These processes ne=
ver
> > > =A0requested swap IO.
>=20
> I think that swap writeouts should be charged to the memory hogging
> process, because the process consumes more resources and it should get
> a penalty.
>=20

A process requesting memory gets IO penalty? IMHO, swapping is a kernel=20
mechanism and kernel's way of providing extended RAM. If we want to solve
the issue of memory hogging by a process then right way to solve is to us=
e
memory controller and not by charging the process for IO activity.
Instead, proabably a more suitable way is to charge swap activity to root
group (where by default all the kernel related activity goes).  =20

> > > - If there are multiple buffered writers in the system, then those =
writers
> > > =A0can also be forced to writeout some pages to disk before they ar=
e
> > > =A0allowed to dirty more pages. As per the page cache design, any w=
riter
> > > =A0can pick any inode and start writing out pages. So it can happen=
 a
> > > =A0weight group task is writting out pages dirtied by a lower weigh=
t group
> > > =A0task. If, async bio is mapped to owner's group, it might happen =
that
> > > =A0higher weight group task might be made to sleep on lower weight =
group
> > > =A0task because request descriptors are all consumed up.
>=20
> As mentioned above, in dm-ioband, the bio is charged to the page owner
> and issued immediately.

But you are doing it only for selected pages and not for all buffered
writes?

>=20
> > > It looks like there does not seem to be a clean way which covers al=
l the
> > > cases without issues. I am just trying to think, what is a simple w=
ay
> > > which covers most of the cases. Can we just stick to using submitti=
ng task
> > > context to determine a bio's group (as cfq does). Which can result =
in
> > > following.
> > >
> > > - Less code and reduced complexity.
> > >
> > > - Buffered writes will be charged to pdflush and its group. If one =
wish to
> > > =A0limit buffered write activity for pdflush, one can move all the =
pdflush
> > > =A0threads into a group and assign desired weight. Writes submitted=
 in
> > > =A0process context will continue to be charged to that process irre=
spective
> > > =A0of the fact who dirtied that page.
> >=20
> > What if we wanted to control buffered write activity per group? If a
> > group keeps dirtying pages, we wouldn't want it to dominate the disk
> > IO capacity at the expense of other cgroups (by dominating the writes
> > sent down by pdflush).
>=20
> Yes, I think that is true.
>=20

But anyway we are not able to gurantee this isolation in all the cases.
Again I go back to example of two dd threads doing buffered writes in two
groups.

I don't mind keeping it. Just wanted to make sure that we agree and
understand that keeping it does not mean that we get buffered write vs
buffered write isolation/fairness in all the cases.

> > > - swap activity will be charged to kswapd and its group. If swap wr=
ites
> > > =A0are coming from process context, it gets charged to process and =
its
> > > =A0group.
> > >
> > > - If one is worried about the case of one process being charged for=
 write
> > > =A0out of file mapped by another process during reclaim, then we ca=
n
> > > =A0probably make use of memory controller and mount memory controll=
er and
> > > =A0io controller together on same hierarchy. I am told that with me=
mory
> > > =A0controller, group's memory will be reclaimed by the process requ=
esting
> > > =A0more memory. If that's the case, then IO will automatically be c=
harged
> > > =A0to right group if we use submitting task context.
> > >
> > > I just wanted to bring this point forward for more discussions to k=
now
> > > what is the right thing to do? Use bio tracking or not.
>=20
> Thanks for bringing it forward.
>=20

Thanks
Vivek
