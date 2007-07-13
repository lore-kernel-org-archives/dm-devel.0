From: "Romanowski, John (OFT)" <John.Romanowski@oft.state.ny.us>
Subject: zSeries zipl on a blacklisted multipath path.
Date: Fri, 13 Jul 2007 12:40:55 -0400
Message-ID: <1D80D4F6D179BD4D869FE807A5BF8336018C66DA@EXCNYSM0A1AN.nysemail.nyenet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Class: urn:content-classes:message
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

Hi List,
I run SLES9 on IBM zSeries and I'm trying to hack a way to have my boot
partition on a multipath LUN and yet still be able to run IBM's zipl to
update the boot loader on that LUN.
The SLES9 has kernel 2.6.5-7.276-s390x, device-mapper-1.01.01-1.6,
multipath-tools-0.4.5-0.20.

zipl won't update a multipath boot partition, zipl can't get the
geometry of a device-mapper device and quits with message
"Error: Could not get disk geometry"; this is a device-mapper
limitation, not zipl's fault.
=20
Since zipl needs a plain /dev/sdx boot device to update,
my hack idea is to put the boot partition on the multipath LUN and in
multipath.conf blacklist one of the LUN's paths (lets say /dev/sda) so
zipl can use /dev/sda to update the boot loader. I would unmount the
multipath boot partition device from /boot, mount /dev/sda at /boot and
then run zipl.

Any ideas how risky this would be: I/O to the LUN's non-boot partitions
via multipaths and zipl I/O to the LUN's boot partition via the
blacklisted path?
--------------------------------------------------------
This e-mail, including any attachments, may be confidential, privileged o=
r otherwise legally protected. It is intended only for the addressee. If =
you received this e-mail in error or from someone who was not authorized =
to send it to you, do not disseminate, copy or otherwise use this e-mail =
or its attachments.  Please notify the sender immediately by reply e-mail=
 and delete the e-mail from your system.
