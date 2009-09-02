From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches from Ryo to
	track async bios.
Date: Wed, 2 Sep 2009 08:42:34 +0530
Message-ID: <661de9470909012012u4c4b5e50g816a524262642b1e@mail.gmail.com>
References: <4A9C09BE.4060404@redhat.com> <20090831185640.GF3758@redhat.com>
	 <e98e18940908311651s26de5b70ye6f4a82402956309@mail.gmail.com>
	 <20090901.160004.226800357.ryov@valinux.co.jp>
	 <20090901141142.GA13709@redhat.com>
	 <20090902095912.cdf8a55e.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755644AbZIBDMe@vger.kernel.org>
In-Reply-To: <20090902095912.cdf8a55e.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ryo Tsuruta <ryov@valinux.co.jp>, dhaval@linux.vnet.ibm.com, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, jmoyer@redhat.com, mingo@elte.hu, riel@redhat.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Wed, Sep 2, 2009 at 6:29 AM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 1 Sep 2009 10:11:42 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
>> > > > - Somebody also gave an example where there is a memory hoggin=
g process and
>> > > > =A0possibly pushes out some processes to swap. It does not sou=
nd fair to
>> > > > =A0charge those proccess for that swap writeout. These process=
es never
>> > > > =A0requested swap IO.
>> >
>> > I think that swap writeouts should be charged to the memory hoggin=
g
>> > process, because the process consumes more resources and it should=
 get
>> > a penalty.
>> >
>>
>> A process requesting memory gets IO penalty? IMHO, swapping is a ker=
nel
>> mechanism and kernel's way of providing extended RAM. If we want to =
solve
>> the issue of memory hogging by a process then right way to solve is =
to use
>> memory controller and not by charging the process for IO activity.
>> Instead, proabably a more suitable way is to charge swap activity to=
 root
>> group (where by default all the kernel related activity goes).
>>
>
> I agree. It't memcg's job.
> (Support dirty_ratio in memcg is necessary, I think)
>
> background-write-out-to-swap-for-memory-shortage should be handled
> as kernel I/O. If swap-out-by-memcg bacause of its limit is a problem=
,
> dirty_ratio for memcg should be implemetned.

I tend to agree, looks like dirty_ratio will become important along
with overcommit support in the future.

Balbir Singh.
