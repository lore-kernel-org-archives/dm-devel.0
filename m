From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Revert "dm: always call blk_queue_split() in
	dm_process_bio()"
Date: Thu, 10 Sep 2020 10:24:39 -0400
Message-ID: <20200910142438.GA21919@redhat.com>
References: <529c2394-1b58-b9d8-d462-1f3de1b78ac8@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <529c2394-1b58-b9d8-d462-1f3de1b78ac8@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Vijayendra Suman <vijayendra.suman@oracle.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

[cc'ing dm-devel and linux-block because this is upstream concern too]

On Wed, Sep 09 2020 at  1:00pm -0400,
Vijayendra Suman <vijayendra.suman@oracle.com> wrote:

>    Hello Mike,
> 
>    While Running pgbench tool with  5.4.17 kernel build
> 
>    Following performance degrade is found out
> 
>    buffer read/write metric : -17.2%
>    cache read/write metric : -18.7%
>    disk read/write metric : -19%
> 
>    buffer
>    number of transactions actually processed: 840972
>    latency average = 24.013 ms
>    tps = 4664.153934 (including connections establishing)
>    tps = 4664.421492 (excluding connections establishing)
> 
>    cache
>    number of transactions actually processed: 551345
>    latency average = 36.949 ms
>    tps = 3031.223905 (including connections establishing)
>    tps = 3031.402581 (excluding connections establishing)
> 
>    After revert of Commit
>    2892100bc85ae446088cebe0c00ba9b194c0ac9d ( Revert "dm: always call
>    blk_queue_split() in dm_process_bio()")

I assume 2892100bc85ae446088cebe0c00ba9b194c0ac9d is 5.4-stable's
backport of upstream commit 120c9257f5f19e5d1e87efcbb5531b7cd81b7d74 ?

>    Performance is Counter measurement
> 
>    buffer ->
>    number of transactions actually processed: 1135735
>    latency average = 17.799 ms
>    tps = 6292.586749 (including connections establishing)
>    tps = 6292.875089 (excluding connections establishing)
> 
>    cache ->
>    number of transactions actually processed: 648177
>    latency average = 31.217 ms
>    tps = 3587.755975 (including connections establishing)
>    tps = 3587.966359 (excluding connections establishing)
> 
>    Following is your commit
> 
>    diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>    index cf71a2277d60..1e6e0c970e19 100644
>    --- a/drivers/md/dm.c
>    +++ b/drivers/md/dm.c
>    @@ -1760,8 +1760,9 @@ static blk_qc_t dm_process_bio(struct mapped_device
>    *md,
>             * won't be imposed.
>             */
>            if (current->bio_list) {
>    -               blk_queue_split(md->queue, &bio);
>    -               if (!is_abnormal_io(bio))
>    +               if (is_abnormal_io(bio))
>    +                       blk_queue_split(md->queue, &bio);
>    +               else
>                            dm_queue_split(md, ti, &bio);
>            }
> 
>    Could you have a look if it is safe to revert this commit.

No, it really isn't a good idea given what was documented in the commit
header for commit 120c9257f5f19e5d1e87efcbb5531b7cd81b7d74 -- the
excessive splitting is not conducive to performance either.

So I think we need to identify _why_ reverting this commit is causing
such a performance improvement.  Why is calling blk_queue_split() before
dm_queue_split() benefiting your pgbench workload?

Thanks,
Mike
