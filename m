From: John Utz <John.Utz@wdc.com>
Subject: are the dm target ioctl handlers extensible to serving
 arbitrary configuration ioctls?
Date: Tue, 22 Jul 2014 21:35:38 +0000
Message-ID: <8A51900D08212F40B3DE22453052F69839C477D3@wdscexmb02>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

And if so, how would I connect to them from userland? 

What would be the device that i opened for reading and writing?

Based on my review of the code, it seems that these particular ioctl servicing routines are designed to service DM or block device specific ioctls and not designed to support setting or getting configuration information about the particular dm target instance.

Specifically, i wish to be able to use an ioctl to set and get the number of zones and other things in the dm-zacsim.ko that i am currently coding.

Here is the ioctl handler implementation in dm-linear.c that is an example of the ioctl handler that i am asking about:


static int linear_ioctl(struct dm_target *ti, unsigned int cmd,
117                         unsigned long arg)
118 {
119         struct linear_c *lc = (struct linear_c *) ti->private;
120         struct dm_dev *dev = lc->dev;
121         int r = 0;

              // CAN I ADD MY OWN ARBITRARY STUFF IN HERE?

122 
123         /*
124          * Only pass ioctls through if the device sizes match exactly.
125          */
126         if (lc->start ||
127             ti->len != i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT)
128                 r = scsi_verify_blk_ioctl(NULL, cmd);
129 
130         return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
131 }

tnx!

johnu
