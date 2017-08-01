From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm-integrity: Do not check integrity for
 failed read operations
Date: Tue, 1 Aug 2017 09:53:24 +0200
Message-ID: <3f027fbd-61b6-4507-848c-7c6af0ca213c@gmail.com>
References: <1501485740-27519-1-git-send-email-hyc.lee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1501485740-27519-1-git-send-email-hyc.lee@gmail.com>
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
To: Hyunchul Lee <hyc.lee@gmail.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: kernel-team@lge.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On 07/31/2017 09:22 AM, Hyunchul Lee wrote:
> From: Hyunchul Lee <cheol.lee@lge.com>
> 
> Even though read operations fail, dm_integrity_map_continue()
> calls integrity_metadata() to check integrity. In this case,
> just complete these.

Yes this makes sense to me.

If bio->bi_status is set, it is directly propagated and the whole
bio is failed.

But this is just shortcut, the bio will fail the same way (with bi_status),
just integrity calculation code is skipped, so I think it should go to 4.13.

Thanks,
Milan

> 
> Signed-off-by: Hyunchul Lee <cheol.lee@lge.com>
> ---
>  drivers/md/dm-integrity.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 10f123e..f99eee9 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -1697,7 +1697,11 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
>  
>  	if (need_sync_io) {
>  		wait_for_completion_io(&read_comp);
> -		integrity_metadata(&dio->work);
> +		if (likely(!bio->bi_status))
> +			integrity_metadata(&dio->work);
> +		else
> +			dec_in_flight(dio);
> +
>  	} else {
>  		INIT_WORK(&dio->work, integrity_metadata);
>  		queue_work(ic->metadata_wq, &dio->work);
> 
