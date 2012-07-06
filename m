From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-mirror: fix crash with mirror recovery and discard
Date: Fri, 6 Jul 2012 16:38:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1207061629150.16361@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1207061454200.1119@file.rdu.redhat.com>
	<20120706194859.GA10276@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120706194859.GA10276@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

> > +	ti->discard_zeroes_data_unsupported = 1;
> >  
> >  	ms->kmirrord_wq = alloc_workqueue("kmirrord",
> >  					  WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
> 
> This should be split out to a separate patch and properly justified in
> the patch header.  Is there something unique to dm-mirror that renders
> the underlying device's zeroing unreliable?

There are two possible approaches to handling REQ_DISCARD

1. treat REQ_DISCARD as REQ_FLUSH (this is what the patch does) --- i.e. 
do not synchronize it with region states, do not set mirror error on 
failure. In this mode we must assume that there are uninitialized data 
after a flush.

For example, if there is a region that is being resynchronized and we send 
REQ_DISCARD that overlaps this region, there is no guarantee that data in 
this region were zeroed. 

- kcopyd reads a few blocks for resynchronization
- REQ_DISCARD is sent to both mirror legs, both disks overwrites the area 
with zeroes
- kcopyd writes those blocks to the other leg => the blocks are no longer 
zero despite REQ_DISCARD being sent


2. treat REQ_DISCARD as writes (i.e. synchronize it with region states, 
wait until resynchronization finishes, etc.) --- it is possible to do it 
this way to, but if we do it this way, we have to split REQ_DISCARD on 
region boundaries (it is currently split only on target boundaries, 
which is insufficient).


Mikulas
