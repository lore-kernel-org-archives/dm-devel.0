From: Douglas McClendon <dmc.lists@filteredperception.org>
Subject: Re: DM_snapshot_cow filesystem (dmsetup create snapshot)
Date: Thu, 01 Dec 2011 21:44:53 -0600
Message-ID: <4ED849B5.7020206@filteredperception.org>
References: <20111029204947.GU23336@agk-dp.fab.redhat.com>
	<CAEcBt+Ux+GVmm7zBeFA7k5PHOQoSKLTKcifB95ne5dBtX400dQ@mail.gmail.com>
	<4ED2DF0F.1070108@filteredperception.org>
	<CAEcBt+UEJXSY7oK+j0gw9fkzjnWOUcBFhPdXCVFe3HZNh6zOTw@mail.gmail.com>
	<4ED59040.50406@filteredperception.org>
	<CAEcBt+XxVh8b=TJu-Z+3XBL=K6LUhs2QZyeZKGMGh_Lp+UBGbA@mail.gmail.com>
	<20111130220259.GA7595@agk-dp.fab.redhat.com>
	<4ED6BD81.4090609@filteredperception.org>
	<20111201141236.GB7595@agk-dp.fab.redhat.com>
	<4ED7E11D.1090904@filteredperception.org>
	<20111201202029.GC7595@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111201202029.GC7595@agk-dp.fab.redhat.com>
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

On 12/01/2011 02:20 PM, Alasdair G Kergon wrote:
> On Thu, Dec 01, 2011 at 02:18:37PM -0600, Douglas McClendon wrote:
>> The overlay device in this situation is a read-write tmpfile in tmpfs,
>> looped to be available as the dm-snapshot 'snapshot/overlay device'.
>
> Ah - well if your base device is already read-only, then there is no
> corruption and you should be able to edit the bit of the disk image
> that says 'this image is invalid' and recover it read-only or extend it.

The commandline to do the 'edit' was requested for users like Fred, and 
because I guess one day I might find myself wanting to do the same.

As per possibly avoiding the need for such a workaround, and thinking 
about the non-read-only base situation, does the following request sound 
at least logically consistent, and correct in its assumptions-

Currently in a dm-snapshot case such as the fedora liveusb, the instant 
a persistent snapshot becomes full, it is marked as invalid, and further 
accesses result in (fixme?).  But it would be preferable if instead of 
being marked invalid at the instant it fills up, it is instead marked as 
invalid at the first instant after it is full, and its base device gets 
written to.  And beyond that as a second change from the current state 
of things, the virtual device using the overlay falls into a read-only 
state the instant the overlay it is using reaches a full state. 
(instead of as happens now ?? maybe selective write failures based on 
whether or not the write destination is in a chunk within the full 
overlay ??)

Thus in read-only base cases, the overlay never gets marked as invalid, 
and no users have any need for a workaround tool or commandline to flip 
the invalid bit(?) to valid, in order to mount and use/recover the data 
present in the snapshot.

-dmc
