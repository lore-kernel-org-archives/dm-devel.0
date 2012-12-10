From: James Robertson <j@mesrobertson.com>
Subject: kpartx mounted vmdk images and bad write performance
Date: Mon, 10 Dec 2012 20:14:32 +1100
Message-ID: <CAMALoy_KGkU9TyNeB_HZPK_Nm5xrpmMvVyPGT52mCSGA01kB+Q@mail.gmail.com>
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

I am using kpartx to mount some VMware vmdk virtual disks in order to
write some data to the partitions contained therein.

Initially writing the data starts off fine, but within about 30
seconds or after a few hundred megabytes is written, everything grinds
to a halt and IO plummets.

When mounting the vmdk partitions using losesetup, performance is
better and doesn't stop but it does appear to slow down at times.

The vmdk's are located on a USB3 disk and the disk performance is good
when writing to the disk itself.  I am copying one of the vmdk's to a
local disk on the server to see if the USB disk is a factor and will
advise.

When I monitor it using "atop" I can see high utilisation that seems
to swap between the physical disk and the loop device being written
to.

I am using Debian Wheezy with Kernel 3.2.0-4-amd64 and kpartx
0.4.9+git0.4dfdaf2b-6

Is this is a known limitation or something that kpartx was never
intended to support... or perhaps a bug?

Kind Regards,

James
