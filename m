From: Daire Byrne <daire.byrne@gmail.com>
Subject: Re: Shared snapshot tests
Date: Wed, 21 Apr 2010 18:54:10 +0100
Message-ID: <h2l131780341004211054p6e3cb893xb5dcb38ed2a9fceb@mail.gmail.com>
References: <20100415182356.GN13021@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.1004200207170.24170@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1004200207170.24170@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mikulas,

On Tue, Apr 20, 2010 at 7:58 AM, Mikulas Patocka <mpatocka@redhat.com> wrot=
e:
>> =A0 (2) similarly why does the read performance change at all
>> (214->127MB/s). There is no COW overhead. This is the case for both
>> the old snapshots and the new shared ones.
>
> I am thinking that it could be because I/Os (including reads) are split at
> chunk size boundary. But then, it would be dependent on chunk size --- and
> it isn't.
>
> Try this:
> Don't use snapshots and load plain origin target manually with dmsetup:
> dmsetup create origin --table "0 `blockdev --getsize /dev/sda1` snapshot-=
origin /dev/sda1"
> (replace /dev/sda1 with the real device)
> Now, /dev/mapper/origin and /dev/sda1 contain identical data.
> Can you see 214->127MB/s read performance drop in /dev/mapper/origin?

No I don't see the drop in read performance in this case.

> Compare /sys/block/dm-X/queue content for the device if no snapshot is
> loaded and if some snapshot is loaded. Is there a difference? What if you
> manually set the values to be the same? (i.e. tweak max_sectors_kb or
> others)

It looks like max_sectors_kb goes from 512 -> 4 when a snapshot is
done. But increasing this manually doesn't seem to have much effect.
Actually increasing it seems to hurt read performance even more. No
other changes in nr_requests, read_ahead etc.

> Would it make sense to limit this write-holding? I think no, because it
> wouldn't improve i/o latency. It would just make i/o latency less
> variable. Can you think of an application where high i/o latency doesn't
> matter and variable i/o latency does matter?

Well the only thing I have experience with is LustreFS. I have used
the "old" snapshots with that and the server does tend to trigger lots
of alerts if it can't commit by a certain time (e.g. when a big COW
operation is happening). I just figure that with a fast RAID (or SSDs)
that writing the COW and new data to the drive at the same time
shouldn't incur such a massive seek hit whilst making the performance
more even/predictable.

>> =A0 (4) why is there a small (but appreciable) drop in writes as the
>> number of snapshots increase? It should only have to do a single COW
>> in all cases no?
>
> Yes, it does just one cow and it uses ranges, so the data structures have
> no overhead for multiple snapshots.
>
> Did you recreate the environment from scratch? (both the filesystem and
> the whole snapshot shared store)
>
> The shared snapshot store writes continuously forward and if you didn't
> recreate it, it may be just increasing disk seek times as it moves to the
> device end.
>
> A filesystem may be also writing to different places, so you'd better
> recreate it too.

Yes I think something like this might have happened. But now after
coming back to retest after a reboot I'm getting much better write
performance (~90MB/s instead of ~38MB/s) with N snapshots. It seems
like my previous write results were too low for some reason. So now my
RAID does 308MB/s writes + 214MB/s reads without snapshots and 90MB/s
writes + 127MB/s reads with shared snapshots - not too bad. I will
poke around some more.

Out of interest what are Redhat's plans for this feature? Will it be
in RHEL6 or is it going to wait until it is accepted upstream and then
make it into some later Fedora release? Could it be easily backported
to RHEL5 do you think?

Daire
