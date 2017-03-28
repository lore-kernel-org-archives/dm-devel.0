From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: move dm_table_destroy() to same header as
	dm_table_create()
Date: Tue, 28 Mar 2017 15:31:51 -0400
Message-ID: <20170328193150.GA21445@redhat.com>
References: <20170328183102.80620-1-briannorris@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170328183102.80620-1-briannorris@chromium.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brian Norris <briannorris@chromium.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 28 2017 at  2:31pm -0400,
Brian Norris <briannorris@chromium.org> wrote:

> If anyone is going to use dm_table_create(), they probably should be
> able to use dm_table_destroy() too. Move the dm_table_destroy()
> definition outside the private header, near dm_table_create()
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Not seeing why we need dm_table_create() exposed.  So I think you went
the wrong way with this.  Unless you have an actual need, I'd prefer to
see dm_table_create() moved from include/linux/device-mapper.h to
drivers/md/dm.h

Mike


> ---
>  drivers/md/dm.h               | 1 -
>  include/linux/device-mapper.h | 5 +++++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index f298b01f7ab3..c54d2f1934ce 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -48,7 +48,6 @@ struct dm_md_mempools;
>  /*-----------------------------------------------------------------
>   * Internal table functions.
>   *---------------------------------------------------------------*/
> -void dm_table_destroy(struct dm_table *t);
>  void dm_table_event_callback(struct dm_table *t,
>  			     void (*fn)(void *), void *context);
>  struct dm_target *dm_table_get_target(struct dm_table *t, unsigned int index);
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index a7e6903866fd..70cb6af56f67 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -472,6 +472,11 @@ void dm_table_set_type(struct dm_table *t, unsigned type);
>  int dm_table_complete(struct dm_table *t);
>  
>  /*
> + * Destroy the table when finished.
> + */
> +void dm_table_destroy(struct dm_table *t);
> +
> +/*
>   * Target may require that it is never sent I/O larger than len.
>   */
>  int __must_check dm_set_target_max_io_len(struct dm_target *ti, sector_t len);
> -- 
> 2.12.2.564.g063fe858b8-goog
> 
