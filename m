From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH v3 1/1] Add dm verity root hash pkcs7 sig validation
Date: Sat, 8 Jun 2019 11:11:37 +0200
Message-ID: <54170d18-31c7-463d-10b5-9af8b666df0f@gmail.com>
References: <20190607223140.16979-1-jaskarankhurana@linux.microsoft.com>
 <20190607223140.16979-2-jaskarankhurana@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190607223140.16979-2-jaskarankhurana@linux.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, scottsh@microsoft.com, ebiggers@google.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On 08/06/2019 00:31, Jaskaran Khurana wrote:
> The verification is to support cases where the roothash is not secured by
> Trusted Boot, UEFI Secureboot or similar technologies.
> One of the use cases for this is for dm-verity volumes mounted after boot,
> the root hash provided during the creation of the dm-verity volume has to
> be secure and thus in-kernel validation implemented here will be used
> before we trust the root hash and allow the block device to be created.
> 
> The signature being provided for verification must verify the root hash and
> must be trusted by the builtin keyring for verification to succeed.
> 
> The hash is added as a key of type "user" and the description is passed to
> the kernel so it can look it up and use it for verification.
> 
> Adds DM_VERITY_VERIFY_ROOTHASH_SIG: roothash verification
> against the roothash signature file *if* specified, if signature file is
> specified verification must succeed prior to creation of device mapper
> block device.
> 
> Adds DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE: roothash signature *must* be
> specified for all dm verity volumes and verification must succeed prior
> to creation of device mapper block device.

AFAIK there are tools that use dm-verity internally (some container
functions in systemd can recognize and check dm-verity partitions) and with
this option we will just kill possibility to use it without signature.

Anyway, this is up to Mike and Mikulas, I guess generic distros will not
set this option.

Some minor details below:

> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index be7a6eb92abc..8a8c142bcfe1 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -61,7 +61,7 @@ obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
>  obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
>  obj-$(CONFIG_DM_RAID)	+= dm-raid.o
>  obj-$(CONFIG_DM_THIN_PROVISIONING)	+= dm-thin-pool.o
> -obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
> +obj-$(CONFIG_DM_VERITY)		+= dm-verity.o dm-verity-verify-sig.o

Why is this different from existing FEC extension? 
FEC uses ifdefs in header to blind functions if config is not set.

ifeq ($(CONFIG_DM_VERITY_FEC),y)
dm-verity-objs                  += dm-verity-fec.o
endif

...

> diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
> new file mode 100644
> index 000000000000..1a889be76ede
> --- /dev/null
> +++ b/drivers/md/dm-verity-verify-sig.c

...

> +	key = request_key(&key_type_user,
> +			key_desc, NULL);
> +	if (IS_ERR(key))
> +		return PTR_ERR(key);

You will need dependence on keyring here (kernel can be configured without it),
try to compile it without CONFIG_KEYS selected.

I think it is ok that  DM_VERITY_VERIFY_ROOTHASH_SIG can directly require CONFIG_KEYS.
(Add depends on CONFIG_KEYS in KConfig)

Also please increase minor version of dm-verity target when adding functions, something like

@@ -1175,7 +1175,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 static struct target_type verity_target = {
        .name           = "verity",
-       .version        = {1, 4, 0},
+       .version        = {1, 5, 0},

Thanks,
Milan
