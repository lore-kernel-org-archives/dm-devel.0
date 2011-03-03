From: Charles Slivkoff <slivkoff@cmu.edu>
Subject: Re: Dell MD3200 - sd: Current: sense key: Illegal
 Request ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Date: Thu, 03 Mar 2011 11:14:17 -0500
Message-ID: <4D6FBE59.9040000@cmu.edu>
References: <4D6BFCF9.4080809@cmu.edu> <4D6E91E7.4010305@cmu.edu>
	<4D6ECAD2.4040807@cmu.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D6ECAD2.4040807@cmu.edu>
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

The host type for my host (rman-ss-03) was set to "Linux", BTW.

...
      STORAGE ARRAY
         Default type:                Windows

         Default Group

         Host:                        rman-ss-03
            Host type:                Linux
            Interface type:           SAS
               Host port identifier:  5a:4b:ad:b0:44:65:8e:00
               Alias:                 Port0
               Host port identifier:  5a:4b:ad:b0:44:65:60:00
               Alias:                 Port1
...

Regardless, I changed the default host type to "Linux" and rebooted.

No change in behavior. The "phantom" LUNs are still listed and the 
errors are still being logged.

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

$ tail /var/log/messages
Mar  3 11:13:48 rman-ss-03 kernel: FAILED
Mar  3 11:13:48 rman-ss-03 kernel:   status = 1, message = 00, host = 0, 
driver = 08
Mar  3 11:13:48 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal 
Request
Mar  3 11:13:48 rman-ss-03 kernel:     <<vendor>> ASC=0x94 
ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  3 11:13:48 rman-ss-03 kernel:
Mar  3 11:13:53 rman-ss-03 kernel: FAILED
Mar  3 11:13:53 rman-ss-03 kernel:   status = 1, message = 00, host = 0, 
driver = 08
Mar  3 11:13:53 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal 
Request
Mar  3 11:13:53 rman-ss-03 kernel:     <<vendor>> ASC=0x94 
ASCQ=0x1ASC=0x94 ASCQ=0x1
Mar  3 11:13:53 rman-ss-03 kernel:


> I looked at your storage profile.. Noticed  that your host type
> setting is wrong.. See below. 
 > Default host OS:      Windows (Host OS index 0)
 > Can you set it to "Linux" and see if your problem goes away.
> I am yet to look at messages file.. Please try this and let me know..
>  Thanks Babu
