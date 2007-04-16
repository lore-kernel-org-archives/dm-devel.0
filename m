From: Herbert Xu <herbert.xu@redhat.com>
Subject: [0/3] [DM] dm-crypt: Add async blkcipher support
Date: Mon, 16 Apr 2007 20:58:23 +1000
Message-ID: <20070416105823.GA11225@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi:

These three patches convert dm-crypt from a synchronous blkcipher user
to an asynchronous one.  Due to the design of of the async blkcipher
interface, synchronous block ciphers are still supported by the same
code.  In fact, the dm-crypt performance is slightly better compared
to the previous synchronous interface.

With this change dm-crypt will support any asynchronous crypto drivers
that are added to Linux.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
