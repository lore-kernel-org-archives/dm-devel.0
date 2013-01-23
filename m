From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [dm-devel] dm-integrity: integrity protection device-mapper target
Date: Wed, 23 Jan 2013 12:20:15 +0200
Message-ID: <CALLzPKb1niHhUXP=Pn7_2JLWtkkJxGrnEz17Da=9OHiA8SQiCg@mail.gmail.com>
References: <Pine.LNX.4.64.1301151955280.7468@file.rdu.redhat.com>
	<CALLzPKZVo3ng=Hz4cg0qrw0nDYsPjKy5AR=AJtMg+3PU=epz1w@mail.gmail.com>
	<Pine.LNX.4.64.1301221928350.21650@file.rdu.redhat.com>
	<CABmXcB8bv_nNGdoRVc2ukEO2Z+gBnhUiYo2fJ755snTRouji6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CABmXcB8bv_nNGdoRVc2ukEO2Z+gBnhUiYo2fJ755snTRouji6w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Will Drewry <redpig@dataspill.org>
Cc: device-mapper development <dm-devel@redhat.com>, alan.cox@intel.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 23, 2013 at 8:09 AM, Will Drewry <redpig@dataspill.org> wrote:
> On Tue, Jan 22, 2013 at 5:29 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>>
>>
>> On Fri, 18 Jan 2013, Kasatkin, Dmitry wrote:
>>
>>> Hi Mikulas,
>>>
>>> Thanks for looking into it.
>>>
>>> On Thu, Jan 17, 2013 at 6:54 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>>> > Hi Dmitry
>>> >
>>> > I looked at dm-integrity. The major problem is that if crash happens when
>>> > data were written and checksum wasn't, the block has incorrect checksum
>>> > and can't be read again.
>>> >
>>>
>>> This is how it works.
>>> This is a purpose of integrity protection - do not allow "bad" content
>>> to load and use.
>
> With respect to the use of "integrity", you may want to consider
> something like dm-integrity-hmac to disambiguate from the BIO
> integrity naming.  It's why I proposed the somewhat obtuse "verity"
> name for the other data-integrity target.
>
>>> But even with encryption it might happen that some blocks have been
>>> updated and some not.
>>> Even if  reading the blocks succeeds, the content can be a mess from
>>> old and new blocks.
>>
>> dm-crypt encrypts each 512-byte sector individually, so (assuming that
>> there is no disk with sector size <512 bytes), it can't result in random
>> data. You read either new data or old data.
>>
>>> This patch I sent out has one missing feature what I have not pushed yet.
>>> In the case of none-matching blocks, it just zeros blocks and returns
>>> no error (zero-on-mismatch).
>>> Writing to the block replaces the hmac.
>>> It works quite nicely. mkfs and fsck is able to read and write/fix the
>>> filesystem.
>>
>> But it causes silent data corruption for the user. So it's worse than
>> returning an error.
>>
>>> > How is this integrity target going to be used? Will you use it in an
>>> > environment where destroying data on crash doesn't matter? (can you
>>> > describe such environment?)
>>> >
>>>
>>> We are looking for possibility to use it in LSM based environment,
>>> where we do not want
>>> attacker could make offline modification of the filesystem and modify
>>> the TCB related stuff.
>>
>> What are the exact attach attack possibilities you are protecting against?
>>
>> Can the attacker observe or modify the data while system is running? (for
>> example the data is accessed remotely over an unsecured network
>> connection?) Or is it only protecting against modifications when the
>> system is down?
>>
>> Can the attacker modify the partition with hashes? - or do you store it in
>> another place that is supposed to be secure?
>
> Given that HMACs are being used to authenticate blocks, I'd assume,
> until corrected, that the HMACs aren't required to be on secure
> storage.  To that end, it seems like there is a distinct risk that an
> attacker could use old data blocks and old HMACs to construct an
> "authentic" dm-integrity target that doesn't match anything the
> user/TPM ever saw in aggregate before.  Perhaps I missed something
> when I skimmed the code, but it doesn't seem trivial to version the
> data or bind them to a large enough group of adjacent blocks without
> paying more computational costs (like using a Merkle tree with an
> HMAC'd root node). Technically, all the blocks would still be
> authentic, but the ordering in time and space wouldn't be. I'd love to
> know what ideas you have for that, or if that sort of attack is out of
> scope?  For ordering in space, inclusion of the sector index in the
> HMAC might help.
>

Hello,

Yes. You are right. All is about computational and IO costs.
"In time" is really hard to manage. The key is the same and there is a
possibility to
replace the blocks with older block.

But this is a case with encryption as well. right?

"in space" - it is easier. As you said sector index might be used like
with encryption.
Please have a look to dm_int_calc_hmac(). It uses already offset in
calculations..

	err = crypto_shash_init(&desc.shash);
	if (!err)
		err = crypto_shash_update(&desc.shash, digest, size);
	if (!err)
		err = crypto_shash_finup(&desc.shash, (u8 *)&offset,
					  sizeof(offset), hmac);

Thanks,
Dmitry


> thanks!
> will
>
>> What are you going to do if you get failed checksum because of a crash?
>>
>>> > It could possibly be used with ext3 or ext4 with data=journal mode - in
>>> > this mode, the filesystem writes everything to journal and overwrites data
>>> > and metadata with copy from journal on reboot, so it wouldn't matter if a
>>> > block that was being written is unreadable after the reboot. But even with
>>> > data=journal there are still some corner cases where metadata are
>>> > overwritten without journaling (for example fsck or tune2fs utilities) -
>>> > and if a crash happens, it could make metadata unreadable.
>>> >
>>>
>>> In normal environment, if fsck crashes, it might corrupt file system
>>> in the same way.
>>> zero-on-mismatch makes block device still accessible/fixable for fsck.
>>
>> The problem is that it apmplifies filesystem damage. For example, suppose
>> that fsck is modifying an inode. You get a crash and on next reboot not
>> just one inode, but the whole block of inodes is unreadable (or replaced
>> with zeros). Fsck "fixes" it, but the user loses more files.
>>
>>
>> I am thinking about possibly rewriting it so that it has two hashes per
>> sector so that if either old or new data is read, at least one hash
>> matches and it won't result in data corruption.
>>
>> Mikulas
