From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: NIC and HBA based multipathing
Date: Thu, 15 Nov 2007 12:44:46 -0600
Message-ID: <473C939E.10609@cs.wisc.edu>
References: <20071101215726.GB11002@linux.vnet.ibm.com>	<20071106230157.GA23800@linux.vnet.ibm.com>	<342d47870711061746s64daeaa0wcb6adf060506686c@mail.gmail.com>	<20071107025935.GA22697@us.ibm.com>	<20071107050925.GA25156@linux.vnet.ibm.com>	<342d47870711070707s7ac0fca2w1fdda12fb73fc548@mail.gmail.com>	<342d47870711120954p56f41b30ob2c0956d11740244@mail.gmail.com>	<20071112201835.GB23668@linux.vnet.ibm.com>	<342d47870711121234o3aa82f95vc248308ef30097a3@mail.gmail.com>	<342d47870711130852x4352d55axd2a0759cba9aa79@mail.gmail.com>
	<342d47870711151000o8bc5e6aw31394e039370c42c@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <342d47870711151000o8bc5e6aw31394e039370c42c@mail.gmail.com>
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

Scott Moseman wrote:
> On Nov 13, 2007 10:52 AM, Scott Moseman <scmoseman@gmail.com> wrote:
>>> # ls -l /dev/sd* | grep -v sda
>>> brw-------  1 root root 8, 16 Nov  7 14:43 /dev/sdb
>>> brw-rw----  1 root disk 8, 17 Nov  7 14:43 /dev/sdb1
>>> brw-rw----  1 root disk 8, 33 Nov  7 14:45 /dev/sdc1
>> I can use 'mknod sdc b 8 32' to generate a new /dev/sdc, which I can
>> fdisk and the data looks good, but once I reboot the /dev/sdc device
>> is once again removed (or not re-created, whichever the case may be).
>>
> 
> Does anyone know why the /dev/sdc device might not get created on
> boot?  Is this something that the iSCSI initiator should handle?  The

The iscsi initiator is not responsible for creating device nodes. If you 
see this:

SCSI device sdb: 8417280 512-byte hdwr sectors (4310 MB)
SCSI device sdb: drive cache: write through
  sdb: sdb1
Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0

then the initiator and scsi layer have done everything they can.

> operating system?

It seems like a udev problem, but I do not know for sure.
