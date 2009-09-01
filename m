From: Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches
	from Ryo to track async bios.
Date: Tue, 1 Sep 2009 11:02:22 -0700
Message-ID: <e98e18940909011102p7af308d5n9733b12d0a693b77@mail.gmail.com>
References: <4A9C09BE.4060404@redhat.com> <20090831185640.GF3758@redhat.com>
	<e98e18940908311651s26de5b70ye6f4a82402956309@mail.gmail.com>
	<20090901.160004.226800357.ryov@valinux.co.jp>
	<20090901141142.GA13709@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Tue, Sep 1, 2009 at 7:11 AM, Vivek Goyal<vgoyal@redhat.com> wrote:
> On Tue, Sep 01, 2009 at 04:00:04PM +0900, Ryo Tsuruta wrote:
>> Hi,
>>
>> > > Hi Rik,
>> > >
>> > > Thanks for reviewing the patches. I wanted to have better understa=
nding of
>> > > where all does it help to associate a bio to the group of process =
who
>> > > created/owned the page. Hence few thoughts.
>> > >
>> > > When a bio is submitted to IO scheduler, it needs to determine the=
 group
>> > > bio belongs to and group which should be charged to. There seem to=
 be two
>> > > methods.
>> > >
>> > > - Attribute the bio to cgroup submitting process belongs to.
>> > > - For async requests, track the original owner hence cgroup of the=
 page
>> > > =E1and charge that group for the bio.
>> > >
>> > > One can think of pros/cons of both the approaches.
>> > >
>> > > - The primary use case of tracking async context seems be that if =
a
>> > > =E1process T1 in group G1 mmaps a big file and then another proces=
s T2 in
>> > > =E1group G2, asks for memory and triggers reclaim and generates wr=
ites of
>> > > =E1the file pages mapped by T1, then these writes should not be ch=
arged to
>> > > =E1T2, hence blkio_cgroup pages.
>> > >
>> > > =E1But the flip side of this might be that group G2 is a low weigh=
t group
>> > > =E1and probably too busy also right now, which will delay the writ=
e out
>> > > =E1and possibly T2 will wait longer for memory to be allocated.
>>
>> In order to avoid this wait, dm-ioband issues IO which has a page with
>> PG_Reclaim as early as possible.
>>
>
> So in above case IO is still charged to G2 but you keep a track if page=
 is
> PG_Reclaim then releae the this bio before other bios queued up in the
> group?
>
>> > > - At one point of time Andrew mentioned that buffered writes are g=
enerally a
>> > > =E1big problem and one needs to map these to owner's group. Though=
 I am not
>> > > =E1very sure what specific problem he was referring to. Can we att=
ribute
>> > > =E1buffered writes to pdflush threads and move all pdflush threads=
 in a
>> > > =E1cgroup to limit system wide write out activity?
>>
>> I think that buffered writes also should be controlled per cgroup as
>> well as synchronous writes.
>>
>
> But it is hard to achieve fairness for buffered writes becase we don't
> create complete parallel IO paths and not necessarily higher weight
> process dispatches more buffered writes to IO scheduler. (Due to page
> cache buffered write logic).
>
> So in some cases we might see buffered write fairness and in other case=
s
> not. For example, run two dd processes in two groups doing buffered wri=
tes
> and it is hard to achieve fairness between these.

If something is broken, we don't necessarily have to break it further.
Instead, we should be thinking about why its hard to achieve fairness
with buffered write back. Is there a way to change the writeback path
to send down a constant stream of IO, instead of sending down bursts?

>
> That's why the idea that if we can't ensure Buffered write vs Buffered
> write fairness in all the cases, then does it make sense to attribute
> buffered writes to pdflush and put pdflush threads into a separate grou=
p
> to limit system wide write out activity.
>
>> > > - Somebody also gave an example where there is a memory hogging pr=
ocess and
>> > > =E1possibly pushes out some processes to swap. It does not sound f=
air to
>> > > =E1charge those proccess for that swap writeout. These processes n=
ever
>> > > =E1requested swap IO.
>>
>> I think that swap writeouts should be charged to the memory hogging
>> process, because the process consumes more resources and it should get
>> a penalty.
>>
>
> A process requesting memory gets IO penalty? IMHO, swapping is a kernel
> mechanism and kernel's way of providing extended RAM. If we want to sol=
ve
> the issue of memory hogging by a process then right way to solve is to =
use
> memory controller and not by charging the process for IO activity.
> Instead, proabably a more suitable way is to charge swap activity to ro=
ot
> group (where by default all the kernel related activity goes).
>
>> > > - If there are multiple buffered writers in the system, then those=
 writers
>> > > =E1can also be forced to writeout some pages to disk before they a=
re
>> > > =E1allowed to dirty more pages. As per the page cache design, any =
writer
>> > > =E1can pick any inode and start writing out pages. So it can happe=
n a
>> > > =E1weight group task is writting out pages dirtied by a lower weig=
ht group
>> > > =E1task. If, async bio is mapped to owner's group, it might happen=
 that
>> > > =E1higher weight group task might be made to sleep on lower weight=
 group
>> > > =E1task because request descriptors are all consumed up.
>>
>> As mentioned above, in dm-ioband, the bio is charged to the page owner
>> and issued immediately.
>
> But you are doing it only for selected pages and not for all buffered
> writes?
>
>>
>> > > It looks like there does not seem to be a clean way which covers a=
ll the
>> > > cases without issues. I am just trying to think, what is a simple =
way
>> > > which covers most of the cases. Can we just stick to using submitt=
ing task
>> > > context to determine a bio's group (as cfq does). Which can result=
 in
>> > > following.
>> > >
>> > > - Less code and reduced complexity.
>> > >
>> > > - Buffered writes will be charged to pdflush and its group. If one=
 wish to
>> > > =E1limit buffered write activity for pdflush, one can move all the=
 pdflush
>> > > =E1threads into a group and assign desired weight. Writes submitte=
d in
>> > > =E1process context will continue to be charged to that process irr=
espective
>> > > =E1of the fact who dirtied that page.
>> >
>> > What if we wanted to control buffered write activity per group? If a
>> > group keeps dirtying pages, we wouldn't want it to dominate the disk
>> > IO capacity at the expense of other cgroups (by dominating the write=
s
>> > sent down by pdflush).
>>
>> Yes, I think that is true.
>>
>
> But anyway we are not able to gurantee this isolation in all the cases.
> Again I go back to example of two dd threads doing buffered writes in t=
wo
> groups.
>
> I don't mind keeping it. Just wanted to make sure that we agree and
> understand that keeping it does not mean that we get buffered write vs
> buffered write isolation/fairness in all the cases.
>
>> > > - swap activity will be charged to kswapd and its group. If swap w=
rites
>> > > =E1are coming from process context, it gets charged to process and=
 its
>> > > =E1group.
>> > >
>> > > - If one is worried about the case of one process being charged fo=
r write
>> > > =E1out of file mapped by another process during reclaim, then we c=
an
>> > > =E1probably make use of memory controller and mount memory control=
ler and
>> > > =E1io controller together on same hierarchy. I am told that with m=
emory
>> > > =E1controller, group's memory will be reclaimed by the process req=
uesting
>> > > =E1more memory. If that's the case, then IO will automatically be =
charged
>> > > =E1to right group if we use submitting task context.
>> > >
>> > > I just wanted to bring this point forward for more discussions to =
know
>> > > what is the right thing to do? Use bio tracking or not.
>>
>> Thanks for bringing it forward.
>>
>
> Thanks
> Vivek
>
