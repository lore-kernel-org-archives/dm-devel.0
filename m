From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dd to a striped device with 9 disks gets much lower
 throughput when oflag=direct used
Date: Fri, 27 Jan 2012 18:24:26 +0100
Message-ID: <4F22DDCA.4000201@redhat.com>
References: <CACyXjPzWjBz0=btbL0Gx_qoxRQs7wy9m=dY1--xL29uszTpmFA@mail.gmail.com>
	<20120127085226.GA16520@infradead.org>
	<CACyXjPz1mKXtCnRnzVDotOES9QaD0kLKBP_r_GWe_FrgZq0g3g@mail.gmail.com>
	<4F22BFBC.1000709@redhat.com>
	<CACyXjPw0a8EhCSz=9tr4VN5r55c3L3jexpH3eCuWxnm+7MAQFg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACyXjPw0a8EhCSz=9tr4VN5r55c3L3jexpH3eCuWxnm+7MAQFg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 27.1.2012 16:28, Richard Sharpe napsal(a):
> On Fri, Jan 27, 2012 at 7:16 AM, Zdenek Kabelac<zkabelac@redhat.com>  wrote:
>> Dne 27.1.2012 16:03, Richard Sharpe napsal(a):
>>
>>> On Fri, Jan 27, 2012 at 12:52 AM, Christoph Hellwig<hch@infradead.org>
>>>   wrote:
>>>>
>>>> On Thu, Jan 26, 2012 at 05:06:42PM -0800, Richard Sharpe wrote:
>>>>>
>>>>> Why do I see such a big performance difference? Does writing to the
>>>>> device also use the page cache if I don't specify DIRECT IO?
>>>>
>>>>
>>>> Yes.  Trying adding conv=fdatasync to both versions to get more
>>>> realistic results.
>>>
>>>
>>> Thank you for that advice. I am comparing btrfs vs rolling my own
>>> thing using the new dm thin-provisioning approach to get something
>>> with resilient metadata, but I need to support two different types of
>>> IO, one that uses directio and one that can take advantage of the page
>>> cache.
>>>
>>> So far, btrfs gives me around 800MB/s with a similar setup (can't get
>>> exactly the same setup) without DIRECTIO and 450MB/s with DIRECTIO. a
>>> dm striped setup is giving me about 10% better throughput without
>>> DIRECTIO but only about 45% of the performance with DIRECTIO.
>>>
>>
>> You've mentioned you are using thinp device with stripping - do you have
>> stripes properly aligned on data-block-size of thinp device ?
>> (I think 9 disks are properly quite hard to align somehow on 3.2 kernel,
>> since data block size needs to be power of 2 - I think 3.3 will have this
>> relaxed to page size boundary.
>
> Actually, so far I have not used any thinp devices, since from reading
> the documentation it seemed that, for what I am doing, I need to give
> thinp a mirrored device for its metadata and a striped device for its
> data, so I thought I would try just a striped device.
>
> Actually, I can cut that back to 8 devices in the stripe. I am using
> 4kiB block sizes and writing 256kiB blocks in the dd requests and
> there is no parity involved so there should be no read-modify-write
> cycles.
>
> I imagine that if I push the write sizes up to a MB or more at a time
> throughput will get better because at the moment each device is being
> given 32kIB or 16kiB (a few devices) with DIRECTIO and with a larger
> write size they will get more data at a time.
>

Well I cannot tell how big influence proper alignment has in your case, but it 
would be good to measure it in your case.
Do you use data_block_size equal to stripe size (256KiB 512blocks ?)

Zdenek
