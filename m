From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6/9] dm crypt: support diskcipher
Date: Fri, 23 Aug 2019 14:27:02 +1000
Message-ID: <20190823042702.GA17034@gondor.apana.org.au>
References: <CGME20190823042038epcas2p2000738f3ca7f5f3d92ea1c32de2bcf99@epcas2p2.samsung.com>
 <017901d5596a$1df3a590$59daf0b0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <017901d5596a$1df3a590$59daf0b0$@samsung.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: "boojin.kim" <boojin.kim@samsung.com>
Cc: 'Ulf Hansson' <ulf.hansson@linaro.org>, 'Mike Snitzer' <snitzer@redhat.com>, dm-devel@redhat.com, 'Andreas Dilger' <adilger.kernel@dilger.ca>, 'Alasdair Kergon' <agk@redhat.com>, 'Eric Biggers' <ebiggers@kernel.org>, linux-samsung-soc@vger.kernel.org, 'Krzysztof Kozlowski' <krzk@kernel.org>, 'Jaehoon Chung' <jh80.chung@samsung.com>, 'Kukjin Kim' <kgene@kernel.org>, linux-ext4@vger.kernel.org, linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 'Jaegeuk Kim' <jaegeuk@kernel.org>, linux-arm-kernel@lists.infradead.org, 'Jens Axboe' <axboe@kernel.dk>, "'Theodore Y. Ts'o'" <tytso@mit.edu>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, "'David S. Miller'" <davem@davemloft.net>
List-Id: dm-devel.ids

On Fri, Aug 23, 2019 at 01:20:37PM +0900, boojin.kim wrote:
>
> If yes, I think the following API needs to be added to skcipher:  
> - _set(): BIO submitter (dm-crypt, f2fs, ext4) sets cipher to BIO.
> - _mergeable(): Block layer checks if two BIOs have the same cipher.
> - _get(): Storage driver gets cipher from BIO.
> - _set_crypt(): Storage driver gets crypto information from cipher and 
> writes it on the descriptor of Storage controller.
> Is it acceptable to skcipher ?

No.  If you're after total offload then the crypto API is not for
you.  What we can support is the offloading of encryption/decryption
over many sectors.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
