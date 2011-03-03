From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: Re: Dell MD3200 - sd: Current: sense key: Illegal
 Request ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Date: Wed, 2 Mar 2011 21:32:08 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FF56B448@cosmail01.lsi.com>
References: <4D6BFCF9.4080809@cmu.edu>
	<4D6E91E7.4010305@cmu.edu>,<4D6ECAD2.4040807@cmu.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D6ECAD2.4040807@cmu.edu>
Content-Language: en-US
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
List-Id: dm-devel.ids

  I looked at your storage profile.. Noticed  that your host type setting is wrong.. See below.
  Default host OS:      Windows (Host OS index 0)                     
  Can you set it to "Linux" and see if your problem goes away. I am yet to look at messages file.. Please try this and let me know..
Thanks
Babu


________________________________________
From: dm-devel-bounces@redhat.com [dm-devel-bounces@redhat.com] On Behalf Of Charles Slivkoff [slivkoff@cmu.edu]
Sent: Wednesday, March 02, 2011 4:55 PM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] Dell MD3200 - sd: Current: sense key: Illegal Request ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1

> One of your lun seem to have a problem. See these messages below..
>
> Mar  2 12:43:14 rman-ss-03 kernel: scsi 1:0:0:0: rdac: LUN 0 (unowned)
> Mar  2 12:43:14 rman-ss-03 kernel: sd 1:0:0:1: rdac: LUN 1 (unowned)
> Mar  2 12:43:14 rman-ss-03 kernel: sd 1:0:0:2: rdac: LUN 2 (owned)
> Mar  2 12:43:14 rman-ss-03 kernel: scsi 2:0:0:0: rdac: LUN 0 (unowned)
> Mar  2 12:43:14 rman-ss-03 kernel: sd 2:0:0:1: rdac: LUN 1 (owned)
> Mar  2 12:43:14 rman-ss-03 kernel: sd 2:0:0:2: rdac: LUN 2 (unowned)
> Mar  2 12:43:14 rman-ss-03 kernel: rdac: device handler registered
 >
> Lun 0 is not owned by any of the controllers also it is not claimed
 > by sd driver for some reason.  Can you find out why that happened..
 > Or you can remove Lun 0 and see if issue goes away..

I'm not sure what 1:0:0:0 and 2:0:0:0 are or where they came from. They
show up in lsscsi but there is no sd device assigned to them, obviously.

$ lsscsi
[0:0:32:0]   enclosu DP       BACKPLANE        1.07  -
[0:2:0:0]    disk    DELL     PERC H700        2.30  /dev/sda
[0:2:1:0]    disk    DELL     PERC H700        2.30  /dev/sdb
[1:0:0:0]    disk    DELL     MD32xx           0770  -
[1:0:0:1]    disk    DELL     MD32xx           0770  /dev/sdc
[1:0:0:2]    disk    DELL     MD32xx           0770  /dev/sdd
[1:0:0:31]   disk    DELL     Universal Xport  0770  /dev/sde
[2:0:0:0]    disk    DELL     MD32xx           0770  -
[2:0:0:1]    disk    DELL     MD32xx           0770  /dev/sdf
[2:0:0:2]    disk    DELL     MD32xx           0770  /dev/sdg
[2:0:0:31]   disk    DELL     Universal Xport  0770  /dev/sdh
[3:0:0:0]    cd/dvd  TEAC     DVD-ROM DV-28SW  R.2A  /dev/scd0

These LUNs do not exist in the array configuration. I only see LUNs 1,
2, and 31.

The profile saved from my array is here:  http://tinypaste.com/73823

I added to /etc/sysctl.conf "dev.scsi.logging_level = 4096" and
rebooted. The new syslog since the boot is here: http://tinypaste.com/5b72b

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
