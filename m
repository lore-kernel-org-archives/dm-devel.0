From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: dm-integrity: integrity protection device-mapper target
Date: Wed, 23 Jan 2013 12:19:58 +0200
Message-ID: <CALLzPKaZF1mrkpGYK01O0L-YvCYNBcCxoAgvOFoBmCuuXaywLw@mail.gmail.com>
References: <Pine.LNX.4.64.1301151955280.7468@file.rdu.redhat.com>
	<CALLzPKZVo3ng=Hz4cg0qrw0nDYsPjKy5AR=AJtMg+3PU=epz1w@mail.gmail.com>
	<Pine.LNX.4.64.1301221928350.21650@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1301221928350.21650@file.rdu.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com, alan.cox@intel.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi,

On Wed, Jan 23, 2013 at 3:29 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Fri, 18 Jan 2013, Kasatkin, Dmitry wrote:
>
>> Hi Mikulas,
>>
>> Thanks for looking into it.
>>
>> On Thu, Jan 17, 2013 at 6:54 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>> > Hi Dmitry
>> >
>> > I looked at dm-integrity. The major problem is that if crash happens when
>> > data were written and checksum wasn't, the block has incorrect checksum
>> > and can't be read again.
>> >
>>
>> This is how it works.
>> This is a purpose of integrity protection - do not allow "bad" content
>> to load and use.
>>
>> But even with encryption it might happen that some blocks have been
>> updated and some not.
>> Even if  reading the blocks succeeds, the content can be a mess from
>> old and new blocks.
>
> dm-crypt encrypts each 512-byte sector individually, so (assuming that
> there is no disk with sector size <512 bytes), it can't result in random
> data. You read either new data or old data.

I have not expressed correctly what I wanted to say.
Basically a file might consists of several sectors where part of them
will have an
old content and part of them will have a new content.
That "combination" content is a garbage...

>
>> This patch I sent out has one missing feature what I have not pushed yet.
>> In the case of none-matching blocks, it just zeros blocks and returns
>> no error (zero-on-mismatch).
>> Writing to the block replaces the hmac.
>> It works quite nicely. mkfs and fsck is able to read and write/fix the
>> filesystem.
>
> But it causes silent data corruption for the user. So it's worse than
> returning an error.

Agree. Error is good as it was.

>
>> > How is this integrity target going to be used? Will you use it in an
>> > environment where destroying data on crash doesn't matter? (can you
>> > describe such environment?)
>> >
>>
>> We are looking for possibility to use it in LSM based environment,
>> where we do not want
>> attacker could make offline modification of the filesystem and modify
>> the TCB related stuff.
>
> What are the exact attach attack possibilities you are protecting against?
>

That is to protect against offline attacks only - when the system is down.
LSM supposed to protect when system is running.

> Can the attacker observe or modify the data while system is running? (for
> example the data is accessed remotely over an unsecured network
> connection?) Or is it only protecting against modifications when the
> system is down?
>

Right.

> Can the attacker modify the partition with hashes? - or do you store it in
> another place that is supposed to be secure?
>

As also Will said in the next email..
That is not hashes, but HMACs. They are protected by the key and do
not require secure storage.

> What are you going to do if you get failed checksum because of a crash?
>

Integrity verification failed - return an error.
No reason to run modified /sbin/init.
I understand about unusable system, but this is to prevent running
compromised system.

>> > It could possibly be used with ext3 or ext4 with data=journal mode - in
>> > this mode, the filesystem writes everything to journal and overwrites data
>> > and metadata with copy from journal on reboot, so it wouldn't matter if a
>> > block that was being written is unreadable after the reboot. But even with
>> > data=journal there are still some corner cases where metadata are
>> > overwritten without journaling (for example fsck or tune2fs utilities) -
>> > and if a crash happens, it could make metadata unreadable.
>> >
>>
>> In normal environment, if fsck crashes, it might corrupt file system
>> in the same way.
>> zero-on-mismatch makes block device still accessible/fixable for fsck.
>
> The problem is that it apmplifies filesystem damage. For example, suppose
> that fsck is modifying an inode. You get a crash and on next reboot not
> just one inode, but the whole block of inodes is unreadable (or replaced
> with zeros). Fsck "fixes" it, but the user loses more files.
>

From security perspective it is "unsafe" to run fsck.
System has been compromised and fixing it by fsck might result in
unexpected behavior.

>
> I am thinking about possibly rewriting it so that it has two hashes per
> sector so that if either old or new data is read, at least one hash
> matches and it won't result in data corruption.
>

This is an improving step. There are different performance issues
about such approach.
I was working on such solution before dm_bufio appeared.
In own integrity data management it was so that I could know what
block of primary integrity data
is written and could issue write for secondary integrity data.
Integrity data blocks writing/updating were handled independently of each other.
It was easily possible to get "mirror" block and issue a write request.
With bufio API I do not really see how target could be notified that
buffer has been written.
May be complete callback on like bio_end_io would be needed.
You might advise on how to achieve it.
But there are performance issues with that and it might be the next step.

Thanks,

Dmitry

> Mikulas
