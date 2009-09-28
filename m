From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: IO scheduler based IO controller V10
Date: Mon, 28 Sep 2009 10:56:55 -0400
Message-ID: <20090928145655.GB8192@redhat.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	<4ABC28DE.7050809@datenparkplatz.de>
	<20090925202636.GC15007@redhat.com>
	<4e5e476b0909271000u69d79346s27cccad219e49902@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4e5e476b0909271000u69d79346s27cccad219e49902@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Sun, Sep 27, 2009 at 07:00:08PM +0200, Corrado Zoccolo wrote:
> Hi Vivek,
> On Fri, Sep 25, 2009 at 10:26 PM, Vivek Goyal <vgoyal@redhat.com> wrote=
:
> > On Fri, Sep 25, 2009 at 04:20:14AM +0200, Ulrich Lukas wrote:
> >> Vivek Goyal wrote:
> >> > Notes:
> >> > - With vanilla CFQ, random writers can overwhelm a random reader.
> >> > =A0 Bring down its throughput and bump up latencies significantly.
> >>
> >>
> >> IIRC, with vanilla CFQ, sequential writing can overwhelm random read=
ers,
> >> too.
> >>
> >> I'm basing this assumption on the observations I made on both OpenSu=
se
> >> 11.1 and Ubuntu 9.10 alpha6 which I described in my posting on LKML
> >> titled: "Poor desktop responsiveness with background I/O-operations"=
 of
> >> 2009-09-20.
> >> (Message ID: 4AB59CBB.8090907@datenparkplatz.de)
> >>
> >>
> >> Thus, I'm posting this to show that your work is greatly appreciated=
,
> >> given the rather disappointig status quo of Linux's fairness when it
> >> comes to disk IO time.
> >>
> >> I hope that your efforts lead to a change in performance of current
> >> userland applications, the sooner, the better.
> >>
> > [Please don't remove people from original CC list. I am putting them =
back.]
> >
> > Hi Ulrich,
> >
> > I quicky went through that mail thread and I tried following on my
> > desktop.
> >
> > ##########################################
> > dd if=3D/home/vgoyal/4G-file of=3D/dev/null &
> > sleep 5
> > time firefox
> > # close firefox once gui pops up.
> > ##########################################
> >
> > It was taking close to 1 minute 30 seconds to launch firefox and dd g=
ot
> > following.
> >
> > 4294967296 bytes (4.3 GB) copied, 100.602 s, 42.7 MB/s
> >
> > (Results do vary across runs, especially if system is booted fresh. D=
on't
> > =A0know why...).
> >
> >
> > Then I tried putting both the applications in separate groups and ass=
ign
> > them weights 200 each.
> >
> > ##########################################
> > dd if=3D/home/vgoyal/4G-file of=3D/dev/null &
> > echo $! > /cgroup/io/test1/tasks
> > sleep 5
> > echo $$ > /cgroup/io/test2/tasks
> > time firefox
> > # close firefox once gui pops up.
> > ##########################################
> >
> > Now I firefox pops up in 27 seconds. So it cut down the time by 2/3.
> >
> > 4294967296 bytes (4.3 GB) copied, 84.6138 s, 50.8 MB/s
> >
> > Notice that throughput of dd also improved.
> >
> > I ran the block trace and noticed in many a cases firefox threads
> > immediately preempted the "dd". Probably because it was a file system
> > request. So in this case latency will arise from seek time.
> >
> > In some other cases, threads had to wait for up to 100ms because dd w=
as
> > not preempted. In this case latency will arise both from waiting on q=
ueue
> > as well as seek time.
>=20
> I think cfq should already be doing something similar, i.e. giving
> 100ms slices to firefox, that alternate with dd, unless:
> * firefox is too seeky (in this case, the idle window will be too small=
)
> * firefox has too much think time.
>=20

Hi Corrado,

"firefox" is the shell script to setup the environment and launch the
broser. It seems to be a group of threads. Some of them run in parallel
and some of these seems to be running one after the other (once previous
process or threads finished).


> To rule out the first case, what happens if you run the test with your
> "fairness for seeky processes" patch?

I applied that patch and it helps a lot.

http://lwn.net/Articles/341032/

With above patchset applied, and fairness=3D1, firefox pops up in 27-28
seconds.

So it looks like if we don't disable idle window for seeky processes on=20
hardware supporting command queuing, it helps in this particular case.

Thanks
Vivek


=20
> To rule out the second case, what happens if you increase the slice_idl=
e?
>=20
> Thanks,
> Corrado
>=20
> >
> > With cgroup thing, We will run 100ms slice for the group in which fir=
efox
> > is being launched and then give 100ms uninterrupted time slice to dd.=
 So
> > it should cut down on number of seeks happening and that's why we pro=
bably
> > see this improvement.
> >
> > So grouping can help in such cases. May be you can move your X sessio=
n in
> > one group and launch the big IO in other group. Most likely you shoul=
d
> > have better desktop experience without compromising on dd thread outp=
ut.
>=20
> > Thanks
> > Vivek
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at =A0http://www.tux.org/lkml/
> >
>=20
>=20
>=20
> --=20
> _______________________________________________________________________=
___
>=20
> dott. Corrado Zoccolo                          mailto:czoccolo@gmail.co=
m
> PhD - Department of Computer Science - University of Pisa, Italy
> -----------------------------------------------------------------------=
---
