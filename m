From: Harald Braumann <harry-bxs7j/2bvUasTnJN9+BGXg@public.gmane.org>
Subject: Re: dm-integrity standalone - lack of metadata
Date: Tue, 26 Jun 2018 14:30:09 +0200
Message-ID: <4A07D9DC-3CD9-48AC-9952-A083DF1F8E03@unheit.net>
References: <20180624095348.GA819@nn.nn>
 <c2d97932-69f0-20aa-e66a-fd6be5b5eda3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
In-Reply-To: <c2d97932-69f0-20aa-e66a-fd6be5b5eda3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://www.saout.de/mailman/options/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.saout.de/pipermail/dm-crypt/>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=help>
List-Subscribe: <https://www.saout.de/mailman/listinfo/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=subscribe>
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Sender: "dm-crypt" <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
To: Milan Broz <gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dm-crypt-4q3lyFh4P1g@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids



On 24 June 2018 13:01:06 CEST, Milan Broz <gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>(added cc to dm-devel annd Mikulas)

>On 06/24/2018 11:53 AM, Harald Braumann wrote:
>> However, the superblock lacks some crucial information:

>yes, I agree. The reason is that dm-integrity was in the first
>place designed for authenticated encryption (to store auth tags).
>Then additional metadata ia stored in LUKS2 header.
I understand.

>For the rest I just I have not enough energy (and real-world use cases)
>to convince Mikulas that we need attributes below in superblock (as the
>dm-integrity
>code is written mostly by him).
>At least for the algorithm I mention this idea several times ;-)
OK, good. I was just afraid that there might be some technical reason and this was out of the question.

>> integritysetup format /dev/sdb2 -v --integrity crc32c --sector-size
>> 4096
>> => 39.6 MiB/s
>>
>> Format with --no-wipe, open the target and use dd:
>> dd if=/dev/zero of=/dev/mapper/int bs=1M
>> => 63 MiB/s
>> 
>> Same as above, but opening without journal (which really isn't
>> required for that step, even if the final target should be journaled):
>> => 135 MiB/s

>Internal wipe also uses activation without journal, it is slow probably
>because we use direct-io (can you add oflag=direct to your dd command?
>Is it the same speed as integritysetup wipe?)
Sorry, I haven't gotten around to it, yet. 

>> /etc/udev/rules.d/70-dm-integrity.rules:
>> 
>> ACTION!="add", GOTO="dm_integrity_end"
>> SUBSYSTEM!="block", GOTO="dm_integrity_end"
>> ENV{ID_FS_TYPE}!="DM_integrity", GOTO="dm_integrity_end"
>> 
>> RUN+="/sbin/integritysetup open $devnode $kernel-integrity
>--integrity crc32c --integrity-no-journal"
>> 
>> LABEL="dm_integrity_end"

>This is not the best way - integritysetup itself need udev
>synchronization, so it will
>race here with udev.
Could you elaborate on that? How does it need udev and could I add anything to the rules to ensure proper synchronization?

>I think we need similar system like /etc/crypttab (or extend crypttab
>of integrity targets).
Thats what I wanted to avoid. I would like it to work like LVM where volumes can be set up automatically with just metadata stored on the device itself.

Best regards
harry
_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
https://www.saout.de/mailman/listinfo/dm-crypt
