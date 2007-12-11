From: Dane Miller <dane@greatschools.net>
Subject: dm errors 'no longer valid device'
Date: Tue, 11 Dec 2007 10:20:16 -0800
Message-ID: <1197397216.30413.11.camel@danedesk.greatschools.net>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

I've recently started getting device mapper errors that I don't
understand while creating a LVM snapshot.  I think I blew my chance at
asking the linux-lvm list (list archives show my blunder), but this also
seems like a device mapper issue.  Apologies in advance if this is the
wrong list for such a question... I'm not really sure whom to ask.

Here are the errors.  Anyone know what's going on?

lvcreate --snapshot --name vm1optsnap --size 10G /dev/vg0/vm1opt
  /dev/dm-9: stat failed: No such file or directory
  Path /dev/dm-9 no longer valid for device(253,9)
  Aborting - please provide new pathname for what used to be /dev/dm-9
  /dev/dm-10: stat failed: No such file or directory
  Path /dev/dm-10 no longer valid for device(253,10)
  Aborting - please provide new pathname for what used to be /dev/dm-10
  /dev/dm-11: stat failed: No such file or directory
  Path /dev/dm-11 no longer valid for device(253,11)
  Aborting - please provide new pathname for what used to be /dev/dm-11
  Logical volume "vm1optsnap" created

Kernel: 2.6.9-42.0.10.ELsmp i686 athlon i386 GNU/Linux
LVM2: lvm2-2.02.21-5.el4
Device-mapper: device-mapper-1.02.17-3.0.1.el4

Thanks for any suggestions or pointers,
Dane

-- 
Dane Miller
Systems Administartor
Greatschools, Inc
http://www.greatschools.net
