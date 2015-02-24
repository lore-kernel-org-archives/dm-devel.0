From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC PATCH 4/4] dm: delay running the queue slightly
 during request completion
Date: Tue, 24 Feb 2015 08:51:20 -0800
Message-ID: <54ECAC08.7040603@kernel.dk>
References: <1424796250-38553-1-git-send-email-snitzer@redhat.com>
	<1424796250-38553-5-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1424796250-38553-5-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: shivakrishna.merla@netapp.com, jmoyer@redhat.com
List-Id: dm-devel.ids

On 02/24/2015 08:44 AM, Mike Snitzer wrote:
> On really fast storage it can be beneficial to delay running the
> request_queue to allow the elevator more opportunity to merge requests.
>
> Otherwise, it has been observed that requests are being sent to
> q->request_fn much quicker than is ideal on IOPS-bound backends.
>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>   drivers/md/dm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index fc92899..92091e0 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1034,7 +1034,7 @@ static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
>   	 * queue lock again.
>   	 */
>   	if (run_queue)
> -		blk_run_queue_async(md->queue);
> +		blk_delay_queue(md->queue, HZ / 10);

This looks dangerous... How will this impact sync IO? Heuristics like 
this will always come back and bite you in the ass.

A slightly more friendly heuristic might be to delay running the queue, 
if you still have pending IO. That would give you a more sawtooth like 
queue depth management, so it would potentially slow down a bit, but the 
upside would be more efficient merging since it would allow some 
requests so sit a little bit before being dispatched.

-- 
Jens Axboe
