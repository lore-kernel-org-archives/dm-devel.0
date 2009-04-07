From: Alasdair G Kergon <agk@redhat.com>
Subject: FW: [RHSA-2009:0411-01] Moderate:
	device-mapper-multipath security update
Date: Tue, 7 Apr 2009 23:06:59 +0100
Message-ID: <20090407220659.GP5688@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

=====================================================================
                   Red Hat Security Advisory

Synopsis:          Moderate: device-mapper-multipath security update
Advisory ID:       RHSA-2009:0411-01
Product:           Red Hat Enterprise Linux
Advisory URL:      https://rhn.redhat.com/errata/RHSA-2009-0411.html
Issue date:        2009-04-07
CVE Names:         CVE-2009-0115 
=====================================================================

1. Summary:

Updated device-mapper-multipath packages that fix a security issue are now
available for Red Hat Enterprise Linux 4 and 5.

This update has been rated as having moderate security impact by the Red
Hat Security Response Team.

2. Relevant releases/architectures:

Red Hat Enterprise Linux (v. 5 server) - i386, ia64, ppc, s390x, x86_64
Red Hat Enterprise Linux AS version 4 - i386, ia64, ppc, s390, s390x, x86_64
Red Hat Enterprise Linux Desktop (v. 5 client) - i386, x86_64
Red Hat Enterprise Linux Desktop version 4 - i386, x86_64
Red Hat Enterprise Linux ES version 4 - i386, ia64, x86_64
Red Hat Enterprise Linux WS version 4 - i386, ia64, x86_64

3. Description:

The device-mapper multipath packages provide tools to manage multipath
devices by issuing instructions to the device-mapper multipath kernel
module, and by managing the creation and removal of partitions for
device-mapper devices.

It was discovered that the multipathd daemon set incorrect permissions on
the socket used to communicate with command line clients. An unprivileged,
local user could use this flaw to send commands to multipathd, resulting in
access disruptions to storage devices accessible via multiple paths and,
possibly, file system corruption on these devices. (CVE-2009-0115)

Users of device-mapper-multipath are advised to upgrade to these updated
packages, which contain a backported patch to resolve this issue. The
multipathd service must be restarted for the changes to take effect.

Important: the version of the multipathd daemon in Red Hat Enterprise Linux
5 has a known issue which may cause a machine to become unresponsive when
the multipathd service is stopped. This issue is tracked in the Bugzilla
bug #494582; a link is provided in the References section of this erratum.
Until this issue is resolved, we recommend restarting the multipathd
service by issuing the following commands in sequence:

	# killall -KILL multipathd

	# service multipathd restart

4. Solution:

Before applying this update, make sure that all previously-released
errata relevant to your system have been applied.

This update is available via Red Hat Network.  Details on how to use
the Red Hat Network to apply this update are available at
http://kbase.redhat.com/faq/docs/DOC-11259

5. Bugs fixed (http://bugzilla.redhat.com/):

493330 - CVE-2009-0115 device-mapper-multipath: insecure permissions on multipathd.sock

6. Package List:

Red Hat Enterprise Linux AS version 4:

Source:
ftp://updates.redhat.com/enterprise/4AS/en/os/SRPMS/device-mapper-multipath-0.4.5-31.el4_7.1.src.rpm

i386:
device-mapper-multipath-0.4.5-31.el4_7.1.i386.rpm
device-mapper-multipath-debuginfo-0.4.5-31.el4_7.1.i386.rpm

ia64:
device-mapper-multipath-0.4.5-31.el4_7.1.ia64.rpm
device-mapper-multipath-debuginfo-0.4.5-31.el4_7.1.ia64.rpm

ppc:
device-mapper-multipath-0.4.5-31.el4_7.1.ppc.rpm
device-mapper-multipath-debuginfo-0.4.5-31.el4_7.1.ppc.rpm

s390:
device-mapper-multipath-0.4.5-31.el4_7.1.s390.rpm
device-mapper-multipath-debuginfo-0.4.5-31.el4_7.1.s390.rpm

s390x:
device-mapper-multipath-0.4.5-31.el4_7.1.s390x.rpm
device-mapper-multipath-debuginfo-0.4.5-31.el4_7.1.s390x.rpm

x86_64:
device-mapper-multipath-0.4.5-31.el4_7.1.x86_64.rpm
device-mapper-multipath-debuginfo-0.4.5-31.el4_7.1.x86_64.rpm

Red Hat Enterprise Linux Desktop version 4:

Source:
ftp://updates.redhat.com/enterprise/4Desktop/en/os/SRPMS/device-mapper-multipath-0.4.5-31.el4_7.1.src.rpm

i386:
device-mapper-multipath-0.4.5-31.el4_7.1.i386.rpm
device-mapper-multipath-debuginfo-0.4.5-31.el4_7.1.i386.rpm

x86_64:
device-mapper-multipath-0.4.5-31.el4_7.1.x86_64.rpm
device-mapper-multipath-debuginfo-0.4.5-31.el4_7.1.x86_64.rpm

Red Hat Enterprise Linux ES version 4:

Source:
ftp://updates.redhat.com/enterprise/4ES/en/os/SRPMS/device-mapper-multipath-0.4.5-31.el4_7.1.src.rpm

i386:
device-mapper-multipath-0.4.5-31.el4_7.1.i386.rpm
device-mapper-multipath-debuginfo-0.4.5-31.el4_7.1.i386.rpm

ia64:
device-mapper-multipath-0.4.5-31.el4_7.1.ia64.rpm
device-mapper-multipath-debuginfo-0.4.5-31.el4_7.1.ia64.rpm

x86_64:
device-mapper-multipath-0.4.5-31.el4_7.1.x86_64.rpm
device-mapper-multipath-debuginfo-0.4.5-31.el4_7.1.x86_64.rpm

Red Hat Enterprise Linux WS version 4:

Source:
ftp://updates.redhat.com/enterprise/4WS/en/os/SRPMS/device-mapper-multipath-0.4.5-31.el4_7.1.src.rpm

i386:
device-mapper-multipath-0.4.5-31.el4_7.1.i386.rpm
device-mapper-multipath-debuginfo-0.4.5-31.el4_7.1.i386.rpm

ia64:
device-mapper-multipath-0.4.5-31.el4_7.1.ia64.rpm
device-mapper-multipath-debuginfo-0.4.5-31.el4_7.1.ia64.rpm

x86_64:
device-mapper-multipath-0.4.5-31.el4_7.1.x86_64.rpm
device-mapper-multipath-debuginfo-0.4.5-31.el4_7.1.x86_64.rpm

Red Hat Enterprise Linux Desktop (v. 5 client):

Source:
ftp://ftp.redhat.com/pub/redhat/linux/enterprise/5Client/en/os/SRPMS/device-mapper-multipath-0.4.7-23.el5_3.2.src.rpm

i386:
device-mapper-multipath-0.4.7-23.el5_3.2.i386.rpm
device-mapper-multipath-debuginfo-0.4.7-23.el5_3.2.i386.rpm
kpartx-0.4.7-23.el5_3.2.i386.rpm

x86_64:
device-mapper-multipath-0.4.7-23.el5_3.2.x86_64.rpm
device-mapper-multipath-debuginfo-0.4.7-23.el5_3.2.x86_64.rpm
kpartx-0.4.7-23.el5_3.2.x86_64.rpm

Red Hat Enterprise Linux (v. 5 server):

Source:
ftp://ftp.redhat.com/pub/redhat/linux/enterprise/5Server/en/os/SRPMS/device-mapper-multipath-0.4.7-23.el5_3.2.src.rpm

i386:
device-mapper-multipath-0.4.7-23.el5_3.2.i386.rpm
device-mapper-multipath-debuginfo-0.4.7-23.el5_3.2.i386.rpm
kpartx-0.4.7-23.el5_3.2.i386.rpm

ia64:
device-mapper-multipath-0.4.7-23.el5_3.2.ia64.rpm
device-mapper-multipath-debuginfo-0.4.7-23.el5_3.2.ia64.rpm
kpartx-0.4.7-23.el5_3.2.ia64.rpm

ppc:
device-mapper-multipath-0.4.7-23.el5_3.2.ppc.rpm
device-mapper-multipath-debuginfo-0.4.7-23.el5_3.2.ppc.rpm
kpartx-0.4.7-23.el5_3.2.ppc.rpm

s390x:
device-mapper-multipath-0.4.7-23.el5_3.2.s390x.rpm
device-mapper-multipath-debuginfo-0.4.7-23.el5_3.2.s390x.rpm
kpartx-0.4.7-23.el5_3.2.s390x.rpm

x86_64:
device-mapper-multipath-0.4.7-23.el5_3.2.x86_64.rpm
device-mapper-multipath-debuginfo-0.4.7-23.el5_3.2.x86_64.rpm
kpartx-0.4.7-23.el5_3.2.x86_64.rpm

These packages are GPG signed by Red Hat for security.  Our key and 
details on how to verify the signature are available from
https://www.redhat.com/security/team/key/#package

7. References:

http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-0115
http://www.redhat.com/security/updates/classification/#moderate
https://bugzilla.redhat.com/show_bug.cgi?id=494582

8. Contact:

The Red Hat security contact is <secalert@redhat.com>.  More contact
details at https://www.redhat.com/security/team/contact/

Copyright 2009 Red Hat, Inc.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (GNU/Linux)

iD8DBQFJ26TjXlSAg2UNWIIRAnW7AJ4tUnBrI4MY67KDkm1s/8otbCkBIgCeIG5L
k0Qd+xIu8PF3oLGHw61yKbE=
=AdN9
-----END PGP SIGNATURE-----
