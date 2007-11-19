From: Tore Anderson <tore@linpro.no>
Subject: Re: Use LVM on /dev/mapper/diskname
Date: Mon, 19 Nov 2007 15:06:12 +0100
Message-ID: <47419854.2000508@linpro.no>
References: <1195480602.6074.3.camel@sanderbal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1195480602.6074.3.camel@sanderbal>
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

* S. J. van Harmelen

> I have a couple of LUN's that are handled by the multipath driver.
> This works great, but now I want to use LVM so I can take snapshots
> of one LUN to another LUN.
> 
> Can someone tell me how to do this?
> 
> When I do pvcreate /dev/mapper/diskname I get an error that the disk
> is already part of an volume group. But I sertainly did not configure
> that.
> 
> Can it be that the multipath driver of devmapper did that?

If you have a PV signature on the volume, LVM might have used one of the
paths instead of using the multipath'ed device under /dev/mapper.  You
should be able to check this by running the command "pvs" - it should
list all the detected PVs on your system.

If this was the problem, you can avoid it by instructing LVM to not scan
SCSI devices directly, by adding a line in /etc/lvm/lvm.conf like this:

device {
  filter = [ "a|^/dev/mapper/.*|", "r|.*|" ]
}

This will make LVM only look at devices in /dev/mapper/ as possible PV
candidates, ignoring all other devices.  Beware if you have a PV on the
internal drives though, you might want to have something like this
instead in that case (if that PV is on /dev/sda2, for instance):

  filter = [ "a|^/dev/mapper/.*|", "a|^/dev/sda2$|", "r|.*|" ]

Make sure lvm.conf makes its way into the initramfs if you start the LVM
stuff there.  I know Ubuntu doesn't include this file by default, at least.

Regards
-- 
Tore Anderson
