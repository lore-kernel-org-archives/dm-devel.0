From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC 1/1] Add dm verity root hash pkcs7 sig validation.
Date: Tue, 21 May 2019 09:38:35 +0200
Message-ID: <7e922983-7716-e215-a29b-3154f7afb493@gmail.com>
References: <20190520215422.23939-1-jaskarankhurana@linux.microsoft.com>
 <20190520215422.23939-2-jaskarankhurana@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190520215422.23939-2-jaskarankhurana@linux.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org
List-Id: dm-devel.ids

On 20/05/2019 23:54, Jaskaran Khurana wrote:
> Adds in-kernel pkcs7 signature checking for the roothash of
> the dm-verity hash tree.
> 
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
> Adds DM_VERITY_VERIFY_ROOTHASH_SIG: roothash verification
> against the roothash signature file *if* specified, if signature file is
> specified verification must succeed prior to creation of device mapper 
> block device.
> 
> Adds DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE: roothash signature *must* be
> specified for all dm verity volumes and verification must succeed prior
> to creation of device mapper block device.

I am not sure this is a good idea. If I understand it correctly, this will
block creating another dm-verity mappings without PKCS7 signature, and these
are used in many other environments and applications that could possibly
run on that system later.

(But I have no idea how to solve it better though :-)

...

> +	/* Root hash signature is  a optional parameter*/
> +	r = verity_verify_root_hash(root_hash_digest_to_validate,
> +				    strlen(root_hash_digest_to_validate),
> +				    verify_args.sig,
> +				    verify_args.sig_size);
> +	if (r < 0) {
> +		ti->error = "Root hash verification failed";
> +		goto bad;
> +	}

You are sending the PKCS7 signature as a (quite large) binary blob inside the mapping table.

I am not sure if it is possible here (I guess so), but why not put this it kernel keyring
and then just reference it from mapping table?
(We use kernel keyring in libcryptsetup already for dm-crypt.)

It will also solve an issue in userspace patch, when you are reading the signature
file too late (devices can be suspended in that moment, so I would prefer to download
sig file to keyring in advance, and then just reference it in mapping table).

(I guess you will send merge request for veritysetup userspace part later.)

Milan
