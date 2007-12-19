From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Configuring multipath for root device
Date: Wed, 19 Dec 2007 13:18:13 -0800
Message-ID: <1198099093.26366.32.camel@linuxchandra>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-O7TsfdbUPhjbejz7bwYz"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
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


--=-O7TsfdbUPhjbejz7bwYz
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I am working on a multipath usage document. Attached is the installation
section of that document.

Note that it is written for RHEL5 U1 and SLES10 SP1.

Good Luck,

chandra

On Wed, 2007-12-19 at 13:02 -0800, Pradipmaya Maharana wrote:
> Hi All,
> 
> Is there a process/document that talks about how to configure
> root/boot device for multipath?
> 
> Thanks and Regards,
> Pradipmaya.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------


--=-O7TsfdbUPhjbejz7bwYz
Content-Disposition: attachment; filename=f1
Content-Type: text/plain; name=f1; charset=utf-8
Content-Transfer-Encoding: 7bit

4.1. Installation instructions for SLES10

Note: This is tested on SLES10 SP1. If you have any other version, your
mileage may vary.

   1. Install the OS in a device that has multiple paths. Make sure the
root device's "Mount by" option is set to "Device by-id" (this option is
available under "expert partitioner" as "fstab options").
   2. Complete the installation. Let the system boot up in multiuser mode.
Make sure the root device, swap device are all referenced by their by-id
device node entries instead of /dev/sd* type names. If they are not, fix
them first.
   3. Once booted, update /etc/multipath.conf If you have to make changes
to /etc/multipath.conf, make the changes.
      Note: the option "user_friendly_names" is not supported by initrd.
So, if you have user_friendly_names in your /etc/multipath.conf file,
comment it for now, you can uncomment it later.
   4. Enable multipathing by running the following commands
          * chkconfig boot.multipath on

          * chkconfig multipathd on 
   5. Add multipath module to initrd

      Edit the file /etc/sysconfig/kernel and add "dm-multipath" to
INITRD_MODULES". Note: If your storage devices needs a hardware handler,
add the corresponding module to INITRD_MODULES, in addition to
"dm-multipath". For example add "dm-rdac" and "dm-multipath" to support
IBM's DS4K storage devices
   6.  Run mkinitrd
      Note: You can uncomment the user friendly name if you have commented it above.
   7. Reboot 

The system will come up with the root disk on a multipathed device.

Note: You can switch off multipathing to the root device by adding
multipath=off to the kernel command line.

4.2. Installation instructions for RHEL5

Note: This is tested on RHEL5 U1. If you have any other version, your
mileage may vary.

   1. Start the installation with the kernel command line "linux mpath"
          * You will see multipathed devices (/dev/mapper/mpath*) as
          * installation devices. 
   2. Finish the installation.
   3. Reboot.
          * If your boot device does not need multipath.conf and does not
          * have a special hardware handler, then you are done. If you have
          * either of these, follow the steps below. 
   4. Once booted, update multipath.conf file, if needed.
   5. Run mkinitrd, if you need a hardware handler, add it to initrd with --with option.
          * # mkinitrd /boot/initrd.final.img --with=dm-rdac 
   6. Replace the initrd in your grub.conf/lilo.conf/yaboot.conf with the
newly built initrd.
   7. Reboot. 

The system will come up with the root disk on a multipathed device.

Note: You can switch off multipathing to the root device by adding
multipath=off to the kernel command line. Note: By default, RedHat disables
dm-multipath by blacklisting all devices in /etc/multipath.conf. It just
excludes your root device. If you do not see your other multipath devices
through "multipath -ll", then check and fix the blacklist in
/etc/multipath.conf

--=-O7TsfdbUPhjbejz7bwYz
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-O7TsfdbUPhjbejz7bwYz--
