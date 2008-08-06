From: Sharif Nassar <lists-dmdevel@mrwacky.com>
Subject: Re: Status of resizing/growing dm-multipath devices on
	the fly
Date: Wed, 6 Aug 2008 14:46:57 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0808061432330.13407@mrwacky.com>
References: <20080806125355.GM3771@edu.joroinen.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463801342-673291102-1218059217=:13407"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080806125355.GM3771@edu.joroinen.fi>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463801342-673291102-1218059217=:13407
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Aug 2008, Pasi K=E4rkk=E4inen wrote:

> Hello!
>=20
> Is it possible to resize (grow) dm-multipath devices on the fly nowaday=
s?=20
>=20
> I googled and found some discussions about the subject, but the conclus=
ion
> seemed to be it's not possible.. that was a while ago, so I was wonderi=
ng if
> this has been fixed/implemented..=20
>=20
> Using LVM and adding another new LUN/PV is not an option always.. it's =
a lot
> easier to manage the whole thing if it's possible to resize/grow existi=
ng
> LUNs on the fly.


Sure it is, but it's not pretty.  Don't believe the naysayers.
We seem to have a working method for resizing multipath luns from our=20
NetApp filers.  It works on CentOS 4 & 5, for us, and our NetApps.
(2 HBA, times 2 paths on each makes for four SCSI LUN to resize)

The poorly formatted, unpolished, YMMV, no warranty recipe is:

1. Record the state of the dm tables

dmsetup table resize_test | tee orig current new final

2. Split one of the paths

multipath -l
resize_test (360a98000486e5452576f4336486d4c74) dm-2 NETAPP,LUN
[size=3D1.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
  \_ 5:0:0:0 sdb 8:16  [active][undef]
  \_ 6:0:0:0 sdc 8:32  [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
  \_ 6:0:1:0 sdd 8:48  [active][undef]
  \_ 5:0:1:0 sde 8:64  [active][undef]

# Choose a pair: sdb+sdc or sdd+sde. For this, let's choose sdd+sde

# Update current
vi current
0 2097152 multipath 1 queue_if_no_path 0 2 1 round-robin 0 2 1 8:16 4000=20
8:32 4000 round-robin 0 2 1 8:48 1000 8:64 1000

# Change this to:
0 2097152 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1 8:16 4000=20
8:32 4000

# Note this is what happened:
# Remove the second pair beginning with the second "round-robin". We know=
=20
it's sdd+sde based on the major/minor pairs.
# Reduce the number of pairs after "queue_if_no_path" from 2 (0 2 1) to 1=
=20
(0 1 1)

multipathd -k
> del path sdd
> del path sde

# Reload the dm table
dmsetup suspend resize_test current; dmsetup reload resize_test current;=20
dmsetup resume resize_test

# Verify you now just have one set of paths
multipath -l
resize_test (360a98000486e5452576f4336486d4c74) dm-2 NETAPP,LUN
[size=3D1.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
  \_ 5:0:0:0 sdb 8:16  [active][undef]
  \_ 6:0:0:0 sdc 8:32  [active][undef]

3.  Grow the LUN on the SAN (although, this can happen before steps 1 & 2=
=20
as well)

(NetApp specific:)
lun resize /vol/resize_test/lun 10g

4. # Update partition table

blockdev --rereadpt /dev/sdd
blockdev --rereadpt /dev/sde
blockdev --getsize /dev/sdd
blockdev --getsize /dev/sde

# The values for getsize in both commands must be the SAME
# Record this value
# The above gave us the value 20971520

# Update the dm table for new
vi new

0 2097152 multipath 1 queue_if_no_path 0 2 1 round-robin 0 2 1 8:16 4000=20
8:32 4000 round-robin 0 2 1 8:48 1000 8:64 1000

# Change this to:
0 20971520 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1 8:48 1000=
=20
8:64 1000

# Note this is what happened:
# Update the second parameter (num sectors) from 2097152 to 20971520=20
(obtained from blockdev --getsize)
# Remove the second pair beginning with the second "round-robin"
# Reduce the number of pairs after "queue_if_no_path" from 2 (0 2 1) to 1=
=20
(0 1 1)

5.  Switch to the new path

multipathd -k
> add path sdd
> add path sde
> del path sdb
> del path sdc

# Note: We are adding the INACTIVE Paths first (sdd+sde) and then removin=
g
# the ACTIVE paths (sdb+sdc). This is VERY important. I tried reversing i=
t=20
by
# deleting ACTIVE first then adding INACTIVE. Fortunately, multipathd kep=
t=20
one
# of them, refusing to budge.

dmsetup suspend resize_test; dmsetup reload resize_test new; dmsetup=20
resume resize_test

# Verify we've switched to the new path:
multipath -l
resize_test (360a98000486e5452576f4336486d4c74) dm-2 NETAPP,LUN
[size=3D10G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][enabled]
  \_ 6:0:1:0 sdd 8:48  [active][undef]
  \_ 5:0:1:0 sde 8:64  [active][undef]

# Note: multipath now shows the new size (10G). If it still shows the old=
=20
size, chances are
# that one of the block devices in the pair have not had their partition=20
tables updated.
# TURN BACK! AND MAKE SURE TO REREAD THE PARTITION TABLES!


6. Update the block devices on the inactive path

blockdev --rereadpt /dev/sdb
blockdev --rereadpt /dev/sdc
blockdev --getsize /dev/sdb
blockdev --getsize /dev/sdc

7. Re-add the final path

# Update the final dm table

vi final
0 2097152 multipath 1 queue_if_no_path 0 2 1 round-robin 0 2 1 8:16 4000=20
8:32 4000 round-robin 0 2 1 8:48 1000 8:64 1000

# Change to:
0 20971520 multipath 1 queue_if_no_path 0 2 1 round-robin 0 2 1 8:16 4000=
=20
8:32 4000 round-robin 0 2 1 8:48 1000 8:64 1000

# Note this is what happened:
# Update the second parameter (num sectors) from 2097152 to 20971520
# (obtained from blockdev --getsize)

multipathd -k
add path sdb
add path sdc

dmsetup suspend resize_test; dmsetup reload resize_test final; dmsetup=20
resume resize_test

multipathd -k
reconfigure

# Note: This reconfigure is *ESSENTIAL* as it forces multipath to remembe=
r=20
the new size. Without this step, failing one of the paths
# can cause multipath to reuse the previous block device size and cause=20
filesystem problems.

8.  Resize the FS from userland

ext2online /dev/mapper/resize_test
(or resize2fs in newer )


Pfew! Done!
I think this should have been shared by us (myself, Gino Ledesma, Michael=
 Hsu) a long time ago.
We probably wanted to make a pretty pretty script to do it for us.

There is a slightly more convoluted recipe if you were bold and foolish=20
enough to partition the LUN (like we once were).

Cheers,

-sharif

---1463801342-673291102-1218059217=:13407
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


---1463801342-673291102-1218059217=:13407--
