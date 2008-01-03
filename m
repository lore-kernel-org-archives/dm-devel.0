From: Jimmy Stewpot <squid@oranged.to>
Subject: configuration mismatches on multipath.conf
Date: Thu, 03 Jan 2008 12:11:22 +0000
Message-ID: <477CD0EA.8050605@oranged.to>
Reply-To: squid@oranged.to,
	device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

I have been working on the multipath setup of our lab systems to make 
sure that the products are reliable for us to start deploying as our 
default. I have noticed one issue that I am a little confused about. I 
have two multipath{} sections which are identical apart from the WWID 
and aliases. One comes up and reports one active and one enabled channel 
and the other reports both channels being active. Is that normal?

multipath -ll
eux0000411-eul0001138-R10-1 (3600a0b800036fd910000026e477c6db9) dm-1 
IBM,1726-4xx  FAStT
[size=271G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=0][active]
  \_ 0:0:0:10 sdb 8:16  [active][ready]
\_ round-robin 0 [prio=0][enabled]
  \_ 1:0:0:10 sdd 8:48  [active][ready]
eux0000411-eul0001138-R1-1 (3600a0b800036fddd00000286477549b6) dm-0 
IBM,1726-4xx  FAStT
[size=68G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=0][enabled]
  \_ 0:0:0:1  sda 8:0   [active][ready]
\_ round-robin 0 [prio=0][enabled]
  \_ 1:0:0:1  sdc 8:32  [active][ready]


cat /etc/multipath.conf
defaults {
         udev_dir                /dev
         polling_interval        10
         path_grouping_policy    multibus
         getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
         prio_callout            /bin/true
         path_checker            tur
         selector                "round-robin 0"
         rr_min_io               100
         rr_weight               priorities
         failback                immediate
         no_path_retry           fail
         user_friendly_names     yes
}

devnode_blacklist {
         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
         devnode "^hd[a-z][[0-9]*]"
         devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
}

multipaths {
         multipath {
                 wwid                    3600a0b800036fd910000026e477c6db9
                 alias                   eux0000411-eul0001138-R10-1
                 path_grouping_policy    failover
                 path_checker            tur
                 path_selector           "round-robin 0"
                 failback                manual
                 rr_weight               priorities
                 no_path_retry           5
                 rr_min_io               100
         }
         multipath {
                 wwid                    3600a0b800036fddd00000286477549b6
                 alias                   eux0000411-eul0001138-R1-1
                 path_grouping_policy    failover
                 path_checker            tur
                 path_selector           "round-robin 0"
                 failback                manual
                 rr_weight               priorities
                 no_path_retry           5
                 rr_min_io               100
         }
}

devices {
         device {
                 vendor                  "IBM"
                 product                 "1726-4xx  FAStT"
                 path_grouping_policy    multibus
                 getuid_callout          "/lib/udev/scsi_id -g -u -s 
/block/%n"
                 path_checker            tur
                 path_selector           "round-robin 0"
                 hardware_handler        "0"
                 failback                15
                 rr_weight               priorities
                 no_path_retry           queue
                 rr_min_io               100
         }
}


I have done a complete reboot of the system to make sure that there was 
no problem, Ive flushed the configuration and it still comes up in the 
same fashion. Can anyone provide some advice on this problem?

Regards,

Jimmy
