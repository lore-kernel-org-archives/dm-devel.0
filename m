From: Mikael Andersson <mikael@karett.se>
Subject: Re: Update: Disk io deadlocks during large-file io
Date: Wed, 27 Apr 2005 01:18:48 +0200
Message-ID: <426ECC58.2070105@karett.se>
References: <4267F307.8080009@karett.se> <426E76BB.2060201@karett.se>
	<20050426185741.GK7859@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050426185741.GK7859@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Lars Marowsky-Bree wrote:

>On 2005-04-26T19:13:31, Mikael Andersson <mikael@karett.se> wrote:
>
> =20
>
>>With md raid1 instead of dm-mirror i get no lockups during similar
>>workloads or any other workload i've managed to produce. Everything is
>>the same except that i'm using md instead of dm-mirror.
>>   =20
>>
>
>That's not very surprising. md is still the preferred framework for
>raidN as of now, and I'm not sure that will change soon.
> =20
>
I agree that it's not surprising that experimental ( as it is ) software
fails, and even less that it contains some subtle deadlock cases.

>(Yes, consolidating the stack and everything would be nice, but I don't
>see anyone with time on his hands to go do it ;-)
> =20
>
Narrowing it down with something to do dm-mirror/dm-raid1 and not driver
or fs related took me some time, quite some time to be honest. So
obviously i've got some amount of time available. The most peculiar
thing was that a new bios for the motherboard actualy changed the
problem characteristic, so i was a bit surprised when it went away
completely as soon as i switched to md.

Doesn't md and dm-raid share the same blocklayer ?

Why does the crashdumps looks so weird, they seem to be waiting for
something in a function which AFAICT from the source and it's
corresponding assembler doesn't wait for anything, at least not in the
stack frame that's indicated  ?
 Maybe it's just the symbols thats messed up on x86_64 in some way or
i'm just misinterpreting things, i ran gdb vmlinux and looked at it all
from there and comparing it to the output from sysrq-T and addr2line.
According to ps -o cmd,wchan the problematic processes were waiting in
sync_page, or sync_buff according to some notes i have, if that makes sen=
se.
I'll setup a mirror when i've migrated all important data away from
another pair of disks i have and test if i can provoke the problem on
those disks also, that'll give me something to work with.

>Sincerely,
>    Lars Marowsky-Br=E9e <lmb@suse.de>
> =20
>
/Mikael Andersson
