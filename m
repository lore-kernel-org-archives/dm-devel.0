From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [BUG] dm-thin metadata operation failed due to
 -ENOSPC returned by dm_pool_alloc_data_block() after processing DISCARD
 bios
Date: Tue, 3 Apr 2018 11:40:08 +0200
Message-ID: <cb9e0472-7a2d-0a25-f0d3-416404bac5d2@redhat.com>
References: <CAAR726JcYQpSSXAhL6=yPmzT0MOZRG_WwjC63q0QSMzT5qNPSg@mail.gmail.com>
	<e0f8863c-ee85-7962-1ae5-51eba3b43eb0@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e0f8863c-ee85-7962-1ae5-51eba3b43eb0@redhat.com>
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
To: Dennis Yang <dennisyang@qnap.com>, ejt@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 3.4.2018 v 11:31 Zdenek Kabelac napsal(a):
> Dne 3.4.2018 v 06:07 Dennis Yang napsal(a):
>> Hi,
>>
>> Recently we have came across an issue that dm-thin pool will be
>> switched to READ_ONLY mode because dm_pool_alloc_data_block() returns
>> -ENOSPC. AFAIK, this should not happen since alloc_data_block() will
>> check if there is any free space (and commit metadata if it first
>> reports no free space) before it allocates pool block. In addition,
>> total virtual space of all thin volumes is smaller than the pool
>> physical space in my testing environment which makes pool impossible
>> to run out of space.
>>
> 
> 
> Hi
> 
> 
> Which kernel has been used during testing - was this upstream ?
> (4.16??)
> 

Ahh - wrongly applied fstrim - yep reproducible even on this smaller data set.

I'll open BZ case for this.


Regards


Zdenek
