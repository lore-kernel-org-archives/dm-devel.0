From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-mirror: do not degrade the mirror on
 discard error
Date: Mon, 16 Feb 2015 07:44:21 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502160742030.14038@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1502121007010.24282@file01.intranet.prod.int.rdu2.redhat.com>
	<1423967994.19864.9.camel@HansenPartnership.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1423967994.19864.9.camel@HansenPartnership.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Sat, 14 Feb 2015, James Bottomley wrote:

> On Thu, 2015-02-12 at 10:09 -0500, Mikulas Patocka wrote:
> > It may be possible that a device claims discard support but it rejects
> > discards with -EOPNOTSUPP. It happens when using loopback on ext2/ext3
> > filesystem driven by the ext4 driver. It may also happen if the underlying
> > devices are moved from one disk on another.
> > 
> > If discard error happens, we reject the bio with -EOPNOTSUPP, but we do
> > not degrade the array.
> > 
> > This patch fixes failed test shell/lvconvert-repair-transient.sh in the
> > lvm2 testsuite if the testsuite is extracted on an ext2 or ext3 filesystem
> > and it is being driven by the ext4 driver.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > Index: linux-2.6/drivers/md/dm-raid1.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-raid1.c
> > +++ linux-2.6/drivers/md/dm-raid1.c
> > @@ -604,6 +604,15 @@ static void write_callback(unsigned long
> >  		return;
> >  	}
> >  
> > +	/*
> > +	 * If the bio is discard, return an error, but do not
> > +	 * degrade the array.
> > +	 */
> > +	if (bio->bi_rw & REQ_DISCARD) {
> > +		bio_endio(bio, -EOPNOTSUPP);
> 
> I think the error gets ignored, so this is probably harmless, but
> shouldn't you propagate the actual error here?  discard is advisory and
> can fail for a variety of reasons (alignment being chief) for which
> EOPNOTSUPP is inappropriate.
> 
> James

dm-io doesn't pass the error code to the callback, it only returns the 
bitmask of failed devices. So, it is impossible to find the real error 
code.

Mikulas
