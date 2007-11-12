From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Re: NIC and HBA based multipathing
Date: Mon, 12 Nov 2007 11:54:39 -0600
Message-ID: <342d47870711120954p56f41b30ob2c0956d11740244@mail.gmail.com>
References: <342d47870710301211y42200594u444b7af7ae870e7@mail.gmail.com>
	<20071101215726.GB11002@linux.vnet.ibm.com>
	<342d47870711061308p77655083y7ac30a9e9e2a3b72@mail.gmail.com>
	<20071106222043.GA23178@linux.vnet.ibm.com>
	<342d47870711061433h6dce42baj705aca5ae7baa466@mail.gmail.com>
	<20071106230157.GA23800@linux.vnet.ibm.com>
	<342d47870711061746s64daeaa0wcb6adf060506686c@mail.gmail.com>
	<20071107025935.GA22697@us.ibm.com>
	<20071107050925.GA25156@linux.vnet.ibm.com>
	<342d47870711070707s7ac0fca2w1fdda12fb73fc548@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <342d47870711070707s7ac0fca2w1fdda12fb73fc548@mail.gmail.com>
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

On Nov 7, 2007 9:07 AM, Scott Moseman <scmoseman@gmail.com> wrote:
>
> Ok, if multipath is grabbing the HBA device so I'm unable to mount it,
> that's fine, I will go with that.  So I re-enabled the iSCSI initiator
> so that the NIC device would become active and I can see if multipath
> will grab both of them.  No luck, but I'm ahead of where I was
> previously, so here's my status.
>
> In dmesg, both of the devices are being found on boot...
>
> HBA-
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
> NIC-
>
> scsi3 : SFNet iSCSI driver
>   Vendor: EQLOGIC   Model: 100E-00           Rev: 2.3
>   Type:   Direct-Access                      ANSI SCSI revision: 05
> SCSI device sdc: 8417280 512-byte hdwr sectors (4310 MB)
> SCSI device sdc: drive cache: write through
>  sdc: sdc1
> Attached scsi disk sdc at scsi3, channel 0, id 0, lun 0
>
> # multipath -l
> 30690a018f015191a6472441d1500f057
> [size=4 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [active]
>  \_ 1:0:1:0     sdb 8:16 [active][ready]
>
> I'm attaching the output of "multipath -v4" since it's lengthy.
> There's some references to sdc (although [faulty]) that I don't
> understand, but maybe it will help troubleshoot?
>
> My multipath.conf is setup in accordance with
> http://kbase.redhat.com/faq/FAQ_51_7170.shtm .
>
> Thanks,
> Scott
>

Maybe no one wants to open my attachment, here's an abbreviated
version of the "multipath -v" output...

# multipath -v4
load path identifiers cache
#
# all paths in cache :
#
  #:#:#:#  hda 3:0  [faulty] //
30690a018f015191a6472441d1500f057  1:0:1:0 sdb 8:16  [active][ready] EQLOGIC /
  3:0:0:0 sdc 8:32  [faulty] EQLOGIC /100E-00         /2.3

Per my previous email, the "sdc" device is the iSCSI connection
through the NIC.  The HBA connection, "sdb", is working fine.

Thanks,
Scott
