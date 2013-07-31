From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [PATCH] dm-lc.c: fix for a potential NULL pointer
	dereference
Date: Wed, 31 Jul 2013 22:04:09 +0900
Message-ID: <51F90B49.60708@gmail.com>
References: <1375272568-2730-1-git-send-email-gmate.amit@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1375272568-2730-1-git-send-email-gmate.amit@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kumar Amit Mehta <gmate.amit@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Thanks, Kumar.
Your patch is applied.

resume_cache,
a routine to build in-memory data structures
by reading metadata on cache device,
is so complicated in the code and the logic
to thoroughly implement the error checks.

I am wondering how I should face this problem.
Only caring about lines
that allocates large-sized memories
and forget about anything else
is what I am thinking now.
But it is clear that
it is not a way kernel module should be.

Do you guys have some thoughts on this problem?

On 7/31/13 9:09 PM, Kumar Amit Mehta wrote:
> Memory allocation may fail, hence add a check before dereferencing
> the pointer.
> 
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
> ---
>  Driver/dm-lc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Driver/dm-lc.c b/Driver/dm-lc.c
> index 4a65042..e00fb27 100644
> --- a/Driver/dm-lc.c
> +++ b/Driver/dm-lc.c
> @@ -2671,6 +2671,8 @@ static int lc_mgr_message(struct dm_target *ti, unsigned int argc, char **argv)
>  	 */
>  	if (!strcasecmp(cmd, "resume_cache")) {
>  		struct lc_cache *cache = kzalloc(sizeof(*cache), GFP_KERNEL);
> +		if (!cache)
> +			return -ENOMEM;
>  
>  		struct dm_dev *dev;
>  		if (dm_get_device(ti, argv[1], dm_table_get_mode(ti->table),
> 
