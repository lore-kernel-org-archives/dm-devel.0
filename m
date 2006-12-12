From: Hadders <dmraid@workingwithit.com>
Subject: newbie:  Target Length not divisble error
Date: Tue, 12 Dec 2006 22:21:11 +0800
Message-ID: <457EBAD7.1020708@workingwithit.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi all,
  I'm new to trying to get my Intel SATA RAID 0 container working.  I 
want to use the "hardware" mode as oppossed to software RAID so I can 
share it with my Windows setups.
I've just spent the last three days banging my head against a brick wall.
In short, I'm using FC5 and am looking to get the latest kernel, 
2.6.18-1.2239.fc5smp working with this container.  I don't understand 
why it doesn't, the base FC5 kernel does.
I've just got my SATAII disks and setup the container in the Intel BIOS. 
I've installed FC5 from scratch and used anaconda to setup the partitions.
When I reboot into my new kernel, I get an error when it tries to 
activate the container,  that is

device-mapper: table: 253:0 striped: Target length not divisble by chunk 
size

then I get growled at for using parted and not knowing what I'm doing. I 
didn't! honest, I used anaconda.
the lines for setting up the container in the init file of the initrd are
rmparts sdb
rmparts sda
dm create isw_cdgbeijgjh_iaa 0 1250275846 striped 2 256 8:0 8:16 0
dm partadd isw_cdgbeijgjh_iaa

Here's the details of my setup that I can access under 2.6.15-1.2054 
(base FC5) kernel

dmraid -V
dmraid version:        1.0.0.rc11 (2006.05.15) debug
dmraid library version:    1.0.0.rc11 (2006.05.15)
device-mapper version:    4.5.0

dmraid -rD
/dev/sda: isw, "isw_cdgbeijgjh", GROUP, ok, 625142446 sectors, data@ 0
/dev/sdb: isw, "isw_cdgbeijgjh", GROUP, ok, 625142446 sectors, data@ 0

dmraid -s -g
*** Superset
name   : isw_cdgbeijgjh
size   : 1250284892
stride : 0
type   : GROUP
status : ok
subsets: 1
devs   : 2
spares : 0
--> Active Subset
name   : isw_cdgbeijgjh_iaa
size   : 1250275840
stride : 256
type   : stripe
status : ok
subsets: 0
devs   : 2
spares : 0

dmsetup status
isw_cdgbeijgjh_iaap6: 0 4498137 linear
isw_cdgbeijgjh_iaap5: 0 204796557 linear
isw_cdgbeijgjh_iaa: 0 1250275846 striped
isw_cdgbeijgjh_iaap4: 0 1044947925 linear
isw_cdgbeijgjh_iaap3: 0 102398310 linear
isw_cdgbeijgjh_iaap2: 0 102398310 linear
isw_cdgbeijgjh_iaap1: 0 530082 linear

I think the 18-1 kernel uses device-mapper v4.7

However, I'm lost as to what to do now. Help! Please!

Thanks in advance. Hadley
