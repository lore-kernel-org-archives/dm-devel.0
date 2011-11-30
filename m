From: Douglas McClendon <dmc.lists@filteredperception.org>
Subject: Re: DM_snapshot_cow filesystem (dmsetup create snapshot)
Date: Tue, 29 Nov 2011 20:09:04 -0600
Message-ID: <4ED59040.50406@filteredperception.org>
References: <4EABE131.8010706@googlemail.com>	<20111029204947.GU23336@agk-dp.fab.redhat.com>	<CAEcBt+Ux+GVmm7zBeFA7k5PHOQoSKLTKcifB95ne5dBtX400dQ@mail.gmail.com>	<4ED2DF0F.1070108@filteredperception.org>
	<CAEcBt+UEJXSY7oK+j0gw9fkzjnWOUcBFhPdXCVFe3HZNh6zOTw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAEcBt+UEJXSY7oK+j0gw9fkzjnWOUcBFhPdXCVFe3HZNh6zOTw@mail.gmail.com>
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

On 11/29/2011 12:22 AM, Frederick Grose wrote:
> On Sun, Nov 27, 2011 at 8:08 PM, Douglas McClendon
> <dmc.lists@filteredperception.org
> <mailto:dmc.lists@filteredperception.org>> wrote:
>
>     On 11/27/2011 04:31 PM, Frederick Grose wrote:
>
>         On Sat, Oct 29, 2011 at 4:49 PM, Alasdair G Kergon
>         <agk@redhat.com <mailto:agk@redhat.com>
>         <mailto:agk@redhat.com <mailto:agk@redhat.com>>> wrote:
>
>             markmc did some code that shows how to read the format a few
>         years
>             ago here:
>         http://people.gnome.org/~__markmc/code/merge-dm-snapshot.__c
>         <http://people.gnome.org/~markmc/code/merge-dm-snapshot.c>
>         <http://people.gnome.org/%__7Emarkmc/code/merge-dm-__snapshot.c
>         <http://people.gnome.org/%7Emarkmc/code/merge-dm-snapshot.c>>
>
>
>             Otherwise look at dm-snap-persistent.c in the kernel tree.
>
>             Alasdair
>
>
>         Users can easily exhaust a LiveUSB snapshot overlay by writing
>         too many changes to the OS filesystem, such as by performing
>         a yum update.
>
>         Would such an 'exhausted' overlay be amenable to some sort of
>         data recovery or forensics?
>
>         If so, how so; if not, why not?
>
>
>     Can you not mount the exhausted dm snapshot?  If you mean data
>     recovery or forensics beyond that, please elaborate.
>
>     I know I've had issues 'read-only' mounting ext3(2?3?4?) filesystems
>     before (on actually read-only block devices).  Maybe some flags that
>     I've forgotten get past that, but worst case you can always fake a
>     writable device with a 2nd overlay/snapshot going to a writable
>     device, i.e. if you wanted to let fsck repair things.
>
>     -dmc
>
>
> A typical scenario goes like this:
>
> A LiveCD is loaded onto a USB device with a relatively small
> persistent overlay and no separate home.img filesystem.  The user
> proceeds to use the system and save some information.  They may
> execute a df command and see that there is lots of space
> available on the rootfs.  Then they decide to execute a yum
> update or yum install when there is insufficient space available.
> (They do not know about dmsetup status.)  Their session will now
> not shutdown normally. dmsetup status now shows
>
> live-rw: 0 8388608 snapshot Invalid.
>
> The device fails to complete a subsequent boot attempt.  The
> startup log shows

You probably know this, but note there is a reset_overlay (or similar) 
boot flag which I think causes the overlay/snapshot to be reset, to get 
a booting system.  So the rest of this is with the use-case in mind of 
trying to recover prior contents of the overlay/snapshot in a useful way.

>
> mount: /dev/mapper/live-rw: can't read superblock
>
> e2fsck /dev/dm-0 shows
>
> Buffer I/O error on device dm-0, logical block 0 (and 1, 2, 3, 0)
> e2fsck: Attempt to read block from the filesystem resulted in
> short read while trying to open /dev/dm-0
> Could this be a zero-length partition?
>
> I recreated the above scenario on Fedora-16-Live-Desktop
> installed with an overlay-size-mb of 100.  After updating to ~70%
> of the overlay, I wrote with
> dd if=/dev/zero of=/boot/load bs=1M count=10
> 3 times to exhaust the overlay.
>
> With the defective device mounted on a good system, and loop
> devices set up for ext3fs.img and the overlay file,
>
> dmsetup create item --table "0 8388608 snapshot 7:1 7:2 P 8"
> reports
> item: 0 8388608 snapshot Invalid

I don't know what that last line of output specifically means as far as 
subsequent expectations should go, though presumably others on this list 
can elaborate, or worst grep for the message in the code.

Maybe dmsetup is more cooperative with full overlays if they are created 
in read-only mode?(wild guess)

I.e. there is certainly the expectation that you won't be able to write 
to the device (or at a minimum to any chunk not already in the 
overlay(?)).  So as I mentioned, the way I'd go about it would be to 
recreate it (I'm taking for granted above cmdline is correct), but in 
read-only mode, then either just dup that to a new larger device, or add 
a second read-write snapshot layer on top (pointing to a looped tmpfile 
somewhere).  Then try to mount and/or fsck that.

But that presumes that the 'snapshot Invalid' isn't evidence that 
something is preventing even read-only access to the full snapshot.  For 
that I defer to the people more familiar with the relevent code.

>
> e2fsck /dev/dm-0 reports
>
> e2fsck 1.41.14 (22-Dec-2010)
> e2fsck: Attempt to read block from filesystem resulted in short
> read while trying to open /dev/dm-0
> Could this be a zero-length partition?
>
> A hex editor view of the overlay file shows lots of content with
> lots of zeros at the end of the file.
>
> My questions are these:
>
> Might there be a way to edit the overlay file to restore its
> utility for the information written before the damaging write?
>
> If so, how so; if not, why not?

Were it actually the case that full persistent snapshots become 
unusuable (short of 'editing'), that would seem like a bug needing to be 
fixed.

-dmc



>
> Suitable references would do as well.
>
> Thanks!       --Fred
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
