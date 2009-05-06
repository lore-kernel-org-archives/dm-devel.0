From: Divyesh Shah <dpshah@google.com>
Subject: Re: IO scheduler based IO Controller V2
Date: Wed, 06 May 2009 11:47:15 -0700
Message-ID: <4A01DB33.4060103@google.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <20090505132441.1705bfad.akpm@linux-foundation.org> <1241562049.11059.921.camel@twins> <20090506034254.GD4416@balbir.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759915AbZEFSrk@vger.kernel.org>
In-Reply-To: <20090506034254.GD4416@balbir.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: balbir@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>, nauman@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com
List-Id: dm-devel.ids

Balbir Singh wrote:
> * Peter Zijlstra <peterz@infradead.org> [2009-05-06 00:20:49]:
> 
>> On Tue, 2009-05-05 at 13:24 -0700, Andrew Morton wrote:
>>> On Tue,  5 May 2009 15:58:27 -0400
>>> Vivek Goyal <vgoyal@redhat.com> wrote:
>>>
>>>> Hi All,
>>>>
>>>> Here is the V2 of the IO controller patches generated on top of 2.6.30-rc4.
>>>> ...
>>>> Currently primarily two other IO controller proposals are out there.
>>>>
>>>> dm-ioband
>>>> ---------
>>>> This patch set is from Ryo Tsuruta from valinux.
>>>> ...
>>>> IO-throttling
>>>> -------------
>>>> This patch set is from Andrea Righi provides max bandwidth controller.
>>> I'm thinking we need to lock you guys in a room and come back in 15 minutes.
>>>
>>> Seriously, how are we to resolve this?  We could lock me in a room and
>>> cmoe back in 15 days, but there's no reason to believe that I'd emerge
>>> with the best answer.
>>>
>>> I tend to think that a cgroup-based controller is the way to go. 
>>> Anything else will need to be wired up to cgroups _anyway_, and that
>>> might end up messy.
>> FWIW I subscribe to the io-scheduler faith as opposed to the
>> device-mapper cult ;-)
>>
>> Also, I don't think a simple throttle will be very useful, a more mature
>> solution should cater to more use cases.
>>
> 
> I tend to agree, unless Andrea can prove us wrong. I don't think
> throttling a task (not letting it consume CPU, memory when its IO
> quota is exceeded) is a good idea. I've asked that question to Andrea
> a few times, but got no response.

I agree with what Balbir said about the effects of throttling on memory and cpu usage of that task.
Nauman and I have been working on Vivek's set of patches (which also includes some patches by Nauman) and have been testing and developing on top of that. I've found this solution to be the one that takes us closest to a complete solution. This approach works well under the assumption that the queues are backlogged and in the limited testing that we've done so far doesn't fare that badly when they are not backlogged (though there is definitely room to improve there).
With buffered writes, when the queues are not backlogged I think it might be useful to explore into vm space and see if we can do something there w/o any impact to the tasks mem or cpu usage. I don't have any brilliant ideas on this now but want to get people thinking about this.
