From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: 2 TB wraparound on snapshots on kernels < 2.6.33
Date: Wed, 16 Jun 2010 09:52:54 -0400
Message-ID: <4C18D736.7070109@cfl.rr.com>
References: <4C12A32C.3000501@cfl.rr.com>
	<1276290990.2862.161.camel@mulgrave.site>
	<4C13AB90.1070802@cfl.rr.com>
	<1276358598.4399.3.camel@mulgrave.site>
	<1276358949.4399.8.camel@mulgrave.site>
	<4C13CAD6.70902@cfl.rr.com> <4C13D65B.7010800@cfl.rr.com>
	<1276373001.4399.11.camel@mulgrave.site>
	<4C14043B.7080203@cfl.rr.com> <4C1794D6.5070703@cfl.rr.com>
	<Pine.LNX.4.64.1006160911420.25637@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1006160942130.651@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1006160942130.651@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Aha!  I looked at the code carefully as it aroused my suspicions, but I
couldn't quite work out how it actually caused the problem.  Good catch.

On 6/16/2010 9:45 AM, Mikulas Patocka wrote:
> The bug existed even in upstream, but only in 2.6.32 kernel. The reason 
> was this function:
> static inline chunk_t sector_to_chunk(struct dm_exception_store *store,
>                                       sector_t sector)
> {
>         return (sector & ~store->chunk_mask) >> store->chunk_shift;
> }
> 
> "store->chunk_mask" was changed to be unsigned in 2.6.32, so it was 
> masking the sector with 32-bit value. In 2.6.33 that masking was removed. 
> Ubuntu picked that 2.6.32 patch but didn't pick further patches.
> 
> Mikulas
