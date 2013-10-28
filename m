From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 1/2] dm-crypt: Properly handle extra key
	string in initialization
Date: Mon, 28 Oct 2013 17:46:20 +0100
Message-ID: <526E94DC.10304@gmail.com>
References: <1382275000-10660-1-git-send-email-gmazyland@gmail.com>
	<20131028154447.GA25212@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131028154447.GA25212@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 28.10.2013 16:44, Mike Snitzer wrote:
> On Sun, Oct 20 2013 at  9:16am -0400,
> Milan Broz <gmazyland@gmail.com> wrote:

>> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
>> index 0fce0bc..878bda7 100644
>> --- a/drivers/md/dm-crypt.c
>> +++ b/drivers/md/dm-crypt.c
>> @@ -1497,14 +1495,23 @@ static int crypt_ctr_cipher(struct dm_target *ti,
>>   		 * to length of provided multi-key string.
>>   		 * If present (version 3), last key is used as IV seed.
>>   		 */
>> -		if (cc->key_size % cc->key_parts)
>> +		if (cc->key_size % cc->key_parts) {
>>   			cc->key_parts++;
>> +			cc->key_extra_size = cc->key_size / cc->key_parts;
>> +		}
>
> This is leveraging existing heuristics of bumping key_parts and then
> using it to establish 'key_extra_size' -- but the definition of "extra
> size" is eluding me.  Say key_size=101, kepyparts=10 -- remainder is 1.
> So then key_extra_size = 9.
>
> All a bit opaque to me without a ctr usage example to help document in
> the patch header.

All this is because the table format was not designed to include more
independent keys...
(And changing it now will cause more incompatibility problems it solves.)


Anyway, if this helps:

"TCW" is just a shortcut to identify this mode,
(TrueCrypt with whitening if you want)

It uses is normal CBC mode (note cbc in cipher definition)
but with additional operation (whitening) and with key seeded
Initial vector. These additional operations are implemented
in "dmcrypt tcw iv generator".

It requires 3 independent keys:

K - is the normal encryption key, size depends on algorithm
(this is what you see for "normal" dmcrypt mapping)

Kiv - is the key used to seed Initial vector generator,
size is always the same as IV size of algorithm above
(so it is variable)

Kw - is the key used to seed whitening (and additional operation)
size is always 16 bytes (fixed)

I am partially abusing IV generator in dmcrypt for other
work (whitening) (but the same way as we already have in loopAES format).

In fact, whitening is not related to IV at all but this is the simplest
way hot to implement it.

(And again, it is very similar to loopAES handling which
uses multiple keys already.)

Example:

For activation used by cryptsetup
# cryptsetup tcryptOpen ../tc-cbc/tc-cbc-serpent.img tc

we have this table (split to parts)

# dmsetup table --showkeys tc

0 16383 crypt serpent-cbc-tcw \

34f95b96abff946b64f1339ff8653cc77c38697c93b797a496f3786e86eed778 \
# ^^^ this is serpent cipher encryption key K

1850d5112bbae17d209b8310a8f3a034 \
# ^^^ this is the seed for IV, Kiv
  
f1cd297667bc0cd1438fad28d87ef6a1 \
# ^^^ this is the seed for whitening, Kw

1 7:0 1


IOW, for tcw constructor the format of key is simply

K | Kiv | Kw

and key_parts and key_extra_size is just helper how to parse
it properly.

So, key parts = 3 in this case (we have 3 keys - K, Kiv, Kw).

key_extra_size is length of key string which contains additional
keys sizeof(Kiv + Kw) which are not used for encryption algorithm
but are processed elsewhere (in iv generator ctr).


Example for existing loopAES ("lmk IV generator") key is e.g.

K1...K64 | Kiv

(first 64 keys are for 64 independent tcms, Kiv is additional
Key used to seed IV. Thus key_parts = 65, key_extra_size = sizeof(Kiv)
because all keys including Kiv are always of the same size, code
can simply do cc->key_extra_size = cc->key_size / cc->key_parts)


In short, key_parts should now contain number of independent keys
in dmcrypt key mapping table string.

key_extra_size should contain length of the key which must
be cut off when setting core cipher key because this part is
processed elsewhere.

Milan
