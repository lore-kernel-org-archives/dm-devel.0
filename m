From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: clustered snapshots
Date: Thu, 1 Oct 2009 01:43:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0910010137550.10043@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0909281906510.16904@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0909291734020.12870@hs20-bc2-1.build.redhat.com>
	<8CF64616-6BC3-484D-BE4B-9E4B80D35E3F@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8CF64616-6BC3-484D-BE4B-9E4B80D35E3F@redhat.com>
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

> I've just looked at the last group of patches briefly.  So far, I like what I
> see.  I especially like the concept of locking locally first, and then
> switching to cluster.  If I add cluster lock caching - this will further speed
> things up.
> 
> I'd prefer to have the UUID that is passed in on the CTR line be more general
> - leaving the possibility for future features/flags, rather than just plopping
> an extra argument on the end.

OK, so propose some command line syntax.

> I also need to look over the
> 'reread_exceptions' stuff, as this seems a little light...  I assume you
> didn't just take my patch to allow rereads because by adding an additional
> function to the API, you simplify some of the logic?

I actually tested reread (in no-cluster situation). The trick is that we 
must pass the requests to a thread because if we invoke request from a 
request routine, it gets queued and never finished until the request 
routine finishes. The code is already there to handle dropped snapshot, so 
I just reused it.

For the actual reread I resuse most of existing code.

> Also, any progress on adding the cluster locking to the your shared 
> snapshots?
> 
> brassow

I haven't started with it, but I'll do it the same way, it doesn't seem 
hard. I am more scared of the userspace support for clustering (do you 
have any?)

Mikulas
