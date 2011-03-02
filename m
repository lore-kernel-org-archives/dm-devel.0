From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: Re: Dell MD3200 - sd: Current: sense key: Illegal
 Request ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
Date: Tue, 1 Mar 2011 20:35:23 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FF56B443@cosmail01.lsi.com>
References: <4D6BFCF9.4080809@cmu.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D6BFCF9.4080809@cmu.edu>
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

Charles,
   You said "The array is split into 2 virtual disk, each assigned to one of the RAID controllers".
   Did you mean you redistributed the two luns(one is owned by controller A and one by controller B)? 

   It appears that your luns are moving back and forth between two controllers.. You can try setting failback to manual(failback manual).  This is not a solution but to understand the problem.

  Are you seeing "MODE_SELECT" messages in the logs..  Can you paste snippet of log messages..
Thanks
Babu


________________________________________
From: dm-devel-bounces@redhat.com [dm-devel-bounces@redhat.com] On Behalf Of Charles Slivkoff [slivkoff@cmu.edu]
Sent: Monday, February 28, 2011 1:52 PM
To: dm-devel@redhat.com
Subject: [dm-devel] Dell MD3200 - sd: Current: sense key: Illegal Request ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1

I have a MD3200 setup with multipathd running RHEL 5.5.

The array is split into 2 virtual disk, each assigned to one of the RAID
controllers.

I believe I have the drivers setup properly, including scsi_dh_rdac.

multipath.conf has been customized by the Dell software install as follows:

blacklist {
         device {
                 vendor  "*"
                 product "Universal Xport"
         }
}
defaults {
         user_friendly_names yes
         max_fds             8192
}
devices {
         device {
                 vendor                "DELL"
                 product               "MD32xxi"
                 path_grouping_policy  group_by_prio
                 prio                  rdac
                 polling_interval      5
                 path_checker          rdac
                 path-selector         "round-robin 0"
                 hardware_handler      "1 rdac"
                 failback              immediate
                 features              "2 pg_init_retries 50"
                 no_path_retry         30
                 rr_min_io             100
                 prio_callout          "/sbin/mpath_prio_rdac /dev/%n"
         }
         device {
                 vendor                "DELL"
                 product               "MD32xx"
                 path_grouping_policy  group_by_prio
                 prio                  rdac
                 polling_interval      5
                 path_checker          rdac
                 path-selector         "round-robin 0"
                 hardware_handler      "1 rdac"
                 failback              immediate
                 features              "2 pg_init_retries 50"
                 no_path_retry         30
                 rr_min_io             100
                 prio_callout          "/sbin/mpath_prio_rdac /dev/%n"
         }
}


$ multipath -ll mpath8
mpath8 (36842b2b000528f62000005e04d25d3e7) dm-4 DELL,MD32xx
[size=20T][features=3 queue_if_no_path pg_init_retries 50][hwhandler=1
rdac][rw]
\_ round-robin 0 [prio=100][active]
  \_ 2:0:0:1  sdf 8:80  [active][ready]
\_ round-robin 0 [prio=0][enabled]
  \_ 1:0:0:1  sdc 8:32  [active][ghost]

$ multipath -ll mpath9
mpath9 (36842b2b0005294f9000005da4d25d3fb) dm-5 DELL,MD32xx
[size=20T][features=3 queue_if_no_path pg_init_retries 50][hwhandler=1
rdac][rw]
\_ round-robin 0 [prio=100][active]
  \_ 1:0:0:2  sdd 8:48  [active][ready]
\_ round-robin 0 [prio=0][enabled]
  \_ 2:0:0:2  sdg 8:96  [active][ghost]


I have LVM striping extents between these two disks. There are 4 10T
lvols, for example:

$ lvdisplay -m /dev/rmane/d01
   --- Logical volume ---
   LV Name                /dev/rmane/d01
   VG Name                rmane
   LV UUID                6sQcuN-AaG7-EaIN-njz1-LHfB-LlWk-SOfZZE
   LV Write Access        read/write
   LV Status              available
   # open                 1
   LV Size                10.00 TB
   Current LE             1311210
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     65536
   Block device           253:8

   --- Segments ---
   Logical extent 0 to 1311209:
     Type                striped
     Stripes             2
     Stripe size         8192 KB
     Stripe 0:
       Physical volume   /dev/dm-4
       Physical extents  1311210 to 1966814
     Stripe 1:
       Physical volume   /dev/dm-5
       Physical extents  1311210 to 1966814

I am using ext4 in each of the 4 lvols.

Today, I have started coping some data (about 200GB) to one of these
volumes (via rsync) and I've noticed a large number of errors from the
kernel:

Feb 28 14:24:20 rman-ss-03 kernel: FAILED
Feb 28 14:24:20 rman-ss-03 kernel:   status = 1, message = 00, host = 0,
driver = 08
Feb 28 14:24:20 rman-ss-03 kernel:   <6>sd: Current: sense key: Illegal
Request
Feb 28 14:24:20 rman-ss-03 kernel:     <<vendor>> ASC=0x94
ASCQ=0x1ASC=0x94 ASCQ=0x1

These are repeating every 1-2 seconds (a total of 2526 times) during the
111 minutes it took to complete the copy.


My best efforts of researching this error have lead me to this thread:

https://www.redhat.com/archives/dm-devel/2009-September/msg00311.html


I don't have any issues during boot and I'm not sure where to go from here.

Any suggestions would be appreciated.

Thanks,


-Charles


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
