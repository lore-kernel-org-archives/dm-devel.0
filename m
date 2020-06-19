From: Bryan Gurney <bgurney@redhat.com>
Subject: Re: [PATCH v3 3/4] dm dust: add interface to list all
	badblocks
Date: Fri, 19 Jun 2020 11:56:45 -0400
Message-ID: <CAHhmqcS5wJbJdgZ+EucVuP8T_9DhUP-un0=s6CRZKfHdLb7wcQ@mail.gmail.com>
References: <20200619123803.1441373-1-yangerkun@huawei.com>
	<20200619123803.1441373-4-yangerkun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200619123803.1441373-4-yangerkun@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: yangerkun <yangerkun@huawei.com>
Cc: bmr@redhat.com, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, Jun 19, 2020 at 8:37 AM yangerkun <yangerkun@huawei.com> wrote:
>
> This interface may help anyone who want to know all badblocks without
> query block for each.
>
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>  drivers/md/dm-dust.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
> index a0c75c104de0..2ad8fc9293e0 100644
> --- a/drivers/md/dm-dust.c
> +++ b/drivers/md/dm-dust.c
> @@ -284,6 +284,31 @@ static int dust_clear_badblocks(struct dust_device *dd, char *result, unsigned i
>         return 1;
>  }
>
> +static int dust_list_badblocks(struct dust_device *dd, char *result, unsigned int maxlen,
> +                               unsigned int *sz_ptr)
> +{
> +       unsigned long flags;
> +       struct rb_root badblocklist;
> +       struct rb_node *node;
> +       struct badblock *bblk;
> +       unsigned int sz = *sz_ptr;
> +       unsigned long long num = 0;
> +
> +       spin_lock_irqsave(&dd->dust_lock, flags);
> +       badblocklist = dd->badblocklist;
> +       for (node = rb_first(&badblocklist); node; node = rb_next(node)) {
> +               bblk = rb_entry(node, struct badblock, node);
> +               DMEMIT("%llu\n", bblk->bb);
> +               num++;
> +       }
> +
> +       spin_unlock_irqrestore(&dd->dust_lock, flags);
> +       if (!num)
> +               DMEMIT("null");

Simply printing "null" may confuse the user into thinking that
something is wrong, when in fact everything is running normally, and
the bad block list is empty.

Heinz recommended returning an empty report, and I agree with that.
To the user, it would look something like this:

$ sudo dmsetup message dust1 0 listbadblocks

$ sudo dmsetup message dust1 0 countbadblocks
countbadblocks: 0 badblock(s) found


Thanks,

Bryan

> +
> +       return 1;
> +}
> +
>  /*
>   * Target parameters:
>   *
> @@ -427,6 +452,8 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
>                         else
>                                 dd->quiet_mode = false;
>                         r = 0;
> +               } else if (!strcasecmp(argv[0], "listbadblocks")) {
> +                       r = dust_list_badblocks(dd, result, maxlen, &sz);
>                 } else {
>                         invalid_msg = true;
>                 }
> --
> 2.25.4
>
