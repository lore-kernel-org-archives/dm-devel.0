From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: New -udm?
Date: Mon, 11 Apr 2005 02:56:49 -0700
Message-ID: <425A49E1.1010404@us.ibm.com>
References: <20050410192934.GP12752@marowsky-bree.de>	<1113164717.8372.2.camel@zezette>
	<4259B895.4070600@us.ibm.com>	<20050411011444.GA3748@osdl.org>
	<20050411084611.GA12752@marowsky-bree.de>
	<425A42EF.50808@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <425A42EF.50808@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <mikenc@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mike Christie wrote:
> Lars Marowsky-Bree wrote:
> 
>> On 2005-04-10T18:14:44, Dave Olien <dmo@osdl.org> wrote:
>>
>>
>>> You're correct.  I'll rewrite it on Thursday this week.
>>> I'll use the same methods Lars used in the dm-emc.c
>>
>>
>>
>> Note that dm-emc.c also would need to pre-allocate it's requests, but
>> doesn't right now :/
>>
>> Pre-allocating the requests sucks: Either we pre-allocate for _every_
>> path we might potentially need to send the request down on, or fix up
>> the request for the path we sent it down on (which would require us to
>> use internal knowledge about the req structs we're not supposed to
>> have).
> 
> 
> what is wrong with what you have now where you utilize the queue/path's 
> mempool by doing a blk_get_request with GFP_WAIT? Is that "fix up the 
> request..." comment meaning that you do not like to access the request 
> structure for that code, or was it meaning that you have one request 
> that is shared across paths and it needs to be cleaned up for reuse.
> 
> I think the hw_handlers setting up the requests is not so fun. Maybe the 
> block layer scsi_ioctl code could be reworked a little so that it could 
> set some of that up for us since it is very similar.

it is similar, but where the sgio paths allocated with GFP_KERNEL I used 
atomics. For the page allocation (which is way to large for the lsi 
command) I originally just preallocated a page but that seemed to 
wasteful. All I really needed to preallocate was my mode page struct and 
done a virt_to_page to get the page pointer to pass to bio_add_page (I 
wasn't sure if I could do that at the time), I guess? Since I ended up 
failing over at the controller level the preallocation would not even 
have to be per path so it would not have been that much waste.
