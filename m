From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace
 barrier with sequenced flush
Date: Fri, 20 Aug 2010 12:02:49 -0400
Message-ID: <4C6EA729.7030308__21425.0119090595$1282320408$gmane$org@redhat.com>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
	<20100820132214.GA6184@lst.de> <4C6E9CAF.5010202@redhat.com>
	<20100820160009.GI5854@think>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100820160009.GI5854@think>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kerne
List-Id: dm-devel.ids

On 08/20/2010 12:00 PM, Chris Mason wrote:
> On Fri, Aug 20, 2010 at 11:18:07AM -0400, Ric Wheeler wrote:
>> On 08/20/2010 09:22 AM, Christoph Hellwig wrote:
>>> FYI: here's a little writeup to document the new cache flushing scheme,
>>> intended to replace Documentation/block/barriers.txt.  Any good
>>> suggestion for a filename in the kernel tree?
>>>
>>> ---
>>
>> I was thinking that we might be better off using the "durable
>> writes" term more since it is well documented (at least in the
>> database world, where it is the "D" in ACID properties).  Maybe
>> "durable_writes_support.txt" ?
>
> sata_lies.txt?
>
> Ok, maybe writeback_cache.txt?
>
> -chris

writeback_cache.txt is certainly the least confusing :)

ric
