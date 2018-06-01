From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [dm-devel] [PATCH] md: dm-crypt: Add Inline Encryption support
 for dmcrypt
Date: Fri, 1 Jun 2018 09:46:25 -0500
Message-ID: <20180601144625.GA8111@zzz.localdomain>
References: <e9120efc-1e25-79c8-6132-9062dd030539@synopsys.com>
 <7a510610-9133-39aa-6841-3925c532f3c0@gmail.com>
 <BD7FB879CC136E419544C8E2AE7B9C3020BB94@IN01WEMBXA.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BD7FB879CC136E419544C8E2AE7B9C3020BB94@IN01WEMBXA.internal.synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ladvine D Almeida <Ladvine.DAlmeida@synopsys.com>
Cc: Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Joao Pinto <Joao.Pinto@synopsys.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Manjunath M Bettegowda <Manjunath.MB@synopsys.com>, Tejas Joglekar <Tejas.Joglekar@synopsys.com>, Prabu Thangamuthu <Prabu.T@synopsys.com>
List-Id: dm-devel.ids

Hi Ladvine,

On Wed, May 30, 2018 at 02:52:07PM +0000, Ladvine D Almeida wrote:
> On Monday 28 May 2018 05:33 PM, Milan Broz wrote:
> > On 05/28/2018 03:01 PM, Ladvine D Almeida wrote:
> >> This patch adds new option
> >>     -- perform_inline_encrypt
> >> that set the option inside dmcrypt to use inline encryption for
> >> the configured mapping. I want to introduce inline encryption support
> >> in the UFS Host Controller driver. The usage of the same for accomplishing
> >> the Full Disk Encryption is done by the following changes in the
> >> dmcrypt subsystem:
> >>     - New function crypt_inline_encrypt_submit() is added to the
> >> dmcrypt which associate the crypto context to the bios which
> >> are submitted by the subsystem.
> >>     - Successful configuration for the inline encryption will result in
> >> the crypto transformation job being bypassed in the dmcrypt layer and the
> >> actual encryption happens inline to the block device.
> > I am not sure this is a good idea. Dm-crypt should never ever forward
> > plaintext sector to underlying device.
> >
> > And you do not even check that your hw is available in the underlying device!
> >
> > If you want to use dm-crypt, write a crypto API driver for your crypto hw that defines
> > specific cipher and let dm-crypt use this cipher (no patches needed in this case!)
> 
> Thanks for sharing your review.
> I am sharing the links for the patches which are related to inline encryption below:
> https://lkml.org/lkml/2018/5/28/1153
> https://lkml.org/lkml/2018/5/28/1196
> https://lkml.org/lkml/2018/5/28/1158
> https://lkml.org/lkml/2018/5/28/1173
> https://lkml.org/lkml/2018/5/28/1178
> 
> we have crypto API implementation for the hardware for  XTS algorithm, which will get registered when
> the XTS algorithm capability of the inline encryption engine inside UFS Host Controller get detected by the UFS HC
> driver. dm-crypt will be using this registered cipher.
>  dm-crypt patch is unavoidable because the encrypt/decrypt function cannot perform the transformation
> when inline encryption engine is involved. Also, it demands forwarding the plaintext sectors to the underlying
> block device driver and  the crypto transformation happens internally in controller when data transfer happens.
> 

I appreciate that you're working on this, but can you please send the full
series to the relevant mailing lists, so that everyone has the needed context?
Single random patches for this are basically impossible to review.  OFC that
also means including a cover letter that explains the overall problem and your
solution.  In the Cc list I also recommend including the ext4 maintainer
Theodore Ts'o <tytso@mit.edu>, who led a discussion at LSFMM 2017 about this
topic (https://lwn.net/Articles/717754/), and the f2fs maintainer Jaegeuk Kim
<jaegeuk@kernel.org> who has had to deal with this stuff in an Android device
kernel, but for another vendor's inline encryption hardware.  I assume your
solution will work for other vendors too?  I think inline encryption is part of
the latest UFS specificaton now, so the latest hardware does it in a
"standardized" way and doesn't require ad-hoc vendor-specific stuff --- right?
And do you have any plans for inline encryption support with fscrypt (ext4/f2fs
encryption, a.k.a. what Android calls "File-Based Encryption")?  We need a
design for inline encryption in the upstream kernel that is sufficiently general
to work for all these vendors and use cases, not just specific ones.

Just at a quick glance, you also seem to be abusing the crypto API by exposing
inline encryption capabilities as a skcipher_alg.  With inline encryption by
definition you can't actually do encryption outside of a block device request;
as a result, your patch has to use a fallback algorithm to do the actual
encryption for the skcipher_alg, which makes no sense.  So it is not at all
clear to me that you should use the crypto API at all, as opposed to having it
be purely a block layer thing.  (Please also Cc linux-crypto if you are doing
significant work related to the crypto API.)

> >
> > If I read the patch correctly, you do not check any parameters for
> > compatibility with your hw support (cipher, mode, IV algorithm, key length, sector size ...)
> 
> I am registering an algorithm with cipher mode, IV size, block size, supported key size etc. for use by dm-crypt
> as per the hardware capability of inline encryption engine.
> If any other cipher mode, etc is used during the setup stage, DM-Crypt will work as normal.
> 
> >
> > It seems like if the "perform_inline_encrypt" option is present, you just submit
> > the whole bio to your code with new INLINE_ENCRYPTION bit set.
> 
> when the optional argument "perform_inline_encrypt" is set, we are not unconditionally sending the bio
> to the block devices. The steps are explained below:
> 1. user invokes the dm-setup command with the registered cipher "xts" and with the optional argument
> "perform_inline_encrypt".
> 2. dm-setup invokes the setkey function of the newly introduced algorithm, which finds the available key slots
> to be programmed(UFS Host controller Inline Encryption engine has multiple keyslots), program the key slot,
> and return the key slot index as return value of the set key function.
> 3. When read/write operation happens, crypt_map() function in dm-crypt validates whether there is associated
> key configuration index for the request. The Bio will be submitted directly in this case only with the associated
> crypto context.
> 4. Block device driver, eg. UFS host controller driver will create the Transfer requests as per this crypto context and
> encryption happens inside the controller.
> 
> >
> > What happens, if the cipher in table is different from what your hw is doing?
> 
> In this case, the dm-crypt will work as previous. This is because the setkey returns 0.
> whenever there is key configuration index associated, setkey returns index value(greater than 0). The bios are submitted
> with that information to underlying block device drivers.
> Also, care is taken to ensure that fallback will happen incase hardware lacks the support of any key lengths.
> 
> Appreciate your suggestions/feedback. We are trying to bring modifications into the subsystem to support controllers with
> inline encryption capabilities and tried our best to take care of any vulnerabilities or risks associated to same.
> Inline encryption engines got huge advantage over the accelerators/software algorithms that it removes overhead associated
> to current implementation like performing transformation on 512 byte chunks, allocation of scatterlists etc.

Thanks,

Eric
