From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-verity: Fix a boundary condition that
 caused failure for certain device sizes
Date: Fri, 28 Jun 2013 10:53:03 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1306281023280.16714@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1306281007500.16553@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1306281007500.16553@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Cc: xuelingko@gmail.com, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids



On Fri, 28 Jun 2013, Mikulas Patocka wrote:

> Fix a boundary condition that caused failure for certain device sizes
> 
> The problem is reported at
> http://code.google.com/p/cryptsetup/issues/detail?id=160
> 
> For certain device sizes the number of hashes at a specific level was
> calculated incorrectly.
> 
> It happens for example for a device with data and metadata block size 4096
> that has 16385 blocks and algorithm sha256.
> 
> This patch fixes it.
> 
> The same bug exists in the veritysetup tool, so you must use fixed
> veritysetup too if you want to use devices that are affected by this
> boundary condition.

The user can test if he is affected by this bug by running the 
"veritysetup verify" command and also by activating the dm-verity kernel 
driver and reading the whole block device. If it passes without an error, 
then the user is not affected.

The condition for the bug is:

Split the total number of data blocks (data_block_bits) into bit strings, 
each string has hash_per_block_bits bits. hash_per_block_bits is 
rounddown(log2(metadata_block_size/hash_digest_size)). Equivalently, you 
can say that you convert data_blocks_bits to 2^hash_per_block_bits base.

If there some zero bit string below the most significant bit string and at 
least one bit below this zero bit string is set, then the bug happens.

Mikulas
