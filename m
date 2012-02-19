From: Spelic <spelic@shiftmail.org>
Subject: DM / LVM hangs if snapshot present on kernel v3.0.3
Date: Sun, 19 Feb 2012 03:27:39 +0100
Message-ID: <4F405E1B.5030609@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

Hello lists,

Do you have any information about a bug in linux v3.0.3, of LVM snapshot 
making a mess at (clean!) reboot?

Symptoms are: message at boot:
     [   15.668799] device-mapper: table: 252:3: snapshot: Snapshot cow 
pairing for exception table handover failed
     [   15.668934] device-mapper: ioctl: error adding target to table
     [   19.388627] device-mapper: table: 252:3: snapshot: Snapshot cow 
pairing for exception table handover failed
     [   19.388786] device-mapper: ioctl: error adding target to table


and then the volume origin and snapshot come out inactive
         lvVM_TP1_d1 vgVM   owc-i- 500.00g
         ...
         tp1d1-snap1 vgVM   swi-i- 600.00g lvVM_TP1_d1 100.00      (*)
(other volumes not having snapshot are active and working)

(*) please note the size occupied in the snapshot is WRONG, it should be 
4.56% and not 100%.

At this point I did:

# lvchange --refresh vgVM/tp1d1-snap1
Couldn't find snapshot origin uuid 
LVM-WUPTe8bqp25OSeRsFcLpC228A6U0r84T22tfFj4EkWbuB6pP5UDTA7nVRfGSCZW7-real.
# lvs
... *everything hangs* ..!!

It hangs in DM code (too bad I lost the stack trace, sorry)
I think the ssh session hanged at uninterruptible sleep, there was no 
kernel panic, I could indeed login again, however the DM devices were 
hanged bad so AFAIR I had to force a reboot without syncing or it would 
not complete the shutdown process.


At reboot the situation at lvs is unchanged, with the two LVM devices 
(origin and snapshot) still inactive.

This time I try refresh on the *origin*:

# lvchange --refresh vgVM/lvVM_TP1_d1
(no output)
#

and magically everything starts working!
I can do lvs, dmsetup table is all filled, etc.
Size occupied in snapshot shown in lvs is back to correct value 4.56%

Then I reboot (clean!) again so to check that problems are solved now...
Surprise!! The problems are back. The two devices, origin and snapshot, 
are again inactive.

This time I think I learned the lesson and I refresh again *the origin*
(I am SURE I used the origin, I triple checked that, I gave *exactly* 
the same command of the previous time)

# lvchange --refresh vgVM/lvVM_TP1_d1

Surprise!! everything hangs!!

Like before, no kernel panic, however ssh session hangs and DM is 
unresponsive so I had to force a reboot without sync or it would not 
complete.


At reboot again devices are inactive.

At this point I am really fed up of LVM snapshots and I fear for our 
data, so I remove the snapshot with lvremove (I don't remember if I had 
to do lvchange --refresh on the origin before lvremove or not)

As soon as I removed the snapshot everything started working flawlessly.


I am very worried about this bug...
We would need snapshot at work for performing live backups, but with 
this situation I don't know if I am risking more with snapshots  or by 
not performing backups.
Do you have any information on this bug, e.g. has this been fixed since 
3.0.3?

Thank you
Sp
