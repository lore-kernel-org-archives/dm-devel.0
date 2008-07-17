From: KAIZUKA Hiroyuki <kaizuka@valinux.co.jp>
Subject: iobandctl minor update
Date: Thu, 17 Jul 2008 15:12:01 +0900
Message-ID: <487EE2B1.7050607@valinux.co.jp>
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

This is a minor update release of iobandctl.

For now I believe this is a complete version of iobandctl.
The only improvement in this release is cleaned-up source code.

You can find the source code and documentations of iobandctl from:
http://people.valinux.co.jp/~kaizuka/dm-ioband/iobandctl/

iobandctl is an administration tool to realize disk I/O bandwidth
control. It needs dm-ioband, which is an I/O bandwidth controller
implemented as a device-mapper driver. You can find dm-ioband at:
http://people.valinux.co.jp/~ryov/bwctl/

Changes from previous version:
* Source code cleanup.
* Improved execution speed, in the case of using configuration file
  especially.


Thanks,
KAIZUKA Hiroyuki
