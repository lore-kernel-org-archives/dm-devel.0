From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] dm-log: fix return value in create_log_context
	function
Date: Thu, 18 Dec 2008 12:57:37 -0600
Message-ID: <1FD128DB-404C-4758-A276-6149DAAE8F74@redhat.com>
References: <49372F1E.5060200@redhat.com> <494A8BD3.1020708@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <494A8BD3.1020708@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

We might also want to change the message in that case then too,  
right?  Maybe "Unable to create disk io client"?

  brassow

On Dec 18, 2008, at 11:43 AM, Takahiro Yasui wrote:

> Hi all,
>
> What do you think about this patch?
>
>> DMWARN("couldn't allocate disk io client");
>
> This message is not necessarily related to ENOMEM and returning
> variable "r" is better than doing -ENOMEM in terms of function
> encapsulation.
>
> I appreciate any comments.
>
> Regards,
> Taka
>
>
>> Hi,
>>
>> This is very trivial fix, but let me post it to improve code
>> readability. In the current implementation, caller function
>> does not use the return value and no action is changed.
>>
>> Regards,
>> ---
>> Takahiro Yasui
>> Hitachi Computer Products (America) Inc.
>>
>>
>>
>> When dm_io_client_create function fails in create_log_context
>> function, return value is set to variable r but it is not used.
>> r should be returned.
>>
>>
>> Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
>> ---
>> drivers/md/dm-log.c |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: linux-2.6.28-rc7/drivers/md/dm-log.c
>> ===================================================================
>> --- linux-2.6.28-rc7.orig/drivers/md/dm-log.c
>> +++ linux-2.6.28-rc7/drivers/md/dm-log.c
>> @@ -461,7 +461,7 @@ static int create_log_context(struct dm_
>> 			r = PTR_ERR(lc->io_req.client);
>> 			DMWARN("couldn't allocate disk io client");
>> 			kfree(lc);
>> -			return -ENOMEM;
>> +			return r;
>> 		}
>>
>> 		lc->disk_header = vmalloc(buf_size);
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
