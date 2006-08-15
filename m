From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: Re: [PATCH] device-mapper core should use private
	bioset
Date: Tue, 15 Aug 2006 17:31:45 +0200
Message-ID: <OFE5FB4967.6033BD4D-ONC12571CB.00549CAB-C12571CB.0054DE20@de.ibm.com>
References: <20060815151725.GA18633@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060815151725.GA18633@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Alasdair G Kergon <agk@redhat.com> wrote on 15.08.2006 17:17:25:

> On Tue, Aug 15, 2006 at 05:03:34PM +0200, Stefan Bader wrote:
> > --- linux-2.6.17/drivers/md/dm.c   2006-06-19 14:01:40.000000000 +0200
> > +++ linux-2.6.17-new/drivers/md/dm.c   2006-08-15 16:21:30.000000000 
+0200
> > @@ -44,6 +44,7 @@ struct dm_io {
> >  struct target_io {
> >     struct dm_io *io;
> >     struct dm_target *ti;
> > +   struct bio_set *bs;
> >     union map_info info;
> >  };
> 
> Can this be avoided, perhaps with some cunning?
> As indicated in the comment, we want this structure to shrink ratherthan 
grow.
> 

IMHO the best solution would be to have a bio reference the bioset it came 
from.
But then I don't think people would like the bio structure to grow... I'll 
give
it some more thought.

Stefan
