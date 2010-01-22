From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [RFC][PATCH 0/3] dm-raid1: fix deadlock at suspend
 after suspend was interrupted
Date: Fri, 22 Jan 2010 01:16:07 -0500
Message-ID: <4B5942A7.1050902@redhat.com>
References: <4B5618D7.4050202@redhat.com>
	<4B566EDC.5070006@ct.jp.nec.com>	<4B578A7C.6030400@redhat.com>
	<4B581C6E.80503@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B581C6E.80503@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: k-ueda@ct.jp.nec.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Ueda-san,

Kiyoshi Ueda wrote:
> On 01/21/2010 07:58 AM +0900, Takahiro Yasui wrote:
>> Kiyoshi Ueda wrote:
>>> On 01/20/2010 05:40 AM +0900, Takahiro Yasui wrote:
>>>> Introduce a target handler, cancel_presuspend, to cancel status changes
>>>> done by a target specific presuspend handler.
>>> How about using ->resume as a cancelling method?
>>> Though you have to audit existing targets' ->resume handler,
>>> I think it's better idea than adding another target handler
>>> just for this purpose.
> <snip>
>> I'm afraid that we need to modify each target's resume handler so that
>> they work properly even after processing presuspend handler but before
>> postsuspend handler.
>>
>> Please let me know if there is some oversight.
> 
> There is no oversight.
> Perhaps I should have said 'audit (and modify if necessary)'.
> 
> If auditing and modifying all targets are difficult, I don't object
> your approach which adds ->cancel_presuspend.
> But ->cancel_presuspend should be a subset of ->resume and it should
> make some code duplication.  If ->resume can always restore target state
> correctly, it may avoid such duplication.
> 
> Althrough I'm not sure the following idea is really reasonable,
> I think it should be worth to consider about it:
>   When ->postsuspend is called and the device is really suspended,
>   DMF_SUSPENDED flag is set in md->flags.
>   So targets' ->resume handler can use it to check ->postsuspend
>   had been called or not.

Hmm. It looks good idea.

By exporting dm_suspended(), targets running in kernel space, can get
the current status and choose actions to cancel state changes done
in presuspend(). One execption is dm-log-userspace. It calls user space
functions. So other solution is needed.

I will try to update this patch set according to your suggestions.

Thanks,
Taka
