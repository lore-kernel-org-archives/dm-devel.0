From: Patrick Caulfield <pcaulfie@redhat.com>
Subject: Re: [PATCH] [RFC] persistent readable names
Date: Thu, 06 Oct 2005 08:07:36 +0100
Message-ID: <4344CD38.2030004@redhat.com>
References: <4343DFDC.2020701@redhat.com>
	<20051005150923.GC6195@free.fr>	<20051005180721.GA22387@us.ibm.com>	<1128547659.6140.40.camel@zezette>
	<20051005223824.GA27219@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051005223824.GA27219@us.ibm.com>
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

Patrick Mansfield wrote:

> Here is some /dev, lsscsi and scsi_id output on a SLES9 system (rpm
> udev-021-36.55). by-path is basically pci and scsi bus_id's; by-id is
> basically scsi_id plus partition output. 
> 
> [Uh oh, the by-path output looks broken! It should be scsi-1:0:0:0 pointing to sdc not scsi-0:0:0:0, but this shows the /dev structure.]
> 
> I hope this clears things up:
> 
> elm3a47:~ # ls -l /dev/disk/by-path | grep sdc
> lrwxrwxrwx  1 root root   9 Oct  5 08:18 pci-0000:01:01.1-scsi-0:0:0:0 -> ../../sdc
> lrwxrwxrwx  1 root root  10 Oct  5 08:18 pci-0000:01:01.1-scsi-0:0:0:0p1 -> ../../sdc1
> lrwxrwxrwx  1 root root  10 Oct  5 08:18 pci-0000:01:01.1-scsi-0:0:0:0p2 -> ../../sdc2
> lrwxrwxrwx  1 root root  10 Oct  5 08:18 pci-0000:01:01.1-scsi-0:0:0:0p3 -> ../../sdc3
> 
> elm3a47:~ # ls -l /dev/disk/by-id | grep sdc
> lrwxrwxrwx  1 root root   9 Oct  5 08:18 320000004cf311121 -> ../../sdc
> lrwxrwxrwx  1 root root  10 Oct  5 08:18 320000004cf311121p1 -> ../../sdc1
> lrwxrwxrwx  1 root root  10 Oct  5 08:18 320000004cf311121p2 -> ../../sdc2
> lrwxrwxrwx  1 root root  10 Oct  5 08:18 320000004cf311121p3 -> ../../sdc3
> 
> elm3a47:~ # lsscsi | grep sdc
> [1:0:0:0]    disk    IBM-ESXS ST318453FC    F  B953  /dev/sdc
> 
> elm3a47:~ # ls -l /sys/block/sdc/device
> lrwxrwxrwx  1 root root 0 Oct  5 08:18 /sys/block/sdc/device -> ../../devices/pci0000:00/0000:00:1f.0/0000:01:01.1/host1/1:0:0:0
> 
> elm3a47:~ # scsi_id -g -s /block/sdc
> 320000004cf311121
> 


Those are the names I'm trying to free people from.

OK, multipath1 - multipath5000 aren't exactly friendly (but how else are you
going to name 5000 disks - there aren't that many Simpsons characters!) but
they're are a /lot/ easier to deal with than those I can see there.

-- 

patrick
