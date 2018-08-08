From: xiaojin <jin.xiao@intel.com>
Subject: Re: [PATCH] dm-bufio: adjust the reserved buffer for
 dm-verify-target.
Date: Wed, 8 Aug 2018 13:51:32 +0800
Message-ID: <5B6A84E4.2020805@intel.com>
References: <1533704823-5448-1-git-send-email-jin.xiao@intel.com>
 <20180808052514.GA20034@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180808052514.GA20034@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, yanmin.zhang@intel.com
List-Id: dm-devel.ids



On 2018年08月08日 13:25, Greg KH wrote:
> On Wed, Aug 08, 2018 at 01:07:03PM +0800, xiao jin wrote:
>> We hit the BUG() report at include/linux/scatterlist.h:144!
>> The callback is as bellow:
>>    => verity_work
>>    => verity_hash_for_block
>>    => verity_verify_level
>>    => verity_hash
>>    => verity_hash_update
>>    => sg_init_one
>>    => sg_set_buf
>>
>> More debug shows the root cause. When creating dufio client it
>> uses the __vmalloc() to allocate the buffer data for the reserved
>> dm_buffer. The buffer that allocated by the __vmalloc() is invalid
>> according to the __virt_addr_valid().
>>
>> Mostly the reserved dm_buffer is not touched. But occasionally
>> it might fail to allocate the dm_buffer data when we try to
>> allocate in the __alloc_buffer_wait_no_callback(). Then it has
>> to take the reserved dm_buffer for usage. Finally it reports the
>> BUG() as virt_addr_valid() detects the buffer data address is invalid.
>>
>> The patch is to adjust the reserved buffer for dm-verity-target. We
>> allocated two dm_buffers into the reserved buffers list when creating
>> the buffer interface. The first dm_buffer in the reserved buffer list
>> is allocated by the __vmalloc(), it's not used after that. The second
>> dm_buffer in the reserved buffer list is allocated by the
>> __get_free_pages() which can be consumed after that.
>>
>> Signed-off-by: xiao jin <jin.xiao@intel.com>
>> ---
>>   drivers/md/dm-bufio.c         | 4 ++--
>>   drivers/md/dm-verity-target.c | 2 +-
>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>
> </formletter>
Thanks, I will resend to review without the stable mail list.
