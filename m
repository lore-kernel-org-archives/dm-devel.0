From: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 17/23] io-controller: anticipatory changes
 for hierarchical fair queuing
Date: Mon, 31 Aug 2009 13:21:16 -0400
Message-ID: <4A9C068C.2020008@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<1251495072-7780-18-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1251495072-7780-18-git-send-email-vgoyal@redhat.com>
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
> This patch changes anticipatory scheduler to use queue scheduling code from
> elevator layer.  One can go back to old as by deselecting
> CONFIG_IOSCHED_AS_HIER. Even with CONFIG_IOSCHED_AS_HIER=y, with-out any
> other cgroup created, AS behavior should remain the same as old.
> 
> o AS is a single queue ioschduler, that means there is one AS queue per group.
> 
> o common layer code select the queue to dispatch from based on fairness, and
>   then AS code selects the request with-in group.
> 
> o AS runs reads and writes batches with-in group. So common layer runs timed
>   group queues and with-in group time, AS runs timed batches of reads and
>   writes.
> 
> o Note: Previously AS write batch length was adjusted synamically whenever
>   a W->R batch data direction took place and when first request from the
>   read batch completed.
> 
>   Now write batch updation takes place when last request from the write
>   batch has finished during W->R transition.
> 
> o AS runs its own anticipation logic to anticipate on reads. common layer also
>   does the anticipation on the group if think time of the group is with-in
>   slice_idle.
> 
> o Introduced few debugging messages in AS.
> 
> Signed-off-by: Nauman Rafique <nauman@google.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>
