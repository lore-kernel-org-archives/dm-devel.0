From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-crypt] dm-integrity standalone - lack of metadata
Date: Sun, 24 Jun 2018 13:01:06 +0200
Message-ID: <c2d97932-69f0-20aa-e66a-fd6be5b5eda3@gmail.com>
References: <20180624095348.GA819@nn.nn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180624095348.GA819@nn.nn>
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
To: Harald Braumann <harry@unheit.net>, dm-crypt@saout.de, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

(added cc to dm-devel annd Mikulas)

Hi,

On 06/24/2018 11:53 AM, Harald Braumann wrote:
> Hi!
> 
> I'm using the dm-integrity target standalone with crc32c for component
> devices of a RAID. I don't use journaling, because the perfomance hit
> is too big and I don't really need it in that case.
> 
> I want to automatically activate these targets using udev
> rules (see below). However, the superblock lacks some crucial
> information:


yes, I agree. The reason is that dm-integrity was in the first
place designed for authenticated encryption (to store auth tags).
Then additional metadata ia stored in LUKS2 header.

For the rest I just I have not enough energy (and real-world use cases)
to convince Mikulas that we need attributes below in superblock (as the dm-integrity
code is written mostly by him).
At least for the algorithm I mention this idea several times ;-)

There are some patches for dm-integrity targeted to 4.19 floating around,
so let's add these ideas to the mix.

> - Integrity algorithm
> The algorithm is not stored in the superblock and so I have to use
> crc32 hard-coded in my udev rule. This is of course no general
> solution. I don't quite understand why it is not stored in the
> superblock. Is there a technical reason for that?
> 
> - Journal mode
> I open the integrity devices without journaling. But again, that's
> hard-coded and it would a be problem if I had other devices, where I
> actually want journaling. It would be nice, if the superblock
> contained a use_journal flag so the default could be configured on the
> device itself.
> 
> - UUID/label support
> Not strictly required for my use case, but would be nice for
> persistent naming.
> 
> While playing around with that, I also noticed that integritysetup
> format is extremly slow (this is on an HDD):
> 
> integritysetup format /dev/sdb2 -v --integrity crc32c --sector-size
> 4096
> => 39.6 MiB/s

This can be perhaps fine-tuned, but for standalone integrity I expect
we will use internal wipe, so this will be just fallback.
See https://www.redhat.com/archives/dm-devel/2018-June/msg00089.html

> Format with --no-wipe, open the target and use dd:
> dd if=/dev/zero of=/dev/mapper/int bs=1M
> => 63 MiB/s
> 
> Same as above, but opening without journal (which really isn't
> required for that step, even if the final target should be journaled):
> => 135 MiB/s

Internal wipe also uses activation without journal, it is slow probably
because we use direct-io (can you add oflag=direct to your dd command?
Is it the same speed as integritysetup wipe?)

> I have absolutely no problem with using the dd method, but it kind of
> makes the built-in format method redundant. 
> 
> Best regards
> harry
> 
> /etc/udev/rules.d/70-dm-integrity.rules:
> 
> ACTION!="add", GOTO="dm_integrity_end"
> SUBSYSTEM!="block", GOTO="dm_integrity_end"
> ENV{ID_FS_TYPE}!="DM_integrity", GOTO="dm_integrity_end"
> 
> RUN+="/sbin/integritysetup open $devnode $kernel-integrity --integrity crc32c --integrity-no-journal"
> 
> LABEL="dm_integrity_end"

This is not the best way - integritysetup itself need udev synchronization, so it will
race here with udev.

I think we need similar system like /etc/crypttab (or extend crypttab of integrity targets).

Milan
