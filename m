From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1 of 2] DM Snapshot: remove redundant valid test
Date: Thu, 24 Sep 2009 13:41:19 +0100
Message-ID: <20090924124119.GH3866@agk-dp.fab.redhat.com>
References: <200909231519.n8NFJ8K3028667@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200909231519.n8NFJ8K3028667@hydrogen.msp.redhat.com>
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 23, 2009 at 10:19:08AM -0500, Jon Brassow wrote:
> Patch name: dm-snapshot-remove-redundant-valid-test.patch
> There is another valid test when we take the lock, the previous test can
> be dropped.
 
I'm going to leave this one for now, until I've seen the performance analysis.
- Is the argument here that the gain from not checking it twice while the snapshot
is valid outweighs the cost of the extra locking when the snapshot is full and
pending I/O is being failed as rapidly as possible and by that time there'll be
no other threads fighting for that lock?

Alasdair
