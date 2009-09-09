From: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 26/23] io-controller: fix writer preemption
 with in a group
Date: Wed, 09 Sep 2009 00:59:30 -0400
Message-ID: <4AA73632.2020309@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<20090908222835.GD3558@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090908222835.GD3558@redhat.com>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
> o Found another issue during testing. Consider following hierarchy.
> 
> 			root
> 			/ \
> 		       R1  G1
> 			  /\
> 			 R2 W
> 
>   Generally in CFQ when readers and writers are running, reader immediately
>   preempts writers and hence reader gets the better bandwidth. In case of
>   hierarchical setup, it becomes little more tricky. In above diagram, G1
>   is a group and R1, R2 are readers and W is writer tasks.
> 
>   Now assume W runs and then R1 runs and then R2 runs. After R2 has used its
>   time slice, if R1 is schedule in, after couple of ms, R1 will get backlogged
>   again in group G1, (streaming reader). But it will not preempt R1 as R1 is
>   also a reader and also because preemption across group is not allowed for
>   isolation reasons. Hence R2 will get backlogged in G1 and will get a 
>   vdisktime much higher than W. So when G2 gets scheduled again, W will get
>   to run its full slice length despite the fact R2 is queue on same service
>   tree.
> 
>   The core issue here is that apart from regular preemptions (preemption 
>   across classes), CFQ also has this special notion of preemption with-in
>   class and that can lead to issues active task is running in a differnt
>   group than where new queue gets backlogged.
> 
>   To solve the issue keep a track of this event (I am calling it late
>   preemption). When a group becomes eligible to run again, if late_preemption
>   is set, check if there are sync readers backlogged, and if yes, expire the
>   writer after one round of dispatch.
> 
>   This solves the issue of reader not getting enough bandwidth in hierarchical
>   setups.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Conceptually a nice solution.  The code gets a little tricky,
but I guess any code dealing with these situations would end
up that way :)

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
