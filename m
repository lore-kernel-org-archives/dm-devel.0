From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: info on defaults and features key for 1750500
Date: Tue, 17 Mar 2009 11:00:37 +0100
Message-ID: <561c252c0903170300w4b76fc2ck8563b747992d5bde@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Hello,
I have an IBM DS6800 storage system that is identified as 1750500
[]# cat /proc/scsi/scsi
Attached devices:
...
Host: scsi1 Channel: 00 Id: 01 Lun: 00
  Vendor: IBM      Model: 1750500          Rev: .441
  Type:   Direct-Access                    ANSI SCSI revision: 05
...

My system is rh el 5U3 x86_64 and has two fc hba connected to two fc
switches (connected then to the 4 ports of the storage system).
sw version is device-mapper-multipath-0.4.7-23.el5

I have a doubt about default configuration.
In this moment:
in multipath.conf no particular setting about the storage model. I only have

defaults {
        user_friendly_names yes
}

Under /usr/share/doc/device-mapper-multipath-0.4.7
multipath.conf.defaults says:
#defaults {
#       udev_dir                /dev
#       polling_interval        5
#       selector                "round-robin 0"
#       path_grouping_policy    failover
#       getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
#       prio_callout            none
#       path_checker            readsector0
#       rr_min_io               1000
#       rr_weight               uniform
#       failback                manual
#       no_path_retry           fail
#       user_friendly_names     no
#       bindings_file           "/var/lib/multipath/bindings"
#}

and
#       device {
#               vendor                  "IBM"
#               product                 "1750500"
#               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
#               prio_callout            "/sbin/mpath_prio_alua %d"
#               features                "1 queue_if_no_path"
#               hardware_handler        "0"
#               path_grouping_policy    group_by_prio
#               failback                immediate
#               rr_weight               uniform
#               rr_min_io               1000
#               path_checker            tur
#       }

multipath.conf.annotated says
#       # name    : no_path_retry
#       # scope   : multipath & multipathd
#       # desc    : tell the number of retries until disable queueing, or
#       #           "fail" means immediate failure (no queueing),
#       #           "queue" means never stop queueing
#       # values  : queue|fail|n (>0)
#       # default : (null)
#       #
#       #no_path_retry  queue


two questions:
1) what is the meaning of the line
features                "1 queue_if_no_path"
? I didn't find anything about the "features" key.....
Is it the same as "no_path_retry=queue" ?

2) If the answer to 1) is no, taking for good the defaults above, does
this mean that in a default config I have on my system
no_path_retry           fail
?

Is there a command where I can see the actual config ?
(if for example anyone wants to cross check defaults written in docs
and real code behaviour)

Thanks in advance,
Gianluca
