From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-crypt: Fix per-bio data alignment
Date: Wed, 27 Aug 2014 12:18:27 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1408271057540.18309@file01.intranet.prod.int.rdu2.redhat.com>
References: <53F238EF.10409@winsoft.pl>
	<1408386997-14690-1-git-send-email-gmazyland@gmail.com>
	<alpine.LRH.2.02.1408191433450.29729@file01.intranet.prod.int.rdu2.redhat.com>
	<53F3A864.9060704@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53F3A864.9060704@gmail.com>
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
Cc: snitzer@redhat.com, agk@redhat.com, kkolasa@winsoft.pl, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids



On Tue, 19 Aug 2014, Milan Broz wrote:

> 
> On 08/19/2014 08:37 PM, Mikulas Patocka wrote:
> > Hi
> > 
> > I would like to see the explanation, why does this patch fix it. i686 
> > allows unaligned access for most instructions, so I wonder how could 
> > adding an alignment fix it.
> > 
> > What is the exact cipher mode that crashes it? How can I reproduce it with 
> > cryptsetup?
> > 
> > Is it possible that something shoots beyond the end of cc->iv_size and the 
> > alignment just masks this bug?
> 
> Hi Mikulas,
> 
> TBH I did not analysed it in detail, but apparently there is 4byte more needed
> on 32bit arch, I checked size before and after my patch and these
> 4 bytes solves the problem. (I guess crypto cipher api requires alignment here but
> I have really no time to trace it now.)
> 
> For me it crashes lrw mode for twofish (I think it uses twofish_i586 but cannot verify it now)
> (but see oops log posted) but probably there are more cases.
> 
> If there is no other magic related, it should be easily reproducible just by running
> "make check" (or directly tcrypt-compat-test) from cryptsetup upstream (1.6.6 release is also fine)
> on 32 bit with 3.17-rc1.
> 
> (I am running it with AES-NI capable CPU, quite common Lenovo nb config.)
> 
> Milan

Hi

The bug is caused by this:

Here we calculate dm_req_start and allocate cc->dmreq_start + 
sizeof(struct dm_crypt_request) + cc->iv_size bytes.

        cc->dmreq_start += crypto_ablkcipher_alignmask(any_tfm(cc)) &
                           ~(crypto_tfm_ctx_alignment() - 1);

        cc->req_pool = mempool_create_kmalloc_pool(MIN_IOS, 
cc->dmreq_start +
                        sizeof(struct dm_crypt_request) + cc->iv_size);

        cc->per_bio_data_size = ti->per_bio_data_size =
                                sizeof(struct dm_crypt_io) + 
cc->dmreq_start +
                                sizeof(struct dm_crypt_request) + 
cc->iv_size;


Here, we take the end of struct dm_crypt_request (it may not be aligned), 
align it and use it as iv:

static u8 *iv_of_dmreq(struct crypt_config *cc,
                       struct dm_crypt_request *dmreq)
{
        return (u8 *)ALIGN((unsigned long)(dmreq + 1),
                crypto_ablkcipher_alignmask(any_tfm(cc)) + 1);
}

The result is that iv may point beyond the end of allocated space.

This bug is very old, it existed there from 
3a7f6c990ad04e6f576a159876c602d14d6f7fef (2.6.25). The bug was masked by 
the fact that kmalloc rounds up size to the next power of two. The new 
changes in dm-crypt in 3.17-rc1 remove this rounding and thus the bug 
started to show up.

I think we also need new debug option for kmalloc that will catch writes 
beyond the end of kmalloc memory like this. (the current slab debug 
doesn't catch it because it checks for writes beyond the end of the slab 
chunk, which was already padded to the next power of 2).

Mikulas
