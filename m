From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] dm table: simplify discard support processing
Date: Thu, 14 Jul 2011 17:43:47 +0200
Message-ID: <4E1F0EB3.9010004@redhat.com>
References: <20110714143037.GA12049@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110714143037.GA12049@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 07/14/2011 04:30 PM, Mike Snitzer wrote:
> Remove 'discards_supported' from the dm_table structure.  The same
> information can be easily discovered from the table's target(s) in
> dm_table_supports_discards().
> 
> Also DMWARN if a target sets 'discards_supported' override but forgets
> to set 'num_discard_requests'.

Why not BUG_ON? It is bug in code on static attribute, isn't? :-)

> @@ -1426,6 +1422,9 @@ bool dm_table_supports_discards(struct dm_table *t)
>  	while (i < dm_table_get_num_targets(t)) {
>  		ti = dm_table_get_target(t, i++);
>  
> +		if (!ti->num_discard_requests)
> +			return 0;
> +		

>  		if (ti->discards_supported)
>  			return 1;

What if next target has ti->num_discard_requests = 0 here?
Shouldn't it loop through the all targets always?

Milan
