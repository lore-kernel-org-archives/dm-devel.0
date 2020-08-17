From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH 3/6] multipathd: adopt static char* arr in
 sd_notify_status func
Date: Mon, 17 Aug 2020 23:59:39 +0800
Message-ID: <be6f471d-2f42-3882-e5f0-e5e4acd8531e@huawei.com>
References: <351fa23b-b730-ce22-7e89-24f26a693a6a@huawei.com>
	<2d7cd13e-d1df-5fc7-9403-1f845faf64d7@huawei.com>
	<e5de8fe451462738776acb8c4107e729828e87a2.camel@suse.com>
	<d44fd311-e66b-b196-6735-919f02e39ff4@huawei.com>
	<dbec56af9d3e25ab7c3806abf8ac86f4c160302f.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <dbec56af9d3e25ab7c3806abf8ac86f4c160302f.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, bmarzins@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>
List-Id: dm-devel.ids



On 2020/8/17 23:44, Martin Wilck wrote:
> On Mon, 2020-08-17 at 23:33 +0800, Zhiqiang Liu wrote:
>>
>> On 2020/8/17 16:35, Martin Wilck wrote:
>>> On Sun, 2020-08-16 at 09:44 +0800, Zhiqiang Liu wrote:
>>>> We adopt static char* array (sd_notify_status_msg) in
>>>> sd_notify_status func, so it looks more simpler and easier
>>>> to expand.
>>>>
>>>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>>>> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
>>>> ---
>>>>  multipathd/main.c | 26 ++++++++++++--------------
>>>>  1 file changed, 12 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/multipathd/main.c b/multipathd/main.c
>>>> index cab1d0d..a09ccd1 100644
>>>> --- a/multipathd/main.c
>>>> +++ b/multipathd/main.c
>>>> @@ -177,23 +177,21 @@ daemon_status(void)
>>>>   * I love you too, systemd ...
>>>>   */
>>>>  #ifdef USE_SYSTEMD
>>>> +static const char *sd_notify_status_msg[DAEMON_STATUS_SIZE] = {
>>>> +	[DAEMON_INIT] = "STATUS=init",
>>>> +	[DAEMON_START] = "STATUS=startup",
>>>> +	[DAEMON_CONFIGURE] = "STATUS=configure",
>>>> +	[DAEMON_IDLE] = "STATUS=up",
>>>> +	[DAEMON_RUNNING] = "STATUS=up",
>>>> +	[DAEMON_SHUTDOWN] = "STATUS=shutdown",
>>>> +};
>>>> +
>>>
>>> This repetition of "STATUS=" looks clumsy. It's not your fault,
>>> because
>>> the current code does the same thing. But if you want to clean this
>>> up,
>>> please create the notification string in a dynamic buffer, and use
>>> daemon_status() for those cases where it applies.
>>>
>>> Regards
>>> Martin
>>>
>> Thanks for your reply.
>> Besides the prefixes "STATUS=", there are also some differences
>> between
>> sd_notify_status_msg[DAEMON_IDLE|DAEMON_RUNNING] and
>> demon_status_msg[DAEMON_IDLE|DAEMON_RUNNING].
>>
>> For example,
>> sd_notify_status_msg[DAEMON_RUNNING] = "STATUS=up",
>> demon_status_msg[DAEMON_RUNNING] = "running"
>>
>> So if we create the notification string in a dynamic buffer with
>> using daemon_status, we have to make some special judgement
>> on DAEMON_RUNNING and DAEMON_IDLE status. This may be why
>> the sd_notify_status func was created.
>>
>> We can implement both solutions. Martin, which one do you prefer?
> 
> That's what I meant with "where it applies". You treat the IDLE and
> RUNNING cases first (probably in a switch statement), and use
> daemon_status() for the "default" case.
> 
> The  reason we don't differentiate between "running" and "idle" in the
> sd_notify() code path is that the daemon switches between these states
> very often (at least once per tick) and these notifications causes lots
> of dbus traffic without much value.
> 
> Regards
> Martin

Thank you for your patience.
I will do that as your suggestion.

Regards
Zhiqiang Liu
