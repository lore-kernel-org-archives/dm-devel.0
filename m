From: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 20/23] io-controller: Per cgroup request
	descriptor support
Date: Mon, 31 Aug 2009 13:54:44 -0400
Message-ID: <4A9C0E64.8000401@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<1251495072-7780-21-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1251495072-7780-21-git-send-email-vgoyal@redhat.com>
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
> o Currently a request queue has got fixed number of request descriptors for
>   sync and async requests. Once the request descriptors are consumed, new
>   processes are put to sleep and they effectively become serialized. Because
>   sync and async queues are separate, async requests don't impact sync ones
>   but if one is looking for fairness between async requests, that is not
>   achievable if request queue descriptors become bottleneck.
> 
> o Make request descriptor's per io group so that if there is lots of IO
>   going on in one cgroup, it does not impact the IO of other group.
> 
> o This patch implements the per cgroup request descriptors. request pool per
>   queue is still common but every group will have its own wait list and its
>   own count of request descriptors allocated to that group for sync and async
>   queues. So effectively request_list becomes per io group property and not a
>   global request queue feature.
> 
> o Currently one can define q->nr_requests to limit request descriptors
>   allocated for the queue. Now there is another tunable q->nr_group_requests
>   which controls the requests descriptr limit per group. q->nr_requests
>   supercedes q->nr_group_requests to make sure if there are lots of groups
>   present, we don't end up allocating too many request descriptors on the
>   queue.
> 
> Signed-off-by: Nauman Rafique <nauman@google.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>
