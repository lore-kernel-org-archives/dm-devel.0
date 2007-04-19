From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: device-mapper mirror module (dm-raid)
Date: Thu, 19 Apr 2007 11:00:48 +0200
Message-ID: <OF9CCCC11F.B4C96036-ONC12572C2.00308E51-C12572C2.00317179@de.ibm.com>
References: <f535b83b0704130249q55517c15recc876490524fe63@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f535b83b0704130249q55517c15recc876490524fe63@mail.gmail.com>
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

dm-devel-bounces@redhat.com wrote on 13.04.2007 11:49:07:

> 
> 1. Is recovery here really necessary ?
> 
> Every time when a bio is written to a mirrred target, mirror driver 
> will queue 
> this io to the write bio_list whthin the mirror_set, finally a kcopyd 
will be 
> invoke to write this bio to all mirrored device. Is the flow correct? 
> 

AFAIK, thats wrong. Write creates and submits one write bio for each 
mirror target.
Kcopyd won't be used, except for recovery (currently startup only if I 
remember
correctly).

> But... there are nothing doing in  the write callback function 
> (write_callback).... right ?
> So in the current version, we won't have any regions that is needed 
> to be recovered.
> 
Starting any I/O within a region will mark this as dirty. If all I/O on a 
region
completed sucessfully it will be set in-sync again. Haven't looked at that 
lately
but it was a bit hidden since write_callback didn't do all the work. Parts 
of it
were done in the common end_io function of the target.

> ---------------------------------------------------------------- 
> 
> 2. Should we put all read action into the read bio_list of the 
mirror_set ?
> 
> In mirror_map.... should we put all read requests into the read 
> bio_list of the 
> mirror_set after check the return value from log->type->in_sync(), since 

> do_read() method does the same thing and it will be invoke when a 
do_work 
> is invoke? Or shoulwe d move all read actions including the checking 
> (in mirror_map) to the do_read() function ?
> 
> ---------------------------------------------------------------- 
> 
IMHO better move all to the read bio_list. So the mapping completes sooner 
and
the balancing and possible retries could be done in one place.

Regards,
Stefan
