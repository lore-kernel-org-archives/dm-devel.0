From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: NIC and HBA based multipathing
Date: Tue, 6 Nov 2007 15:01:57 -0800
Message-ID: <20071106230157.GA23800@linux.vnet.ibm.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Scott Moseman <scmoseman@gmail.com> wrote:
> On Nov 6, 2007 4:20 PM, Mike Anderson <andmike@linux.vnet.ibm.com> wrote:
> >
> > > # mount /dev/sdb1 /sanHBA
> > > mount: /dev/sdb1 already mounted or /sanHBA busy
> >
> > It appears something else has claimed the device prior to your mount call.
> >         - Is it lvm? Run pvs and see if the device was claimed. If that is
> >           not what you want you may need to use the lvm.conf filters.
> >
> 
> Here's what's in dmesg...
> 
> scsi1 : qla4xxx
>  QLogic iSCSI HBA Driver version: 5.01.00.08
>   QLogic ISP4032 @ 0000:14:01.1 hdma+, host#=1, fw=03.00.01.24
>   Vendor: EQLOGIC   Model: 100E-00           Rev: 2.3
>   Type:   Direct-Access                      ANSI SCSI revision: 05
> qla4xxx 0000:14:01.1: scsi(1:0:1:0): Enabled tagged queuing, queue depth 32.
> SCSI device sdb: 8417280 512-byte hdwr sectors (4310 MB)
> SCSI device sdb: drive cache: write through
>  sdb: sdb1
> Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0
> 
> I can fdisk the /dev/sdb drive and it's the SAN partition alright.

Are there any dm messages in the dmesg output? 

Are you sure dm multipath did not grab the device(s) on boot?

What is the output of multipath -l?

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
