From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: IO scheduler based IO controller V10
Date: Tue, 06 Oct 2009 16:17:44 +0900 (JST)
Message-ID: <20091006.161744.189719641.ryov@valinux.co.jp>
References: <20091005.235535.193690928.ryov@valinux.co.jp>
	<20091005171023.GG22143@redhat.com>
	<e98e18940910051111r110dc776l5105bf931761b842@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e98e18940910051111r110dc776l5105bf931761b842@mail.gmail.com>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, yoshikawa.takuya@oss.ntt.co.jp, jmoyer@redhat.com, mingo@elte.hu, vgoyal@redhat.com, righi.andrea@gmail.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, m-ikeda@ds.jp.nec.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

Hi Vivek and Nauman,

Nauman Rafique <nauman@google.com> wrote:
> >> > > How about adding a callback function to the higher level control=
ler?
> >> > > CFQ calls it when the active queue runs out of time, then the hi=
ger
> >> > > level controller use it as a trigger or a hint to move IO group,=
 so
> >> > > I think a time-based controller could be implemented at higher l=
evel.
> >> > >
> >> >
> >> > Adding a call back should not be a big issue. But that means you a=
re
> >> > planning to run only one group at higher layer at one time and I t=
hink
> >> > that's the problem because than we are introducing serialization a=
t higher
> >> > layer. So any higher level device mapper target which has multiple
> >> > physical disks under it, we might be underutilizing these even mor=
e and
> >> > take a big hit on overall throughput.
> >> >
> >> > The whole design of doing proportional weight at lower layer is op=
timial
> >> > usage of system.
> >>
> >> But I think that the higher level approch makes easy to configure
> >> against striped software raid devices.
> >
> > How does it make easier to configure in case of higher level controll=
er?
> >
> > In case of lower level design, one just have to create cgroups and as=
sign
> > weights to cgroups. This mininum step will be required in higher leve=
l
> > controller also. (Even if you get rid of dm-ioband device setup step)=
.

In the case of lower level controller, if we need to assign weights on
a per device basis, we have to assign weights to all devices of which
a raid device consists, but in the case of higher level controller,=20
we just assign weights to the raid device only.

> >> If one would like to
> >> combine some physical disks into one logical device like a dm-linear=
,
> >> I think one should map the IO controller on each physical device and
> >> combine them into one logical device.
> >>
> >
> > In fact this sounds like a more complicated step where one has to set=
up
> > one dm-ioband device on top of each physical device. But I am assumin=
g
> > that this will go away once you move to per reuqest queue like implem=
entation.

I don't understand why the per request queue implementation makes it
go away. If dm-ioband is integrated into the LVM tools, it could allow
users to skip the complicated steps to configure dm-linear devices.

> > I think it should be same in principal as my initial implementation o=
f IO
> > controller on request queue and I stopped development on it because o=
f FIFO
> > dispatch.

I think that FIFO dispatch seldom lead to prioviry inversion, because
holding period for throttling is not too long to break the IO priority.
I did some tests to see whether priority inversion is happened.

The first test ran fio sequential readers on the same group. The BE0
reader got the highest throughput as I expected.

nr_threads      16      |      16    |     1
ionice          BE7     |     BE7    |    BE0
------------------------+------------+-------------
vanilla     10,076KiB/s | 9,779KiB/s | 32,775KiB/s
ioband       9,576KiB/s | 9,367KiB/s | 34,154KiB/s

The second test ran fio sequential readers on two different groups and
give weights of 20 and 10 to each group respectively. The bandwidth
was distributed according to their weights and the BE0 reader got
higher throughput than the BE7 readers in the same group. IO priority
was preserved within the IO group.

group         group1    |         group2
weight          20      |           10   =20
------------------------+--------------------------
nr_threads      16      |      16    |     1
ionice          BE7     |     BE7    |    BE0
------------------------+--------------------------
ioband      27,513KiB/s | 3,524KiB/s | 10,248KiB/s
                        |     Total =3D 13,772KiB/s

Here is my test script.
-------------------------------------------------------------------------
arg=3D"--time_base --rw=3Dread --runtime=3D30 --directory=3D/mnt1 --size=3D=
1024M \
     --group_reporting"

sync
echo 3 > /proc/sys/vm/drop_caches

echo $$ > /cgroup/1/tasks
ionice -c 2 -n 0 fio $arg --name=3Dread1 --output=3Dread1.log --numjobs=3D=
16 &
echo $$ > /cgroup/2/tasks
ionice -c 2 -n 0 fio $arg --name=3Dread2 --output=3Dread2.log --numjobs=3D=
16 &
ionice -c 1 -n 0 fio $arg --name=3Dread3 --output=3Dread3.log --numjobs=3D=
1 &
echo $$ > /cgroup/tasks
wait
-------------------------------------------------------------------------

Be that as it way, I think that if every bio can point the iocontext
of the process, then it makes it possible to handle IO priority in the
higher level controller. A patchse has already posted by Takhashi-san.
What do you think about this idea?

  Date Tue, 22 Apr 2008 22:51:31 +0900 (JST)
  Subject [RFC][PATCH 1/10] I/O context inheritance
  From Hirokazu Takahashi <>
  http://lkml.org/lkml/2008/4/22/195

> > So you seem to be suggesting that you will move dm-ioband to request =
queue
> > so that setting up additional device setup is gone. You will also ena=
ble
> > it to do time based groups policy, so that we don't run into issues o=
n
> > seeky media. Will also enable dispatch from one group only at a time =
so
> > that we don't run into isolation issues and can do time accounting
> > accruately.
>=20
> Will that approach solve the problem of doing bandwidth control on
> logical devices? What would be the advantages compared to Vivek's
> current patches?

I will only move the point where dm-ioband grabs bios, other
dm-ioband's mechanism and functionality will stll be the same.
The advantages against to scheduler based controllers are:
 - can work with any type of block devices
 - can work with any type of IO scheduler and no need a big change.

> > If yes, then that has the potential to solve the issue. At higher lay=
er one
> > can think of enabling size of IO/number of IO policy both for proport=
ional
> > BW and max BW type of control. At lower level one can enable pure tim=
e
> > based control on seeky media.
> >
> > I think this will still left with the issue of prio with-in group as =
group
> > control is separate and you will not be maintatinig separate queues f=
or
> > each process. Similarly you will also have isseus with read vs write
> > ratios as IO schedulers underneath change.
> >
> > So I will be curious to see that implementation.
> >
> >> > > My requirements for IO controller are:
> >> > > - Implement s a higher level controller, which is located at blo=
ck
> >> > > =A0 layer and bio is grabbed in generic_make_request().
> >> >
> >> > How are you planning to handle the issue of buffered writes Andrew=
 raised?
> >>
> >> I think that it would be better to use the higher-level controller
> >> along with the memory controller and have limits memory usage for ea=
ch
> >> cgroup. And as Kamezawa-san said, having limits of dirty pages would
> >> be better, too.
> >>
> >
> > Ok. So if we plan to co-mount memory controller with per memory group
> > dirty_ratio implemented, that can work with both higher level as well=
 as
> > low level controller. Not sure if we also require some kind of a per
> > memory group flusher thread infrastructure also to make sure higher w=
eight
> > group gets more job done.

I'm not sure either that a per memory group flusher is necessary.
An we have to consider not only pdflush but also other threads which=20
issue IOs from multiple groups.

> >> > > - Can work with any type of IO scheduler.
> >> > > - Can work with any type of block devices.
> >> > > - Support multiple policies, proportional wegiht, max rate, time
> >> > > =A0 based, ans so on.
> >> > >
> >> > > The IO controller mini-summit will be held in next week, and I'm
> >> > > looking forard to meet you all and discuss about IO controller.
> >> > > https://sourceforge.net/apps/trac/ioband/wiki/iosummit
> >> >
> >> > Is there a new version of dm-ioband now where you have solved the =
issue of
> >> > sync/async dispatch with-in group? Before meeting at mini-summit, =
I am
> >> > trying to run some tests and come up with numbers so that we have =
more
> >> > clear picture of pros/cons.
> >>
> >> Yes, I've released new versions of dm-ioband and blkio-cgroup. The n=
ew
> >> dm-ioband handles sync/async IO requests separately and
> >> the write-starve-read issue you pointed out is fixed. I would
> >> appreciate it if you would try them.
> >> http://sourceforge.net/projects/ioband/files/
> >
> > Cool. Will get to testing it.

Thanks for your help in advance.

Thanks,
Ryo Tsuruta
