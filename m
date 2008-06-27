From: KAIZUKA Hiroyuki <kaizuka@valinux.co.jp>
Subject: iobandctl (a utility tool for dm-ioband) update
Date: Fri, 27 Jun 2008 19:13:32 +0900
Message-ID: <4864BD4C.9000506@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

iobandctl has been updated to v0.0.3.
This version of iobandctl enables you:
 To use the configuration files to configure I/O bandwidth control settings,
 To apply I/O bandwidth control to multiple disks which share the I/O
 bandwidth,
 To apply the new bandwidth control policy which has been implemented on
 dm-ioband v1.0.0.
See http://people.valinux.co.jp/~kaizuka/dm-ioband/iobandctl/
for more details.

iobandctl is an administration tool to realize disk I/O bandwidth control
using dm-ioband, which is an I/O bandwidth controller implemented as a
device-mapper driver. You can find dm-ioband at:
http://people.valinux.co.jp/~ryov/bwctl/

Changes from previous version:
* Configuration file support
 o config subcommand is added.
 o It is possible to configure your I/O bandwidth control settings
   using your configuration file.
* Multiple disks support
 o −−bind option is added on "create" subcommand.
 o It is possible to apply I/O bandwidth control to multiple disks
   which share the I/O bandwidth.
 o It's certain that two or more Logical Units contained in the same
   SCSI target device share the I/O bandwidth. You are able to distribute the
   bandwidth among the partitions involved in these Logical Units.
* New bandwidth control policy support
 o policy subcommand is added.
 o The new policy "weight-iosize" do I/O bandwidth control based on
   the size of I/Os instead of the number of I/Os, which is the existing and
   default policy named "weight-iocount".
* Particular devices name support such as certain raid devices
 o Support for logical drive names such as "/dev/cciss/c1d0" and
   raid device names such as "/dev/md0".
 o This simply means that iobandctl has come to treat such names
   properly now, though it couldn't do that in previous version.
 o It needs you to understand which device share the I/O bandwidth
   with which other device, and configure proper settings using --bind option.

Regards,
KAIZUKA Hiroyuki
