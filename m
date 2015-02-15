From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mirror: do not degrade the mirror on discard error
Date: Sat, 14 Feb 2015 22:36:55 -0500
Message-ID: <20150215033655.GA10570@redhat.com>
References: <alpine.LRH.2.02.1502121007010.24282@file01.intranet.prod.int.rdu2.redhat.com>
	<1423967994.19864.9.camel@HansenPartnership.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Sat, Feb 14 2015 at  9:39pm -0500,
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

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

In general you're right.  But this particular dm-mirror code doesn't
concern itself with specific error codes.  See dm-io.c:dec_count(), any
error that occurs sets an error bit that corresponds to the raid member
that experienced the failure.  And write_callback() will just check to
see if any errors occured across all members (by checking if each raid
members' bit is set in the 'unsigned long error' passed to
write_callback).

This is the first I've dug into this aspect of the old dm-mirror code
(thankfully we have the dm-raid target that wraps MD now!).. I'm not
liking that error codes are getting dropped on the floor in dm-io.
But I don't have a strong interest in fixing this just for dm-mirror
given the code is becoming increasingly niche (really only offers
clustered mirroring now).

BUT dm-io is used by other targets, so this is could become a bigger
issue if specific error codes matter to targets issuing io using dm-io.
So far it hasn't been an issue.  But something I'll keep in mind.
