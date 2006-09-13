From: Piet Delaney <piet@bluelane.com>
Subject: New LVM2/device-mapper development tarballs - works with
	kernel from Linus?
Date: Tue, 12 Sep 2006 23:10:42 -0700
Message-ID: <ee87d2$i8v$1@sea.gmane.org>
Reply-To: piet@bluelane.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
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

  I just tried dm-crypt and there appears to have been a change in the 
/dev interface. 

In 2.6.13 and linux-2.6.18 I'm seeing a /dev/device-mapper file. 

  crw-rw----  1 root root 10, 63 2006-09-12 21:33 /dev/device-mapper

Note NOT a directory.

The docs from Redhat device-mapper.0.96.03 thru device-mapper.1.02.09 all
seem to say:

   /dev/mapper was called /dev/device-mapper prior to 0.96.04.
   Consequently scripts/devmap_mknod.sh has been updated.

and seem to expect a DIRECTORY. Maybe this is a udev problem,
but I suspect it's a device-mapper problem. Perhaps I need
to go back before 0.96.03.

I'll look into the new New LVM2/device-mapper development tarballs;
my guess is it doesn't work with Linus kernel on kernel.org.

-piet
