From: "Scott Moseman" <scmoseman@gmail.com>
Subject: mapper device perms on reboot
Date: Tue, 26 Feb 2008 15:04:16 -0600
Message-ID: <342d47870802261304s54c3650dv83216abd8ffaee8f@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

How can I get the mapper device permissions set on reboot?

When I attempted to try this...

# cat /etc/udev/permissions.d/50-udev.permissions | grep mapper
mapper/mpath*:oracle:dba:0660

But it did not seem to work...

# ls -l /dev/mapper/mpath*
brw-rw----  1 root disk 253, 2 Feb 26 20:56 /dev/mapper/mpath0
brw-rw----  1 root disk 253, 5 Feb 26 20:56 /dev/mapper/mpath0p1
brw-rw----  1 root disk 253, 3 Feb 26 20:56 /dev/mapper/mpath1
brw-rw----  1 root disk 253, 4 Feb 26 20:56 /dev/mapper/mpath1p1

Am I doing something wrong?  Is there another way to do this?

Thanks,
Scott
