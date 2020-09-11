From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] dax: fix for do not print error message for
 non-persistent memory block device
Date: Fri, 11 Sep 2020 08:54:46 +0800
Message-ID: <92b65cc3-37b6-d038-148a-a32db682830b@suse.de>
References: <20200903115549.17845-1-colyli@suse.de>
	<20200903160608.GU878166@iweiny-DESK2.sc.intel.com>
	<c202e410-99af-3f15-0f76-def5fba7a83a@suse.de>
	<CA+RJvhxBHriCuJhm-D8NvJRe3h2MLM+ZMFgjeJjrRPerMRLvdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+RJvhxBHriCuJhm-D8NvJRe3h2MLM+ZMFgjeJjrRPerMRLvdg@mail.gmail.com>
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
To: John Pittman <jpittman@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, dm-devel@redhat.com, Adrian Huang <ahuang12@lenovo.com>, Jan Kara <jack@suse.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: dm-devel.ids

On 2020/9/11 04:29, John Pittman wrote:
> But it should be moved prior to the two bdev_dax_pgoff() checks right?
>  Else a misaligned partition on a dax unsupported block device can
> print the below messages.
> 
> kernel: sda1: error: unaligned partition for dax
> kernel: sda2: error: unaligned partition for dax
> kernel: sda3: error: unaligned partition for dax
> 

Aha, yes you are right, I agree with you.

Coly Li


> Reviewed-by: John Pittman <jpittman@redhat.com>
> 
> On Thu, Sep 3, 2020 at 12:12 PM Coly Li <colyli@suse.de> wrote:
>>
>> On 2020/9/4 00:06, Ira Weiny wrote:
>>> On Thu, Sep 03, 2020 at 07:55:49PM +0800, Coly Li wrote:
>>>> When calling __generic_fsdax_supported(), a dax-unsupported device may
>>>> not have dax_dev as NULL, e.g. the dax related code block is not enabled
>>>> by Kconfig.
>>>>
>>>> Therefore in __generic_fsdax_supported(), to check whether a device
>>>> supports DAX or not, the following order should be performed,
>>>> - If dax_dev pointer is NULL, it means the device driver explicitly
>>>>   announce it doesn't support DAX. Then it is OK to directly return
>>>>   false from __generic_fsdax_supported().
>>>> - If dax_dev pointer is NOT NULL, it might be because the driver doesn't
>>>>   support DAX and not explicitly initialize related data structure. Then
>>>>   bdev_dax_supported() should be called for further check.
>>>>
>>>> IMHO if device driver desn't explicitly set its dax_dev pointer to NULL,
>>>> this is not a bug. Calling bdev_dax_supported() makes sure they can be
>>>> recognized as dax-unsupported eventually.
>>>>
>>>> This patch does the following change for the above purpose,
>>>>     -       if (!dax_dev && !bdev_dax_supported(bdev, blocksize)) {
>>>>     +       if (!dax_dev || !bdev_dax_supported(bdev, blocksize)) {
>>>>
>>>>
>>>> Fixes: c2affe920b0e ("dax: do not print error message for non-persistent memory block device")
>>>> Signed-off-by: Coly Li <colyli@suse.de>
>>>
>>> I hate to do this because I realize this is a bug which people really need
>>> fixed.
>>>
>>> However, shouldn't we also check (!dax_dev || !bdev_dax_supported()) as the
>>> _first_ check in __generic_fsdax_supported()?
>>>
>>> It seems like the other pr_info's could also be called when DAX is not
>>> supported and we probably don't want them to be?
>>>
>>> Perhaps that should be a follow on patch though.  So...
>>
>> I am not author of c2affe920b0e, but I guess it was because
>> bdev_dax_supported() needed blocksize, so blocksize should pass previous
>> checks firstly to make sure bdev_dax_supported() has a correct blocksize
>> to check.
>>
>>>
>>> As a direct fix to c2affe920b0e
>>>
>>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>>
>> Thanks.
>>
>> Coly Li
>>
[snipped]
