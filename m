From: Aaron Bergstralh <bergstralh@wisc.edu>
Subject: Re: Resizing multipath maps: reload ioctl failed: Invalid
	argument
Date: Wed, 24 Oct 2007 10:50:16 -0500
Message-ID: <e3d7f74d16a4a.471f2368@wiscmail.wisc.edu>
References: <000101c81648$917e2980$cf42e3c1@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <dm-devel-bounces@redhat.com>
In-reply-to: <000101c81648$917e2980$cf42e3c1@pitagora.it>
Content-language: en
Content-disposition: inline
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

> Hi,
> I'm trying to resize a multipath map (an EMC Clariion LUN) but something
> goes wrong with ioctl call. 
> After resizing LUN by EMC Navisphere, I rescanned four paths using:
>  echo "1" > /sys/bus/scsi/drivers/sd/<h>\:<b>\:<t>\:<l>/block/device/rescan
>  ...
> I noticed (in /var/log/messages) that kernel "sees" new size only for 
> two
> paths, surely the active ones (Clariion is an active/passive array).
> Then, I trespassed LUN on the other storage processor and rescanned all
> paths a second time: all sizes was updated.
> But, re-running 'multipath -v2', I got:
>  # multipath -v 2
>  device-mapper: reload ioctl failed: Invalid argument
> I found no other way to make this work but umounting filesystem,
> deactivating LVM and ran 'multipath -f ... && multipath -v2' (and then 
> other
> regular LVM stuffs).
> OS is Red Hat 4.5.
> 
> About this, I found this message in archives:
>  http://www.redhat.com/archives/dm-devel/2007-August/msg00188.html
> 
> Is it confirmed that online resizing with multipath is impossible?
> 
> If yes, in my opinion, this is a serious limitation to a serious enterprise
> use of Linux.

I have used the following in the past when I needed to resize online. I have only tested this for the round robin selector but a similar method could also work for other selectors.

#Started with the following dm table
dmsetup table m500i_A_lun_4
0 157287936 multipath 0 0 1 1 round-robin 0 2 1 8:80 100 8:160 100

###Used the following in a script to complete the resize
dmsetup suspend m500i_A_lun_4

#Reload with one device removed and old size
dmsetup load m500i_A_lun_4 <<EOF
0 157287936 multipath 0 0 1 1 round-robin 0 1 1 8:80 100
EOF
dmsetup resume m500i_A_lun_4
dmsetup suspend m500i_A_lun_4

#Reload with one device removed for all other devices
dmsetup load m500i_A_lun_4 <<EOF
0 157287936 multipath 0 0 1 1 round-robin 0 1 1 8:160 100
EOF
dmsetup resume m500i_A_lun_4
dmsetup suspend m500i_A_lun_4

#Reload with all devices and new size
dmsetup load m500i_A_lun_4 <<EOF
0 209717248 multipath 0 0 1 1 round-robin 0 2 1 8:80 100 8:160 100
EOF
dmsetup resume m500i_A_lun_4

After the last step everything is able to see the new device size. I know this isn't an ideal solution but it might be useful for some people.

Aaron Bergstralh
