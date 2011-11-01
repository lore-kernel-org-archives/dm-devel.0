From: Milan Broz <mbroz@redhat.com>
Subject: Re: creating two device mapper files for an underline
 blockdevice
Date: Tue, 01 Nov 2011 09:31:54 +0100
Message-ID: <4EAFAE7A.7060000@redhat.com>
References: <CABMcfaMVsagfFdtg+f1eYR501wWSMbxsEAHTYD_5MTF1bABu0A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABMcfaMVsagfFdtg+f1eYR501wWSMbxsEAHTYD_5MTF1bABu0A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Sanjana Shari <sanjana.linux@gmail.com>
List-Id: dm-devel.ids

On 11/01/2011 07:08 AM, Sanjana Shari wrote:

> But if I use the other part of the disk to map. The command is not successful
> 
> [root@bladelinux01 root]#  dmsetup create half1 --table "102401 102399 linear /dev/loop0 102400"
> device-mapper: reload ioctl failed: Invalid argument
> Command failed

You have to always map the whole table (starting at sector 0).
If you see syslog, you can see why
  device-mapper: table: 254:2: linear: Gap in table
  device-mapper: ioctl: error adding target to table

Anyway, for the info how it works, example how to switch active table:

1. create linear device mapped to /dev/sdb

  # dmsetup create x --table "0 10000 linear /dev/sdb 0"
  # dmsetup table x
  0 10000 linear 8:16 0

2. Remap the first half of device to another target, here "error"

 - load new (yet inactive) table
 # echo -e "0 5000 error\n5000 10000 linear /dev/sdb 5000" | dmsetup load x                                      

 - so now you have one active table and one inactive (prepared for switch)
 # dmsetup table x
 0 10000 linear 8:16 0

 # dmsetup table x --inactive
 0 5000 error 
 5000 10000 linear 8:16 5000

3. switch to new (inactive) table (note that "dmsetup suspend" here is implicit)
  # dmsetup resume x

  # dmsetup table x
  0 5000 error 
  5000 10000 linear 8:16 5000


If you want more info about this low level DM operation, read
http://people.redhat.com/agk/talks/FOSDEM_2005/
http://mbroz.fedorapeople.org/talks/DeviceMapperBasics/
(old, but still useful, I hope :-)

Milan
