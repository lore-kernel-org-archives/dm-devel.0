From: John Little <jslittl@hendricks.org>
Subject: Re: Multipath and SAN Fabric failover
Date: Fri, 8 Sep 2006 11:32:32 -0400
Message-ID: <20060908113232.214106b1@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Bernd

I commented out everything including the blacklist in the multipath.conf as you suggested.  When I unplug the fc cable from fabric a the filesystem goes into read only mode.  multipath -v2 -d shows the same errors previously noted.  After rebooting I unplugged the fc cable from fabric b.  The file system properly stays in read\write mode.

Just to make sure that I've covered everything I partitioned the disk as /dev/sdc and then used lvm2 command: pvcreate /dev/disk/by-name/capsprod-part1 to initialize and use the partition with lvm.

I found the following error in dmesg:

device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-devel@redhat.com
dm-netlink version 0.0.2 loaded
device-mapper: dm-multipath version 1.0.4 loaded
device-mapper: dm-round-robin version 1.0.0 loaded
device-mapper: dm-multipath: error getting device<====error
device-mapper: error adding target to table<====error
device-mapper: dm-emc version 0.0.3 loaded
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: long trespass command will be send
device-mapper: dm-emc: emc_pg_init: sending switch-over command
device-mapper: dm-emc: honor reservation bit will not be set (default)
device-mapper: dm-emc: emc_pg_init: sending switch-over command

Can you give me an idea of what else to check?  I'm nowhere near an expert on this subject as just about everything I've learned has been from reading this list.  

A couple  of questions come to mind:
Is the lun not properly trespassing  from fabric a to fabric b?
Where does the directive [features=1 queue_if_no_path] come from when
running multipath -v2 -d?  Could this be the problem?

Thanks,

John


>Heya,


>I think you should just try an empty multipath.conf, only put the blacklist in. The EMC CX needs pp_emc as prio callout for example. The defaults within >multipath should just work. Also make sure your failovermode and arraycommpath are both set to 1. A few hints are mentioned on >http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=TestedEnvironments

>Please fill in if you find something that's missing there.

>Best regards,

>Bernd Zeimetz


>>John Little wrote:

>>    Hi all,

>>    I am trying to setup our server so that we have fabric failover from
 >>   the san.  However my file sytem comes up read-only when I pull a cable
 >>  for testing.

>>    I am using the following:
>>    SLES 10
>>    multipath-tools-0.4.6-25.8
>>    q-logic 2342 dual port hba
>>    emc cx600 san
>>    (4) McData DS-24 switches (2 for fabric a and 2 for fabric b)
