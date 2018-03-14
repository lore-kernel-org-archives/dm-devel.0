From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] Add an option to dm-verity to validate hashes at most
 once
Date: Wed, 14 Mar 2018 12:09:57 -0700
Message-ID: <20180314190957.GB183724@google.com>
References: <20180306231456.210504-1-totte@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180306231456.210504-1-totte@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrik Torstensson <totte@google.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, samitolvanen@google.com, gkaiser@google.com, paulcrowley@google.com
List-Id: dm-devel.ids

Hi Patrik,

On Tue, Mar 06, 2018 at 03:14:56PM -0800, Patrik Torstensson wrote:
> Add an option to dm-verity to validate hashes at most once
> to allow platforms that is CPU/memory contraint to be
> protected by dm-verity against offline attacks.
> 
> The option introduces a bitset that is used to check if
> a block has been validated before or not. A block can
> be validated more than once as there is no thread protection
> for the bitset.
> 
> This patch has been developed and tested on entry-level
> Android Go devices.
> 
> Signed-off-by: Patrik Torstensson <totte@google.com>
> ---
>  drivers/md/dm-verity-target.c | 58 +++++++++++++++++++++++++++++++++--
>  drivers/md/dm-verity.h        |  1 +
>  2 files changed, 56 insertions(+), 3 deletions(-)

The new option needs to be documented in Documentation/device-mapper/verity.txt,
including a description of what the option does as well as how it affects the
security properties of dm-verity.  There should also be a mention of why the
option applies to data blocks but not hash blocks, assuming that's intentional.

verity_status() also needs to be updated to show the new option, otherwise it
will not be visible via the DM_TABLE_STATUS ioctl ('dmsetup table' on the
command line).

Also the minor version number in the struct target_type needs to be incremented,
so that userspace can determine whether the option is supported.

>  
>  	for (b = 0; b < io->n_blocks; b++) {
>  		int r;
> +		sector_t cur_block = io->block + b;
>  		struct ahash_request *req = verity_io_hash_req(v, io);
>  
> +		if (v->validated_blocks &&
> +		    likely(test_bit(cur_block, v->validated_blocks))) {
> +			verity_bv_skip_block(v, io, &io->iter);
> +			continue;
> +		}
> +
>  		r = verity_hash_for_block(v, io, io->block + b,

Can you replace 'io->block + b' with 'cur_block' here as well?

Thanks,

- Eric
