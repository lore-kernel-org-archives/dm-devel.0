From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: multipath_busy() stalls IO due to scsi_host_is_busy()
Date: Wed, 16 May 2012 16:29:50 +0200
Message-ID: <4FB3B9DE.1050903@itwm.fraunhofer.de>
References: <4FB39D78.9020300@itwm.fraunhofer.de> <1337177200.2985.71.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1337177200.2985.71.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dm-devel@redhat.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: dm-devel.ids

On 05/16/2012 04:06 PM, James Bottomley wrote:
> On Wed, 2012-05-16 at 14:28 +0200, Bernd Schubert wrote:
>> shost->can_queue ->  62 here
>> shost->host_busy ->  62 when one of the multipath groups does IO, further
>> multipath groups then seem to get stalled.
>>
>> I'm not sure yet why multipath_busy() does not stall IO when there is a
>> passive path in the prio group.
>>
>> Any idea how to properly address this problem?
>
> shost->can_queue is supposed to represent the maximum number of possible
> outstanding commands per HBA (i.e. the HBA hardware limit).  Assuming
> the driver got it right, the only way of increasing this is to buy a
> better HBA.

HBA is a mellanox IB adapter. I have not checked yet where the limit of 
62 queue entries comes from. This is also not a real problem. Real 
problem is that multipath suspends IO, although it should not.
As I said, if I remove the functionality of those busy functions 
everything is fine. I think what happens is that dm-multipath suspends 
IO for too long and in the mean time the other path already submits IO 
again. So I guess the underlying problem is an unfair queuing strategy.


Cheers,
Bernd
