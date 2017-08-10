From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 1/9] QUEUE_FLAG_NOWAIT to indicate device supports nowait
Date: Thu, 10 Aug 2017 12:15:08 -0500
Message-ID: <05106658-7bc4-4054-fbda-3b33ea32e215@suse.de>
References: <20170808203246.sdjnpzixxz5brjaf@kernel.org>
 <51cdf08c-c8a4-6bbd-3342-7cdb2b510668@suse.de>
 <20170809150205.4dm3vskyjqzyejsq@kernel.org>
 <de5000a0-a52c-bce4-de4f-ab39aae4b593@suse.de>
 <20170809202125.5zs4h45luqlub5if@kernel.org>
 <b3017adc-619d-06f7-ffb5-5ba14f01ffc2@suse.de>
 <20170810011742.s45ugh55jslvkguu@kernel.org>
 <a20baa0e-261b-f912-5bca-40c7523d7c44@suse.de>
 <3a23e4af-9ec0-43f3-5aa0-5af68e0dac07@kernel.dk>
 <bfbd8644-1cd9-a748-1039-3dc08e4c45f5@suse.de>
 <20170810142515.GC14925@quack2.suse.cz>
 <e0c72d10-388e-efac-242d-1b3542490085@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <e0c72d10-388e-efac-242d-1b3542490085@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>
Cc: Shaohua Li <shli@kernel.org>, linux-block@vger.kernel.org, hch@infradead.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On 08/10/2017 09:28 AM, Jens Axboe wrote:
> On 08/10/2017 08:25 AM, Jan Kara wrote:
>> On Thu 10-08-17 06:49:53, Goldwyn Rodrigues wrote:
>>> On 08/09/2017 09:17 PM, Jens Axboe wrote:
>>>> On 08/09/2017 08:07 PM, Goldwyn Rodrigues wrote:
>>>>>>>>>>> No, from a multi-device point of view, this is inconsistent. I
>>>>>>>>>>> have tried the request bio returns -EAGAIN before the split, but
>>>>>>>>>>> I shall check again. Where do you see this happening?
>>>>>>>>>>
>>>>>>>>>> No, this isn't multi-device specific, any driver can do it.
>>>>>>>>>> Please see blk_queue_split.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> In that case, the bio end_io function is chained and the bio of
>>>>>>>>> the split will replicate the error to the parent (if not already
>>>>>>>>> set).
>>>>>>>>
>>>>>>>> this doesn't answer my question. So if a bio returns -EAGAIN, part
>>>>>>>> of the bio probably already dispatched to disk (if the bio is
>>>>>>>> splitted to 2 bios, one returns -EAGAIN, the other one doesn't
>>>>>>>> block and dispatch to disk), what will application be going to do?
>>>>>>>> I think this is different to other IO errors. FOr other IO errors,
>>>>>>>> application will handle the error, while we ask app to retry the
>>>>>>>> whole bio here and app doesn't know part of bio is already written
>>>>>>>> to disk.
>>>>>>>
>>>>>>> It is the same as for other I/O errors as well, such as EIO. You do
>>>>>>> not know which bio of all submitted bio's returned the error EIO.
>>>>>>> The application would and should consider the whole I/O as failed.
>>>>>>>
>>>>>>> The user application does not know of bios, or how it is going to be
>>>>>>> split in the underlying layers. It knows at the system call level.
>>>>>>> In this case, the EAGAIN will be returned to the user for the whole
>>>>>>> I/O not as a part of the I/O. It is up to application to try the I/O
>>>>>>> again with or without RWF_NOWAIT set. In direct I/O, it is bubbled
>>>>>>> out using dio->io_error. You can read about it at the patch header
>>>>>>> for the initial patchset at [1].
>>>>>>>
>>>>>>> Use case: It is for applications having two threads, a compute
>>>>>>> thread and an I/O thread. It would try to push AIO as much as
>>>>>>> possible in the compute thread using RWF_NOWAIT, and if it fails,
>>>>>>> would pass it on to I/O thread which would perform without
>>>>>>> RWF_NOWAIT. End result if done right is you save on context switches
>>>>>>> and all the synchronization/messaging machinery to perform I/O.
>>>>>>>
>>>>>>> [1] http://marc.info/?l=linux-block&m=149789003305876&w=2
>>>>>>
>>>>>> Yes, I knew the concept, but I didn't see previous patches mentioned
>>>>>> the -EAGAIN actually should be taken as a real IO error. This means a
>>>>>> lot to applications and make the API hard to use. I'm wondering if we
>>>>>> should disable bio split for NOWAIT bio, which will make the -EAGAIN
>>>>>> only mean 'try again'.
>>>>>
>>>>> Don't take it as EAGAIN, but read it as EWOULDBLOCK. Why do you say
>>>>> the API is hard to use? Do you have a case to back it up?
>>>>
>>>> Because it is hard to use, and potentially suboptimal. Let's say you're
>>>> doing a 1MB write, we hit EWOULDBLOCK for the last split. Do we return a
>>>> short write, or do we return EWOULDBLOCK? If the latter, then that
>>>> really sucks from an API point of view.
>>>>
>>>>> No, not splitting the bio does not make sense here. I do not see any
>>>>> advantage in it, unless you can present a case otherwise.
>>>>
>>>> It ties back into the "hard to use" that I do agree with IFF we don't
>>>> return the short write. It's hard for an application to use that
>>>> efficiently, if we write 1MB-128K but get EWOULDBLOCK, the re-write the
>>>> full 1MB from a different context.
>>>>
>>>
>>> It returns the error code only and not short reads/writes. But isn't
>>> that true for all system calls in case of error?
>>>
>>> For aio, there are two result fields in io_event out of which one could
>>> be used for error while the other be used for amount of writes/reads
>>> performed. However, only one is used. This will not work with
>>> pread()/pwrite() calls though because of the limitation of return values.
>>>
>>> Finally, what if the EWOULDBLOCK is returned for an earlier bio (say
>>> offset 128k) for a 1MB pwrite(), while the rest of the 7 128K are
>>> successful. What short return value should the system call return?
>>
>> This is indeed tricky. If an application submits 1MB write, I don't think
>> we can afford to just write arbitrary subset of it. That just IMHO too much
>> violates how writes traditionally behaved. Even short writes trigger bugs
>> in various applications but I'm willing to require that applications using
>> NOWAIT IO can handle these. However writing arbitrary subset looks like a
>> nasty catch. IMHO we should not submit further bios until we are sure
>> current one does not return EWOULDBLOCK when splitting a larger one...
> 
> Exactly, that's the point that both Shaohua and I was getting at. Short
> writes should be fine, especially if NOWAIT is set. Discontig writes
> should also be OK, but it's horrible and inefficient. If we do that,
> then using this feature is a net-loss, not a win by any stretch.
> 

To make sure I understand this, we disable bio splits for NOWAIT bio so
we return EWOULDBLOCK for the entire I/O.

-- 
Goldwyn
