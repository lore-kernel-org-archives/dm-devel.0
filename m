From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for-3.14] dm cache: add total cache blocks to
 status output
Date: Thu, 9 Jan 2014 17:13:23 -0500
Message-ID: <20140109221323.GA5555@redhat.com>
References: <20140109210412.GA5288@redhat.com>
	<684DDE51-1D4E-44AB-8E85-CDD6F38B5D07@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <684DDE51-1D4E-44AB-8E85-CDD6F38B5D07@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids

On Thu, Jan 09 2014 at  4:28pm -0500,
Brassow Jonathan <jbrassow@redhat.com> wrote:

> Yes, that'd be nice if we could have this.
> 
> It would be great if chunk_size (i.e. cache block size) was also
> included somehow.  If I had that, I could calculate the size of the
> cache using the status output alone.  I won't complain much if it
> isn't there though, because I can get that from the mapping table.
> 
> The reason I like adding the total number of cache blocks is because I
> /can't/ get that information from either type of status (_INFO or
> _TABLE) for the cache target.  Instead, I would have to get the cache
> device from the mapping table and query that device for its size -
> possible, but the level of indirection is a pain.  As it sits in the
> kernel today, it seems strange to provide some information, but not
> enough to fill in the whole picture.

So ideally you want both the cache blocksize and the metadata blocksize.
We can easily add them, wouldn't be the end of the world.  What format
seems best?

<#used metadata blocks>/<#total metadata blocks> <metadata block size>
<#used cache blocks>/<#total cache blocks> <cache block size>
...

or:

<metadata block size> <#used metadata blocks>/<#total metadata blocks>
<cache block size> <#used cache blocks>/<#total cache blocks>
...

or something else?

(fyi, these status blocksizes would be expressed in 512b sectors)

> Speaking of values I can't compute with the _INFO and _TABLE status...
> "block size" does not mean the same thing for the metadata and data
> numbers - one is in chunk_size and the other is in something else
> (neither seem to be in sectors, as is DM custom).

The cache's block_size is in terms of 512b sectors during table load and
it is then stored in cache->sectors_per_block so I'm not sure what you
mean.

As for cache metadata block size, it is fixed at 4K (just like
dm-thin-metadata).  And yes, DM_CACHE_METADATA_BLOCK_SIZE is in bytes,
not sectors... not a big deal as we convert it to sectors when storing
it in the metadata's superblock. *shrug*

> Honestly, I'm not
> very sure why the ratios are provided for the metadata area... who
> cares?  Is it info we don't need?  No-one has ever asked if the RAID
> or mirror log areas are mostly full.  I don't need to worry about
> overfilling, do I?

If the metadata device isn't sized appropriately you can run out of
metadata space.  But in general, yes the metadata use is fixed based on
the size of the particular cache device and chosen policy (due to policy
hint size).

So we _could_ add a negative check that warns/errors to the user if the
provided metadata device isn't adequate for addressing the entire cache
device.
