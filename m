From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH for-3.14] dm cache: add total cache blocks to
 status output
Date: Fri, 10 Jan 2014 10:32:59 +0000
Message-ID: <20140110103258.GD20496@debian>
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
Cc: device-mapper development <dm-devel@redhat.com>, ejt@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 09, 2014 at 03:28:13PM -0600, Brassow Jonathan wrote:
> Yes, that'd be nice if we could have this.
> 

> It would be great if chunk_size (i.e. cache block size) was also
> included somehow.  If I had that, I could calculate the size of the
> cache using the status output alone.  I won't complain much if it
> isn't there though, because I can get that from the mapping table.

Yes, either get it from the table or LVM's metadata.  This is static
information, that doesn't change during the lifetime of the cache.

> The reason I like adding the total number of cache blocks is because
> I /can't/ get that information from either type of status (_INFO or
> _TABLE) for the cache target.  Instead, I would have to get the
> cache device from the mapping table and query that device for its
> size - possible, but the level of indirection is a pain.  As it sits
> in the kernel today, it seems strange to provide some information,
> but not enough to fill in the whole picture.

You do have the information.  And since LVM set up these devices I
don't understand why it's so hard to find the size of the fast device
used in the cache.

> Speaking of values I can't compute with the _INFO and _TABLE
> status...  "block size" does not mean the same thing for the
> metadata and data numbers - one is in chunk_size and the other is in
> something else (neither seem to be in sectors, as is DM custom).
> Honestly, I'm not very sure why the ratios are provided for the
> metadata area... who cares?  Is it info we don't need?  No-one has
> ever asked if the RAID or mirror log areas are mostly full.  I don't
> need to worry about overfilling, do I?

The metadata block size is always 4k (common to dm-thin, dm-cache and
dm-era), the cache block size is variable.  For dm-thin it's
impossible to predict how much metadata space is enough, since it
depends on the number of snapshots, and the degree of metadata sharing
within those snapshots.  dm-cache is a lot more predictable, but it is
an error condition we need to check for.  For instance;

i)   The metadata device may have been created too small in the first
     place due to some bug in userland tools.

ii)  A bug in the kernel driver may cause a metadata leak (happened last month).

iii) At the moment cache policies have the option of storing a 4byte
     'hint' against each cache entry.  We do have a patch to make this
     hint size variable; this is all tested, and integrated with the
     tools.  The only reason it wasn't pushed is the policy that was
     going to use it didn't go up.  As soon as someone dreams up a
     policy that needs more space than 4 bytes then metadata use will
     become less predictable.

- Joe
