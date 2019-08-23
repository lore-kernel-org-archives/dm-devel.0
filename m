From: "boojin.kim" <boojin.kim@samsung.com>
Subject: Re: [PATCH 6/9] dm crypt: support diskcipher
Date: Fri, 23 Aug 2019 13:20:37 +0900
Message-ID: <017901d5596a$1df3a590$59daf0b0$@samsung.com>
References: <CGME20190823042038epcas2p2000738f3ca7f5f3d92ea1c32de2bcf99@epcas2p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Language: ko
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
Cc: 'Ulf Hansson' <ulf.hansson@linaro.org>, 'Mike Snitzer' <snitzer@redhat.com>, dm-devel@redhat.com, 'Andreas Dilger' <adilger.kernel@dilger.ca>, 'Alasdair Kergon' <agk@redhat.com>, 'Eric Biggers' <ebiggers@kernel.org>, linux-samsung-soc@vger.kernel.org, 'Herbert Xu' <herbert@gondor.apana.org.au>, 'Krzysztof Kozlowski' <krzk@kernel.org>, 'Jaehoon Chung' <jh80.chung@samsung.com>, 'Kukjin Kim' <kgene@kernel.org>, linux-ext4@vger.kernel.org, linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 'Jaegeuk Kim' <jaegeuk@kernel.org>, linux-arm-kernel@lists.infradead.org, 'Jens Axboe' <axboe@kernel.dk>, 'Theodore Ts'o' <tytso@mit.edu>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, "'David S. Miller'" <davem@davemloft.net>
List-Id: dm-devel.ids

On Wed, Aug 21, 2019 at 17:19:41PM +0900, Herbert Xu wrote:

> On Wed, Aug 21, 2019 at 04:57:41PM +0900, boojin.kim wrote:
> >
> > Can you tell me which patch you mentioned? Is this?
> > https://patches.linaro.org/project/linux-crypto/list/?series=22762
> >
>
> Yes this is the one.
>
> Cheers,

I looked at ESSIV patch-set.
Can you please confirm that you mean:
'Register FMP as the template of skcipher instead of diskcipher,
and simplify the interface for FMP user'

If yes, I think the following API needs to be added to skcipher:  
- _set(): BIO submitter (dm-crypt, f2fs, ext4) sets cipher to BIO.
- _mergeable(): Block layer checks if two BIOs have the same cipher.
- _get(): Storage driver gets cipher from BIO.
- _set_crypt(): Storage driver gets crypto information from cipher and 
writes it on the descriptor of Storage controller.
Is it acceptable to skcipher ?
