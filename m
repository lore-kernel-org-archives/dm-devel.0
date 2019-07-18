From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH v7 1/1] Add dm verity root hash pkcs7 sig validation.
Date: Wed, 17 Jul 2019 18:04:46 -0700
Message-ID: <d057b88f-0a21-0843-1212-af46f67343a2@infradead.org>
References: <20190718004615.16818-1-jaskarankhurana@linux.microsoft.com>
 <20190718004615.16818-2-jaskarankhurana@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190718004615.16818-2-jaskarankhurana@linux.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>, gmazyland@gmail.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, scottsh@microsoft.com, mdsakib@microsoft.com, mpatocka@redhat.com, ebiggers@google.com
List-Id: dm-devel.ids

Hi,
Just a couple of minor nits:

On 7/17/19 5:46 PM, Jaskaran Khurana wrote:
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 3834332f4963..c2b04d226c90 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -490,6 +490,18 @@ config DM_VERITY
>  
>  	  If unsure, say N.
>  
> +config DM_VERITY_VERIFY_ROOTHASH_SIG
> +	def_bool n

It already defaults to n, so we usually try to omit that (don't repeat it).

> +	bool "Verity data device root hash signature verification support"
> +	depends on DM_VERITY
> +	select SYSTEM_DATA_VERIFICATION
> +	  help

"help" should only be indented by one tab (and not the extra 2 spaces).

> +	  The device mapper target created by DM-VERITY can be validated if the
> +	  pre-generated tree of cryptographic checksums passed has a pkcs#7
> +	  signature file that can validate the roothash of the tree.
> +
> +	  If unsure, say N.
> +
>  config DM_VERITY_FEC
>  	bool "Verity forward error correction support"
>  	depends on DM_VERITY


thanks.
-- 
~Randy
