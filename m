From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 support ?
Date: Mon, 24 Oct 2005 09:54:12 +1000
Message-ID: <17244.8868.117125.78408@cse.unsw.edu.au>
References: <1129981242.7217.6.camel@jetpack.demon.co.uk>
	<17242.17266.315175.852854@cse.unsw.edu.au>
	<1129996688.7217.9.camel@jetpack.demon.co.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Alan Hourihane on Saturday October 22
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

On Saturday October 22, alanh@fairlite.demon.co.uk wrote:
> > More usefully though, I'd be very happy to talk about how md/raid5 can
> > be made to be sufficient.  I'd be happy for it to integrate more
> > closely with dm, if that was seen to be of value.
> 
> That'd be useful Neil.
> 
> I'll explain the problem.
> 
> I've got a SIL3114 controller with 4 x 200GB drives attached. Now that
> SIL controller supports RAID5. Given that I set the RAID support up in
> the BIOS I can now boot from the array.
> 
> If one of those disks die, I understand that the BIOS will still allow
> me to boot from the array, even though the primary disk may have died.
> 
> In the md/raid5 setup, I'm not sure that's the case and if you lose the
> primary you have to muck about with your bootloader to fix things up.

It seems the core problem here is that you need soft-raid5 in Linux
which can work with the metadata that is stored by the BIOS on the SIL
controller. 
This shouldn't be too hard to do, providing it is reasonably
documented.
'md' has all the meta-data operations reasonably well factored out, so
working with new formats shouldn't be difficult.

I suspect that it would be best to have the code for understanding the
metadata run in user-space rather than in the kernel - I gather that
is what dmraid does.

For raid5, we really need synchronous metadata updates when a device
fails, as it is not really safe to write anything after the decision
to fail a device, and before the metadata has been updated.

I am currently working on adding sysfs support to md and raid5 and
would prefer to use this as the interface between md and a user-space
metadata handler (though I could probably be convinced to work under
the dm ioctls as well if that was important).

So the enhancements that seem to be needed to md/raid5 would include:

1/ Introduce a new metadata type which the kernel doesn't read or
   write at all.  When a write is required, it signals userspace
   somehow, and blocks writes until it is told to continue.

2/ Allow all config information to be provided by userspace.  The
   current SET_ARRAY_INFO is not quite up to the task.  e.g. you 
   cannot give a device offset through that interface.


I plan to do (2) anyway, probably through sysfs, but maybe configfs -
I'm not sure yet.

(1) probably needs a bit more thought and some understanding on what
the userspace metadata tool would require.
I imagine having an event counter which is updated whenever a
metadata update is required.
The userspace tool would
  - read a number from the event-counter file
  - extract all the metadata information needed from sysfs
  - write it to the devices
  - write the original event-count to some other sysfs file.

The kernel would not allow further writes until the number written
to the second file matches the most current event counter, thus if
multiple events happened while the metadata was being updated, we
still wouldn't get out of sync.

Of course, we wouldn't want to have to poll the event-counter
file.  We would need some more direct notification of change.  As
I am using sysfs, maybe some sort of hot-plug event... but I'll
have to learn more about hot plug events first.


Does any of this sound useful?
Any other suggestions?

NeilBrown
