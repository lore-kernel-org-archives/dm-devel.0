From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Re: 1st of 2 patches for dm_emc.c and dm-multipath
	hardware handler interface
Date: Mon, 11 Sep 2006 17:23:14 -0500
Message-ID: <4505E1D2.6060607@cs.wisc.edu>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D13B7@CORPUSMX40A.corp.emc.com>
	<4505B902.9040901@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4505B902.9040901@cs.wisc.edu>
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
Cc: agk@redhat.com, Edward Goggin <egoggin@emc.com>
List-Id: dm-devel.ids

Mike Christie wrote:
> Edward Goggin wrote:
>> On Friday, September 08, 2006 2:00 PM, Mike Christie wrote
>>> Mike Christie wrote:
>>>> Edward Goggin wrote:
>>>>> +
>>>>> +	rq->buffer = rq->data = h->buffer;
>>>>> +	rq->data_len = len;
>>>>> +	rq->bio = rq->biotail = NULL;
>>>>>  
>>>> I think I only suggested that you use the block layer map 
>>> functions in
>>>> the previous review. Now I will say, use them and fix the 
>>> core code to
>>>> not allocate memory or use a mempool since it will also fix the path
>>>> testers at the same time :) The reason is that the scsi 
>>> layer is trying
>>>> to make every thing run with scatterlists. In 2.6.18, every place is
>>>> converted (they should be at least), so you should not be 
>>> adding another
>>>> place where we send down a data buffer like this.
>>>>
>>> And if we are going to continue to do some scsi processing in dm I
>>> already did some helpers you could base yourself off of here
>>>
>>> http://www.cs.wisc.edu/~michaelc/block/dm/v4/
>> I was first trying to submit these changes to the upstream code
>> (I chose 2.6.18-rc4) since I this is what I thought you had
>> suggested that I do when we talked about it briefly at the dm bof
>> session at OLS.
>>
>> Should I not be taking this tack?
>>
> 
> I have no idea what Alasdair wants exactly and I have no idea when we
> are going to do anything.
> 
> I thought you were going to all the trouble of redoing your patches and
> fixing them up for review comments because you and alasdair switched and
> were staying with the hw handlers completely in dm-multpath route, or I
> thought the reason you were going to all this trouble to update your
> code and go through the review process was because for RHEL 5, we were
> staying with the hw handlers completely in dm-multipath route.
> 

Oh yeah, the comment about making the bios allocated from a per queue
pool like the requests and changing the allocation flags that are used
in those paths should be handled no matter where we put things and what
distro we are talking about. That should be a separate patch that goes
through the block layer maintainer though, since it fixes issues in the
block sg and scsi layer we well as dm.
