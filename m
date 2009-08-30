From: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 11/23] io-controller: Introduce group idling
Date: Sat, 29 Aug 2009 20:38:20 -0400
Message-ID: <4A99C9FC.2010004@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<1251495072-7780-12-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1251495072-7780-12-git-send-email-vgoyal@redhat.com>
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
> o It is not always that IO from a process or group is continuous. There are
>   cases of dependent reads where next read is not issued till previous read
>   has finished. For such cases, CFQ introduced the notion of slice_idle,
>   where we idle on the queue for sometime hoping next request will come
>   and that's how fairness is provided otherwise queue will be deleted
>   immediately from the service tree and this process will not get the
>   fair share.
> 
> o This patch introduces the similar concept at group level. Idle on the group
>   for a period of "group_idle" which is tunable through sysfs interface. So
>   if a group is empty and about to be deleted, we idle for the next request.
> 
> o This patch also introduces the notion of wait busy where we wait for one
>   extra group_idle period even if queue has consumed its time slice. The
>   reason being that group will loose its share upon removal from service
>   tree as some other entity will be picked for dispatch and vtime jump will
>   take place.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
