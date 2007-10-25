From: "Domenico Viggiani" <dviggiani@tiscali.it>
Subject: RE: RE: Resizing multipath maps: reload ioctl
	failed:Invalidargument
Date: Thu, 25 Oct 2007 17:41:11 +0200
Message-ID: <000101c8171d$784fdf50$cf42e3c1@pitagora.it>
References: <000101c81648$917e2980$cf42e3c1@pitagora.it><e3d7f74d16a4a.471f2368@wiscmail.wisc.edu><000001c816f8$90a96460$cf42e3c1@pitagora.it>
	<e52e9cf62b8b.47206a5a@wiscmail.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e52e9cf62b8b.47206a5a@wiscmail.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

> -----Original Message-----
> From: dm-devel-bounces@redhat.com 
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Aaron Bergstralh
> Sent: Thursday, October 25, 2007 5:05 PM
> ...
> If you don't know your new size you can grab it from one of 
> the devices with blockdev: /sbin/blockdev --getsize /dev/sdb 
> 

"/sbin/blockdev --getsize /dev/sdb" gives old size :-( even if I rescanned
SCSI devices with "echo "1" >
/sys/bus/scsi/drivers/sd/<SCSI-ID>/block/device/rescan" for all 4 paths and
verified in /var/log/messages that kernel sees new size.
Thus latest load fails with usual error (ioctl).

--
DV
