From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/2] dm thin: Flush data device before
 committing metadata to avoid data corruption
Date: Wed, 4 Dec 2019 15:17:10 -0500
Message-ID: <20191204201710.GA31432@redhat.com>
References: <20191204140742.26273-1-ntsironis@arrikto.com>
	<alpine.LRH.2.11.1912041907490.11561@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1912041907490.11561@mx.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: dm-devel@redhat.com, thornber@redhat.com, Nikos Tsironis <ntsironis@arrikto.com>, agk@redhat.com
List-Id: dm-devel.ids

On Wed, Dec 04 2019 at  2:58pm -0500,
Eric Wheeler <dm-devel@lists.ewheeler.net> wrote:

> On Wed, 4 Dec 2019, Nikos Tsironis wrote:
> 
> > The thin provisioning target maintains per thin device mappings that map
> > virtual blocks to data blocks in the data device.
> > 
> > When we write to a shared block, in case of internal snapshots, or
> > provision a new block, in case of external snapshots, we copy the shared
> > block to a new data block (COW), update the mapping for the relevant
> > virtual block and then issue the write to the new data block.
> > 
> > Suppose the data device has a volatile write-back cache and the
> > following sequence of events occur:
> 
> For those with NV caches, can the data disk flush be optional (maybe as a 
> table flag)?

IIRC block core should avoid issuing the flush if not needed.  I'll have
a closer look to verify as much.

Mike
