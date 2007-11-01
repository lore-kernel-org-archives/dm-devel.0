From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: NIC and HBA based multipathing
Date: Thu, 01 Nov 2007 14:53:09 -0500
Message-ID: <472A2EA5.8050609@cs.wisc.edu>
References: <342d47870710300956k3bde2d06j7a50acc6c8225fe5@mail.gmail.com>	<5fb0f77b0710301040l4eeca0a7n2ccdc00b14285294@mail.gmail.com>
	<342d47870710301211y42200594u444b7af7ae870e7@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <342d47870710301211y42200594u444b7af7ae870e7@mail.gmail.com>
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
> Thanks for the follow-up.  I have each initiator setup with access to
> the SAN.  The NIC is accessing /dev/sdb and the HBA is accessing
> /dev/sdc.  I can mount either (or both) and access the data on the SAN
> volume.

Yeah, the iscsi bits looks fine. You will have a /dev/sdX for the nic 
and one of the HBA.

When you start multipath, multipath should then create one multipath 
device from those two scsi ones.

> 
> # rpm -qa | grep multipath
> device-mapper-multipath-0.4.5-16.1.RHEL4
> 
> # /etc/init.d/multipathd status
> multipathd (pid 15929) is running...
> 
> I'm following the instructions on Red Hat's KB to setup the
> multipath.conf file.  The modprobes were successful, the service
> started, but...
> 
> # multipath -v2
> error calling out /sbin/scsi_id -g -u -s /block/sda
> 
> ...with /dev/sda being my physical hard drive.  dmesg output says:
> 
> device-mapper: dm-multipath: error getting device
> device-mapper: error adding target to table

So are you asking about the errors from /dev/sda being accessed by 
multipath, or are you looking for help on adding the iscsi disks to a 
multipath device or both :)
