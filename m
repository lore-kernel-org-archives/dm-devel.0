From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH] dm: also check for conflicting table type in
	dm_table_set_type
Date: Fri, 21 May 2010 18:01:06 +0900
Message-ID: <4BF64BD2.1090108@ct.jp.nec.com>
References: <20100520222625.GA19250@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100520222625.GA19250@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Mike,

On 05/21/2010 07:26 AM +0900, Mike Snitzer wrote:
> Factorize live table type compatibility check into
> dm_table_type_matches_live_table().  Catching a conflicting table type
> early, during table load, avoids failing during resume -- which always
> leaves the DM device suspended.
> 
> So also check type during dm_table_set_type() -- which happens as part
> of a table load.  But preserve the existing check during resume, in
> dm_swap_table(), because a racing table load could stage an inactive
> table that conflicts with the table type that dm_swap_table() is about
> to make live:

As you noted, the additional check in dm_table_set_type() is racy and
has no guarantee to detect problematic table loading in some cases.
Although I'm not sure such a duplicated racy check is really needed,
it will detect most cases and users may be happy with that.

So I have no objection, but at least, please put some comments that
it's racy in the code below.

> +finish:
> +	if (!dm_table_type_matches_live_table(t))
> +		return -EINVAL;
> +

Thanks,
Kiyoshi Ueda
