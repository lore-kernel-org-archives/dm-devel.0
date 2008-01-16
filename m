From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Configuring multipath for root device
Date: Wed, 16 Jan 2008 10:49:31 -0800
Message-ID: <110b17190801161049o127a22edq1888f9184156b52@mail.gmail.com>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
	<1198099093.26366.32.camel@linuxchandra>
	<110b17190801071219k11749b81n45a7d1d5d35b9413@mail.gmail.com>
	<4783239C.7020206@suse.de>
	<110b17190801151825ofd63e20yd9d4f01be7b67407@mail.gmail.com>
	<20080116173649.GA30593@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080116173649.GA30593@us.ibm.com>
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

Here are some details:

linux-qeh4:~ # ls -al /dev/disk/by-id/
total 0
drwxr-xr-x 2 root root 180 Jan 16 10:39 .
drwxr-xr-x 5 root root 100 Jan 16 10:12 ..
lrwxrwxrwx 1 root root   9 Jan 16 10:12 edd-int13_dev80 -> ../../sda
lrwxrwxrwx 1 root root  10 Jan 16 10:12 edd-int13_dev80-part1 -> ../../sda1
lrwxrwxrwx 1 root root  10 Jan 16 10:12 edd-int13_dev80-part2 -> ../../sda2
lrwxrwxrwx 1 root root   9 Jan 16 10:12 scsi-222f2000155c11879 -> ../../sdb
lrwxrwxrwx 1 root root  10 Jan 16 10:12 scsi-222f2000155c11879-part1
-> ../../sda1
lrwxrwxrwx 1 root root  10 Jan 16 10:12 scsi-222f2000155c11879-part2
-> ../../sda2
linux-qeh4:~ #
linux-qeh4:~ #
linux-qeh4:~ # cat /etc/fstab
/dev/system/root     /                    reiserfs   acl,user_xattr        1 1
/dev/sda1            /boot                ext2       acl,user_xattr        1 2
/dev/system/swap     swap                 swap       defaults              0 0
proc                 /proc                proc       defaults              0 0
sysfs                /sys                 sysfs      noauto                0 0
debugfs              /sys/kernel/debug    debugfs    noauto                0 0
usbfs                /proc/bus/usb        usbfs      noauto                0 0
devpts               /dev/pts             devpts     mode=0620,gid=5       0 0
linux-qeh4:~ #
linux-qeh4:~ #
linux-qeh4:~ # uname -a
Linux linux-qeh4 2.6.16.46-0.12-smp #1 SMP Thu May 17 14:00:09 UTC
2007 i686 i686 i386 GNU/Linux
linux-qeh4:~ #
linux-qeh4:~ # mount
/dev/mapper/system-root on / type reiserfs (rw,acl,user_xattr)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
debugfs on /sys/kernel/debug type debugfs (rw)
udev on /dev type tmpfs (rw)
devpts on /dev/pts type devpts (rw,mode=0620,gid=5)
/dev/sda1 on /boot type ext2 (rw,acl,user_xattr)
securityfs on /sys/kernel/security type securityfs (rw)

Let me know if you need any other information.

Malahal, are you saying that I should mount the "/" and "swap" by
volume label and it should be able to boot fine?

Thanks and Regards,
Pradipmaya.



On Jan 16, 2008 9:36 AM,  <malahal@us.ibm.com> wrote:
> Pradipmaya Maharana [pradipmaya@gmail.com] wrote:
> > Hi All,
> >
> > Thanks for all your comments, it worked for installaions on partitions.
> >
> > Now the question is:
> > Is it supposed to work the same way if the SLES is installed on LVM?
>
> Hmmm, I don't know if LVM devices have by-id names. I never installed
> SLES on LVM with multipath. Label is your best friend with LVM and that
> is what RHEL uses, I believe.
>
> > On SLES, under fstab, I do not see any device, except for the boot
> > device; other entries does not have /dev/deisk mention. In such
> > scenario, how am I supposed to make the /root device multipath-aware?
>
> They probably have labels???
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
