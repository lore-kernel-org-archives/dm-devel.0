From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [bug report] dm: add emulated block size target
Date: Wed, 29 Apr 2020 17:09:30 +0200
Message-ID: <0aca39de-3efb-e1ce-dfd5-6d3059799bd6@redhat.com>
References: <20200429132140.GA815210@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200429132140.GA815210@mwanda>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Thanks for reporting this.

See patch to fix this submitted to dm-devel.

Heinz

On 4/29/20 3:21 PM, Dan Carpenter wrote:
> Hello Heinz Mauelshagen,
>
> The patch d3d11ad3d087: "dm: add emulated block size target" from Mar
> 9, 2020, leads to the following static checker warning:
>
> 	drivers/md/dm-ebs-target.c:190 __ebs_process_bios()
> 	warn: assigning signed to unsigned: 'bio->bi_status = r' '(-4095)-0'
>
> drivers/md/dm-ebs-target.c
>     173                          if (__block_mod(bio_end_sector(bio), ec->u_bs) && block2 != block1)
>     174                                  dm_bufio_prefetch(ec->bufio, block2, 1);
>     175                  }
>     176          }
>     177
>     178          bio_list_for_each(bio, &bios) {
>     179                  r = -EIO;
>     180                  if (bio_op(bio) == REQ_OP_READ)
>     181                          r = __ebs_rw_bio(ec, READ, bio);
>     182                  else if (bio_op(bio) == REQ_OP_WRITE) {
>     183                          write = true;
>     184                          r = __ebs_rw_bio(ec, WRITE, bio);
>     185                  } else if (bio_op(bio) == REQ_OP_DISCARD) {
>     186                          /* FIXME: (optionally) call dm_bufio_discard_buffers() once upstream. */
>     187                          r = __ebs_forget_bio(ec, bio);
>     188                  }
>     189
>     190                  bio->bi_status = r;
>                          ^^^^^^^^^^^^^^^^^^
> "r" is a negative error code and ->bi_status is a u8 so this won't work.
>
>     191          }
>     192
>     193          /*
>     194           * We write dirty buffers after processing I/O on them
>     195           * but before we endio thus addressing REQ_FUA/REQ_SYNC.
>     196           */
>     197          r = write ? dm_bufio_write_dirty_buffers(ec->bufio) : 0;
>
> regards,
> dan carpenter
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
