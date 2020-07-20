From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: Re: master - multipathd: fix fd leak when iscsi device
	logs in
Date: Mon, 20 Jul 2020 14:19:32 +0800
Message-ID: <87fb8f6a-3a33-a804-6f49-f0f029c7c13f@huawei.com>
References: <6eb10725-456f-de68-e927-1f5a9771c16c@huawei.com>
	<86d8307c-1747-2254-4f87-fac36f0d51ca@redhat.com>
	<0d26c9f6-4379-f201-a9a5-839bddef3f25@huawei.com>
	<92db2c49d0ddbbc385c6a14ef3d99a54457b908e.camel@suse.com>
	<b482dfdb-a40b-e523-1dcc-d37ddc4fc399@redhat.com>
	<f818352533682ae13fee17eb945fc2c9f62d15cd.camel@suse.com>
	<20200714222241.GK11089@octiron.msp.redhat.com>
	<1943423d8efe0deac64595f71bb56e06b52cdd7c.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1943423d8efe0deac64595f71bb56e06b52cdd7c.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: lixiaokeng <lixiaokeng@huawei.com>, linfeilong@huawei.com, dm-devel@redhat.com, lutianxiong@huawei.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On 2020/7/16 1:41, Martin Wilck wrote:
> On Tue, 2020-07-14 at 17:22 -0500, Benjamin Marzinski wrote:
>> On Mon, Jul 13, 2020 at 09:59:43PM +0200, Martin Wilck wrote:
>>> Comments welcome.
>>
>> We've agreed that dm_lib_release() is unnecessary, since we always
>> call
>> dm_udev_wait() when update_devs() is needed. dm_lib_exit() should
>> already be safe, since we only call it after cleaning up the other
>> threads. dm_task_set_cookie() looks safe to me as well, assuming that
>> we
>> have early initialization. So we are really talking about
>> dm_task_run()
>> and dm_udev_wait(). Clearly dm_udev_wait() always needs to run under
>> a
>> lock. Two threads trying to remove items from a list at the same time
>> isn't safe, and there's no way to know if there will be items on the
>> _node_ops list. The one thing I'm not sure of, is whether every call
>> to
>> dm_task_run() always needs to be locked. clearly we could, and it
>> would
>> be safer. Also, clearly for calls that add elements to _node_ops it
>> must. But for calls like DM_DEVICE_TABLE or DM_DEVICE_LIST, the only
>> issue that I can see with concurrent calls is the possibility that
>> _ioctl_buffer_double_factor gets increased too much. Perhaps that's
>> enough of a problem that we should just lock all dm_task_run() calls
>> as
>> well.
> 
> Yes. We shouldn't try to be too smart. It's easier to verify that every
> call is wrapped under a lock than to figure out later whether we made
> the case distinction right.
> 
> So, action plan:
> 
>  - remove dm_lib_release() calls
>  - Combine all possibly racy calls related to libdm initialization in
>    some early init call, protected by pthread_once()
>  - make sure dm_lib_exit() is handled correctly
>  - add locking around dm_task_run() and dm_udev_wait()
> 
> Regards
> Martin
> 

Thanks for your detailed analysis.

Look forward to the new version with solving the issue.

Regards,
Zhiqiang Liu
