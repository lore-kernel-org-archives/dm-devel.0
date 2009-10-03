From: Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: IO scheduler based IO controller V10
Date: Sat, 3 Oct 2009 14:43:14 +0200
Message-ID: <4e5e476b0910030543o776fb505ka0ce38da9d83b33c@mail.gmail.com>
References: <200910021255.27689.czoccolo@gmail.com>
	 <20091002124921.GA4494@redhat.com>
	 <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
	 <1254497520.10392.11.camel@marge.simson.net>
	 <20091002154020.GC4494@redhat.com>
	 <12774.1254502217@turing-police.cc.vt.edu>
	 <20091002195815.GE4494@redhat.com>
	 <4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com>
	 <20091002222756.GG4494@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756104AbZJCMnM@vger.kernel.org>
In-Reply-To: <20091002222756.GG4494@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, Mike Galbraith <efault@gmx.de>, Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, riel@redhat.com
List-Id: dm-devel.ids

On Sat, Oct 3, 2009 at 12:27 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sat, Oct 03, 2009 at 12:14:28AM +0200, Corrado Zoccolo wrote:
>> In fact I think that the 'rotating' flag name is misleading.
>> All the checks we are doing are actually checking if the device truly
>> supports multiple parallel operations, and this feature is shared by
>> hardware raids and NCQ enabled SSDs, but not by cheap SSDs or single
>> NCQ-enabled SATA disk.
>>
>
> While we are at it, what happens to notion of priority of tasks on SSDs?
This is not changed by proposed patch w.r.t. current CFQ.
> Without idling there is not continuous time slice and there is no
> fairness. So ioprio is out of the window for SSDs?
I haven't NCQ enabled SSDs here, so I can't test it, but it seems to
me that the way in which queues are sorted in the rr tree may still
provide some sort of fairness and service differentiation for
priorities, in terms of number of IOs.
Non-NCQ SSDs, instead, will still have the idle window enabled, so it
is not an issue for them.
>
> On SSDs, will it make more sense to provide fairness in terms of number or
> IO or size of IO and not in terms of time slices.
Not on all SSDs. There are still ones that have a non-negligible
penalty on non-sequential access pattern (hopefully the ones without
NCQ, but if we find otherwise, then we will have to benchmark access
time in I/O scheduler to select the best policy). For those, time
based may still be needed.

Thanks,
Corrado

>
> Thanks
> Vivek
