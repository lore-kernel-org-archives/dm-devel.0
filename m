From: "Ronei Kliemann" <Ronei@tscom.com.br>
Subject: Problem with HP 110 G5
Date: Fri, 5 Feb 2010 14:03:46 -0200
Message-ID: <766AD601A3F2BC4BB5C12D5CC0678B061467DF@tecsystem.TecSystem.local>
References: <886648DFAE0D42CC97560EF58E589076@TecSystem.local>
Reply-To: Ronei@tscom.com.br, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <886648DFAE0D42CC97560EF58E589076@TecSystem.local>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Lucca

Thanks' for reply.

[Backup_DrClin /]# modprobe dm-mirror
[Backup_DrClin /]# modprobe dm-mirror
[Backup_DrClin /]# modprobe -l dm-mirror
/lib/modules/2.6.18-128.1.10.el5/kernel/drivers/md/dm-mirror.ko
[Backup_DrClin /]# modprobe -v dm-mirror
[Backup_DrClin /]# dmraid -ay
RAID set "ddf1_Raid_1_Mirror" was not activated
ERROR: device "ddf1_Raid_1_Mirror" could not be found





Message: 6
Date: Thu, 4 Feb 2010 08:09:47 +0100
From: Luca Berra <bluca@comedia.it>
To: dm-devel@redhat.com
Subject: Re: [dm-devel] Problem with HP - ML 110 G5
Message-ID: <20100204070947.GA29619@maude.comedia.it>
Content-Type: text/plain; charset=iso-8859-1; format=flowed

On Wed, Feb 03, 2010 at 05:12:38PM -0200, Ronei Kliemann wrote:
>Feb  3 08:31:35 Backup_DrClin kernel: device-mapper: table: 253:0:
mirror: Device lookup failure
>
>Feb  3 08:31:35 Backup_DrClin kernel: device-mapper: ioctl: error
adding target to table
>
>Feb  3 08:31:35 Backup_DrClin kernel: device-mapper: ioctl: device
doesn't appear to be in the dev hash table.

modprobe dm-mirror?

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL

Ronei Kliemann
Tec System Sistemas Eletronicos LTDA
Fone/Fax: 55 51 3599 1191 (Ramal 23) / Fone: 55 51 2108 0721 / Fone: 55
51 9259 5361
Celular:. 55 51 9127 3588 
VoIP Tellfree: 782 1191 / DDR - 780 3191
E-mail: ronei@tscom.com.br
Site: www.tscom.com.br 
Msn: kronei@hotmail.com (apenas para - Chat)
 

Message: 3
Date: Wed, 3 Feb 2010 17:12:38 -0200
From: "Ronei Kliemann" <Ronei@tscom.com.br>
To: <dm-devel@redhat.com>
Subject: [dm-devel] Problem with HP - ML 110 G5
Message-ID:
	
<766AD601A3F2BC4BB5C12D5CC0678B0614679E@tecsystem.TecSystem.local>
Content-Type: text/plain; charset="iso-8859-1"

Hi

 

I am with one problem that I couldn't find solution at the intenet. 

 

My server is HP ML 110 G5 with Embedded Raid. By lspci , I can see that
it's a  "RAID bus controller: Intel Corporation 82801 SATA RAID
Controller (rev 02)". I am using centos 5

 

I can see that RAID is not working because there isn?t volume at
/dev/mapper/, just "control".

 

"[Backup_DrClin ~]# cd /dev/mapper/

[Backup_DrClin mapper]# ls

control

[Backup_DrClin mapper]#"

 

 

The device mapper was load at boot:

 

 

[Backup_DrClin log]# grep device-mapper dmesg

device-mapper: uevent: version 1.0.3

device-mapper: ioctl: 4.11.5-ioctl (2007-12-12) initialised:
dm-devel@redhat.com

device-mapper: multipath: version 1.0.5 loaded

[Backup_DrClin log]#

 

 

I Try to activate dmraid, but no work:

 

[Backup_DrClin mapper]# dmraid -ay

RAID set "ddf1_Raid_1_Mirror" was not activated

ERROR: device "ddf1_Raid_1_Mirror" could not be found

[Backup_DrClin mapper]#

 

I can see at logs : (/var/log/messages

 

Feb  3 08:31:35 Backup_DrClin kernel: device-mapper: table: 253:0:
mirror: Device lookup failure

Feb  3 08:31:35 Backup_DrClin kernel: device-mapper: ioctl: error adding
target to table

Feb  3 08:31:35 Backup_DrClin kernel: device-mapper: ioctl: device
doesn't appear to be in the dev hash table.

 

 

 

More info:

 

[Backup_DrClin log]# dmraid -s

*** Group superset .ddf1_disks

--> Subset

name   : ddf1_Raid_1_Mirror

size   : 312237824

stride : 128

type   : mirror

status : ok

subsets: 0

devs   : 2

spares : 0

[Backup_DrClin log]#

 

[Backup_DrClin log]# dmraid -r

/dev/sda: ddf1, ".ddf1_disks", GROUP, ok, 312237856 sectors, data@ 0

/dev/sdb: ddf1, ".ddf1_disks", GROUP, ok, 312237856 sectors, data@ 0

[Backup_DrClin log]#

 

 

[Backup_DrClin mapper]# dmraid -rD -d -d -d -v -v -v

WARN: locking /var/lock/dmraid/.lock

NOTICE: /dev/sda: asr     discovering

NOTICE: /dev/sda: ddf1    discovering

NOTICE: creating directory dmraid.ddf1

NOTICE: writing metadata file "sda.dat"

NOTICE: writing offset to file "sda.offset"

NOTICE: writing size to file "sda.size"

NOTICE: /dev/sda: ddf1 metadata discovered

NOTICE: /dev/sda: hpt37x  discovering

NOTICE: /dev/sda: hpt45x  discovering

NOTICE: /dev/sda: isw     discovering

NOTICE: /dev/sda: jmicron discovering

NOTICE: /dev/sda: lsi     discovering

NOTICE: /dev/sda: nvidia  discovering

NOTICE: /dev/sda: pdc     discovering

NOTICE: /dev/sda: sil     discovering

NOTICE: /dev/sda: via     discovering

NOTICE: /dev/sdb: asr     discovering

NOTICE: /dev/sdb: ddf1    discovering

NOTICE: writing metadata file "sdb.dat"

NOTICE: writing offset to file "sdb.offset"

NOTICE: writing size to file "sdb.size"

NOTICE: /dev/sdb: ddf1 metadata discovered

NOTICE: /dev/sdb: hpt37x  discovering

NOTICE: /dev/sdb: hpt45x  discovering

NOTICE: /dev/sdb: isw     discovering

NOTICE: /dev/sdb: jmicron discovering

NOTICE: /dev/sdb: lsi     discovering

NOTICE: /dev/sdb: nvidia  discovering

NOTICE: /dev/sdb: pdc     discovering

NOTICE: /dev/sdb: sil     discovering

NOTICE: /dev/sdb: via     discovering

NOTICE: /dev/sdc: asr     discovering

NOTICE: /dev/sdc: ddf1    discovering

NOTICE: /dev/sdc: hpt37x  discovering

NOTICE: /dev/sdc: hpt45x  discovering

NOTICE: /dev/sdc: isw     discovering

NOTICE: /dev/sdc: jmicron discovering

NOTICE: /dev/sdc: lsi     discovering

NOTICE: /dev/sdc: nvidia  discovering

NOTICE: /dev/sdc: pdc     discovering

NOTICE: /dev/sdc: sil     discovering

NOTICE: /dev/sdc: via     discovering

INFO: RAID devices discovered:

 

/dev/sda: ddf1, ".ddf1_disks", GROUP, ok, 312237856 sectors, data@ 0

/dev/sdb: ddf1, ".ddf1_disks", GROUP, ok, 312237856 sectors, data@ 0

WARN: unlocking /var/lock/dmraid/.lock

[Backup_DrClin mapper]#

 

[Backup_DrClin /]# yum list dmraid*

Loading "installonlyn" plugin

Setting up repositories

Reading repository metadata in from local files

Excluding Packages from CentOS-5 - Base

Finished

Excluding Packages from CentOS-5 - Updates

Finished

Excluding Packages from CentOS-5 - Addons

Finished

Excluding Packages from CentOS-5 - Extras

Finished

Installed Packages

dmraid.i386                              1.0.0.rc13-53.el5
installed

dmraid-events.i386                       1.0.0.rc13-53.el5
installed

Available Packages

dmraid-devel.i386                        1.0.0.rc13-53.el5      base

dmraid-events-logwatch.i386              1.0.0.rc13-53.el5      base

[Backup_DrClin /]#

 

Could someone help me? I guess that must be a Bug !

 

Thank?s

 

 

Ronei Kliemann

Tec System Sistemas Eletronicos LTDA

Fone/Fax: 55 51 3599 1191 (Ramal 23) / Fone: 55 51 2108 0721 / Fone: 55
51 9259 5361

Celular:. 55 51 9127 3588 

VoIP Tellfree: 782 1191 / DDR - 780 3191

E-mail: ronei@tscom.com.br

Site: www.tscom.com.br 

Msn: kronei@hotmail.com (apenas para - Chat)
