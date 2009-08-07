From: Akshay Lal <alal@cleversafe.com>
Subject: User specific priorities on for iscsi paths doesn't seem
	to work
Date: Fri, 07 Aug 2009 15:25:24 -0500
Message-ID: <4A7C8DB4.1090608@cleversafe.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com, John Quigley <jquigley@cleversafe.com>
List-Id: dm-devel.ids

I'm having a few issues with path priorities. It seems that the choice 
of path to use during I/O is independent of the user defined priorities 
for each path.

I am setting the priorities by executing writing a script that is used 
by prio_callout. This seems to work when I execute multipath -ll since 
all the specified priorities show up correctly. (the 
path_grouping_policy being used is  failover)

multipath -ll:
--------------
mpath2 (244534e3833623961) dm-1 DSNET,Dispersed Store
[size=47G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=10][enabled]
 \_ 85:0:0:0 sdc 8:32  [active][ready]
\_ round-robin 0 [prio=5][enabled]
 \_ 87:0:0:0 sde 8:64  [active][ready]
mpath1 (244534e3266616134) dm-0 DSNET,Dispersed Store
[size=47G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=5][enabled]
 \_ 84:0:0:0 sdb 8:16  [active][ready]
\_ round-robin 0 [prio=10][enabled]
 \_ 86:0:0:0 sdd 8:48  [active][ready]

At this point when I dd to /dev/mapper/mpath1 or /dev/mapper/mpath2 the 
priorities don't come into play at all. Data starts going to /dev/sdc 
for /dev/mapper/mpath2 & /dev/sdb for /dev/mapper/mpath1, which totally 
by-passes the set priorities. Below is a list of all the conf files and 
scripts I'm using.



/etc/multipath.conf
--------------------
defaults {
        udev_dir                /dev
        polling_interval        1
        selector                "round-robin 0"
        path_grouping_policy    multibus
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            "/bin/bash 
/root/MultipathScripts/mpath_prio_alt %n"
        path_checker            tur
        rr_min_io               128
        max_fds                 8192
        rr_weight               priorities
        failback                immediate
        no_path_retry           queue
        user_friendly_names     yes
}


/root/MultipathScripts/mpath_prio_alt :
---------------------------------------
#!/bin/bash
# if not passed any device name, return a priority of 0
if [ -z "${1}" ];then
        echo 0
        exit
fi

ENTRY="$(ls -l1 /dev/disk/by-path | grep /${1}'$')"
DEV="${ENTRY##* ip-}"
if [ "$DEV" = "${ENTRY}" ];then #This is not an iSCSI device
        echo 0
        exit
fi

# stripping $ENTRY to obtain the IP:Port-iscsi-iqn-lunNumber
DEV="${ENTRY##* ip-}"
#DEV="${DEV%% ->*}" # the pattern changed in CentOS 5.3
#DEV="$(echo ${DEV} | sed 's/-lun-[0-9][0-9]* ->.*//')"
DEV="${DEV%%-lun-[0-9]* ->*}"

echo $(grep ${DEV} /root/MultipathScripts/iscsi.list | cut -f2)


/root/MultipathScripts/iscsi.list:
----------------------------------
192.xxx.xxx.103:3260-iscsi-iqn.2008-07.com.company:stoarge-2    1
192.xxx.xxx.106:3260-iscsi-iqn.2008-07.com.company:stoarge-2    0
192.xxx.xxx.103:3260-iscsi-iqn.2008-07.com.company:stoarge-1    0
192.xxx.xxx.106:3260-iscsi-iqn.2008-07.com.company:stoarge-1    1


Is there something I'm doing wrong? I would like to be able to define 
the priorities per device, and ensure that data only traverses on the 
lower priority path when
a) a failure to the first path (path with a higher priority) occures
b) no other path with a higher priority exists

--
Akshay Lal
