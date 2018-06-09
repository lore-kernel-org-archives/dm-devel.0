From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dm-thin: Why is DATA_DEV_BLOCK_SIZE_MIN_SECTORS set
 to 64k?
Date: Sat, 9 Jun 2018 21:58:25 +0200
Message-ID: <9b85623a-c7ae-a6ab-b0b6-ae18833fa5cf@redhat.com>
References: <alpine.LRH.2.11.1805172332520.20870@mail.ewheeler.net>
	<8bde7e8c-d2c1-c67d-f0ca-5b121053b34f@redhat.com>
	<alpine.LRH.2.11.1806091847540.28960@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1806091847540.28960@mail.ewheeler.net>
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
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 9.6.2018 v 21:31 Eric Wheeler napsal(a):
> On Fri, 18 May 2018, Zdenek Kabelac wrote:
> 
>> Dne 18.5.2018 v 01:36 Eric Wheeler napsal(a):
>>> Hello all,
>>>
>>> Is there a technical reason that DATA_DEV_BLOCK_SIZE_MIN_SECTORS is
>>> limited to 64k?
>>>
>>> I realize that the metadata limits the maximum mappable pool size, so it
>>> needs to be bigger for big pools---but it is also the minimum COW size.
>>>
>>> Looking at the code this is enforced in pool_ctr() but isn't used anywhere
>>> else in the code.  Is it strictly necessary to enforce this minimum?
>>>
>>
>>
>> Hi
>>
>> Selection of 64k  was chosen as compromise between used space for metadada,
>> locking contention, kernel memory usage and overall speed performance.
> 
> I understand the choice.  What I am asking is this: would it be safe to
> let others make their own choice about block size provided they are warned
> about the metadata-chunk-size/pool-size limit tradeoff?
> 
> If it is safe, can we relax the restriction?  For example, 16k chunks
> still enables ~4TB pools, but with 1/4th of the CoW IO overhead on heavily
> snapshotted environments.

Hi

I can't speak for actual DM target developer - but in real world - when user 
starts to update a block - in most cases further surrounding blocks are also 
usually modified.

So it would need to be probably seen if there is some real word scenario where 
it proves there is major measurable gain by using smaller chunks (of course we 
can make a synthetic  workload writing every n-th  sector - but would be 
probably useful to see a real-case where it shows a good need for smaller 
chunks as the  memory and locking  resources usage would certainly scale a lot
a there are users for whoms 'performance' lose of 64k chunk is still too big 
and need to use bigger chunks even with snapshots.

Regards

Zdenek
