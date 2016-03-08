From: Steven Wilton <swilton@fluentit.com.au>
Subject: Re: [PATCH v3] dm-cache watermarks
Date: Tue, 8 Mar 2016 23:16:51 +0800
Message-ID: <56DEECE3.6070301@fluentit.com.au>
References: <56DBFAEB.2050801@fluentit.com.au>
	<20160307141713.GA19967@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160307141713.GA19967@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On 07/03/16 22:17, Mike Snitzer wrote:
> On Sun, Mar 06 2016 at  4:39am -0500,
> Steven Wilton <swilton@fluentit.com.au> wrote:
>
>> I realised that I over-thought the original logic.  The attached
>> patch is much simpler - write back dirty cache entries at the
>> migration threshold rate when we are over the low watermark, and we
>> write back as fast as possible when we go over the high watermark.
>>
>> The current behaviour can be replicated by setting the high
>> watermark to 100, and the low watermark to 0.
>>
>> regards
>>
>> Steven
> These should default to current behavior (100 and 0 respectively, like
> you mentioned above).
>
> This change needs an accompanying Documentation update.  It also needs a
> proper path header to accurately convey the scope of the change.
>
> Please post v4 with these changes and then I'll take a closer look (as
> I'm sure Joe will).  But please be aware that in general we want less
> knobs, not more.
>
> Thanks,
> Mike
>
>
Thanks for getting back to me on this.  I have just submitted the patch 
from git (after reading up on how).  Can you please confirm that the new 
patch is in the correct format?

If you want less knobs, then the high watermark may not be much use, and 
I can remove it from the patch.  The initial request was mainly for a 
review to make sure I have not done anything obviously wrong that will 
lead to data corruption.

I am happy to run some benchmarks on before and after to quantify any 
performance gains.

I started looking into this because I noticed an increase in both disk 
busy time and data being written to the origin device after I enabled 
dm-cache on a production system.  The overall performance feels better 
even though the origin device is busier, but I am most interested to see 
what effect the low watermark has on this system.

I have also had a thought on the stats emitted by dm-cache, and think 
that it would be useful to export the number of write hits on already 
dirty blocks so we can see how efficient the writeback has been at 
avoiding writes to the origin. What is your view on changing the output 
format here?  If the output format cannot be changed, would you consider 
re-defining a write hit in writeback mode as a hit on an already dirty 
block, since this is the only scenario where I/O is avoided on the 
origin device?

regards

Steve
