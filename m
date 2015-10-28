From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 1/2] dm-raid: Fix minimal device check
Date: Wed, 28 Oct 2015 20:39:48 +0100
Message-ID: <56312484.2020506@redhat.com>
References: <1446058201-12628-1-git-send-email-agrover@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446058201-12628-1-git-send-email-agrover@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


NACK

md can drive a single disk raid5.



On 10/28/2015 07:50 PM, Andy Grover wrote:
> Check raid_type->minimal_devs instead of parity_devs. minimal_devs is used
> nowhere else (and makes sense to use here) so I think this is what was
> intended.
>
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>   drivers/md/dm-raid.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index a090121..5941cfd 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -151,7 +151,7 @@ static struct raid_set *context_alloc(struct dm_target *ti, struct raid_type *ra
>   	unsigned i;
>   	struct raid_set *rs;
>   
> -	if (raid_devs <= raid_type->parity_devs) {
> +	if (raid_devs < raid_type->minimal_devs) {
>   		ti->error = "Insufficient number of devices";
>   		return ERR_PTR(-EINVAL);
>   	}
