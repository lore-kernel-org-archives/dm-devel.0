From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] dm-ingerity: change memcmp to strncmp
Date: Wed, 13 Mar 2019 07:40:26 -0700
Message-ID: <1552488026.3022.2.camel@HansenPartnership.com>
References: <alpine.LRH.2.02.1903130753420.22289@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1903130753420.22289@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, 2019-03-13 at 07:56 -0400, Mikulas Patocka wrote:
> If the string opt_string is small, the function memcmp can access
> bytes
> that are beyond the terminating nul character. In theory, it could
> cause
> segfault, if opt_string were located just below some unmapped memory.
> 
> This patch changes memcmp to strncmp, so that we don't read bytes
> beyond
> the end of the string.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org	# v4.12+
> 
> ---
>  drivers/md/dm-integrity.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-integrity.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-integrity.c	2019-03-12
> 15:33:17.000000000 +0100
> +++ linux-2.6/drivers/md/dm-integrity.c	2019-03-12
> 15:34:49.000000000 +0100
> @@ -3185,7 +3185,7 @@ static int dm_integrity_ctr(struct dm_ta
>  			journal_watermark = val;
>  		else if (sscanf(opt_string, "commit_time:%u%c",
> &val, &dummy) == 1)
>  			sync_msec = val;
> -		else if (!memcmp(opt_string, "meta_device:",
> strlen("meta_device:"))) {
> +		else if (!strncmp(opt_string, "meta_device:",
> strlen("meta_device:"))) {

strncmp(a, b, strlen(b)) is semantically equivalent to strcmp(a,b) but
the latter is far shorter and easier so you should use it.

James
