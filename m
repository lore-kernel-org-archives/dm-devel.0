From: "ted creedon" <tcreedon@easystreet.com>
Subject: RE: (no subject)
Date: Fri, 15 Sep 2006 12:36:16 -0700
Message-ID: <026401c6d8fe$380a4dd0$aa01010a@teddoris.fam>
References: <4509D246.7010803@us.ibm.com>
Reply-To: tcreedon@easystreet.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4509D246.7010803@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'Darrick J. Wong'" <djwong@us.ibm.com>, 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

For what its worth, using SuSE 10.1

1. Set up e Nvidia SATA raids in the bios slots 2 and 3 in the controller,
slot 1 is linux
2. Devices look like /dev/sdb1 /dev/sdc1 on boot
3. run YaST it detects /dev/sdb and sdc as raid
4. use YaST partitioner to make /dev/md0 a mirror raid for sdb and sdc
5. /dev/sdb1 and /dev/sdc1 disappear and are replaced with /dev/md0

tedc

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On
Behalf Of Darrick J. Wong
Sent: Thursday, September 14, 2006 3:06 PM
To: device-mapper development
Subject: Re: [dm-devel] (no subject)

Mr. Kirk,

> Sounds like dmraid is grabbing them.  I'm not sure where the configuration
for
> dmraid is, but that's a starting point.

I think FC5 runs "dmraid -ay" automatically, which probes disks and sets
up device-mapper configurations.  However, to ensure that this is really
dmraid's fault, could you post the output of "dmsetup table" after you
boot the system (and before you blow away the dm devices, obviously)?

If it _is_ dmraid, then you'll want to clean out any RAID configurations
in the SATA BIOS, and/or run dmraid -E /dev/sdX to remove the dmraid
configuration data.

Thanks,

--Darrick


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
