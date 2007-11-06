From: malahal@us.ibm.com
Subject: Re: NIC and HBA based multipathing
Date: Tue, 6 Nov 2007 14:54:13 -0800
Message-ID: <20071106225413.GB5668@us.ibm.com>
References: <342d47870710300956k3bde2d06j7a50acc6c8225fe5@mail.gmail.com>
	<5fb0f77b0710301040l4eeca0a7n2ccdc00b14285294@mail.gmail.com>
	<342d47870710301211y42200594u444b7af7ae870e7@mail.gmail.com>
	<472A2EA5.8050609@cs.wisc.edu>
	<342d47870711011321j1ff065c3jb54589988f3c499f@mail.gmail.com>
	<20071101215726.GB11002@linux.vnet.ibm.com>
	<342d47870711061308p77655083y7ac30a9e9e2a3b72@mail.gmail.com>
	<20071106222043.GA23178@linux.vnet.ibm.com>
	<342d47870711061433h6dce42baj705aca5ae7baa466@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <342d47870711061433h6dce42baj705aca5ae7baa466@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Scott Moseman <scmoseman@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Scott Moseman [scmoseman@gmail.com] wrote:
> qla4xxx 0000:14:01.1: scsi(1:0:1:0): Enabled tagged queuing, queue depth 32.
> SCSI device sdb: 8417280 512-byte hdwr sectors (4310 MB)
> SCSI device sdb: drive cache: write through
>  sdb: sdb1
> Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0
> 
> I can fdisk the /dev/sdb drive and it's the SAN partition alright.

As Mike pointed out, quite likely that someone has claimed /dev/sdb1.
Maybe, lvm, evms, dmraid, ...etc. You will have to find out who claimed
it by running commands from lvm/evms/etc... OR if you don't have useful
data on it, simple zero few MB at the beginning and the end of the
partition and reboot. It may work. I am assuming that /sanHBA is not
used by anyone either (like CD'ing into it and then trying to mount).

Helpful commands: fuser -m /dev/sdb1; dd if=/dev/zero of=/dev/sdb1
count=1 bs=1M
