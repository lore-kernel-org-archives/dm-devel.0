From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: add a bi_error field to struct bio
Date: Wed, 22 Jul 2015 15:59:46 -0600
Message-ID: <55B01252.90004@kernel.dk>
References: <1437398977-8492-1-git-send-email-hch@lst.de> <1437398977-8492-2-git-send-email-hch@lst.de> <55AFE643.5000704@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55AFE643.5000704@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Neil Brown <neilb@suse.de>, Liu Bo <bo.li.liu@oracle.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 07/22/2015 12:51 PM, Jens Axboe wrote:
> On 07/20/2015 07:29 AM, Christoph Hellwig wrote:
>> Currently we have two different ways to signal an I/O error on a BIO:
>>
>>   (1) by clearing the BIO_UPTODATE flag
>>   (2) by returning a Linux errno value to the bi_end_io callback
>>
>> The first one has the drawback of only communicating a single possible
>> error (-EIO), and the second one has the drawback of not beeing
>> persistent
>> when bios are queued up, and are not passed along from child to parent
>> bio in the ever more popular chaining scenario.  Having both mechanisms
>> available has the additional drawback of utterly confusing driver authors
>> and introducing bugs where various I/O submitters only deal with one of
>> them, and the others have to add boilerplate code to deal with both kinds
>> of error returns.
>>
>> So add a new bi_error field to store an errno value directly in struct
>> bio and remove the existing mechanisms to clean all this up.
>
> I think this is a good change, the only part I _really_ dislike is that
> this now bumps a struct bio from 2 cache lines to 3. Have you done any
> perf testing?

One possible solution would be to shrink bi_flags to an unsigned int, no 
problems fitting that in. Then we could stuff bi_error in that (new) 
hole, and we would end up having the same size again.

-- 
Jens Axboe
