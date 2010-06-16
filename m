From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: 2 TB wraparound on snapshots on kernels < 2.6.33
Date: Wed, 16 Jun 2010 09:45:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1006160942130.651@hs20-bc2-1.build.redhat.com>
References: <4C12A32C.3000501@cfl.rr.com>
	<1276290990.2862.161.camel@mulgrave.site>
	<4C13AB90.1070802@cfl.rr.com> <1276358598.4399.3.camel@mulgrave.site>
	<1276358949.4399.8.camel@mulgrave.site> <4C13CAD6.70902@cfl.rr.com>
	<4C13D65B.7010800@cfl.rr.com> <1276373001.4399.11.camel@mulgrave.site>
	<4C14043B.7080203@cfl.rr.com> <4C1794D6.5070703@cfl.rr.com>
	<Pine.LNX.4.64.1006160911420.25637@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1006160911420.25637@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Phillip Susi <psusi@cfl.rr.com>
List-Id: dm-devel.ids



On Wed, 16 Jun 2010, Mikulas Patocka wrote:

> 
> 
> On Tue, 15 Jun 2010, Phillip Susi wrote:
> 
> > After further testing of mainline kernels, it seems that the bug was
> > fixed between 2.6.32 and 2.6.33.  Looking over the logs, I see no
> > changes that were intended to fix this issue, but there were quite a
> > number of changes to the snapshot code.  I can only conclude that these
> > inadvertently fixed the problem.
> 
> Hi
> 
> I wasn't able to reproduce this bug on any upstream kernel and I suspect 
> it is caused by incorrect patching on Ubuntu side. Ubuntu kernels 
> 2.6.31-16 and before don't have the bug, 2.6.31-17 and above have it.
> 
> Mikulas

The bug existed even in upstream, but only in 2.6.32 kernel. The reason 
was this function:
static inline chunk_t sector_to_chunk(struct dm_exception_store *store,
                                      sector_t sector)
{
        return (sector & ~store->chunk_mask) >> store->chunk_shift;
}

"store->chunk_mask" was changed to be unsigned in 2.6.32, so it was 
masking the sector with 32-bit value. In 2.6.33 that masking was removed. 
Ubuntu picked that 2.6.32 patch but didn't pick further patches.

Mikulas
