From: "KAIZUKA Hiroyuki" <kaizuka@valinux.co.jp>
Subject: dm-ioband utility tool update (LVM support)
Date: Thu, 29 May 2008 19:19:50 +0900
Message-ID: <b4f682fb0805290319s442cc896w303ac11b80dfd988@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

Hi, everyone,

iobandctl has been updated.
It came to be able to deal with LVM Volume Groups.

iobandctl is an administration tool to realize disk I/O bandwidth control
using dm-ioband, which is an I/O bandwidth controller implemented as a
device-mapper driver. You can find dm-ioband at:
http://people.valinux.co.jp/~ryov/dm-ioband

Changes from previous version:
*  LVM support.
  o You can specify a Volume Group for the device name on "create" subcommand.
    Ioband devices are created per LV involved in the VG.
  o "create" subcommand has come not to try to create already existing ioband
    devices. This helps you to create an ioband device which will map on to
    newly added Logical Volume.
  o You can specify Logical Volumes for the device name on "weight" subcommand.
  o You can specify Volume Groups or Logical Volumes for the device name on
    "group", "showconfig", and "status" subcommand.
  o You can specify a Volume Group or a Logical Volume for the device name on
    "destroy" subcommand. Now, it is possible to delete each ioband device,
    not all ioband devices involved in the specified device.
* Fixed a bug, when resetting ioband device statistics counter.

Limitations:
* iobandctl does not support the "weight-iosize" policy yet, which has been
  newly added to dm-ioband v1.0.0.

For more details, please refer to:
http://people.valinux.co.jp/~kaizuka/dm-ioband/iobandctl/

Thanks,
KAIZUKA Hiroyuki
