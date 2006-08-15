From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH] device-mapper core should use private
	bioset
Date: Tue, 15 Aug 2006 16:17:25 +0100
Message-ID: <20060815151725.GA18633@agk.surrey.redhat.com>
References: <44E1E246.2000608@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <44E1E246.2000608@de.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stefan Bader <Stefan.Bader@de.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Aug 15, 2006 at 05:03:34PM +0200, Stefan Bader wrote:
> --- linux-2.6.17/drivers/md/dm.c	2006-06-19 14:01:40.000000000 +0200
> +++ linux-2.6.17-new/drivers/md/dm.c	2006-08-15 16:21:30.000000000 +0200
> @@ -44,6 +44,7 @@ struct dm_io {
>  struct target_io {
>  	struct dm_io *io;
>  	struct dm_target *ti;
> +	struct bio_set *bs;
>  	union map_info info;
>  };
  
Can this be avoided, perhaps with some cunning?
As indicated in the comment, we want this structure to shrink rather than grow.

Alasdair
-- 
agk@redhat.com
