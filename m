From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches
 from Ryo to track async bios.
Date: Tue, 01 Sep 2009 16:00:04 +0900 (JST)
Message-ID: <20090901.160004.226800357.ryov@valinux.co.jp>
References: <4A9C09BE.4060404@redhat.com> <20090831185640.GF3758@redhat.com>
	<e98e18940908311651s26de5b70ye6f4a82402956309@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e98e18940908311651s26de5b70ye6f4a82402956309@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: nauman@google.com
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, mingo@elte.hu, vgoyal@redhat.com, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

Hi,

> > Hi Rik,
> >
> > Thanks for reviewing the patches. I wanted to have better understandi=
ng of
> > where all does it help to associate a bio to the group of process who
> > created/owned the page. Hence few thoughts.
> >
> > When a bio is submitted to IO scheduler, it needs to determine the gr=
oup
> > bio belongs to and group which should be charged to. There seem to be=
 two
> > methods.
> >
> > - Attribute the bio to cgroup submitting process belongs to.
> > - For async requests, track the original owner hence cgroup of the pa=
ge
> > =A0and charge that group for the bio.
> >
> > One can think of pros/cons of both the approaches.
> >
> > - The primary use case of tracking async context seems be that if a
> > =A0process T1 in group G1 mmaps a big file and then another process T=
2 in
> > =A0group G2, asks for memory and triggers reclaim and generates write=
s of
> > =A0the file pages mapped by T1, then these writes should not be charg=
ed to
> > =A0T2, hence blkio_cgroup pages.
> >
> > =A0But the flip side of this might be that group G2 is a low weight g=
roup
> > =A0and probably too busy also right now, which will delay the write o=
ut
> > =A0and possibly T2 will wait longer for memory to be allocated.

In order to avoid this wait, dm-ioband issues IO which has a page with
PG_Reclaim as early as possible.

> > - At one point of time Andrew mentioned that buffered writes are gene=
rally a
> > =A0big problem and one needs to map these to owner's group. Though I =
am not
> > =A0very sure what specific problem he was referring to. Can we attrib=
ute
> > =A0buffered writes to pdflush threads and move all pdflush threads in=
 a
> > =A0cgroup to limit system wide write out activity?

I think that buffered writes also should be controlled per cgroup as
well as synchronous writes.

> > - Somebody also gave an example where there is a memory hogging proce=
ss and
> > =A0possibly pushes out some processes to swap. It does not sound fair=
 to
> > =A0charge those proccess for that swap writeout. These processes neve=
r
> > =A0requested swap IO.

I think that swap writeouts should be charged to the memory hogging
process, because the process consumes more resources and it should get
a penalty.

> > - If there are multiple buffered writers in the system, then those wr=
iters
> > =A0can also be forced to writeout some pages to disk before they are
> > =A0allowed to dirty more pages. As per the page cache design, any wri=
ter
> > =A0can pick any inode and start writing out pages. So it can happen a
> > =A0weight group task is writting out pages dirtied by a lower weight =
group
> > =A0task. If, async bio is mapped to owner's group, it might happen th=
at
> > =A0higher weight group task might be made to sleep on lower weight gr=
oup
> > =A0task because request descriptors are all consumed up.

As mentioned above, in dm-ioband, the bio is charged to the page owner
and issued immediately.

> > It looks like there does not seem to be a clean way which covers all =
the
> > cases without issues. I am just trying to think, what is a simple way
> > which covers most of the cases. Can we just stick to using submitting=
 task
> > context to determine a bio's group (as cfq does). Which can result in
> > following.
> >
> > - Less code and reduced complexity.
> >
> > - Buffered writes will be charged to pdflush and its group. If one wi=
sh to
> > =A0limit buffered write activity for pdflush, one can move all the pd=
flush
> > =A0threads into a group and assign desired weight. Writes submitted i=
n
> > =A0process context will continue to be charged to that process irresp=
ective
> > =A0of the fact who dirtied that page.
>=20
> What if we wanted to control buffered write activity per group? If a
> group keeps dirtying pages, we wouldn't want it to dominate the disk
> IO capacity at the expense of other cgroups (by dominating the writes
> sent down by pdflush).

Yes, I think that is true.

> > - swap activity will be charged to kswapd and its group. If swap writ=
es
> > =A0are coming from process context, it gets charged to process and it=
s
> > =A0group.
> >
> > - If one is worried about the case of one process being charged for w=
rite
> > =A0out of file mapped by another process during reclaim, then we can
> > =A0probably make use of memory controller and mount memory controller=
 and
> > =A0io controller together on same hierarchy. I am told that with memo=
ry
> > =A0controller, group's memory will be reclaimed by the process reques=
ting
> > =A0more memory. If that's the case, then IO will automatically be cha=
rged
> > =A0to right group if we use submitting task context.
> >
> > I just wanted to bring this point forward for more discussions to kno=
w
> > what is the right thing to do? Use bio tracking or not.

Thanks for bringing it forward.

Thanks,
Ryo Tsuruta
