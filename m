From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: clustered snapshots
Date: Tue, 29 Sep 2009 17:39:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0909291734020.12870@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0909281906510.16904@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0909281906510.16904@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

I uploaded a new version there. It has selective re-read and it has 
optimized locking --- it does no remote communication if the chunk already 
exists, so it should be as efficient as Jon's approach.

Jon, please look at it and review the patches, if you find out that this 
approach can't work at all, we can drop it and go with your approach. If 
it is OK, we can consider adopting it, it looks simpler than making 
clustered-exception-store.

Mikulas


On Mon, 28 Sep 2009, Mikulas Patocka wrote:

> Hi
> 
> I uploaded my test clustered snapshots to 
> http://people.redhat.com/mpatocka/patches/kernel/clustered-snapshots-preview/
> 
> My patches take different approach from Jon's patches. My patches 
> basically replace down_write(&s->lock) and up_write(&s->lock) with 
> clusterized locking.
> 
> If there are pending exceptions, the cluster lock must be held while the 
> local lock is unlocked. The cluster lock is droppen when all pending 
> exceptions are reallocated and the local lock is dropped.
> 
> The patches are based on my & Mike's merging.
> 
> These patches are less invasive than Jon's, they area small, they don't 
> change so much logic and most importantly, they leave merging as it is.
> 
> Note that it was never tried in a cluster because I don't have a cluster!! 
> So there may be a silly bug that makes it not work at all. The purpose of 
> the patches is to show different simpler approach to clustering. You 
> should test it and debug it.
> 
> TODO:
> - implement lock caching (Jon's task for his dm-lock module)
> - once we implement it, we can implement selective re-read --- i.e. don't 
> reread the exceptions if the cluster lock was not taken by any other node
> - in a few cases we could optimize it to use readlock or only local lock
> - implemented cluster merging
> 
> Mikulas
> 
