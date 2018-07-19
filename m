From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/5] crypto: Add IV generation templates
Date: Thu, 19 Jul 2018 16:54:12 +0800
Message-ID: <20180719085412.5fxcanx364zten3b@gondor.apana.org.au>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
 <1531899055-29362-5-git-send-email-wangxiongfeng2@huawei.com>
 <b6eaf471-7279-ca4f-bb7c-d25df8db2419@gmail.com>
 <20180718164625.GA20360@sirena.org.uk>
 <82248c13-42fe-b598-0cd7-68e5db0b51be@gmail.com>
 <cda1d3de-3f21-2dfc-0423-c1cf456838b4@huawei.com>
 <CAK8P3a2oubqRKg1tnoG6CsmUs-U5Ab6q5rwpfg08PRNJLhEjEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a2oubqRKg1tnoG6CsmUs-U5Ab6q5rwpfg08PRNJLhEjEw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>, Milan Broz <gmazyland@gmail.com>, Mark Brown <broonie@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jonathan Cameron <jonathan.cameron@huawei.com>
List-Id: dm-devel.ids

On Thu, Jul 19, 2018 at 10:50:12AM +0200, Arnd Bergmann wrote:
>
> There seems to be some support for at least essiv(aes) in
> drivers/crypto/ccree/cc_cipher.c, is that compatible with your essiv(*)
> template, or is that something else?

Whatever it is it should be removed.  We should not be adding
hardware algorithms for which there is no software equivalent.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
