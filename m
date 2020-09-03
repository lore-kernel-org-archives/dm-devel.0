From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v2] dax: fix for do not print error message
 for non-persistent memory block device
Date: Fri, 4 Sep 2020 00:14:16 +0800
Message-ID: <fa3c9861-1c1b-23a5-8c20-dea4c13b060d@suse.de>
References: <20200903152839.19040-1-colyli@suse.de>
	<20200903160005.GA11871@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200903160005.GA11871@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, dm-devel@redhat.com, Adrian Huang <ahuang12@lenovo.com>, Jan Kara <jack@suse.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: dm-devel.ids

On 2020/9/4 00:00, Mike Snitzer wrote:
> On Thu, Sep 03 2020 at 11:28am -0400,
> Coly Li <colyli@suse.de> wrote:
> 
>> When calling __generic_fsdax_supported(), a dax-unsupported device may
>> not have dax_dev as NULL, e.g. the dax related code block is not enabled
>> by Kconfig.
>>
>> Therefore in __generic_fsdax_supported(), to check whether a device
>> supports DAX or not, the following order should be performed,
>> - If dax_dev pointer is NULL, it means the device driver explicitly
>>   announce it doesn't support DAX. Then it is OK to directly return
>>   false from __generic_fsdax_supported().
>> - If dax_dev pointer is NOT NULL, it might be because the driver doesn't
>>   support DAX and not explicitly initialize related data structure. Then
>>   bdev_dax_supported() should be called for further check.
>>
>> IMHO if device driver desn't explicitly set its dax_dev pointer to NULL,
>> this is not a bug. Calling bdev_dax_supported() makes sure they can be
>> recognized as dax-unsupported eventually.
>>
>> This patch does the following change for the above purpose,
>>     -       if (!dax_dev && !bdev_dax_supported(bdev, blocksize)) {
>>     +       if (!dax_dev || !bdev_dax_supported(bdev, blocksize)) {
> 
> Don't think I've ever seen a one-liner fix document the diff in its
> patch header.  Really no need for that.
>
Oops, I just see this comment when I maximum my email client window now.
OK, I will post a v4 version to remove the above diff-like style comment.

Coly Li
