From: Jens Axboe <axboe@kernel.dk>
Subject: Re: virtio_blk: fix defaults for max_hw_sectors and max_segment_size
Date: Wed, 26 Nov 2014 14:53:21 -0700
Message-ID: <54764BD1.2070804@kernel.dk>
References: <20141120190058.GA31214@redhat.com> <20141121095456.GB8866@infradead.org> <20141121154920.GA7644@redhat.com> <54762E9A.2070007@kernel.dk> <20141126205106.GA31815@redhat.com> <54763DEC.3050207@kernel.dk> <20141126215108.GA32077@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141126215108.GA32077@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, martin.petersen@oracle.com, mst@redhat.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, dm-devel@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
List-Id: dm-devel.ids

On 11/26/2014 02:51 PM, Mike Snitzer wrote:
> On Wed, Nov 26 2014 at  3:54pm -0500,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 11/26/2014 01:51 PM, Mike Snitzer wrote:
>>> On Wed, Nov 26 2014 at  2:48pm -0500,
>>> Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>>>
>>>> That code isn't even in mainline, as far as I can tell...
>>>
>>> Right, it is old RHEL6 code.
>>>
>>> But I've yet to determine what changed upstream that enables this to
>>> "just work" with a really large max_sectors (I haven't been looking
>>> either).
>>
>> Kind of hard for the rest of us to say, since it's triggering a BUG in
>> code we don't have :-)
> 
> I never asked you or others to weigh in on old RHEL6 code.  Once I
> realized upstream worked even if max_sectors is _really_ high I said
> "sorry for the noise".
> 
> But while you're here, I wouldn't mind getting your take on virtio-blk
> setting max_hw_sectors to -1U.
> 
> As I said in my original reply to mst: it only makes sense to set a
> really high initial upper bound like that in a driver if that driver
> goes on to stack an underlying device's limit.

-1U should just work, IMHO, there's no reason we should need to cap it
at some synthetic value. That said, it seems it should be one of those
parameters that should be negotiated up and set appropriately.

-- 
Jens Axboe
