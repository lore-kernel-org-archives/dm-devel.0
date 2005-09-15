From: gistolero@gmx.de
Subject: Re: mpath_ctl observation + some novice questions
Date: Thu, 15 Sep 2005 18:31:38 +0200
Message-ID: <4329A1EA.9040203@gmx.de>
References: <20050915132538.GA27752@locust.cns.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050915132538.GA27752@locust.cns.vt.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

> Next topic.  I'm a real dm novice user.  I have not
> figured out how to create the disk devices and lvm fs.  Is there 
> a doc on how to do this?  My guess is that I need 
> to map the wwid in multipath.conf.  Is this demonstrated
> somewhere?  Thanks.

use a test environment, no production server!


startup-configuration:

1.) load dm-mapper and HBA kernel modules


2.) create partitions on each lun (e.g.: lun0 has two paths sda and sdb - 
"fdisk sda" creates the partitions for sda _and_ sdb) - you have to do this 
step _before_ creating multipath devices (kpartx in 
/etc/dev.d/block/multipath.dev reads this partition information)


3.) create /etc/multipath.conf

- check multipath.conf.annotated and multipath.conf.synthetic in the 
multipath-tools tarball
- get lun wwid's with "scsi_id -g -u -s /block/sd?"
- create a "multipath { ... }" section for each lun (define "wwid" and "alias")
- create a "device { ... }" section for your storage (see "TestedEnvironments" 
located at the multipath-tools homepage) - set "path_grouping_policy" and 
"prio_callout" (setting "prio_callout" is important. if you choose a wrong 
value, you will see nothing after starting multipath)


4.) start multipathd (debug with "-d" or "-v4" (syslog))


5.) run "multipath /dev/sd?" for each sd? device

multipath should create device-mapper table entries (see "dmsetup table"), 
block-device-files in /dev/mapper/ and links in /dev/ for the lun and for each 
partition

e.g.: you have created two partitions and your lun alias is "yellow" (defined 
in /etc/multipath.conf):

# dmsetup table
yellow1: ...
yellow: ...
yellow2: ...

# ls /dev/mapper/
yellow yellow1 yellow2 control

# ls -F /dev/yellow*
/dev/yellow@  /dev/yellow1@  /dev/yellow2@

and check "multipath [-v3] -ll"


6.) create filesystems and mount /dev/yellow1 and /dev/yellow2


you can delete the current configuration with "dmsetup remove yellow2; dmsetup 
remove yellow1; dmsetup remove yellow"

hope that helps
simon
