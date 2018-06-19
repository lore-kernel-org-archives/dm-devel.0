From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm thin: superblock may write succeed before other
 metadata blocks because of wirting metadata in async mode.
Date: Tue, 19 Jun 2018 09:11:06 -0400
Message-ID: <20180619131106.GA31018@redhat.com>
References: <20180522005336.GA30152@yyp.>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180522005336.GA30152@yyp.>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Monty Pavel <monty_pavel@sina.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, May 21 2018 at  8:53pm -0400,
Monty Pavel <monty_pavel@sina.com> wrote:

> 
> If dm_bufio_write_dirty_buffers func is called by __commit_transaction
> func and power loss happens during executing it, coincidencely
> superblock wrote correctly but some metadata blocks didn't. The reason
> is we write all metadata in async mode. We can guarantee that we send
> superblock after other blocks but we cannot guarantee that superblock
> write completely early than other blocks.
> So, We need to commit other metadata blocks before change superblock.
> 
> Signed-off-by: Monty Pavel <monty_pavel@sina.com>
> ---
>  drivers/md/dm-thin-metadata.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
> index 36ef284..897d7d6 100644
> --- a/drivers/md/dm-thin-metadata.c
> +++ b/drivers/md/dm-thin-metadata.c
> @@ -813,6 +813,14 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
>  	if (r)
>  		return r;
>  
> +	r = dm_tm_commit(pmd->tm, sblock);
> +	if (r)
> +		return r;
> +
> +	r = superblock_lock(pmd, &sblock);
> +	if (r)
> +		return r;
> +
>  	disk_super = dm_block_data(sblock);
>  	disk_super->time = cpu_to_le32(pmd->time);
>  	disk_super->data_mapping_root = cpu_to_le64(pmd->root);
> -- 
> 1.7.1

Have you actually found this patch to be effective?  It should be
unnecessary.  But I must admit that in looking at the related code I
couldn't convince myself it was.

But then Joe pointed me to this comment block from
dm-transaction-manager.h:

/*
 * We use a 2-phase commit here.
 *
 * i) Make all changes for the transaction *except* for the superblock.
 * Then call dm_tm_pre_commit() to flush them to disk.
 *
 * ii) Lock your superblock.  Update.  Then call dm_tm_commit() which will
 * unlock the superblock and flush it.  No other blocks should be updated
 * during this period.  Care should be taken to never unlock a partially
 * updated superblock; perform any operations that could fail *before* you
 * take the superblock lock.
 */
int dm_tm_pre_commit(struct dm_transaction_manager *tm);
int dm_tm_commit(struct dm_transaction_manager *tm, struct dm_block *superblock);

So given __commit_transaction() is using dm_tm_pre_commit() prior to the
dm_tm_commit() to flush the superblock -- it would seem that there isn't
any conceptual potential for corruption.

If you've found the dm_tm_pre_commit() to be lacking (whereby not all
metadata getting flushed to disk before the superblock) then please
explain your findings.

Thanks,
Mike
