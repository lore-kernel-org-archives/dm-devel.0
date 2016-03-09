From: Steven Wilton <swilton@fluentit.com.au>
Subject: Re: [PATCH] dm cache: add writeback watermarks
Date: Wed, 9 Mar 2016 08:43:28 +0800
Message-ID: <56DF71B0.7060804@fluentit.com.au>
References: <1457448762-6784-1-git-send-email-swilton@fluentit.com.au>
	<20160308152335.GA4126@rh-vpn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160308152335.GA4126@rh-vpn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids



On 8/03/2016 11:23 PM, Joe Thornber wrote:
> On Tue, Mar 08, 2016 at 10:52:42PM +0800, Steven Wilton wrote:
>> Add 2 new options to the dm-cache code, writeback_low_watermark to
>> keep a section of the cache dirty in order to reduce the amount
>> of data being migrated from the cache to the origin, and
>> writeback_high_watermark to allow a threshold to be set where the
>> dirty cache entries are flushed as quick as possible.
> Right. mq is being removed, or rather becoming an alias for smq (patch
> posted a couple of weeks ago to dm-devel).
>
> smq already has a writeback delay to prevent writeback of frequently
> changing data:
>
> https://github.com/jthornber/linux-2.6/blob/thin-dev/drivers/md/dm-cache-policy-smq.c#L338
> https://github.com/jthornber/linux-2.6/blob/thin-dev/drivers/md/dm-cache-policy-smq.c#L850
> https://github.com/jthornber/linux-2.6/blob/thin-dev/drivers/md/dm-cache-policy-smq.c#L876
>
> and has a threshold/watermark that triggers more aggressive writeback:
>
> https://github.com/jthornber/linux-2.6/blob/thin-dev/drivers/md/dm-cache-policy-smq.c#L1463
>
> I think this decision belongs in the policy, you've moved it to the
> core.
>
> Also I'm trying to avoid introducing tunables to the interface.  It's
> not enough to document what the tunables do, but we also have to
> explain how people should arrive at the correct values for their work
> loads.
>
> Have you tried smq?  What work load are you running?  Does your patch
> improve things?
>
> - Joe
>
Hi Joe,

I'm very new to dm-devel, and was not aware of the smq patch.  I will 
base any new patches off this work.  I did just had a look, and am I 
correct in saying that the smq patch will still be limited to migrating 
data at the migration_threshold rate?

I have not tried my patch on any production data yet, since I wanted to 
make sure I had not done anything obviously that was going to eat my 
data first :)   If it is possible to confirm that I'm not doing anything 
silly, I am happy to both run some benchmarks and see the difference on 
production workloads, and post any results.

My goal is to reduce the number of writebacks occurring, and I still 
think that having a low watermark is the best way to achieve.  I know 
that I was reading some notes form the bcache developer, who found that 
having a low watermark helped bcache.  The one improvement that I can 
think of would be to flush below the low watermark if the I/O load is 
below a particular threshold.

If you could have a look at my patch to confirm that it's not doing 
anything bad, I will update my branch to use smq and develop a patch 
against that, and run some tests on my data before posting another patch.

regards

Steven
