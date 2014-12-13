From: Jianjian Huo <samuel.huo@gmail.com>
Subject: Re: [dm-devel] [PATCH v2] staging: writeboost: Add dm-writeboost
Date: Fri, 12 Dec 2014 22:45:30 -0800
Message-ID: <CAB=cV2Rvp95xuKNd0WzfLpMGrwdSCPxGt6npo+FH0H1y_5kY9Q@mail.gmail.com>
References: <54883195.1060304@gmail.com> <20141211152626.GA8196@redhat.com>
 <548A39E7.80508@gmail.com> <20141212142447.GA30315@debian>
 <548B0517.6070603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <548B0517.6070603@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: device-mapper development <dm-devel@redhat.com>
Cc: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org, thornber@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

If I understand it correctly, the whole idea indeed is very simple,
the consumer/provider and circular buffer model. use SSD as a circular
write buffer, write flush thread stores incoming writes to this buffer
sequentially as provider, and writeback thread write those data logs
sequentially into backing device as consumer.

If writeboost can do that without any random writes, then probably it
can save SSD/FTL of doing a lot of dirty jobs, and utilize the faster
sequential read/write performance from SSD. That'll be awesome.
However, I saw every data log segment in its design has meta data
header, like dirty_bits, so I guess writeboost has to randomly write
those data headers of stored data logs in SSD; also, splitting all bio
into 4KB will hurt its ability to get max raw SSD throughput, modern
NAND Flash has pages much bigger than 4KB; so overall I think the
actual benefits writeboost gets from this design will be discounted.

The good thing is that it seems writeboost doesn't use garbage
collection to clean old invalid logs, this will avoid the double
garage collection effect other caching module has, which essentially
both caching module and internal SSD will perform garbage collections
twice.

And one question, how long will be data logs replay time during init,
if SSD is almost full of dirty data logs?

Jianjian

On Fri, Dec 12, 2014 at 7:09 AM, Akira Hayakawa <ruby.wktk@gmail.com> wrote:
>> However, after looking at the current code, and using it I think it's
>> a long, long way from being ready for production.  As we've already
>> discussed there are some very naive design decisions in there, such as
>> copying every bio payload to another memory buffer, splitting all io
>> down to 4k.  Think about the cpu overhead and memory consumption!
>> Think about how it will perform when memory is constrained and it
>> can't allocate many of those rambufs!  I'm sure more issues will be
>> found if I read further.
> These decisions are made based on measurement. They are not naive.
> I am a man who dislikes performance optimization without measurement.
> As a result, I regard things brought by the simplicity much important
> than what's from other design decisions possible.
>
> About the CPU consumption,
> the average CPU consumption while performing random write fio
> with consumer level SSD is only 3% or so,
> which is 5 times efficient than bcache per iops.
>
> With RAM-backed cache device, it reaches about 1.5GB/sec throughput.
> Even in this case the CPU consumption is only 12%.
> Please see this post,
> http://www.redhat.com/archives/dm-devel/2014-February/msg00000.html
>
> I don't think the CPU consumption is small enough to ignore.
>
> About the memory consumption,
> you seem to misunderstand the fact.
> The rambufs are not dynamically allocated but statically.
> The default amount is 8MB and this is usually not to argue.
>
>> Mike raised the question of why you want this in the kernel so much?
>> You'd find none of the distros would support it; so it doesn't widen
>> your audience much.  It's far better for you to maintain it outside of
>> the kernel at this point.  Any users will be bold, adventurous people,
>> who will be quite capable of building a kernel module.
> Some people deploy Writeboost in their daily use.
> The sound of "log-structured" seems to easily attract storage guys' attention.
> If this driver is merged into upstream, I think it gains many audience and
> thus feedback.
> When my driver was introduced by Phoronix before, it actually drew attentions.
> They must wait for Writeboost become available in upstream.
> http://www.phoronix.com/scan.php?page=news_item&px=MTQ1Mjg
>
>> I'm sorry to have disappointed you so, but if I let this go upstream
>> it would mean a massive amount of support work for me, not to mention
>> a damaged reputation for dm.
> If you read the code further, you will find how simple the mechanism is.
> Not to mention the code itself is.
>
> - Akira
>
> On 12/12/14 11:24 PM, Joe Thornber wrote:
>> On Fri, Dec 12, 2014 at 09:42:15AM +0900, Akira Hayakawa wrote:
>>> The SSD-caching should be log-structured.
>>
>> No argument there, and this is why I've supported you with
>> dm-writeboost over the last couple of years.
>>
>> However, after looking at the current code, and using it I think it's
>> a long, long way from being ready for production.  As we've already
>> discussed there are some very naive design decisions in there, such as
>> copying every bio payload to another memory buffer, splitting all io
>> down to 4k.  Think about the cpu overhead and memory consumption!
>> Think about how it will perform when memory is constrained and it
>> can't allocate many of those rambufs!  I'm sure more issues will be
>> found if I read further.
>>
>> I'm sorry to have disappointed you so, but if I let this go upstream
>> it would mean a massive amount of support work for me, not to mention
>> a damaged reputation for dm.
>>
>> Mike raised the question of why you want this in the kernel so much?
>> You'd find none of the distros would support it; so it doesn't widen
>> your audience much.  It's far better for you to maintain it outside of
>> the kernel at this point.  Any users will be bold, adventurous people,
>> who will be quite capable of building a kernel module.
>>
>> - Joe
>>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
