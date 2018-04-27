From: Patrick Mitchell <patricklmitchell9@gmail.com>
Subject: Undo removing a missing PV to a VG,
	which caused inconsistent metadata
Date: Fri, 27 Apr 2018 11:23:29 -0400
Message-ID: <CA+2BD2fc2Fqqefk_c0B83sCsg=+DYS2J9L0y4Q9vcLmcYCmsLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I had (4) platter disks and (1) SSD in a VG lvm.  LV's were either on
platters or the SSD, none were across both.

Long story short, booted without SSD plugged in, and didn't need
access to the LV's on the SSD.  Needed to create a temporary LV on the
platters, and got an error about not being able to create a LV while
the VG was incomplete, with the SSD missing.  Stupidly ran its advise
of something like vgreduce --removemissing without reading vgreduce's
man page.  Thinking this would either be temporary for that boot, or I
could just easily re-add it later.

Still couldn't create the LV on the platter disks, so powered off and
installed the SSD.

I never added any LV's or made any other changes, so I just need to revert the
metadata change, don't need to merge any changes in.



pvs does show the SSD partition, with attribute missing.

vgs does shows all 5 pv's, attribute partial.

lvs dhows SSD thin pool, partial.  Does NOT show the single thin
volume that is within the SSD thin pool.  Assuming that makes sense
since the thin pool isn't activated.


How do I permanently re-add the SSD PV to the VG, so the thin pool
activates, and the thin volume is accessible?

Is there an easy way I can compare the contents of metadata 315 and
319, verify 315 is exactly what I want, and reload 315 to be the
current metadata on all PVs?  Or is there a different way to go?

I'm thinking "vgextend --restoremissing" might not be the way to go,
since there's inconsistent metadata, but maybe that would be OK and it
would just write a v320 to all 5 PVs.

Should I manually dump the metadata based on offsets shown by pvck,
find 315, assuming that has the correct information, and run
vgcfgrestore on that file?  Would that write like a new version 320
metadata to all 5 PVs?

My system volume's etc doesn't have a backup of metadata 315.  That
etc backup was written on an ISO CD tmpfs and is now gone.

I'm thinking the journalctl messages below mentioning "vgreduce
--removemissing" and "--activationmode partial" are not at all what I
want at this point.



APPLICABLE JOURNALCTL OUTPUT: (hand-typed, booted on ISO CD)

lvm: WARNING: lvmetad is being updated, retrying (setup) for 10 more seconds.
...
lvm: WARNING: Not using lvmetad after 10 sec lvmetad_update_wait_time.
lvm: WARNING: Autoactivation reading from disk instead of lvmetad.
...
lvmetad: update_metadata ignoring outdated metadata on PV XYZ seqno
315 for ABC lvm seqno 319
lvmetad: PV XYZ has outdated metadata for VG ABC
lvm: WARNING: Inconsistent metadata found for VG lvm
lvmetad: Cannot use VG metadata for lvm ABC from PV XDYZ on 66309
...
lvm: WARNING: Missing device /dev/nvme0n1p5 reappeared, updating
metadata for VG lvm to version 319.
WARNING: Device /dev/nvme0n1p5 still marked missing because of
allocated data on it, remove volumes and consider vgreduce
--removemissing.
WARNING: Inconsistent metadata found for VG lvm - updating to use version 319
...
lvm: Refusing refresh of partial LV lvm/nvmethin. Use
'--activationmode partial' to override.
lvm: lvm: refresh before autoactivation failed.
...
lvm: Refusing activation of partial LV lvm/nvmethin.  Use
'--activationmode partial' to override.
...
lvm: 43 logical volume(s) in volume group "lvm" now active
lvm: autoactivation failed.
systemd: lvm2-pvscan@8:19.service: Main process exited, code=exited,
status=5/NOTINSTALLED
systemd: lvm2-pvscan@8:19.service: Failed with result 'exit-code'.
systemd: Failed to start LVM2 PV scan on device 8:19.
lvm: 51 logical volume(s) in volume group "lvm" monitored
...
lvm: Not monitoring lvm/disk1thin failed
...
lvm: Refusing refresh of partial LV lvm/nvmethin. Use
'--activationmode partial' to override.
...
lvm: Refusing activation of partial LV lvm/nvmethin.  Use
'--activationmode partial' to override.
lvm: 43 logical volume(s) in volume group "lvm" now active
lvm: lvm: autoactivation failed
systemd: lvm2-pvscan@8:3.service: Main process exited, code=exited,
status=5/NOTINSTALLED
systemd: lvm2-pvscan@8:3.service: Failed with result 'exit-code'.
systemd: Failed to start LVM2 pv scan on device 8:3.
lvm: Refusing refresh of partial LV lvm/nvmethin. Use
'--activationmode partial' to override.
