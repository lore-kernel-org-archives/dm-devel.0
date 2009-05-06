From: Nauman Rafique <nauman@google.com>
Subject: Re: IO scheduler based IO Controller V2
Date: Wed, 6 May 2009 10:59:13 -0700
Message-ID: <e98e18940905061059l402d6231o8b1446a1c96d2c84@mail.gmail.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
	 <20090505132441.1705bfad.akpm@linux-foundation.org>
	 <20090506023332.GA1212@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760328AbZEFR7p@vger.kernel.org>
In-Reply-To: <20090506023332.GA1212@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, peterz@infradead.org
List-Id: dm-devel.ids

On Tue, May 5, 2009 at 7:33 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, May 05, 2009 at 01:24:41PM -0700, Andrew Morton wrote:
>> On Tue, =A05 May 2009 15:58:27 -0400
>> Vivek Goyal <vgoyal@redhat.com> wrote:
>>
>> >
>> > Hi All,
>> >
>> > Here is the V2 of the IO controller patches generated on top of 2.=
6.30-rc4.
>> > ...
>> > Currently primarily two other IO controller proposals are out ther=
e.
>> >
>> > dm-ioband
>> > ---------
>> > This patch set is from Ryo Tsuruta from valinux.
>> > ...
>> > IO-throttling
>> > -------------
>> > This patch set is from Andrea Righi provides max bandwidth control=
ler.
>>
>> I'm thinking we need to lock you guys in a room and come back in 15 =
minutes.
>>
>> Seriously, how are we to resolve this? =A0We could lock me in a room=
 and
>> cmoe back in 15 days, but there's no reason to believe that I'd emer=
ge
>> with the best answer.
>>
>> I tend to think that a cgroup-based controller is the way to go.
>> Anything else will need to be wired up to cgroups _anyway_, and that
>> might end up messy.
>
> Hi Andrew,
>
> Sorry, did not get what do you mean by cgroup based controller? If yo=
u
> mean that we use cgroups for grouping tasks for controlling IO, then =
both
> IO scheduler based controller as well as io throttling proposal do th=
at.
> dm-ioband also supports that up to some extent but it requires extra =
step of
> transferring cgroup grouping information to dm-ioband device using dm=
-tools.
>
> But if you meant that io-throttle patches, then I think it solves onl=
y
> part of the problem and that is max bw control. It does not offer min=
imum
> BW/minimum disk share gurantees as offered by proportional BW control=
=2E
>
> IOW, it supports upper limit control and does not support a work cons=
erving
> IO controller which lets a group use the whole BW if competing groups=
 are
> not present. IMHO, proportional BW control is an important feature wh=
ich
> we will need and IIUC, io-throttle patches can't be easily extended t=
o support
> proportional BW control, OTOH, one should be able to extend IO schedu=
ler
> based proportional weight controller to also support max bw control.
>
> Andrea, last time you were planning to have a look at my patches and =
see
> if max bw controller can be implemented there. I got a feeling that i=
t
> should not be too difficult to implement it there. We already have th=
e
> hierarchical tree of io queues and groups in elevator layer and we ru=
n
> BFQ (WF2Q+) algorithm to select next queue to dispatch the IO from. I=
t is
> just a matter of also keeping track of IO rate per queue/group and we=
 should
> be easily be able to delay the dispatch of IO from a queue if its gro=
up has
> crossed the specified max bw.
>
> This should lead to less code and reduced complextiy (compared with t=
he
> case where we do max bw control with io-throttling patches and propor=
tional
> BW control using IO scheduler based control patches).
>
> So do you think that it would make sense to do max BW control along w=
ith
> proportional weight IO controller at IO scheduler? If yes, then we ca=
n
> work together and continue to develop this patchset to also support m=
ax
> bw control and meet your requirements and drop the io-throttling patc=
hes.
>
> The only thing which concerns me is the fact that IO scheduler does n=
ot
> have the view of higher level logical device. So if somebody has setu=
p a
> software RAID and wants to put max BW limit on software raid device, =
this
> solution will not work. One shall have to live with max bw limits on
> individual disks (where io scheduler is actually running). Do your pa=
tches
> allow to put limit on software RAID devices also?
>
> Ryo, dm-ioband breaks the notion of classes and priority of CFQ becau=
se
> of FIFO dispatch of buffered bios. Apart from that it tries to provid=
e
> fairness in terms of actual IO done and that would mean a seeky workl=
oad
> will can use disk for much longer to get equivalent IO done and slow =
down
> other applications. Implementing IO controller at IO scheduler level =
gives
> us tigher control. Will it not meet your requirements? If you got spe=
cific
> concerns with IO scheduler based contol patches, please highlight the=
se and
> we will see how these can be addressed.

In my opinion, IO throttling and dm-ioband are probably simpler, but
incomplete solutions to the problem. And for a solution to be
complete, it would have to be at a IO scheduler layer so it can do
things like taking an IO as soon as it comes and stick it to the front
of all the queues so that it can go to the disk right away. This patch
set is big, but it takes us in the right direction. Our ultimate goal
should be able to reach the level of control that we can have over CPU
and network resources. And I don't think IO throttling and dm-ioband
approaches take us in that direction.

>
> Thanks
> Vivek
>
