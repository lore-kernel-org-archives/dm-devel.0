From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC PATCH v5 1/1] Add dm verity root hash pkcs7 sig validation.
Date: Thu, 27 Jun 2019 16:41:50 -0700
Message-ID: <20190627234149.GA212823@gmail.com>
References: <20190619191048.20365-1-jaskarankhurana@linux.microsoft.com>
 <20190619191048.20365-2-jaskarankhurana@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190619191048.20365-2-jaskarankhurana@linux.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, scottsh@microsoft.com, mpatocka@redhat.com, gmazyland@gmail.com
List-Id: dm-devel.ids

Hi Jaskaran, one comment (I haven't reviewed this in detail):

On Wed, Jun 19, 2019 at 12:10:48PM -0700, Jaskaran Khurana wrote:
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index db269a348b20..2d658a3512cb 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -475,6 +475,7 @@ config DM_VERITY
>  	select CRYPTO
>  	select CRYPTO_HASH
>  	select DM_BUFIO
> +	select SYSTEM_DATA_VERIFICATION
>  	---help---
>  	  This device-mapper target creates a read-only device that
>  	  transparently validates the data on one underlying device against
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index be7a6eb92abc..3b47b256b15e 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -18,7 +18,7 @@ dm-cache-y	+= dm-cache-target.o dm-cache-metadata.o dm-cache-policy.o \
>  		    dm-cache-background-tracker.o
>  dm-cache-smq-y   += dm-cache-policy-smq.o
>  dm-era-y	+= dm-era-target.o
> -dm-verity-y	+= dm-verity-target.o
> +dm-verity-y	+= dm-verity-target.o dm-verity-verify-sig.o
>  md-mod-y	+= md.o md-bitmap.o
>  raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
>  dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o

Perhaps this should be made optional and controlled by a kconfig option
CONFIG_DM_VERITY_SIGNATURE_VERIFICATION, similar to CONFIG_DM_VERITY_FEC?

CONFIG_SYSTEM_DATA_VERIFICATION brings in a lot of stuff, which might be
unnecessary for some dm-verity users.  Also, you've already separated most of
the code out into a separate .c file anyway.

- Eric
