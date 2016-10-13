From: Yibin Wang <wangyibin@huawei.com>
Subject: Re: dm-mpath: Handling SCSI-3 PR RELEASE in
 multi-controller environment
Date: Thu, 13 Oct 2016 19:16:13 +0800
Message-ID: <57FF6CFD.3060708@huawei.com>
References: <1CD7AA44E04E6942954526708D37BF7B287F89@szxeml509-mbs.china.huawei.com>
	<20161009151622.GA19856@lst.de> <57FF5194.4030402@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <57FF5194.4030402@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Jiangyiwen <jiangyiwen@huawei.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids



On 2016/10/13 17:19, Yibin Wang wrote:
> Hi Christoph,
>
> Thanks for your reply. Comments inline...
>
> On 2016/10/9 23:16, Christoph Hellwig wrote:
> ......
>>
>>>     - For regisetr, we should stop iteration on failure, and 
>>> followed by a
>>>      non-stopping unregister operation.
>> What do you mean with "non-stopping"?  Currently once register failed
>> for a path we then ungerigster all paths, and ignore failures (e.g. due
>> to a down path or an not already registered path).
>

BTW, did you mean using dm_pr::fail_early as the indication whether
multipath_iterate_devices() should fail early upon failure? If that's 
the case,
I can't see it is used anywhere except in dm_pr_register().

Please correct me if I am wrong.  Thanks!

> That's exactly what I meant - do not stop on failures while doing 
> unregistration.
