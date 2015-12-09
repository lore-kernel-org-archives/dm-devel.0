From: "John Stoffel" <john@stoffel.org>
Subject: fixing mangled UUIDs
Date: Wed, 9 Dec 2015 11:16:04 -0500
Message-ID: <22120.21444.300955.356941@quad.stoffel.home>
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
To: LVM general discussion and development <linux-lvm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids


I've got a Debian Jessie system running Linux kernel 4.4-rc4 on AMD64
Phenom II X4 with 16gb of RAM.  I've just replaced a bunch of failing
1Tb drives and my 320Gb boot drives with 2 x 4Tb disks and 2 x 500gb
SSDs.  Using LVM cache for a couple of areas and it's looking good so
far.  I've got the following LVM targets:

   # dmsetup targets
   cache            v1.8.0
   thin-pool        v1.16.0
   thin             v1.16.0
   raid             v1.7.0
   zero             v1.1.0
   mirror           v1.14.0
   snapshot-merge   v1.4.0
   snapshot-origin  v1.9.0
   snapshot         v1.15.0
   multipath        v1.10.0
   flakey           v1.3.1
   delay            v1.2.1
   crypt            v1.14.1
   striped          v1.5.1
   linear           v1.2.1
   error            v1.3.0

And packages installed:

  libllvm3.5:amd64        1:3.5-10
  liblvm2app2.2:amd64     2.02.111-2.2
  liblvm2cmd2.02:amd64    2.02.111-2.2
  lvm2    2.02.111-2.2

So now I want to monitor performance and cache usage.  But I can't
because:

  dmsetup status --target cache

Fails with:

The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVas2sZsZM8mw0VXDgx03ryaq351RUEL4j-cmeta"
should be mangled but it contains blacklisted characters.
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVbbcg3pVFZyDngdRLS4aECbc571Lyb5MI"
should be mangled but it contains blacklisted characters.
Command failed


So I've looked at dmsetup man page and tried to run

   dmsetup mangle

But it fails on all the LVM volumes with stuff like this:

   data-pete:
   LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVbbcg3pVFZyDngdRLS4aECbc571Lyb5MI:
   UUID in incorrect form.
   Unable to change device UUID. The device must be deactivated first.
   Command failed

So when I do:

  umount /mnt/pete
  lvchange -an data/pete
  dmsetup mangle data/pete

it bombs out.  I've compiled the latest lvm2 tools, but it still dies:

  # /opt/lvm2/sbin/dmsetup --version
  Library version:   1.02.114-git (2015-12-05)
  Driver version:    4.34.0

So I have two questions:

1. How do I mangle the name properly?  Do I need to reboot using a
   LiveCD of some sort?

2. And can we fix the failing of: dmsetup status --target-cache even
when there are UUIDs that need de-mangling?

I'm happy to test patches, versions, etc.

THanks,
John
