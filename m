From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm-crypt: Fix access beyond the end of
	allocated space
Date: Thu, 28 Aug 2014 19:59:57 +0200
Message-ID: <53FF6E1D.10308@gmail.com>
References: <alpine.LRH.2.02.1408281108120.31317@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1408281108120.31317@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>, kkolasa@winsoft.pl
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 08/28/2014 05:09 PM, Mikulas Patocka wrote:
> dm-crypt has a bug that it accesses memory beyond allocated space.
> 
> To minimize allocation overhead, dm-crypt puts several structures into one
> block allocated with kmalloc. The block holds struct ablkcipher_request,
> cipher-specific scratch pad (crypto_ablkcipher_reqsize(any_tfm(cc))),
> struct dm_crypt_request and initialization vector.
> 
> The variable dmreq_start is set to offset of struct dm_crypt_request
> within this memory block. dm-crypt allocates block with this size:
> cc->dmreq_start + sizeof(struct dm_crypt_request) + cc->iv_size.
> 
> When accessing the initialization vector, dm-crypt uses the function
> iv_of_dmreq, which performs this calculation: ALIGN((unsigned long)(dmreq
> + 1), crypto_ablkcipher_alignmask(any_tfm(cc)) + 1).
> 
> dm-crypt allocated "cc->iv_size" bytes beyond the end of dm_crypt_request
> structure. However, when dm-crypt accesses the initialization vector, it
> takes a pointer to the end of dm_crypt_request, aligns it, and then uses
> it as the initialization vector.
> 
> If the end of dm_crypt_request is not aligned on
> crypto_ablkcipher_alignmask(any_tfm(cc)), the alignment causes
> initialization vector to point beyond the allocated space. This bug is
> very old (it dates back to commit 3a7f6c990ad04e6f576a159876c602d14d6f7fef
> in 2.6.25). However, the bug was masked by the fact that kmalloc rounds up
> the size to the next power of two. Recent change in dm-crypt that puts
> this structure to per-bio data (298a9fa08a1577211d42a75e8fc073baef61e0d9)
> made this bug show up, because there is no longer any padding beyond the
> end of iv_size.
> 
> This patch fixes the bug by calculating the variable iv_size_padding and
> adding it to the allocated size.
> 
> The patch also corrects alignment of dm_crypt_request. struct
> dm_crypt_request is specific to dm-crypt (it isn't used by the crypto
> subsystem at all), so it is aligned on __alignof__(struct
> dm_crypt_request).
> 
> The patch also aligns per_bio_data_size on ARCH_KMALLOC_MINALIGN, so that
> it is aligned as if the block was allocated with kmalloc.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Thanks for fixing this!

I tried all reproducers I have and no problems here with your patch.
(Except another unrelated oops in scsi_debug :-)

Tested-by: Milan Broz <gmazyland@gmail.com>

Milan
