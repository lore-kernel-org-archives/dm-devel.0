From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm thin: Avoid flushing the data device twice
Date: Thu, 5 Dec 2019 14:43:46 -0500
Message-ID: <20191205194346.GB95063@lobo>
References: <20191204170638.28163-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191204170638.28163-1-ntsironis@arrikto.com>
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
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: dm-devel@redhat.com, thornber@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, Dec 04 2019 at 12:06P -0500,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> Since we flush the data device as part of a metadata commit, it's
> redundant to then submit any deferred REQ_PREFLUSH bios.
> 
> Add a check in process_deferred_bios() for deferred REQ_PREFLUSH bios
> and complete them immediately.
> 
> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
> ---
>  drivers/md/dm-thin.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index e0be545080d0..40d8a255dbc3 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -2383,8 +2383,18 @@ static void process_deferred_bios(struct pool *pool)
>  	while ((bio = bio_list_pop(&bio_completions)))
>  		bio_endio(bio);
>  
> -	while ((bio = bio_list_pop(&bios)))
> -		generic_make_request(bio);
> +	while ((bio = bio_list_pop(&bios))) {
> +		if (bio->bi_opf & REQ_PREFLUSH) {
> +			/*
> +			 * We just flushed the data device as part of the
> +			 * metadata commit, so there is no reason to send
> +			 * another flush.
> +			 */
> +			bio_endio(bio);
> +		} else {
> +			generic_make_request(bio);
> +		}
> +	}
>  }
>  
>  static void do_worker(struct work_struct *ws)
> -- 
> 2.11.0
> 

Don't we need to check if the the bio is an empty flush?  I have this incremental:

---
 drivers/md/dm-thin.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 40d8a255dbc3..9c9a323c0c30 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2384,16 +2384,15 @@ static void process_deferred_bios(struct pool *pool)
 		bio_endio(bio);
 
 	while ((bio = bio_list_pop(&bios))) {
-		if (bio->bi_opf & REQ_PREFLUSH) {
-			/*
-			 * We just flushed the data device as part of the
-			 * metadata commit, so there is no reason to send
-			 * another flush.
-			 */
+		/*
+		 * The data device was flushed as part of metadata commit,
+		 * so complete additional deferred empty REQ_PREFLUSH bios
+		 * immediately.
+		 */
+		if ((bio->bi_opf & REQ_PREFLUSH) && !bio_has_data(bio))
 			bio_endio(bio);
-		} else {
+		else
 			generic_make_request(bio);
-		}
 	}
 }
 
-- 
2.15.0
