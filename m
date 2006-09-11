From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Re: 1st of 2 patches for dm_emc.c and dm-multipath
	hardware handler interface
Date: Mon, 11 Sep 2006 14:29:06 -0500
Message-ID: <4505B902.9040901@cs.wisc.edu>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D13B7@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D13B7@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Goggin <egoggin@emc.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Edward Goggin wrote:
> On Friday, September 08, 2006 2:00 PM, Mike Christie wrote
>> Mike Christie wrote:
>>> Edward Goggin wrote:
>>>> +
>>>> +	rq->buffer = rq->data = h->buffer;
>>>> +	rq->data_len = len;
>>>> +	rq->bio = rq->biotail = NULL;
>>>>  
>>> I think I only suggested that you use the block layer map 
>> functions in
>>> the previous review. Now I will say, use them and fix the 
>> core code to
>>> not allocate memory or use a mempool since it will also fix the path
>>> testers at the same time :) The reason is that the scsi 
>> layer is trying
>>> to make every thing run with scatterlists. In 2.6.18, every place is
>>> converted (they should be at least), so you should not be 
>> adding another
>>> place where we send down a data buffer like this.
>>>
>> And if we are going to continue to do some scsi processing in dm I
>> already did some helpers you could base yourself off of here
>>
>> http://www.cs.wisc.edu/~michaelc/block/dm/v4/
> 
> I was first trying to submit these changes to the upstream code
> (I chose 2.6.18-rc4) since I this is what I thought you had
> suggested that I do when we talked about it briefly at the dm bof
> session at OLS.
> 
> Should I not be taking this tack?
> 

I have no idea what Alasdair wants exactly and I have no idea when we
are going to do anything.

I thought you were going to all the trouble of redoing your patches and
fixing them up for review comments because you and alasdair switched and
were staying with the hw handlers completely in dm-multpath route, or I
thought the reason you were going to all this trouble to update your
code and go through the review process was because for RHEL 5, we were
staying with the hw handlers completely in dm-multipath route.


>>
>> In dm_scsi_end_rq, you could handle errors like transient transport
>> failures for all hw handlers at one tine.
>>
>> http://www.cs.wisc.edu/~michaelc/block/dm/v4/02-dm-scsi-helpers.patch
> 
> Again, doesn't this imply a change from what we already agreed upon?
> That is fine, I just need to know.
> 
>> And in fact a lot of your patch has already been done with this patch
>>
>> http://www.cs.wisc.edu/~michaelc/block/dm/v4/03-emc.patch a year ago.
> 
> I certainly read your patch set at that time it was sent since this is
> how I learned about the availability of the blk_execute_rq_nowait
> interface.  Yet, I certainly didn't mean to plagiarize any of your
> code.  I apologize if I have inadvertently done so.  I definitely

I did not mean to accuse you of plagiarizing my work. I was asking you
to plagiarize my work :) I mean I was asking you to take advantage of
the GPL :)

I meant to say in the previous mail, I did some of the work already and
the reasons why I did some of it were for possibly a good reason, so it
makes sense for you to look at my code, ask questions about why some
things were done so you do not hit some of the problems I already did
and so you can improve upon my solution, and if possible build on top of
my code so you do not have to duplicate the work I already did.
