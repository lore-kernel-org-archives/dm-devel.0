From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/3] block: add QUEUE_FLAG_DAX for devices to advertise
 their DAX support
Date: Thu, 23 Jun 2016 11:10:21 -0700
Message-ID: <CAPcyv4g-VDXUt4_xbn3jPyYiet2gMJQT6=zXCOh9qx+qXyou0A@mail.gmail.com>
References: <1466639694-25394-1-git-send-email-toshi.kani@hpe.com>
 <1466639694-25394-2-git-send-email-toshi.kani@hpe.com>
 <CACTTzNYAxtY-d8+8Vo=Y2WpuXVaSkJk9PC7DcHXKJuU=gqvXFw@mail.gmail.com>
 <1466702773.3504.363.camel@hpe.com>
 <CACTTzNY-sQYGGy-NhGP2hCUH2ynpDD-g74sJt4zY9c9RvGGFKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CACTTzNY-sQYGGy-NhGP2hCUH2ynpDD-g74sJt4zY9c9RvGGFKw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Jun 23, 2016 at 11:05 AM, Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org> wrote:
> On Thu, Jun 23, 2016 at 8:36 PM, Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
>> On Thu, 2016-06-23 at 19:31 +0300, Yigal Korman wrote:
>>> On Thu, Jun 23, 2016 at 2:54 AM, Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
>>> >
>>> >
>>> > Currently, presence of direct_access() in block_device_operations
>>> > indicates support of DAX on its block device.  Because
>>> > block_device_operations is instantiated with 'const', this DAX
>>> > capablity may not be enabled conditinally.
>>> >
>>> > In preparation for supporting DAX to device-mapper devices, add
>>> > QUEUE_FLAG_DAX to request_queue flags to advertise their DAX
>>> > support.  This will allow to set the DAX capability based on how
>>> > mapped device is composed.
>>>
>>> Hi Toshi,
>>> This patch is very helpful!
>>> I think QUEUE_FLAG_DAX can also help with identifying dax devices in
>>> userspace.
>>> Perhaps you'd be willing to squash the patch below with this one or
>>> add it to your submission?
>>
>> Hi Yigal,
>>
>> Good idea.  Mike can probably take it into his tree, but I will include it
>> into the series if I needed to submit v3.
>>
>> Acked-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
>
> Great, Thanks!
> I'll follow the thread to see if it goes through or needs to be resubmitted.
>
>>
>> I have one minor comment below.
>
> My reply below as well.
>
>>
>>> [PATCH] block: expose QUEUE_FLAG_DAX in sysfs
>>>
>>> There's currently no way to identify DAX enabled devices in userspace.
>>>
>>> Signed-off-by: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
>>> ---
>>>  block/blk-sysfs.c | 15 +++++++++++++++
>>>  1 file changed, 15 insertions(+)
>>>
>>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>>> index 9920596..d55126d 100644
>>> --- a/block/blk-sysfs.c
>>> +++ b/block/blk-sysfs.c
>>> @@ -379,6 +379,15 @@ static ssize_t queue_wc_store(struct
>>> request_queue *q, const char *page,
>>>         return count;
>>>  }
>>>
>>> +static ssize_t queue_dax_show(struct request_queue *q, char *page)
>>> +{
>>> +       int bit;
>>> +
>>> +       bit = test_bit(QUEUE_FLAG_DAX, &q->queue_flags);
>>> +
>>> +       return queue_var_show(bit, page);
>>
>> This can be:
>>         return queue_var_show(blk_queue_dax(q), page);
>
> Oh, sure, of course you're right. thanks.
>
> Subject: [PATCH] block: expose QUEUE_FLAG_DAX in sysfs
>
> There's currently no way to identify DAX enabled devices in userspace.
>
> Signed-off-by: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
> Acked-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>

Great!

Acked-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
