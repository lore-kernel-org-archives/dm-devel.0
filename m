From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] dm kcopyd: always complete failed jobs
Date: Wed, 7 Aug 2019 09:12:43 +0000
Message-ID: <BYAPR04MB5816ECBD651A16571529695AE7D40@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190805235603.18337-1-dmitry.fomichev@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 2019/08/06 8:56, Dmitry Fomichev wrote:
> This patch fixes a problem in dm-kcopyd that may leave jobs in
> complete queue indefinitely in the event of backing storage failure.
> 
> This behavior has been observed while running 100% write file fio
> workload against an XFS volume created on top of a dm-zoned target
> device. If the underlying storage of dm-zoned goes to offline state
> under I/O, kcopyd sometimes never issues the end copy callback and
> dm-zoned reclaim work hangs indefinitely waiting for that completion.
> 
> This behavior was traced down to the error handling code in
> process_jobs() function that places the failed job to complete_jobs
> queue, but doesn't wake up the job handler. In case of backing device
> failure, all outstanding jobs may end up going to complete_jobs queue
> via this code path and then stay there forever because there are no
> more successful I/O jobs to wake up the job handler.
> 
> This patch adds a wake() call to always wake up kcopyd job wait queue
> for all I/O jobs that fail before dm_io() gets called for that job.
> 
> The patch also sets the write error status in all sub jobs that are
> failed because their master job has failed.
> 
> Fixes: b73c67c2cbb00 ("dm kcopyd: add sequential write feature")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> ---
>  drivers/md/dm-kcopyd.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
> index df2011de7be2..1bbe4a34ef4c 100644
> --- a/drivers/md/dm-kcopyd.c
> +++ b/drivers/md/dm-kcopyd.c
> @@ -566,8 +566,10 @@ static int run_io_job(struct kcopyd_job *job)
>  	 * no point in continuing.
>  	 */
>  	if (test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags) &&
> -	    job->master_job->write_err)
> +	    job->master_job->write_err) {
> +		job->write_err = job->master_job->write_err;
>  		return -EIO;
> +	}
>  
>  	io_job_start(job->kc->throttle);
>  
> @@ -619,6 +621,7 @@ static int process_jobs(struct list_head *jobs, struct dm_kcopyd_client *kc,
>  			else
>  				job->read_err = 1;
>  			push(&kc->complete_jobs, job);
> +			wake(kc);
>  			break;
>  		}
>  
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
