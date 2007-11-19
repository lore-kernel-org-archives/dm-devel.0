From: usvyatsky_ilya@emc.com
Subject: RE: Multipath v. 0.4.7 trips over USB flash drive
Date: Mon, 19 Nov 2007 16:46:16 -0500
Message-ID: <3A7658DE9640014CB055D6299B111F9C1EF589@CORPUSMX20B.corp.emc.com>
References: <3A7658DE9640014CB055D6299B111F9C1EF588@CORPUSMX20B.corp.emc.com>
	<20071119213230.GA829@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20071119213230.GA829@linux.vnet.ibm.com>
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

Hi Mike,

Thanks for your suggestion.=20
I have tried the upstream version of the multipath, but it seg. faulted.

Looks like it depends on an upstream version of dm.
This means massive upgrade that involves the kernel modules, so it'll
have to wait a bit.
I'll post an update here once I have it tested.

Thanks,
Ilya.


-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Mike Anderson
Sent: Monday, November 19, 2007 4:33 PM
To: device-mapper development
Subject: Re: [dm-devel] Multipath v. 0.4.7 trips over USB flash drive

usvyatsky_ilya@emc.com <usvyatsky_ilya@emc.com> wrote:
> Hi there,
>=20
> I am using DM MPIO for quite a while now and in general it works.
> Lately I encountered a problem with one of my boxes that is equipped
> with USB flash drive and is connected to a disk array.
> Namely, the flash drive has an empty bcdDevice entry, which translates
> into empty /sys/block/sdXX/device/rev file.
> As a result, the 'multipath -ll' command trips over this device and
> bails out without listing any array mpathXX devices.
> The devices are created in /dev/disk/by-name/ directory, so it's just
> the userland tool issue.
>=20
> I've built debug version of multipath and found the following:
>=20
> 1. The function sysfs_get_rev() (which is generated from macro
> declare_sysfs_get_str()) assumes that the rev has to have at least 2
> characters. Since in the case of my device this assumption is false,
the
> function returns 1.
> 2. The caller function is scsi_sysfs_pathinfo() and it returns 1 as
> well.
> 3. The caller function is sysfs_pathinfo(), which returns 1 as well.
> 4. The caller function is pathinfo(), which also returns 1.
> 5. The caller function is store_pathinfo(). Here the pathinfo is not
> stored and NULL is returned to the caller.
> 6. The caller is path_discover() that returns 1.
> 7. The caller is path_discovery() that returns non-zero result.
> 8. The caller is configure() that bails out on this result.
>=20
> I have tried to work around this issue by blacklisting the device, but
> unfortunately the only blacklist check that is done prior to call to
> store_pathinfo() in the path_discover() is based on the devnode.=20
> This means that effectively I cannot use this workaround since with
USB
> device I cannot guarantee that it will always be mapped to the same
> devnode.
>=20
> I'd like to propose a couple of options for a fix for this issue:
>=20
> 1. Re-implement sysfs_get_rev() in such a way that rev filed minimal
> length is no longer required.=20
>    Please see attached a patch that is supposed to take care of this.
> 2. Re-implement pathinfo() to check whether vendor and/or product are
> blacklisted.=20
>    This way non-compliant devices may be blacklisted based on vendor
> and/or product name.
>=20
> I am not sure, which option is preferable, but I clearly need at least
> one of them in the product.
>=20
> Your comments are greatly appreciated.=20
>=20
> Please note that my patch is against v. 0.4.7 of the multipath tool.=20
> I realize that upstream may differ significantly, so if option (1)
makes
> sense I'll revalidate with the latest version and submit the patch if
> necessary.

The upstream version already removes the minimum size.

You should try the multipath-tools git tree version to see if it
addresses
your issue.

http://git.kernel.org/?p=3Dlinux/storage/multipath-tools/.git;a=3Dsummary

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
