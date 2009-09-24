From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1 of 2] DM Snapshot: remove redundant valid test
Date: Thu, 24 Sep 2009 10:05:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0909241000120.18846@hs20-bc2-1.build.redhat.com>
References: <200909231519.n8NFJ8K3028667@hydrogen.msp.redhat.com>
	<20090924124119.GH3866@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090924124119.GH3866@agk-dp.fab.redhat.com>
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
Cc: dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Thu, 24 Sep 2009, Alasdair G Kergon wrote:

> On Wed, Sep 23, 2009 at 10:19:08AM -0500, Jon Brassow wrote:
> > Patch name: dm-snapshot-remove-redundant-valid-test.patch
> > There is another valid test when we take the lock, the previous test can
> > be dropped.
>  I'm going to leave this one for now, until I've seen the performance 
> analysis. - Is the argument here that the gain from not checking it 
> twice while the snapshot is valid outweighs the cost of the extra 
> locking when the snapshot is full and pending I/O is being failed as 
> rapidly as possible and by that time there'll be no other threads 
> fighting for that lock?

The argument is that it is pointless to check the same variable twice. 
This is not about execution performance, this is about programmer 
performance --- everybody who looks at the code starts thinking "oh, why 
is it checked twice, what's hapenning there?". So the need for double 
checking should be either explained or it should be removed.

Performance of I/O on full snapshot is irrelevant, it doesn't matter if 
you return error few tens or hundreds of cycles earlies or later, the data 
will be lost anyway :)

Mikulas

> Alasdair
> 
