From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: New -udm?
Date: Mon, 11 Apr 2005 11:31:35 -0700
Message-ID: <425AC287.8040709@us.ibm.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A8EF@SRMANNING.eng.emc.com>
	<425AC120.4080904@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <425AC120.4080904@us.ibm.com>
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

Mike Christie wrote:
> goggin, edward wrote:
> 
>> On Mon, 11 Apr 2005 04:53:07 -0700
>> Mike Christie <mikenc@us.ibm.com>
>>
>>> Lars Marowsky-Bree wrote:
>>>
>>>> On 2005-04-11T02:27:11, Mike Christie <mikenc@us.ibm.com> wrote:
>>>>
>>>>
>>>>
>>>>> what is wrong with what you have now where you utilize the 
>>>
>>>
>>> queue/path's
>>>
>>>>> mempool by doing a blk_get_request with GFP_WAIT? 
>>>>
>>>>
>>>>
>>>> ... what if it's trying to free memory by going to swap on 
>>>
>>>
>>> multipath,
>>>
>>>> and can't, because we're blocked on getting the request with
>>>> GFP_WAIT...?
>>>
>>>
>>> GFP_WAIT does not casue IOs though. That is the difference between 
>>> waiing on GFP_KERNEL and GFP_WAIT I thought. GFP_KERNEL can cause a 
>>> page write out which you wait on and then there is a problem since it 
>>> could be to the same disk you are trying to recover. But if you are 
>>> just waiting for something to be returned to the mempool like with 
>>> GFP_WAIT + blk_get_request you should be ok as long as the code below 
>>> you eventually give up their resources and frees the requests you are 
>>> waiting on?
>>>
>>
>>  
>> A deterministic, fool-proof solution for this case must deal with
>> the possibility that in order to make progress, one cannot depend
>> that any memory resource which has previously been used will free
>> up -- because the freeing of that memory may be dependent on
>> making progress at this point.  Even using GFP_WAIT, it is possible
>> that all previously allocated bio (not sure about requests) mempool
>> resources needed are queued waiting for a multipath path to become
>> usable again.
> 
> 
> For requests...
> I thought the only way you can have a problem is if userspace is doing 
> sg io directly to the paths, like the path testers, and the lower level 
> drivers do not free resources (like if some evil scsi driver decides to 
> block forever in its error handler while multiple sg io requests are 
> queued for example). There is no one else above us so we do not have to 
> worry about that case where people above dm call blk_get_request on the 
> same queue, deplete the mempool and never free those requests so we 
> block forever on some layer above us which cannot proceed becuase we 
> cannot.
> 
> Using blk_get_request + GFP_WAIT allows dm to use the same block layer 
> code path as __make_request for memory allcoation failures, so if there 
> is a problem with that code itself (like needing to preallocate 
> correctly or some other issue like that - I am not saying preallocation 
> is a problem there) 

maybe starvation with multiple waiters though?

it should be solved for all of us there. It makes no
> sense to have a fool proof multipath but flakey block layer and if we 
> can share code all the better.
> 
>>
>> I don't see a way around needing to use pre-allocated bio memory
>> which is reserved strictly for this purpose -- albeit it is possible
>> that a single bio could be reserved for making progress in serial
>> fashion across all multipaths which are in this state.
>>
>>
>>>> Your patch helps, because it means we need less memory.
>>>>
>>>> But, ultimately, we ought to preallocate the requests 
>>>
>>>
>>> already when the
>>>
>>>> hw-handler is initialized for a map (because presumably at that time
>>>> we'll have enough memory, or can just fail the table 
>>>
>>>
>>> setup). From that
>>>
>>>> point on, our memory useage should not grow.
>>>>
>>
>>
>> -- 
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
> 
> 
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
