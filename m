From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH] User-configurable HDIO_GETGEO for dm
	volumes
Date: Fri, 17 Feb 2006 15:21:47 +0000
Message-ID: <20060217152147.GF12169@agk.surrey.redhat.com>
References: <43F38D83.3040702@us.ibm.com>
	<20060217151650.GC12173@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060217151650.GC12173@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Chris McDermott <lcm@us.ibm.com>
List-Id: dm-devel.ids

On Fri, Feb 17, 2006 at 03:16:50PM +0000, Alasdair G Kergon wrote:
> +static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
> +{
> +	struct mapped_device *md = bdev->bd_disk->private_data;
> +
> +	return dm_table_get_geometry(md->map, geo);
> +}
> 
> And if md->map is NULL?

See also:

  /*
   * Everyone (including functions in this file), should use this
   * function to access the md->map field, and make sure they call
   * dm_table_put() when finished.
   */
  struct dm_table *dm_get_table(struct mapped_device *md)


Alasdair
-- 
agk@redhat.com
