From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] DM RAID:  add RAID1 support
Date: Wed, 25 May 2011 04:05:52 -0400
Message-ID: <20110525080552.GB16582@infradead.org>
References: <201105241931.p4OJVZWJ006336@localhost6.localdomain6>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201105241931.p4OJVZWJ006336@localhost6.localdomain6>
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
List-Id: dm-devel.ids

> +#ifdef md_raid1_congested
> +	if (rs->raid_type->level == 1)
> +		return md_raid1_congested(&rs->md, bits);
> +#endif
> +
>  	return md_raid5_congested(&rs->md, bits);

How well is this tested?  md_raid1_congested is a not a cpp macro
in your md patch, so with that patch it never would be called.

Also I think the congested call really should go through function
pointer indirections instead of opencoding all possible variants like
this.
