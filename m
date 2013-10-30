From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 1/2] dm-crypt: Properly handle extra key
 string in initialization
Date: Wed, 30 Oct 2013 20:30:38 +0100
Message-ID: <52715E5E.1030307@gmail.com>
References: <1382275000-10660-1-git-send-email-gmazyland@gmail.com>
	<1382998864-10380-1-git-send-email-gmazyland@gmail.com>
	<20131030024814.GA17405@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131030024814.GA17405@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 10/30/2013 03:48 AM, Alasdair G Kergon wrote:
> On Mon, Oct 28, 2013 at 11:21:03PM +0100, Milan Broz wrote:
>> +			cc->key_extra_size = cc->key_size / cc->key_parts;
> 
> I don't understand the logic that leads to this assignment.
> 
> Are there some implicit constraints on the input?

This part is only for loopAES (lmk IV generator). In this situation only
one configuration is used in real world which is processed by this code,
65 keys of the same size (64 cipher keys and one IV seed).

The extra part (IV seed key) is thus exactly size of one key.

In dmcrypt lmk is implemented more generic (not limited to 64 cipher keys)
but there is still requirement that all keys are the same length.

(If there is no comment in code mentioning the same size requirement,
it should be here, will add it.)

> 
> Do all invalid inputs produce an appropriate error?

I hope it should.
If the key is correct size, cipher is initialised. If not, it returns error.

If you send garbage and it is of correct length, it is just garbage-in, garbage out.

N.B the problem with dmcrypt table is that some parameters of cipher
are just derived from key string length (e.g. AES-128/192/256).
If user want AES128 but send doubled key, we have no way to detect it...
 
> Is there a clearer way to set out the calculation and can it be annotated?
Dunno. I think comment mentioned above is the best way.

> Can we rename key_extra_size to extrakey_size (like subkey_size)?

I am not sure it is good idea. key_extra_size is related to key_size,
that's why it has this name...

> Is extrakey_size always less than subkey_size?

If you mean subkey in crypt_setkey_allcpus(), no, in principle
they are unrelated.

(subkey size is key size for main encryption, extra key can contain
whatever is needed for initializing IV generator)

For example (very old TrueCrypt container)
3DES cipher, which has K of size 24 bytes (3 * 64bits)

this is table:
0 16383 crypt des3_ede-cbc-tcw 0123f1b2c40ab6240f6defacf46ccb5804d4cf6ed8521b845017b3311a3e120328dc5edc44eb35566cb73f5233738aac 1 7:0 1

Here: key_size is 48, key_parts = 3, extra_key_size = 24.

So cipher subkey, IOW the 3DES key, is 48 - 24 = 24.

And in CW "IV generator" is extra key decoded:
Kw is always 16 bytes, thus Kiv = 24 - 16 = 8 bytes.
(Which is correct, because 3DES has block size 64bits = 8 bytes
and this match IV)

Thanks,
Milan
p.s.
The other changes in following ... no problem, just code style nitpicking ;-)
I will change it and resend once will have time to do it.
