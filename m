From: Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: IO scheduler based IO controller V10
Date: Tue, 29 Sep 2009 09:10:18 +0200
Message-ID: <4e5e476b0909290010r264b980v9e96c3413cc59800@mail.gmail.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	 <4ABC28DE.7050809@datenparkplatz.de>
	 <20090925202636.GC15007@redhat.com>
	 <4e5e476b0909271000u69d79346s27cccad219e49902@mail.gmail.com>
	 <20090928145655.GB8192@redhat.com>
	 <4e5e476b0909280835w3410d58aod93a29d1dcda8909@mail.gmail.com>
	 <20090928171420.GA3643@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753434AbZI2HKR@vger.kernel.org>
In-Reply-To: <20090928171420.GA3643@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com, jens.axboe@oracle.com, Tobias Oetiker <tobi@oetiker.ch>
List-Id: dm-devel.ids

Hi Vivek,
On Mon, Sep 28, 2009 at 7:14 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Sep 28, 2009 at 05:35:02PM +0200, Corrado Zoccolo wrote:
>> On Mon, Sep 28, 2009 at 4:56 PM, Vivek Goyal <vgoyal@redhat.com> wro=
te:
>> > On Sun, Sep 27, 2009 at 07:00:08PM +0200, Corrado Zoccolo wrote:
>> >> Hi Vivek,
>> >> On Fri, Sep 25, 2009 at 10:26 PM, Vivek Goyal <vgoyal@redhat.com>=
 wrote:
>> >> > On Fri, Sep 25, 2009 at 04:20:14AM +0200, Ulrich Lukas wrote:
>> >> >> Vivek Goyal wrote:
>> >> >> > Notes:
>> >> >> > - With vanilla CFQ, random writers can overwhelm a random re=
ader.
>> >> >> > =C2=A0 Bring down its throughput and bump up latencies signi=
ficantly.
>> >> >>
>> >> >>
>> >> >> IIRC, with vanilla CFQ, sequential writing can overwhelm rando=
m readers,
>> >> >> too.
>> >> >>
>> >> >> I'm basing this assumption on the observations I made on both =
OpenSuse
>> >> >> 11.1 and Ubuntu 9.10 alpha6 which I described in my posting on=
 LKML
>> >> >> titled: "Poor desktop responsiveness with background I/O-opera=
tions" of
>> >> >> 2009-09-20.
>> >> >> (Message ID: 4AB59CBB.8090907@datenparkplatz.de)
>> >> >>
>> >> >>
>> >> >> Thus, I'm posting this to show that your work is greatly appre=
ciated,
>> >> >> given the rather disappointig status quo of Linux's fairness w=
hen it
>> >> >> comes to disk IO time.
>> >> >>
>> >> >> I hope that your efforts lead to a change in performance of cu=
rrent
>> >> >> userland applications, the sooner, the better.
>> >> >>
>> >> > [Please don't remove people from original CC list. I am putting=
 them back.]
>> >> >
>> >> > Hi Ulrich,
>> >> >
>> >> > I quicky went through that mail thread and I tried following on=
 my
>> >> > desktop.
>> >> >
>> >> > ##########################################
>> >> > dd if=3D/home/vgoyal/4G-file of=3D/dev/null &
>> >> > sleep 5
>> >> > time firefox
>> >> > # close firefox once gui pops up.
>> >> > ##########################################
>> >> >
>> >> > It was taking close to 1 minute 30 seconds to launch firefox an=
d dd got
>> >> > following.
>> >> >
>> >> > 4294967296 bytes (4.3 GB) copied, 100.602 s, 42.7 MB/s
>> >> >
>> >> > (Results do vary across runs, especially if system is booted fr=
esh. Don't
>> >> > =C2=A0know why...).
>> >> >
>> >> >
>> >> > Then I tried putting both the applications in separate groups a=
nd assign
>> >> > them weights 200 each.
>> >> >
>> >> > ##########################################
>> >> > dd if=3D/home/vgoyal/4G-file of=3D/dev/null &
>> >> > echo $! > /cgroup/io/test1/tasks
>> >> > sleep 5
>> >> > echo $$ > /cgroup/io/test2/tasks
>> >> > time firefox
>> >> > # close firefox once gui pops up.
>> >> > ##########################################
>> >> >
>> >> > Now I firefox pops up in 27 seconds. So it cut down the time by=
 2/3.
>> >> >
>> >> > 4294967296 bytes (4.3 GB) copied, 84.6138 s, 50.8 MB/s
>> >> >
>> >> > Notice that throughput of dd also improved.
>> >> >
>> >> > I ran the block trace and noticed in many a cases firefox threa=
ds
>> >> > immediately preempted the "dd". Probably because it was a file =
system
>> >> > request. So in this case latency will arise from seek time.
>> >> >
>> >> > In some other cases, threads had to wait for up to 100ms becaus=
e dd was
>> >> > not preempted. In this case latency will arise both from waitin=
g on queue
>> >> > as well as seek time.
>> >>
>> >> I think cfq should already be doing something similar, i.e. givin=
g
>> >> 100ms slices to firefox, that alternate with dd, unless:
>> >> * firefox is too seeky (in this case, the idle window will be too=
 small)
>> >> * firefox has too much think time.
>> >>
>> >
>> Hi Vivek,
>> > Hi Corrado,
>> >
>> > "firefox" is the shell script to setup the environment and launch =
the
>> > broser. It seems to be a group of threads. Some of them run in par=
allel
>> > and some of these seems to be running one after the other (once pr=
evious
>> > process or threads finished).
>>
>> Ok.
>>
>> >
>> >> To rule out the first case, what happens if you run the test with=
 your
>> >> "fairness for seeky processes" patch?
>> >
>> > I applied that patch and it helps a lot.
>> >
>> > http://lwn.net/Articles/341032/
>> >
>> > With above patchset applied, and fairness=3D1, firefox pops up in =
27-28 seconds.
>>
>> Great.
>> Can you try the attached patch (on top of 2.6.31)?
>> It implements the alternative approach we discussed privately in jul=
y,
>> and it addresses the possible latency increase that could happen wit=
h
>> your patch.
>>
>> To summarize for everyone, we separate sync sequential queues, sync
>> seeky queues and async queues in three separate RR strucutres, and
>> alternate servicing requests between them.
>>
>> When servicing seeky queues (the ones that are usually penalized by
>> cfq, for which no fairness is usually provided), we do not idle
>> between them, but we do idle for the last queue (the idle can be
>> exited when any seeky queue has requests). This allows us to allocat=
e
>> disk time globally for all seeky processes, and to reduce seeky
>> processes latencies.
>>
>
> Ok, I seem to be doing same thing at group level (In group scheduling
> patches). I do not idle on individual sync seeky queues but if this i=
s
> last queue in the group, then I do idle to make sure group does not l=
oose
> its fair share and exit from idle the moment there is any busy queue =
in
> the group.
>
> So you seem to be grouping all the sync seeky queues system wide in a
> single group. So all the sync seeky queues collectively get 100ms in =
a
> single round of dispatch?

A round of dispatch (defined by tunable target_latency, default 300ms)
is subdivided between the three groups, proportionally to how many
queues are waiting in each, so if we have 1 sequential and 2 seeky
(and 0 async), we get 100ms for seq and 200ms for seeky.

> I am wondering what happens if there are lot
> of such sync seeky queues this 100ms time slice is consumed before al=
l the
> sync seeky queues got a chance to dispatch. Does that mean that some =
of
> the queues can completely skip the one dispatch round?
It can happen: if each seek costs 10ms, and you have more than 30
seeky processes, then you are guaranteed that they cannot issue all in
the same round.
When this happens, the ones that did not issue before, will be the
first ones to be issued in the next round.

Thanks,
Corrado

>
> Thanks
> Vivek
>
>> I tested with 'konsole -e exit', while doing a sequential write with
>> dd, and the start up time reduced from 37s to 7s, on an old laptop
>> disk.
>>
>> Thanks,
>> Corrado
>>
>> >
>> >> To rule out the first case, what happens if you run the test with=
 your
>> >> "fairness for seeky processes" patch?
>> >
>> > I applied that patch and it helps a lot.
>> >
>> > http://lwn.net/Articles/341032/
>> >
>> > With above patchset applied, and fairness=3D1, firefox pops up in =
27-28
>> > seconds.
>> >
>> > So it looks like if we don't disable idle window for seeky process=
es on
>> > hardware supporting command queuing, it helps in this particular c=
ase.
>> >
>> > Thanks
>> > Vivek
>> >
>
>
>



--=20
_______________________________________________________________________=
___

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.co=
m
PhD - Department of Computer Science - University of Pisa, Italy
-----------------------------------------------------------------------=
---
The self-confidence of a warrior is not the self-confidence of the aver=
age
man. The average man seeks certainty in the eyes of the onlooker and ca=
lls
that self-confidence. The warrior seeks impeccability in his own eyes a=
nd
calls that humbleness.
                               Tales of Power - C. Castaneda
