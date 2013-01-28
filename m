From: Will Drewry <redpig@dataspill.org>
Subject: Re: [dm-devel] dm-integrity: integrity protection device-mapper target
Date: Sun, 27 Jan 2013 19:43:21 -0600
Message-ID: <CABmXcB8-kByR6GOT-q+qn_-8dARKWS9vqOdZjmwnn_RZ+ynpHQ@mail.gmail.com>
References: <Pine.LNX.4.64.1301151955280.7468@file.rdu.redhat.com>
	<CALLzPKZVo3ng=Hz4cg0qrw0nDYsPjKy5AR=AJtMg+3PU=epz1w@mail.gmail.com>
	<Pine.LNX.4.64.1301221928350.21650@file.rdu.redhat.com>
	<CABmXcB8bv_nNGdoRVc2ukEO2Z+gBnhUiYo2fJ755snTRouji6w@mail.gmail.com>
	<CALLzPKb1niHhUXP=Pn7_2JLWtkkJxGrnEz17Da=9OHiA8SQiCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CALLzPKb1niHhUXP=Pn7_2JLWtkkJxGrnEz17Da=9OHiA8SQiCg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, alan.cox@intel.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 23, 2013 at 4:20 AM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
> On Wed, Jan 23, 2013 at 8:09 AM, Will Drewry <redpig@dataspill.org> wrote:
>> On Tue, Jan 22, 2013 at 5:29 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>>> On Fri, 18 Jan 2013, Kasatkin, Dmitry wrote:
>>>> Hi Mikulas,
>>>>
>>>> Thanks for looking into it.
>>>>
>>>> On Thu, Jan 17, 2013 at 6:54 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
[snip]
>>> Can the attacker modify the partition with hashes? - or do you store it in
>>> another place that is supposed to be secure?
>>
>> Given that HMACs are being used to authenticate blocks, I'd assume,
>> until corrected, that the HMACs aren't required to be on secure
>> storage.  To that end, it seems like there is a distinct risk that an
>> attacker could use old data blocks and old HMACs to construct an
>> "authentic" dm-integrity target that doesn't match anything the
>> user/TPM ever saw in aggregate before.  Perhaps I missed something
>> when I skimmed the code, but it doesn't seem trivial to version the
>> data or bind them to a large enough group of adjacent blocks without
>> paying more computational costs (like using a Merkle tree with an
>> HMAC'd root node). Technically, all the blocks would still be
>> authentic, but the ordering in time and space wouldn't be. I'd love to
>> know what ideas you have for that, or if that sort of attack is out of
>> scope?  For ordering in space, inclusion of the sector index in the
>> HMAC might help.
>>
>
> Hello,
>
> Yes. You are right. All is about computational and IO costs.
> "In time" is really hard to manage. The key is the same and there is a
> possibility to
> replace the blocks with older block.
>
> But this is a case with encryption as well. right?

I'm not a crypto-expert, but it all depends on if blocks are
interrelated in any way (and thus the algorithm and configuration).
Of course, encryption and integrity are often separate for a reason :)

The 'in time' problem is tricky, but I guess this is a good reason to
extend dm-verity to also have a kernel-supported write mode.  It could
be used as an alternative to the hmac'd block approach (with a
TPM/whatever-signed root hash) to achieve both in-time and in-space
resilience.  Of course, the user would need to decide on the cost then
-- more I/O+CPU versus their risk tolerance.

> "in space" - it is easier. As you said sector index might be used like
> with encryption.
> Please have a look to dm_int_calc_hmac(). It uses already offset in
> calculations..
>
>         err = crypto_shash_init(&desc.shash);
>         if (!err)
>                 err = crypto_shash_update(&desc.shash, digest, size);
>         if (!err)
>                 err = crypto_shash_finup(&desc.shash, (u8 *)&offset,
>                                           sizeof(offset), hmac);

Nice - I misread that!  At least that keeps replays pinned to the same
block index for direct replays.

cheers!
will
