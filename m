From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] dm-switch: use struct_size() in kzalloc()
Date: Thu, 21 Feb 2019 09:27:07 -0600
Message-ID: <a4f967fe-f9c2-88d9-868e-a9c176df04d1@embeddedor.com>
References: <20190108160233.GA20222@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190108160233.GA20222@embeddedor>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi all,

Friendly ping:

Who can take this?

Thanks
--
Gustavo

On 1/8/19 10:02 AM, Gustavo A. R. Silva wrote:
> One of the more common cases of allocation size calculations is finding the
> size of a structure that has a zero-sized array at the end, along with memory
> for some number of elements for that array. For example:
> 
> struct foo {
>     int stuff;
>     void *entry[];
> };
> 
> instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);
> 
> Instead of leaving these open-coded and prone to type mistakes, we can now
> use the new struct_size() helper:
> 
> instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/md/dm-switch.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
> index fae35caf3672..8a0f057b8122 100644
> --- a/drivers/md/dm-switch.c
> +++ b/drivers/md/dm-switch.c
> @@ -61,8 +61,7 @@ static struct switch_ctx *alloc_switch_ctx(struct dm_target *ti, unsigned nr_pat
>  {
>  	struct switch_ctx *sctx;
>  
> -	sctx = kzalloc(sizeof(struct switch_ctx) + nr_paths * sizeof(struct switch_path),
> -		       GFP_KERNEL);
> +	sctx = kzalloc(struct_size(sctx, path_list, nr_paths), GFP_KERNEL);
>  	if (!sctx)
>  		return NULL;
>  
> 
