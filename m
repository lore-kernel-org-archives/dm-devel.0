From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 2/2] md: dm-crypt: Optimize the dm-crypt for XTS mode
Date: Tue, 15 Dec 2015 00:31:52 +0100
Message-ID: <566F5168.7010905@gmail.com>
References: <cover.1450080755.git.baolin.wang@linaro.org>
 <02be0f42bf2d3c3d27b43bc050a783582b7af733.1450080755.git.baolin.wang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <02be0f42bf2d3c3d27b43bc050a783582b7af733.1450080755.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: neilb@suse.com, dan.j.williams@intel.com, martin.petersen@oracle.com, sagig@mellanox.com, kent.overstreet@gmail.com, keith.busch@intel.com, tj@kernel.org, broonie@kernel.org, arnd@arndb.de, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 12/14/2015 09:23 AM, Baolin Wang wrote:
> In now dm-crypt code, it is ineffective to map one bio with just only
> one scatterlist at one time for XTS mode. We can use multiple scatterlists
> to map the whole bio and send all scatterlists of one bio to crypto engine
> to encrypt or decrypt, which can improve the hardware engine's efficiency.

...

> +	/*
> +	 * Here we need to check if it can be encrypted or decrypted with
> +	 * bulk block, which means these encryption modes don't need IV or
> +	 * just need one initial IV. For bulk mode, we can expand the
> +	 * scatterlist entries to map the bio, then send all the scatterlists
> +	 * to the hardware engine at one time to improve the crypto engine
> +	 * efficiency. But it does not fit for other encryption modes, it has
> +	 * to do encryption and decryption sector by sector because every
> +	 * sector has different IV.
> +	 */
> +	if (!strcmp(chainmode, "ecb") || !strcmp(chainmode, "xts"))
> +		cc->bulk_crypto = 1;
> +	else
> +		cc->bulk_crypto = 0;n

It is perfectly fine to use another IV even for XTS mode (despite it is not needed).
You can use ESSIV for example, or benbi (big-endian variant of plain IV).
(And it is really used for some LUKS devices.)

How it is supposed to work in this case?
If I read this patch correctly, it will completely corrupt data in this case because
it expects plain (consecutive) IV...

Also how it handles 32bit plain IV (that restart after 2TB)? (IOW plain IV, not plain64).

Milan
