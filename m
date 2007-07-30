From: "Adrian B" <adriab@gmail.com>
Subject: very slow dm-crypt write operation
Date: Mon, 30 Jul 2007 07:58:36 -0700
Message-ID: <9d8ecb6c0707300758s59f335b1k4010f7664a3c6340@mail.gmail.com>
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

Hi,

  I am seeing very slow dm-crypt writes on a machine where CPU, disk
speed and even dm-crypt reads are normal.
  It appears that kcryptd is scheduled insufficiently on the CPU(s)
when writing to dm-crypt devices. While reading, kcryptd is taking a
lot of CPU time, most of the time (top). But when writing, kcryptd is
taking a lot of pauses - I see intermittent activity where it uses the
CPU for a few seconds, then pauses for a long time, then it's up
again.
  Any idea what's going on?

  Writing a 1 GB file to dm-crypt takes 5 min (!):

time cp /tmp/1GB_File /mnt/dm-crypt/tmp/

real    5m21.123s
user    0m0.119s
sys     0m7.762s

  Reading the same 1 GB file back from dm-crypt takes only 1.5 min:

time cp /mnt/dm-crypt/tmp/1GB_File /tmp

real    1m30.147s
user    0m0.125s
sys     0m7.522s

  Copying the file without dm-crypt takes about 1 min:

time cp /tmp/1GB_File /tmp/Copy01

real    1m12.334s
user    0m0.090s
sys     0m5.856s

  This is Fedora 7, kernel 2.6.22.1-33.fc7 #1 SMP Mon Jul 23 17:33:07
EDT 2007 i686 i686 i386 GNU/Linux.
  Hardware is Intel 865G chipset, Pentium 4 CPU (HT), 2 GB RAM, ATA drive udma5.

  Thank you.
