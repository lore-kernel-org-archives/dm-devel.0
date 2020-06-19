From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: don't try to split REQ_OP_ZONE_APPEND bios
Date: Fri, 19 Jun 2020 12:26:59 -0400
Message-ID: <20200619162658.GB24642@redhat.com>
References: <20200619065905.22228-1-johannes.thumshirn@wdc.com>
 <20200619065905.22228-3-johannes.thumshirn@wdc.com>
 <CY4PR04MB37514CDC42E7F545244D66C6E7980@CY4PR04MB3751.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CY4PR04MB37514CDC42E7F545244D66C6E7980@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Naohiro Aota <Naohiro.Aota@wdc.com>
List-Id: dm-devel.ids

On Fri, Jun 19 2020 at  3:54am -0400,
Damien Le Moal <Damien.LeMoal@wdc.com> wrote:

> On 2020/06/19 15:59, Johannes Thumshirn wrote:
> > REQ_OP_ZONE_APPEND bios cannot be split so return EIO if we can't fit it
> > into one IO.
> > 
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > ---
> >  drivers/md/dm.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 058c34abe9d1..c720a7e3269a 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -1609,6 +1609,9 @@ static int __split_and_process_non_flush(struct clone_info *ci)
> >  
> >  	len = min_t(sector_t, max_io_len(ci->sector, ti), ci->sector_count);
> >  
> > +	if (bio_op(ci->bio) == REQ_OP_ZONE_APPEND && len < ci->sector_count)
> > +		return -EIO;
> > +
> >  	r = __clone_and_map_data_bio(ci, ti, ci->sector, &len);
> >  	if (r < 0)
> >  		return r;
> > 
> 
> I think this is OK. The stacked max_zone_append_sectors limit should have
> prevented that to happen  in the first place I think, but better safe than sorry.
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

If stacked max_zone_append_sectors limit should prevent it then I'd
rather not sprinkle more zoned specific checks in DM core.

Thanks,
Mike
