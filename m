From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] dm ioctl: Use struct_size() helper
Date: Tue, 16 Jun 2020 17:06:03 -0500
Message-ID: <885e7ea3-b29a-eba0-569e-64760102016e@embeddedor.com>
References: <20190828183825.GA4216@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190828183825.GA4216@embeddedor>
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
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: dm-devel.ids

Hi all,

Friendly ping: who can take this?

It's been almost a year... and I just noticed there was a problem
with the email addresses back then...

I just fixed the issue and this patch should now appear on
dm-devel@redhat.com and LKML.

Thanks
--
Gustavo

On 8/28/19 13:38, Gustavo A. R. Silva wrote:
> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
> 
> struct dm_target_deps {
> 	...
>         __u64 dev[0];   /* out */
> };
> 
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes.
> 
> So, replace the following form:
> 
> sizeof(*deps) + (sizeof(*deps->dev) * count)
> 
> with:
> 
> struct_size(deps, dev, count)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/md/dm-ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index fb6f8fb1f13d..b2d52cec70d4 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1446,7 +1446,7 @@ static void retrieve_deps(struct dm_table *table,
>  	/*
>  	 * Check we have enough space.
>  	 */
> -	needed = sizeof(*deps) + (sizeof(*deps->dev) * count);
> +	needed = struct_size(deps, dev, count);
>  	if (len < needed) {
>  		param->flags |= DM_BUFFER_FULL_FLAG;
>  		return;
> 
