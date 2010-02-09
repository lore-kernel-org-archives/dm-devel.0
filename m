From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] dm-crypt: disable block encryption with arc4
Date: Tue, 9 Feb 2010 22:12:38 +0100
Message-ID: <20100209211238.GC21548@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com>
 <20100209073718.GA17612@gondor.apana.org.au>
 <20100209145705.GA20421@Chamillionaire.breakpoint.cc>
 <20100209204519.GC26258@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100209204519.GC26258@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com, linux-crypto@ml.breakpoint.cc, dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
List-Id: dm-devel.ids

* Herbert Xu | 2010-02-10 07:45:19 [+1100]:

>> Herbert, what happend to the "check for streamcipher" idea you had? Is
>> it gone? On the other hand it wouldn't be probably that bad to have a
>
>Well again whether that should be done is up to the dm-crypt
>maintainers.
Milan liked that afaik.

>> seprate interface to grab a block cipher _or_ a stream cipher. So
>
>Just because something isn't a stream cipher doesn't mean that
>it is safe for disk encryption.  People simply shouldn't be using
>random algorithms for disk encryption.
>
>> I can't imaging how you want to fix arc4 that it will work in dm-crypt.
>
>I thought I've explained this before.  Just turn it into a blkcipher
>and add IV.
I beg your pardon. I probably mixed things up.

>> The algorithm relies more or less on the fact that it envolves itself
>> during processing of data.
>
>This is no different to any stream cipher.
Sure. So we fix arc4 and don't play mother . Okay I will into this :)

>
>Cheers,

Sebastian
