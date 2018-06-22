From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 4/6] libmpathpersist: fix byte swapping for
 big endian systems
Date: Fri, 22 Jun 2018 16:48:39 -0700
Message-ID: <a033a0fc-46b1-fccb-7bea-897607aa5a63@wdc.com>
References: <20180622231516.18806-1-mwilck@suse.com>
	<20180622231516.18806-4-mwilck@suse.com>
	<ea8fc535-4602-b326-73c8-7e0b18243181@wdc.com>
	<9345b1022e97ad380fc24b24fb4d5ec7bd498b6c.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9345b1022e97ad380fc24b24fb4d5ec7bd498b6c.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Eli Qiao <taget@linux.vnet.ibm.com>
List-Id: dm-devel.ids

On 06/22/18 16:27, Martin Wilck wrote:
> On Fri, 2018-06-22 at 16:19 -0700, Bart Van Assche wrote:
>> On 06/22/18 16:16, Martin Wilck wrote:
>>> -			sa_key = 0;
>>> -			for (i = 0; i < 8; ++i){
>>> -				if (i > 0)
>>> -					sa_key <<= 8;
>>> -				sa_key |= paramp->sa_key[i];
>>> -			}
>>> +			sa_key = be64_to_cpu(*(uint64_t *)&paramp-
>>>> sa_key[0]);
>>
>> Have you considered to use get_unaligned_be64() instead of the above
>> construct with casts?
> 
> Yes, I did. I opted for this construct for patch brevity (and
> admittedly, lazyness), because get_unaligned_be64() doesn't exist yet.
> I can change that of course if you insist.

Adding an implementation of get_unaligned_be64() and introducing it in 
the above code would be highly appreciated. I think that will improve 
readability.

Thanks,

Bart.
