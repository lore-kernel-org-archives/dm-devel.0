From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH V3 2/5] multipathd: use daemon_status_msg to
 construct sd notify msg in do_sd_notify func
Date: Mon, 31 Aug 2020 19:03:56 +0800
Message-ID: <777ef6aa-f173-0f65-f454-5ae87986f79c@huawei.com>
References: <dc4f5730-157f-8a27-247c-628f38bb6cb5@huawei.com>
	<8e24c49b-6f56-e7ea-7f2a-e7bd9d266e23@huawei.com>
	<cb97dfa97281bf9fe6738ffbf6abb20b5e2991ae.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cb97dfa97281bf9fe6738ffbf6abb20b5e2991ae.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-US
To: Martin Wilck <mwilck@suse.com>
Cc: lixiaokeng <lixiaokeng@huawei.com>, yanxiaodan@huawei.com, linfeilong@huawei.com, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On 2020/8/31 17:55, Martin Wilck wrote:
> Hello Zhiqiang,
> 
> On Sat, 2020-08-29 at 11:03 +0800, Zhiqiang Liu wrote:
>> sd_notify_status() is very similar with daemon_status(), except
>> DAEMON_IDLE and DAEMON_RUNNING state. As suggested by Martin,
>> we can create the sd notification string in a dynamic buffer,
>> and treat DAEMON_IDLE and DAEMON_RUNNING cases first. Then,
>> we can use daemon_status_msg[state] for other cases.
>>
>> V2->V3:
>> - set MSG_SIZE to 32 and use safe_sprintf as suggested by Martin.
>>
>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
>> ---
>>  multipathd/main.c | 34 ++++++++++++----------------------
>>  1 file changed, 12 insertions(+), 22 deletions(-)
> 
> Thanks again. I'd like to modify the patch slightly as attached. 
> I'm sorry that I didn't mention these minor issues in my previous
> reviews. I'm sending you the fixup patch in order to short-circuit 
> the procedure a bit and save both of us some work.
> 
> Would this be ok for you?
> If yes, please resubmit this as v4.
> 
> Regards,
> Martin
> 

Thanks for your suggestion.
I will send the v4 patch as your suggestion.

Regards,
Zhiqiang Liu
