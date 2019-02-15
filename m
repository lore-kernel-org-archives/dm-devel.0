From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH v2] dm thin: Fix bug wrt FUA request
	completion
Date: Fri, 15 Feb 2019 19:21:53 +0200
Message-ID: <57cc8449-e12d-f588-f16d-47cbfde93437@arrikto.com>
References: <20190214232138.25667-1-ntsironis@arrikto.com>
	<20190215135406.GA23097@reti>
	<ff84e335-6f48-c955-fab8-5b307959663a@arrikto.com>
	<20190215151655.GB20900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190215151655.GB20900@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: ejt@redhat.com, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On 2/15/19 5:16 PM, Mike Snitzer wrote:
> On Fri, Feb 15 2019 at  9:33am -0500,
> Nikos Tsironis <ntsironis@arrikto.com> wrote:
> 
>> On 2/15/19 3:54 PM, Joe Thornber wrote:
>>> Ack.
>>>
>>> Thanks for this I was under the mistaken impression that FUA requests got split 
>>> by core dm into separate payload and PREFLUSH requests.
>>>
>>> I've audited dm-cache and that looks ok.
>>>
>>> How did you test this patch?  That missing bio_list_init() in V1 must
>>> have caused memory corruption?
>>>
>>> - Joe
>>
>> Hi Joe,
>>
>> bio_list_init() initializes the bio list's head and tail pointers to
>> NULL and pool_create() allocates the struct pool structure using
>> kzalloc() so the bio list was implicitly correctly initialized and no
>> memory corruption occurred.
> 
> Yes, exactly right.  v1 tested fine for me, so when I saw v2 I reasoned
> through why the bio_list_init() wasn't an issue and it is like you've
> said (kzalloc() saved us).
> 
> Can you help us understand how you identified this issue?  Did you have
> corruption after crash/powerfail and got to looking closer?
> 
> Thanks,
> Mike

Hi Mike,

I identified the issue through code inspection. My job involves working
with device mapper extensively, so I have been studying its code for
quite some time now. I have already submitted a couple of fixes/performance
improvements to dm-snapshot. I will be following them up with a more
extensive patch set.

In this particular case I was trying to understand how to properly
handle REQ_FUA and REQ_PREFLUSH in the context of periodic metadata
commits, like dm-thin and dm-cache do, and I stumbled on this bug while
reading dm-thin's code.

Nikos
