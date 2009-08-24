From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Mon, 24 Aug 2009 14:43:52 -0700
Message-ID: <1251150232.24406.41.camel@chandra-ubuntu>
References: <20090823210536.4730636d@nb-jsosic>
	<20090823213448.154d6cff@nb-jsosic>
	<Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
	<20090824202915.27815959@pc-jsosic.srce.hr>
	<1251139716.24406.4.camel@chandra-ubuntu>
	<20090824205933.4b4c8456@pc-jsosic.srce.hr>
	<1251145497.24406.18.camel@chandra-ubuntu>
	<20090824223627.6e1a918c@pc-jsosic.srce.hr>
	<1251147451.24406.28.camel@chandra-ubuntu>
	<20090824231923.4b7b8396@pc-jsosic.srce.hr>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090824231923.4b7b8396@pc-jsosic.srce.hr>
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


On Mon, 2009-08-24 at 23:19 +0200, Jakov Sosic wrote:
> On Mon, 24 Aug 2009 13:57:31 -0700
> Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> 
> Also from the dmesg - if it helps:
> 
> 
> device-mapper: table: 253:0: multipath: error getting device
> device-mapper: ioctl: error adding target to table
> device-mapper: table: 253:0: multipath: error getting device
> device-mapper: ioctl: error adding target to table

Above message is most likely from your root disk (it is a scsi disk,
right ?).

You can avoid getting this by adding a blacklist in your multipath.conf
file.
> rdac: device handler registered
> device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for
> failover/failback and device management.
> sd 1:0:1:0: rdac: LUN 0 (owned)
> sd 1:0:0:0: rdac: LUN 0 (unowned)
> device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for
> failover/failback and device management.
> sd 1:0:1:1: rdac: LUN 1 (owned)
> sd 1:0:0:1: rdac: LUN 1 (unowned)
> device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for
> failover/failback and device management.
> sd 1:0:0:2: rdac: LUN 2 (owned)
> sd 1:0:1:2: rdac: LUN 2 (unowned)

These are good.
> 
> 
> 
> 
