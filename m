From: Phillip Susi <psusi@cfl.rr.com>
Subject: Device removal handling
Date: Sun, 10 Jul 2011 16:12:10 -0400
Message-ID: <4E1A079A.9060901@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I am trying to understand how device removal is supposed to be handled
and make sure that it works correctly.  So far, what I see is discouraging.

I began by trying to remove the msdos partition table code from dmraid
and leave partition handling up to kpartx.  I realized that this is not
so simple because in order to deactivate the raid array, the partitions
must first be deactivated, which will not be possible if dmraid does not
know about them.  It also seems that dmsetup fails to remove a dm device
that is in use.

I then tried forcing the removal of an underlying physical disk by
writing a 1 to /sys/block/sda/device/remove.  This apparently removed
the disk, but left it in a dangling state since it was apparently still
being referenced by the dm device, which seems to have no notion that
the underlying disk has been removed.  At this point the /sys entry has
gone, so it is no longer even possible to have udev look up the holders
of the device so they can be removed.  This prevents the disk from
reusing the same identifier when it is rescanned.

Shouldn't it be possible to remove an underlying dm-device that is still
in use like you can with the physical disk, and shouldn't such a removal
trigger some kind of notification to the dm-device stacked on top, so
that it can release it?

Also, why do the /sys entries disappear before the device is released?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk4aB5UACgkQJ4UciIs+XuLQYACbB3YCsYoEyfUm5aLITa2wajSp
M8AAoJ5e1sqflyJfwk38A8aZabmb+wkW
=44S4
-----END PGP SIGNATURE-----
