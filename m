From: Douglas McClendon <dmc.lists@filteredperception.org>
Subject: Re: DM_snapshot_cow filesystem (dmsetup create snapshot)
Date: Thu, 01 Dec 2011 14:18:37 -0600
Message-ID: <4ED7E11D.1090904@filteredperception.org>
References: <4EABE131.8010706@googlemail.com>	<20111029204947.GU23336@agk-dp.fab.redhat.com>	<CAEcBt+Ux+GVmm7zBeFA7k5PHOQoSKLTKcifB95ne5dBtX400dQ@mail.gmail.com>	<4ED2DF0F.1070108@filteredperception.org>	<CAEcBt+UEJXSY7oK+j0gw9fkzjnWOUcBFhPdXCVFe3HZNh6zOTw@mail.gmail.com>	<4ED59040.50406@filteredperception.org>	<CAEcBt+XxVh8b=TJu-Z+3XBL=K6LUhs2QZyeZKGMGh_Lp+UBGbA@mail.gmail.com>	<20111130220259.GA7595@agk-dp.fab.redhat.com>	<4ED6BD81.4090609@filteredperception.org>
	<20111201141236.GB7595@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111201141236.GB7595@agk-dp.fab.redhat.com>
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
List-Id: dm-devel.ids

On 12/01/2011 08:12 AM, Alasdair G Kergon wrote:
> On Wed, Nov 30, 2011 at 05:34:25PM -0600, Douglas McClendon wrote:
>> So wouldn't it be much better as far as the user is concerned if, the
>> instant a snapshot reached capacity, it fell over into a read-only state
>> (instead of being marked invalid?), such that further corruption beyond
>
> That would mean your *origin* device becoming read-only as well.

I apologize in that I know I may be getting some terminology confused, 
as devicemapper snapshots are used for many scenarios.  The fedora 
livecd/usb is perhaps only a subset of wider problem-constraints that 
I'm not keeping in mind.  That disclaimer said, in this particular 
situation, using the terminology I use in my own head, the base device 
here is a read-only ext3/4 filesystem image, necessarily read only 
because it is living on a squashfs filesystem, that may be on a 
read-only physical device like cdrom, or read-write (liveusb).

The overlay device in this situation is a read-write tmpfile in tmpfs, 
looped to be available as the dm-snapshot 'snapshot/overlay device'.

The resulting used device is then a read-write device used as a 
read-write ext3/4 filesystem for the rootfs.

When the snapshot fills up, keeping the snapshot device read-write would 
seem to serve no useful purpose.  And the 'base' device was read-only to 
begin with.

The real issue seems to be that the meaningfulness and usefulness of the 
overlay device seems to go from 'meaningful' to 'invalid/meaningless' 
the instant it fills up.  For no beneficial reason I can see (again 
maybe it complicates other dm-snapshot use-case scenarios that I'm not 
considering).


>
> It's been discussed before.  Nobody has been motivated to write the code,
> as there's no need for it on a properly-managed system.
>
> If you care enough about your snapshot contents, then surely you
> would be monitoring it to make sure it doesn't fill up - and if you're
> going to run out of space and can't expand, you would shut down your system
> yourself in a *controlled* way *before* running out of space!

In a typical livecd scenario, the amount of space in the snapshot can be 
very limited (say, half of ram).

In such a scenario, if the first thing I do is 'yum install lftp' I 
might be golden because that only takes a few MB.  If the next thing I 
do however is 'yum install emacs' or something else that brings in a ton 
of dependencies, that single command can exhaust the snapshot.

Are you suggesting some polling(or event driven?) method for the system 
to try to shutdown cleanly in the middle of that yum install?

I admit that would indeed solve the present use case of keeping the 
overlay device functionally usable.  In fact, going with a brutal 
virtual-plug-pulling halt triggered by snapshot full would be fine. 
Though I'd rather at that instant have the system go read-write-rootfs 
so that I can still poke around somewhat, rather than the screen go black.

But I really see no downside to keeping it usable without that 
pro-active infrastructure, by instead just making sure that when it 
fills up, it remains a 'valid, but full snapshot that can at least be 
utilized read-only'.  The alternate of letting it become invalid, such 
that the user can get the 'benefit' that if their current workload 
contains itself to chunks already managed in the snapshot, seems like no 
real benefit to me (maybe if a database was contained entirely within 
the snapshot chunks and the system was only fiddling with that).  Or 
perhaps I'm completely misunderstanding things (entirely possible)

-dmc



>
> Alasdair
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
