From: Douglas McClendon <dmc.fedora@filteredperception.org>
Subject: Re: semop failed for cookie?
Date: Wed, 28 Apr 2010 18:11:46 -0500
Message-ID: <4BD8C0B2.7020509@filteredperception.org>
References: <4BD74F99.8020605@filteredperception.org>
	<20100427223323.GB29708@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100427223323.GB29708@agk-dp.fab.redhat.com>
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

On 04/27/2010 05:33 PM, Alasdair G Kergon wrote:
> On Tue, Apr 27, 2010 at 03:56:57PM -0500, Douglas McClendon wrote:
>> I have a user of an installation tool of mine that is hitting this
>> message, with a very recent pre-fedora-13 kernel.
>
> udev is now involved in this process.
> Check they have up-to-date lvm2 and udev packages and that they've not
> tried to customise their udev rules - if they have, you'll need to
> check their changes didn't break things.
>
> Big script.
>
> Debug it by adding lines to dump the state immediately before the problem
> command, then immediately after it.

Actually, I just grabbed the latest soas nightly livecd build, which for 
these purposes should presumably be considered the same as rawhide.

I tried manually do do what I described.  I.e. make a duplicate (same 
table, different name) snapshot device.

Interestingly, I'm not seeing the semop cookie thing, but now after the 
'resume ioctl failed' message, I checked dmesg, and I'm seeing-

device-mapper: snaphots: Unable to perform snapshot handover until 
source is suspended.

Also, this is under virtualization, which, as with other fedora dev 
builds I've seen, runs bizarrely slowly.  I.e. I had a couple text root 
logins timeout because it didn't finish whatever it needed to finish in 
60 seconds.  And while booting I saw dozens of weird udev failure 
messages.  But I'm thinking that may have nothing to do with the issue, 
and hoping the above message elicits an explanation.  I.e. is what I'm 
doing somehow inadvertently utilizing the new snapshot merging semantics 
even though it wasn't before, and for my purposes shouldn't?

-dmc


>
> Dump state by running 'dmsetup info -c', 'dmsetup table', 'dmsetup status'
> and 'dmsetup udevcookies'.
>
> If that still doesn't help, break the 'dmsetup create' command down into
> its three constituent commands (dmsetup create --notable, dmsetup load,
> dmsetup resume) and dump the state between each of them and confirm
> which is failing.
>
> Alasdair
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
