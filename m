From: Patrick Schleizer <patrick-mailinglists@whonix.org>
Subject: kpartx bug when using very long paths?
Date: Thu, 10 Jul 2014 23:18:36 +0000
Message-ID: <53BF1F4C.5070306@whonix.org>
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

Is it possible, that there is a bug in kpartx when using very long paths?

Test 1 (short paths, works):
----------

#!/bin/bash
set -x
set -e

losetup --all

kpartx -a -s -v /home/tester/whonix_binary/Whonix-Gateway-8.6.1.6.raw
losetup --all
kpartx -d -s -v /home/tester/whonix_binary/Whonix-Gateway-8.6.1.6.raw

losetup --all

Output 1:
----------

sudo ./testscript
+ set -e
+ losetup --all
+ kpartx -a -s -v /home/tester/whonix_binary/Whonix-Gateway-8.6.1.6.raw
add map loop0p1 (254:0): 0 209711104 linear /dev/loop0 4096
+ losetup --all
/dev/loop0: [0801]:5898359
(/home/tester/whonix_binary/Whonix-Gateway-8.6.1.6.raw)
+ kpartx -d -s -v /home/tester/whonix_binary/Whonix-Gateway-8.6.1.6.raw
del devmap : loop0p1
loop deleted : /dev/loop0
+ losetup --all

Test 2 (long paths, fails):
----------

#!/bin/bash
set -x
set -e

losetup --all

kpartx -a -s -v
/home/tester/whonix_binary/Whonix-Gateway-8.6.1.6_report_tempfolder/raw_folder/Whonix-Gateway-8.6.1.6.raw
losetup --all
kpartx -d -s -v
/home/tester/whonix_binary/Whonix-Gateway-8.6.1.6_report_tempfolder/raw_folder/Whonix-Gateway-8.6.1.6.raw

losetup --all

Output 2:
----------

sudo ./testscript
+ set -e
+ losetup --all
+ kpartx -a -s -v
/home/tester/whonix_binary/Whonix-Gateway-8.6.1.6_report_tempfolder/raw_folder/Whonix-Gateway-8.6.1.6.raw
add map loop0p1 (254:0): 0 209711104 linear /dev/loop0 4096
+ losetup --all
/dev/loop0: [0801]:5898422
(/home/tester/whonix_binary/Whonix-Gateway-8.6.1.6_report_tempfolder/raw_folder/Whonix-Gateway-8.6.1.6.raw)
+ kpartx -d -s -v
/home/tester/whonix_binary/Whonix-Gateway-8.6.1.6_report_tempfolder/raw_folder/Whonix-Gateway-8.6.1.6.raw
+ losetup --all
/dev/loop0: [0801]:5898422
(/home/tester/whonix_binary/Whonix-Gateway-8.6.1.6_report_tempfolder/raw_folder/Whonix-Gateway-8.6.1.6.raw)

----------

(Same file, different path.)

In second run, loop is not deleted for some reason. Perhaps a bug?

kpartx version:
0.4.9+git0.4dfdaf2b-7~deb7u2

All the best,
Patrick
