From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH 12/17] bottom-layer barrier support
Date: Tue, 28 Apr 2009 00:52:26 +0100
Message-ID: <20090427235226.GQ23302@agk.fab.redhat.com>
References: <Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
	<20090427214837.GF23302@agk.fab.redhat.com>
	<20090427220644.GG23302@agk.fab.redhat.com>
	<Pine.LNX.4.64.0904271907150.9362@hs20-bc2-1.build.redhat.com>
	<20090427232108.GJ23302@agk.fab.redhat.com>
	<Pine.LNX.4.64.0904271928030.9362@hs20-bc2-1.build.redhat.com>
	<20090427234156.GN23302@agk.fab.redhat.com>
	<Pine.LNX.4.64.0904271942380.9362@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904271945400.9362@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904271945400.9362@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 27, 2009 at 07:49:44PM -0400, Mikulas Patocka wrote:
> Here it is:
 
> @@ -279,8 +280,9 @@ static int delay_map(struct dm_target *t
>  
>  	if ((bio_data_dir(bio) == WRITE) && (dc->dev_write)) {
>  		bio->bi_bdev = dc->dev_write->bdev;
> -		bio->bi_sector = dc->start_write +
> -				 (bio->bi_sector - ti->begin);
> +		if (bio_sectors(bio))
> +			bio->bi_sector = dc->start_write +
> +					 (bio->bi_sector - ti->begin);
  
Thanks:-)
Now it looks similar to the code in the other simple targets again.

Alasdair
-- 
agk@redhat.com
