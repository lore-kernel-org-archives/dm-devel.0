From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 5/9] block: support diskcipher
Date: Tue, 27 Aug 2019 12:40:12 -0400
Message-ID: <20190827164012.GN28066@mit.edu>
References: <CGME20190827083334epcas2p115d479190b9a72c886f66569add78203@epcas2p1.samsung.com>
 <03b201d55cb2$1d4d31b0$57e79510$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <03b201d55cb2$1d4d31b0$57e79510$@samsung.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "boojin.kim" <boojin.kim@samsung.com>
Cc: 'Ulf Hansson' <ulf.hansson@linaro.org>, 'Mike Snitzer' <snitzer@redhat.com>, dm-devel@redhat.com, 'Andreas Dilger' <adilger.kernel@dilger.ca>, 'Alasdair Kergon' <agk@redhat.com>, 'Eric Biggers' <ebiggers@kernel.org>, linux-samsung-soc@vger.kernel.org, 'Herbert Xu' <herbert@gondor.apana.org.au>, 'Krzysztof Kozlowski' <krzk@kernel.org>, 'Satya Tangirala' <satyat@google.com>, 'Jaehoon Chung' <jh80.chung@samsung.com>, 'Kukjin Kim' <kgene@kernel.org>, linux-ext4@vger.kernel.org, 'Chao Yu' <chao@kernel.org>, linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 'Jaegeuk Kim' <jaegeuk@kernel.org>, linux-arm-kernel@lists.infradead.org, 'Jens Axboe' <axboe@kernel.dk>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, "'David S. Miller'" <davem@davemloft.net>
List-Id: dm-devel.ids

On Tue, Aug 27, 2019 at 05:33:33PM +0900, boojin.kim wrote:
> 
> Dear Satya.
> Keyslot manager is a good solution for ICE. And probably no issue for FMP.
> But, I think it's complicated for FMP because FMP doesn't need
> any keyslot control.

Hi Boojin,

I think the important thing to realize here is that there are a large
number of hardware devices for which the keyslot manager *is* needed.
And from the upstream kernel's perspective, supporting two different
schemes for supporting the inline encryption feature is more
complexity than just supporting one which is general enough to support
a wider variety of hardware devices.

If you want somethig which is only good for the hardware platform you
are charged to support, that's fine if it's only going to be in a
Samsung-specific kernel.  But if your goal is to get something that
works upstream, especially if it requires changes in core layers of
the kernel, it's important that it's general enough to support most,
if not all, if the hardware devices in the industry.

Regards,

					- Ted
