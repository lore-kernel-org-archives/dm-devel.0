From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH] dm log: fix unitialized i/o operations flags
Date: Wed, 24 Aug 2016 15:39:25 -0500
Message-ID: <CAJVOszAM86DGUYu9r8VY8jA0dCsq5Ss=qaGp27Eav2iayJ=rAw@mail.gmail.com>
References: <1471979868-14216-1-git-send-email-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471979868-14216-1-git-send-email-heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Aug 23, 2016 at 2:17 PM,  <heinzm@redhat.com> wrote:
> From: Heinz Mauelshagen <heinzm@redhat.com>
>
> During the port to bio_set_op_attrs() of dm-io.c, a dm-log.c
> caller was missing to initialize lc->io_req.bi_op_flags in the
> rw_header() caller of dm_io() which lead to respective unitialized
> bio->bi_op_flags in do_region().
>
> Symptom was hitting the BUG() in sd_init_command() for SCSI devices.
>
> Whilst on it, adjust rw_header() and its callers to use REQ_OP_{READ|WRITE}.
>
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> ---
>  drivers/md/dm-log.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
> index 4ca2d1d..07fc1ad 100644
> --- a/drivers/md/dm-log.c
> +++ b/drivers/md/dm-log.c
> @@ -291,9 +291,10 @@ static void header_from_disk(struct log_header_core *core, struct log_header_dis
>         core->nr_regions = le64_to_cpu(disk->nr_regions);
>  }
>
> -static int rw_header(struct log_c *lc, int rw)
> +static int rw_header(struct log_c *lc, int op)
>  {
> -       lc->io_req.bi_op = rw;
> +       lc->io_req.bi_op = op;
> +       lc->io_req.bi_op_flags = 0;
>
>         return dm_io(&lc->io_req, 1, &lc->header_location, NULL);
>  }
> @@ -316,7 +317,7 @@ static int read_header(struct log_c *log)
>  {
>         int r;
>
> -       r = rw_header(log, READ);
> +       r = rw_header(log, REQ_OP_READ);
>         if (r)
>                 return r;
>
> @@ -630,7 +631,7 @@ static int disk_resume(struct dm_dirty_log *log)
>         header_to_disk(&lc->header, lc->disk_header);
>
>         /* write the new header */
> -       r = rw_header(lc, WRITE);
> +       r = rw_header(lc, REQ_OP_WRITE);
>         if (!r) {
>                 r = flush_header(lc);
>                 if (r)
> @@ -698,7 +699,7 @@ static int disk_flush(struct dm_dirty_log *log)
>                         log_clear_bit(lc, lc->clean_bits, i);
>         }
>
> -       r = rw_header(lc, WRITE);
> +       r = rw_header(lc, REQ_OP_WRITE);
>         if (r)
>                 fail_log_device(lc);
>         else {
> --
> 2.7.4

Looks fine to me.
Reviewed-by: Shaun Tancheff <shaun.tancheff@seagate.com>

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
Regards,
Shaun Tancheff
