From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [PATCH v2] staging: writeboost: Add dm-writeboost
Date: Fri, 12 Dec 2014 09:42:15 +0900
Message-ID: <548A39E7.80508@gmail.com>
References: <54883195.1060304@gmail.com> <20141211152626.GA8196@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141211152626.GA8196@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: gregkh@linuxfoundation.org, dm-devel@redhat.com, driverdev-devel@linuxdriverproject.org, thornber@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Mike,

Below is my comments against Joe's previous comments:

1. Writeboost shouldn't split the bio into 4KB chunks.
No. It is necessary.
I know WALB (https://github.com/starpos/walb) logs data without
splitting but the data structure becomes complicated.
If you read my code carefully, you will notice that splitting
helps the design simplicity and performance.

2. Writeboost has to avoid copying of data to in-core buffer.
No. It is also necessary.
Think about partial write (smaller than 4KB).
Also, think about it's incoming I/O amount is even smaller than
the memory throughput. So, it won't affect the performance and
it's actually not (see the fio performance).
I will also copy data when I implement read-caching that will be
surely criticized by you or Joe eventually.

As for the way of discussing,
it's NOT fair to discuss based on technically not meaningful data
that is measured on VM in this case. It's violence, not discussion.
I am really amazed by you two suddenly "unstably" turning into nacking
within a day.
I showed you a data that Writeboost already surpasses the spindle but you
ignored it is also unfair. Did you think I cheated? With read-caching,
Writeboost can be more performant for sure.

My conclusion at this point is I don't like to change these two fundamental
design decision. If you want to nack without knowing how important these
things, it's fairly OK because device-mapper is your castle.
But in that case, I can't (not won't) persuade you and
sadly, retrieve from not only upstreaming *forever*.

I think you don't even try to understand the importance of Writeboost.
Although this guy really understand it (https://github.com/yongseokoh/dm-src).
The SSD-caching should be log-structured.

- Akira

On 12/12/14 12:26 AM, Mike Snitzer wrote:
> On Wed, Dec 10 2014 at  6:42am -0500,
> Akira Hayakawa <ruby.wktk@gmail.com> wrote:
> 
>> This patch adds dm-writeboost to staging tree.
>>
>> dm-writeboost is a log-structured SSD-caching driver.
>> It caches data in log-structured way on the cache device
>> so that the performance is maximized.
>>
>> The merit of putting this driver in staging tree is
>> to make it possible to get more feedback from users
>> and polish the codes.
>>
>> Signed-off-by: Akira Hayakawa <ruby.wktk@gmail.com>
> 
> Joe Thornber Nacked this from going into staging based on his further
> review of the code.  On the basis that you should _not_ be copying all
> pages associated with each bio into an in-core buffer.  Have you
> addressed that fundamental problem?
> 
> But taking a step back: Why do you think going into staging actually
> helps you?  Anyone who is willing to test this code should be able to
> apply a patch to their kernel.  Having to feed changes to Greg to
> deliver updates to any early consumers of this _EXPERIMENTAL_ target
> seems misplaced when you consider that Joe has detailed important
> fixes, capabilties and tools that need addressing before anyone should
> trust their production data to dm-writeboost.
> 
> I think you're completely missing that you are pushing _hard_ for this
> target to go upstream before it is actually ready.  In doing so you're
> so hung up on that "upstream" milestone that you cannot appreciate the
> reluctance that Joe and I have given the quantity of code you're pushing
> -- especially when coupled with the limited utility of dm-writeboost in
> comparison with full featured upstream drivers like dm-cache and bcache.
> 
> As for this v2, you didn't detail what you changed (I can obviously
> apply v1 and then v2 to see the difference but a brief summary would be
> helpful in general when you revise a patch)
> 
> But one inline comment:
> 
>> diff --git a/drivers/staging/writeboost/TODO b/drivers/staging/writeboost/TODO
>> new file mode 100644
>> index 0000000..761a9fe
>> --- /dev/null
>> +++ b/drivers/staging/writeboost/TODO
>> @@ -0,0 +1,52 @@
>> +TODO:
>> +
>> +- Get the GitExtract test so it's performance is similar to raw spindle.
> 
> No, the whole point of a write cache is to improve performance.  You
> should be trying to surpass the performance of the raw spindle.
> 
