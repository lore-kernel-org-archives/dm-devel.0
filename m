From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [RFC] Hot Reconfiguration of dmraid Arrays
Date: Wed, 08 Mar 2006 16:01:08 -0800
Message-ID: <1141862468.17279.44.camel@localhost.localdomain>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1745378411=="
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
To: dm-devel <dm-devel@redhat.com>, ataraid-list <ataraid-list@redhat.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Chris McDermott <lcm@us.ibm.com>
List-Id: dm-devel.ids


--===============1745378411==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-XOh8nvThzsInoeUJq5N6"


--=-XOh8nvThzsInoeUJq5N6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi everybody,

I've been working on a method to add hot array reconfiguration support
to dmraid so that we can do things like add spares to an array, replace
failed drives, modify arrays, etc without needing to reboot the system
to access the BIOS configuration utility.  The complicated problem here
is that we can't just reload the table of the dm device in question;
dmraid also has to make sure that the new metadata descriptors make it
out to disk.  This proposal requires the creation of two functions for
each dmraid format handler: (1) to check a raid_set for correctness and
(2) to make the requisite metadata changes and write them to the
fakeraid drive.

Currently, dmraid constructs a series of raid_set structures that
describe various attributes of the dm device and point to other
raid_sets or raid_dev structures representing the underlying devices.
Since these raid_sets are referenced from a lib_context, we can think of
the current dmraid configuration as a tree, with raid devices as the
leaf nodes and raid sets as the internal nodes.

To modify the configuration, make a deep copy of the tree and modify the
copy as desired.  This could come from something like
"dmraid /dev/mapper/asr_raid1 add /dev/sda1" or I/O events via dmeventd.
Either way, we end up with a "before" tree and an "after" tree, denoted
by T0 and T1, respectively.

Each raid_set should be modified to point to the dmraid_format that
created it, because the next step would be to traverse the tree and
ensure that the resulting raid sets still make sense.  There are some
checks that could be done at the dmraid level (like not mixing disks
from different fakeraid controllers in one array) and
controller-specific checks that can be done via function (1) in the
dmraid_format structure.  If any of the validation functions return an
error, we can abandon the reconfiguration attempt.  Up to this point, we
have not made any modifications to the running system.

Next, we change the dm tables and on-disk metadata as follows:
- For each raid set in T0 and not in T1,
  - Deconfigure the dm device.
  - If the array is being destroyed (as opposed to going offline),
    - Erase the metadata on all the drives.
- For each raid set that changed between T0 and T1,
  - Suspend the dm device.
  - Call function (2) in the dmraid_format descriptor to have
    the on-disk metadata updated.
  - Generate a new dm table and reload the dm device's table.
  - Resume the device.
- For each raid set in T1 and not in T0,
  - If the array is being created from scratch,
    - Call function (2) in the dmraid_format descriptor to
      have the on-disk metadata created.
  - Generate a dm table and create a new dm device with this table.

Now we're done, so we can update the lib_context structure with the new
configuration tree and destroy the old tree.

Does this seem like a reasonable way to do this?

--D

--=-XOh8nvThzsInoeUJq5N6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)

iD8DBQBED3BEa6vRYYgWQuURAmWoAKCu0DbXkXiyb2P22IMHU+JcE+4nRACgqxwY
SSyNE1mhL0lBNaqQMWIZOkE=
=SD+w
-----END PGP SIGNATURE-----

--=-XOh8nvThzsInoeUJq5N6--


--===============1745378411==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1745378411==--
