From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Improving mirror fault handling.
Date: Mon, 12 Jan 2009 17:27:26 -0600
Message-ID: <1231802846.10230.65.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

<background>
"Events" are mechanism that device-mapper kernel targets use to signal
user-space.  An event can be raised for any number of reasons,
including: a mirror becomes in-sync, an I/O error has occurred to a
device in a mirror, a snapshot has become full - anything that may
warrant user-space interest.

User-space can wait on a DM device (using 'dmsetup wait <device>
[<event_nr>]') for an event to take place; and once an event is
received, take action.  It is always prudent to check the status output
of the DM device once an event is received to ensure you are taking the
appropriate action.  Since devices can raise an event for a variety of
reasons, do not presuppose a particular reason for an event.

There exists a daemon ('dmeventd') specifically designed to listen for
events.  Devices are registered with the daemon along with the name of a
Dynamic Shared Object (aka DSO, aka runtime library) via a library
interface - libdevmapper-event.  The daemon "wait"s on the device for an
event and uses the DSO to process it.  For example, when LVM creates a
mirror, it registers the mirror device with the daemon, specifying
"libdevmapper-event-lvm2mirror.so" as the DSO to use for processing
events.  (If users don't like the way the default DSO handles events,
they can even specify their own.)
</background>

Currently, the mirror DSO - libdevmapper-event-lvm2mirror.so - is
limited in what it does.  (Find the code in
LVM2/daemons/dmeventd/plugins/mirror/dmeventd_mirror.c)  It will tell
you when a mirror becomes "in-sync" and it will remove a device that
suffers an I/O error - regardless of how or why.  It is the last part
that needs improving...

We now have the ability to detect the type of error that was encountered
by the mirror.  After an event, we can get the status of the mirror,
which will look something like this:
"0 41943040 mirror 2 254:3 254:4 40960/40960 1 AA 3 clustered_disk 254:2 A"
The 'A's signify that the disks are "alive".  Looking at
'linux-2.6/drivers/md/dm-raid1.c' we find the other possible states:
 *    A => Alive - No failures
 *    D => Dead - A write failure occurred leaving mirror out-of-sync
 *    S => Sync - A sychronization failure occurred, mirror out-of-sync
 *    R => Read - A read failure occurred, mirror data unaffected
We can do so much more with this information than the immediate removal
of an offending device.  'S' could cause us to simply suspend/resume the
device to restart the resynchronization process - giving us another shot
at it.  'R' could mean that we have a unrecoverable read error - a block
relocation might be initiated via a write.  In the case of a 'D', we
could wait some user configured amount of time (or %'age out of sync)
before removing the offending device, as it could be a transient
failure.

A good DSO would also allow us to do proactive scans of RAID devices -
spotting problems before they bite us.  (Like the existence of an
unrecoverable read error rendering a RAID5 useless - even before a drive
has failed.)  There are lots of possibilities here....

If I were to guess at the phases of development I would say they are:
1) Simplest working solution - DONE

2) Improve parsing of mirror status output in the DSO
- Location => LVM2/daemons/dmeventd/plugins/mirror/dmeventd_mirror.c
- Be able to determine failure types (need more states then just
'ME_FAILURE')
- At the very least, we improve the log messages at this phase and it
sets us up to improve the handling of each error type - potentially
ignoring some error types for now (like read failures).

3) Implement different methods to handle the different error types

4) Transient fault handling
- Since we can't just assume "wait 5 seconds and then see if the failure
still exists", we are going to have to make this configurable.
Discussion should proceed on this in parallel with #2 and #3, since this
phase will take a long time for everyone to agree.  We have to determine
where the user specifies the configuration - lvm.conf?  CLI?  We also
have to determine /what/ their configuration will be based on - time?
percentage of mirror out-of-sync?

5) Proactive scan
- Even in the case where software does everything right, your RAID
volume can become inconsistent.  Long seeks, adjacent track erasure,
problems with RAM or copying, unrecoverable read errors... it'd be nice
if we could spot these before they become a problem.  We could use the
DSO to perform proactive scanning - perhaps just a little bit of the
storage at a time.  Every so many days, you could be reassured that
everything is in order.

 brassow
