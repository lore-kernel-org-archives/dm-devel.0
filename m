From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Thu, 18 Jun 2009 22:01:18 +0200
Message-ID: <1245355278.21548.22.camel@o>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<87672FCF-4B8D-45F8-9DA0-E4BD3E492ABE@redhat.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87672FCF-4B8D-45F8-9DA0-E4BD3E492ABE@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Thu, 2009-06-18 at 11:39 -0500, Jonathan Brassow wrote:
> Eliminate the 3rd argument to that function.  You can use  
> 'dm_rh_bio_to_region'.

No, I can't, because I'm keeping track of regions per single disk as in
the mirroring code rather than dividing the whole sets capacity into
regions. This is because a disk is divided into 2^N sized chunks and
regions have to be 2^M >= 2^N sized.

See caller side in dm-raid45.c, function do_io().

Heinz

> 
>   brassow
> 
> On Jun 15, 2009, at 12:21 PM, heinzm@redhat.com wrote:
> 
> >
> > +void dm_rh_delay_by_region(struct dm_region_hash *rh,
> > +			   struct bio *bio, region_t region)
> > +{
> > +	struct dm_region *reg;
> > +
> > +	/* FIXME: locking. */
> > +	read_lock(&rh->hash_lock);
> > +	reg = __rh_find(rh, region);
> > +	bio_list_add(&reg->delayed_bios, bio);
> > +	read_unlock(&rh->hash_lock);
> > +}
> > +EXPORT_SYMBOL_GPL(dm_rh_delay_by_region);
> > +
> > void dm_rh_stop_recovery(struct dm_region_hash *rh)
> > {
> > 	int i;
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
