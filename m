From: "boojin.kim" <boojin.kim@samsung.com>
Subject: Re: [PATCH 5/9] block: support diskcipher
Date: Thu, 22 Aug 2019 09:54:38 +0900
Message-ID: <017901d55884$2cbc8f60$8635ae20$@samsung.com>
References: <CGME20190822005438epcas2p337aba06b328cdcdd1549395f0bbcfdbc@epcas2p3.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: ko
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: 'Herbert Xu' <herbert@gondor.apana.org.au>, "'David S. Miller'" <davem@davemloft.net>, 'Eric Biggers' <ebiggers@kernel.org>, "'Theodore Y. Ts'o'" <tytso@mit.edu>, 'Chao Yu' <chao@kernel.org>, 'Jaegeuk Kim' <jaegeuk@kernel.org>, 'Andreas Dilger' <adilger.kernel@dilger.ca>'Theodore Ts'o' <tytso@mit.edu>, dm-devel@redhat.com, 'Mike Snitzer' <snitzer@redhat.com>, 'Alasdair Kergon' <agk@redhat.com>, 'Jens Axboe' <axboe@kernel.dk>, 'Krzysztof Kozlowski' <krzk@kernel.org>, 'Kukjin Kim' <kgene@kernel.org>, 'Jaehoon Chung' <jh80.chung@samsung.com>, 'Ulf Hansson' <ulf.hansson@linaro.org>, linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-mmc@vger.kernel.org, linux-samsung-soc@vger.kernel.org, linux-ext4@v
List-Id: dm-devel.ids

On 8/21/19 21:09 AM, Jens Axboe wrote:
> This isn't going to happen. With this, and the inline encryption
> proposed by Google, we'll bloat the bio even more. At least the Google
> approach didn't include bio iter changes as well.

> Please work it out between yourselves so we can have a single, clean
> abstraction that works for both.

I'm looking at inline encryption by Google. 
I will find compatibility with inline encryption to avoid conflicts
in BIO/F2FS.
And changing bio iter has a benefit for diskcipher.
Without changing bio iter, diskcipher should control(alloc/free) a buffer
to hold a 'bi_dun' variable for every bio.
But changing bio iter is difficult to accept for block layer,
I will modify the diskcipher.
And, as you mentioned, inline encryption by Google has this control.
So I might be able to use it.

Thanks.
Boojin Kim.
