From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: Re: [dm- devel][PATCH] checker: add input check of state
 in checker_state_name func
Date: Mon, 10 Aug 2020 19:38:14 +0800
Message-ID: <c4de4f89-05bd-dc0b-d937-9ed6e09c4853@huawei.com>
References: <9c67963b-477f-b3f5-8c8c-048de9357ff9@huawei.com>
	<2625305858d9381eb1f69642d6bbcd743a995af2.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2625305858d9381eb1f69642d6bbcd743a995af2.camel@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, christophe.varoqui@opensvc.com, zkabelac@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>
List-Id: dm-devel.ids



On 2020/8/10 18:17, Martin Wilck wrote:
> On Mon, 2020-08-10 at 09:14 +0800, Zhiqiang Liu wrote:
>> In checker_state_name func, we donot check whether input i
>> is valid. It may cause array access violation problem.
>>
>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>> ---
>>  libmultipath/checkers.c | 26 +++++++++++++++-----------
>>  libmultipath/checkers.h |  3 ++-
>>  2 files changed, 17 insertions(+), 12 deletions(-)
>>
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> Thanks for the patch.
> 
> Btw, are you currently reviewing multipath-tools with coverity or some
> similar tool?
> 
> Martin

Thanks for your reply.
Actually, I just read and learned multipath-tools code without using any tools.
In the future, we may try to use some scanning tools for deep analysis.

Thanks for your review, again.
