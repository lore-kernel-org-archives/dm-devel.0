From: Mark Huth <mhuth@redhat.com>
Subject: dm-linear error: Device lookup failed
Date: Tue, 23 May 2006 08:57:45 +1000
Message-ID: <1148338665.1812.16.camel@solid.brisbane.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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

Hi,
I am encountering the following error/message whilst the machine is
booting up:

kernel: device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-
devel@redhat.com
kernel: device-mapper: dm-linear: Device lookup failed
kernel: device-mapper: error adding target to table
kernel: device-mapper: dm-linear: Device lookup failed
kernel: device-mapper: error adding target to table
kernel: cdrom: open failed.
last message repeated 2 times

I am not using LVM (just a bunch of raid0 partitions) so it seems that
this error is more informational rather than a sign of possible
problems, and the system seems to otherwise be functioning normally.  So
I was wondering if anyone on this list can confirm that it is nothing to
worry about and if there a way to make the system happy to prevent this
message from showing up.  I am using RHEL4U3 (kernel 2.6.9-34.EL).

Thanks,
Mark
