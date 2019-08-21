From: "boojin.kim" <boojin.kim@samsung.com>
Subject: Re: [PATCH 6/9] dm crypt: support diskcipher
Date: Wed, 21 Aug 2019 16:57:41 +0900
Message-ID: <001b01d557f6$1c49fd40$54ddf7c0$@samsung.com>
References: <CGME20190821075742epcas2p4b9104e8249067c048d4050f2888da0a9@epcas2p4.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Language: ko
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
Cc: 'Ulf Hansson' <ulf.hansson@linaro.org>, 'Mike Snitzer' <snitzer@redhat.com>, dm-devel@redhat.com, 'Andreas Dilger' <adilger.kernel@dilger.ca>, 'Alasdair Kergon' <agk@redhat.com>, 'Eric Biggers' <ebiggers@kernel.org>, linux-samsung-soc@vger.kernel.org, 'Herbert Xu' <herbert@gondor.apana.org.au>, 'Krzysztof Kozlowski' <krzk@kernel.org>, 'Jaehoon Chung' <jh80.chung@samsung.com>, 'Kukjin Kim' <kgene@kernel.org>, linux-ext4@vger.kernel.org, 'Chao Yu' <chao@kernel.org>, linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 'Jaegeuk Kim' <jaegeuk@kernel.org>, linux-arm-kernel@lists.infradead.org, 'Jens Axboe' <axboe@kernel.dk>, 'Theodore Ts'o' <tytso@mit.edu>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, "'David S. Miller'" <davem@davemloft.net>
List-Id: dm-devel.ids

On Wed, Aug 21, 2019 at 09:35:36AM +0200, Herbert Xu Herbert wrote:

> I agree.  Please take a look at the recent ESSIV patches on
> linux-crypto and build multi-block operations on top of them
> which can then be implemented by the hardware.
>
> Cheers,

Can you tell me which patch you mentioned? Is this?
https://patches.linaro.org/project/linux-crypto/list/?series=22762
