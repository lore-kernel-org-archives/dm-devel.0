From: Horia Geanta <horia.geanta@nxp.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Wed, 17 Jul 2019 17:09:31 +0000
Message-ID: <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190716221639.GA44406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Biggers <ebiggers@kernel.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

On 7/17/2019 1:16 AM, Eric Biggers wrote:
> Hi Horia,
> 
> On Tue, Jul 16, 2019 at 05:46:29PM +0000, Horia Geanta wrote:
>> Hi,
>>
>> With fuzz testing enabled, I am seeing xts(aes) failures on caam drivers.
>>
>> Below are several failures, extracted from different runs:
>>
>> [    3.921654] alg: skcipher: xts-aes-caam encryption unexpectedly succeeded on test vector "random: len=40 klen=64"; expected_error=-22, cfg="random: inplace use_finup nosimd src_divs=[57.93%@+11, 37.18%@+164, <reimport>0.68%@+4, 0.50%@+305, 3.71%@alignmask+3975]" 
>>
>> [    3.726698] alg: skcipher: xts-aes-caam encryption unexpectedly succeeded on test vector "random: len=369 klen=64"; expected_error=-22, cfg="random: inplace may_sleep use_digest src_divs=[100.0%@alignmask+584]" 
>>
>> [    3.741082] alg: skcipher: xts-aes-caam encryption unexpectedly succeeded on test vector "random: len=2801 klen=64"; expected_error=-22, cfg="random: inplace may_sleep use_digest src_divs=[100.0%@+6] iv_offset=18"
>>
>> It looks like the problem is not in CAAM driver.
>> More exactly, fuzz testing is generating random test vectors and running
>> them through both SW generic (crypto/xts.c) and CAAM implementation:
>> -SW generic implementation of xts(aes) does not support ciphertext stealing
>> and throws -EINVAL when input is not a multiple of AES block size (16B)
>> -caam has support for ciphertext stealing, and allows for any input size
>> which results in "unexpectedly succeeded" error messages.
>>
>> Any suggestion how this should be fixed?
>>
>> Thanks,
>> Horia
> 
> I don't think drivers should allow inputs the generic implementation doesn't,
> since those inputs aren't tested by the crypto self-tests (so how do you know
How about implementation adding static test vectors and using them to validate
the standard feature set that's not supported by the generic implementation?

> it's even correct?), and people could accidentally rely on the driver-specific
> behavior and then be unable to migrate to another platform or implementation.
> 
People could also *intentionally* rely on a driver offering an implementation
that is closer to the spec / standard.

> So for now I recommend just updating the caam driver to return -EINVAL on XTS
> inputs not evenly divisible by the block size.
> 
I was hoping for something more constructive...

> Of course, if there are actual use cases for XTS with ciphertext stealing in the
> kernel, we could add it to all the other implementations too.  But I'm not aware
> of any currently.  Don't all XTS users in the kernel pass whole blocks?
> 
That's my guess too.

What about user space relying on offloading and xts working
according to the spec?

Thanks,
Horia
