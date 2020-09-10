From: Vijayendra Suman <vijayendra.suman@oracle.com>
Subject: Re: Revert "dm: always call blk_queue_split() in dm_process_bio()"
Date: Fri, 11 Sep 2020 00:59:43 +0530
Message-ID: <5261af10-bf5c-f768-dbeb-2e784a5823f9@oracle.com>
References: <529c2394-1b58-b9d8-d462-1f3de1b78ac8@oracle.com>
 <20200910142438.GA21919@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200910142438.GA21919@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, RAMANAN_GOVINDARAJAN <ramanan.govindarajan@oracle.com>, Somu Krishnasamy <somasundaram.krishnasamy@oracle.com>
List-Id: dm-devel.ids

Hello Mike,

I checked with upstream, performance measurement is similar and shows 
performance improvement when 120c9257f5f19e5d1e87efcbb5531b7cd81b7d74 is 
reverted.

On 9/10/2020 7:54 PM, Mike Snitzer wrote:
> [cc'ing dm-devel and linux-block because this is upstream concern too]
>
> On Wed, Sep 09 2020 at  1:00pm -0400,
> Vijayendra Suman <vijayendra.suman@oracle.com> wrote:
>
>>     Hello Mike,
>>
>>     While Running pgbench tool with  5.4.17 kernel build
>>
>>     Following performance degrade is found out
>>
>>     buffer read/write metric : -17.2%
>>     cache read/write metric : -18.7%
>>     disk read/write metric : -19%
>>
>>     buffer
>>     number of transactions actually processed: 840972
>>     latency average = 24.013 ms
>>     tps = 4664.153934 (including connections establishing)
>>     tps = 4664.421492 (excluding connections establishing)
>>
>>     cache
>>     number of transactions actually processed: 551345
>>     latency average = 36.949 ms
>>     tps = 3031.223905 (including connections establishing)
>>     tps = 3031.402581 (excluding connections establishing)
>>
>>     After revert of Commit
>>     2892100bc85ae446088cebe0c00ba9b194c0ac9d ( Revert "dm: always call
>>     blk_queue_split() in dm_process_bio()")
> I assume 2892100bc85ae446088cebe0c00ba9b194c0ac9d is 5.4-stable's
> backport of upstream commit 120c9257f5f19e5d1e87efcbb5531b7cd81b7d74 ?
Yes
>>     Performance is Counter measurement
>>
>>     buffer ->
>>     number of transactions actually processed: 1135735
>>     latency average = 17.799 ms
>>     tps = 6292.586749 (including connections establishing)
>>     tps = 6292.875089 (excluding connections establishing)
>>
>>     cache ->
>>     number of transactions actually processed: 648177
>>     latency average = 31.217 ms
>>     tps = 3587.755975 (including connections establishing)
>>     tps = 3587.966359 (excluding connections establishing)
>>
>>     Following is your commit
>>
>>     diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>>     index cf71a2277d60..1e6e0c970e19 100644
>>     --- a/drivers/md/dm.c
>>     +++ b/drivers/md/dm.c
>>     @@ -1760,8 +1760,9 @@ static blk_qc_t dm_process_bio(struct mapped_device
>>     *md,
>>              * won't be imposed.
>>              */
>>             if (current->bio_list) {
>>     -               blk_queue_split(md->queue, &bio);
>>     -               if (!is_abnormal_io(bio))
>>     +               if (is_abnormal_io(bio))
>>     +                       blk_queue_split(md->queue, &bio);
>>     +               else
>>                             dm_queue_split(md, ti, &bio);
>>             }
>>
>>     Could you have a look if it is safe to revert this commit.
> No, it really isn't a good idea given what was documented in the commit
> header for commit 120c9257f5f19e5d1e87efcbb5531b7cd81b7d74 -- the
> excessive splitting is not conducive to performance either.
>
> So I think we need to identify _why_ reverting this commit is causing
> such a performance improvement.  Why is calling blk_queue_split() before
> dm_queue_split() benefiting your pgbench workload?
Let me know if you want to check some patch.
>
> Thanks,
> Mike
>
