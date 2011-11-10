From: Tiago.Francisco.Abreu@bportugal.pt
Subject: Multipath.conf
Date: Thu, 10 Nov 2011 11:29:02 +0000
Message-ID: <OF65500C59.20F9F543-ON80257944.003C1AE0-80257944.003F18B9@bportugal.pt>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

Hi all.

I have some comments regarding multipath.conf.
1) Can someone point me to the latest version of the documentation?
The following examples seem to show that the multipath(d) are not in sync
with the man.
a) polling_interval
The man page and the comments in the multipath.conf say that the default
value is 5, but when I execute "multipath -t" when I didn't specified the
value in multipath.conf it says the polling_interval is 0.
I don't even know what 0 means.
Is "multipath -t" giving incorrect values? Is my reasonning wrong? Other?

b) path_grouping_policy
man says that the default is multibus.
Red Hat Documentation (
http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/DM_Multipath/config_file_defaults.html
) says the default is Failover.

c) prio
man says default is none.
Red Hat Documentation (
http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/DM_Multipath/config_file_defaults.html
) says the default is const.

d) Why "prio emc" gives "sda: emc prio: query command indicates error",
when I execute multipath -v2 -d with multipathd not running. And sda is
even in the blacklist.

e) If I have EMC Clariion Disk Array, should I use: "path_checker
emc_clariion"?

f) What is the correct getuid_callout:
-  /sbin/scsi_id -g -u -s /block/%n (As old EMC document says)
- /sbin/scsi_id -g -u -s (As the man says)
- "/lib/dev/scsi_id --whitelisted --device=/dev/%n" (As
http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/DM_Multipath/config_file_defaults.html
 says.)

g) There maybe more differences. I didn't check all.

2) Maybe this is not a question to this forum, but what are the correct
defaults section in multipath.conf for a host (SLES 10) in a cluster (so
quick failover), dual HBA to dual switch, with "
# Emulex lpfc options
options lpfc lpfc_nodev_tmo=3 lpfc_devloss_tmo=3
"
in /etc/modprobe.conf.

What do you think of:
defaults {
      polling_interval 5
#     max_polling_interval 4
      udev_dir /dev
      verbosity 2
      selector "round-robin 0"
      path_grouping_policy multibus
      getuid_callout /sbin/scsi_id -g -u -s /block/%n
      prio const
#     prio_callout mpath_prio_emc /dev/%n
      features 1 queue_if_no_path
      path_checker directio
      failback immediate
# Previous one for a quick failover
      rr_min_io 1000
      rr_weight priorities
      no_path_retry fail
# Previous one for a quick failover
#     pg_timeout none
      user_friendly_names yes
      max_fds 8192
      bindings_file "/etc/multipath_bindings"
# Previous one for future compatibility and same partition has /root
      dev_loss_tmo 2
# Previous one for a quick failover
      fast_io_fail_tmo 1
# Previous one for a quick failover
      async_timeout 30
}
Because of the first problem I prefer to define the parameters even if they
are equal to the defaults values instead of not defining the parameters.

Thanks in advance, TA.
