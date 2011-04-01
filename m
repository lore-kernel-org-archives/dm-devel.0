From: Dharmesh Kamdar <kamdard71@yahoo.com>
Subject: multipath -ll output discrepancy for IBM 1818 on SLES 11
	SP1....
Date: Fri, 1 Apr 2011 07:31:30 -0700 (PDT)
Message-ID: <889038.49843.qm@web112308.mail.gq1.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Hi,

We have a SLES 11 SP1 running with following snippet in multpath.conf

##########################
    device {
                vendor "IBM"
                product "1818"
                path_grouping_policy group_by_prio
                prio rdac
                getuid_callout "/lib/udev/scsi_id -g -u -d /dev/%n"
                polling_interval 5
                path_checker rdac
                path_selector "round-robin 0"
                hardware_handler "1 rdac"
                failback immediate
                features "2 pg_init_retries 50"
                no_path_retry 30
                rr_min_io 100
        }
#################################

But when we see "multipath -ll" output we see:
mpathca (3600a0b8000475c52000006a04b60f1d9) dm-38 IBM,1818      FAStT
size=2.0G features='3 queue_if_no_path pg_init_retries 50' hwhandler='1 rdac' 
wp=rw
|-+- policy='round-robin 0' prio=6 status=active
| |- 4:0:5:1  sdcz 70:112 active ready running
| `- 5:0:5:1  sddl 71:48  active ready running
`-+- policy='round-robin 0' prio=1 status=enabled
  |- 4:0:4:1  sdcx 70:80  active ghost running
  `- 5:0:3:1  sddh 70:240 active ghost running


So, my question is : even if we mention 
                             features "2 pg_init_retries 50" 

why are we seeing " features='3 queue_if_no_path pg_init_retries 50' 
hwhandler='1 rdac' wp=rw" in the multipath -ll output ?

1) Where is this "3" coming from  ? and what is it's significance ?? 

2) Is this "3" next to the features in "multipath -ll" output as expected (even 
though we mention "2 pg_init_retries 50" ) in our multipath.conf ??

(We've rebooted and regenerated multipath maps multiple times by "multipath -F" 
and then "multipath" )....but we still see this "discrepancy" (of "2" vs "3") ?

Will appreciate if someone can explain us.

Thanks,
Dharmesh.
