From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: bio's bi_size bug also be founded at dm-stripe.c and
	dm-snap.c (resend in correct charset)
Date: Wed, 29 Jun 2005 06:46:00 -0500
Message-ID: <200506290646.00118.kevcorry@us.ibm.com>
References: <00a501c57c92$c3041020$1f000064@polaris>
	<200506290630.57441.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200506290630.57441.kevcorry@us.ibm.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Zhao Qian <zhaoqian@aaastor.com>
List-Id: dm-devel.ids

On Wed June 29 2005 6:30 am, Kevin Corry wrote:
> > in such situation, bio's
> > bi_size could exceed strip target's chunk size and snap target's chunk
> > size, but in current code, we never care about this. so in strip target
> > we could read/write bad position after stripe_map() function, and cause
> > same effect in dm-snap.c.
>
> I'm quite certain there is code in dm.c to prevent bio's from spanning the
> internal boundaries in the mirror, snapshot, and stripe targets. Have you
> read through the code starting in dm.c::dm_request()? The targets specify
> where their internal boundaries are, and the core driver is responsible for
> splitting up bio's so the targets never get a request that span those
> boundaries.

And now that I've said this, I've gone back and looked, and indeed the 
dm-raid1.c code isn't setting the ti->split_io field (it does get set in 
dm-stripe.c and dm-snap.c).

Alasdair, should that field be set for dm-mirror targets? I'm not as familiar 
with that code, so I'll have to leave that up to you. If it does need to be 
set, I think the following patch should work.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/


Set the target's split_io field when building a dm-mirror device so incoming 
bio's won't span the mirror's internal regions.

--- a/drivers/md/dm-raid1.c 2005-06-29 06:38:16.000000000 -0500
+++ b/drivers/md/dm-raid1.c 2005-06-29 06:41:59.000000000 -0500
@@ -1060,6 +1060,7 @@
  }
 
  ti->private = ms;
+ ti->split_io = ms->rh->region_size;
 
  r = kcopyd_client_create(DM_IO_PAGES, &ms->kcopyd_client);
  if (r) {
