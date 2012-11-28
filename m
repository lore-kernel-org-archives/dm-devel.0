From: Lupin Deterd <lupindeterd@gmail.com>
Subject: Controlling the sequence of dm-* creation
Date: Wed, 28 Nov 2012 08:52:07 +0800
Message-ID: <CAL0mBkTxqdmqd351VxkU1GLwfS_622OfS9wFCOkiWYKAhOAjow@mail.gmail.com>
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

Is there a way to control how a dm- # devices created? e.g by udev or multipath?

Let say, I wanted to have my dm- devices created for multipath devices
to start only on dm-7 to dm-9, instead of using lower numbered
dm-[0-8] as it's been mapped to a different lun. Is this possible?


########## udev logs on dm-# creation ############

Nov 27 11:04:51 SERVER udev[2514]: creating device node '/dev/dm-1'
Nov 27 11:04:51 SERVER udev[2511]: creating device node '/dev/dm-0'
Nov 27 11:05:05 SERVER udev[4896]: configured rule in
'/etc/udev/rules.d/40-local.rules' at line 4 applied, 'sdb' becomes
'dm-2'
Nov 27 11:05:05 SERVER udev[4896]: creating device node '/dev/dm-2'
Nov 27 11:05:05 SERVER udev[4948]: configured rule in
'/etc/udev/rules.d/40-local.rules' at line 4 applied, 'sdr' becomes
'dm-2'
Nov 27 11:05:05 SERVER udev[4948]: creating device node '/dev/dm-2'
Nov 27 11:05:05 SERVER udev[4899]: configured rule in
'/etc/udev/rules.d/40-local.rules' at line 5 applied, 'sdc' becomes
'dm-3'
Nov 27 11:05:05 SERVER udev[4899]: creating device node '/dev/dm-3'
Nov 27 11:05:05 SERVER udev[4902]: configured rule in
'/etc/udev/rules.d/40-local.rules' at line 6 applied, 'sdd' becomes
'dm-4'
Nov 27 11:05:05 SERVER udev[4902]: creating device node '/dev/dm-4'
Nov 27 11:05:05 SERVER udev[4905]: configured rule in
'/etc/udev/rules.d/40-local.rules' at line 7 applied, 'sde' becomes
'dm-5'
Nov 27 11:05:05 SERVER udev[4905]: creating device node '/dev/dm-5'
Nov 27 11:05:05 SERVER udev[4960]: configured rule in
'/etc/udev/rules.d/40-local.rules' at line 8 applied, 'sdv' becomes
'dm-6'
Nov 27 11:05:05 SERVER udev[4960]: creating device node '/dev/dm-6'
Nov 27 11:05:05 SERVER udev[4951]: configured rule in
'/etc/udev/rules.d/40-local.rules' at line 5 applied, 'sds' becomes
'dm-3'
Nov 27 11:05:05 SERVER udev[4951]: creating device node '/dev/dm-3'
Nov 27 11:05:05 SERVER udev[4908]: configured rule in
'/etc/udev/rules.d/40-local.rules' at line 8 applied, 'sdf' becomes
'dm-6'
Nov 27 11:05:05 SERVER udev[4908]: creating device node '/dev/dm-6'
Nov 27 11:05:05 SERVER udev[4957]: configured rule in
'/etc/udev/rules.d/40-local.rules' at line 7 applied, 'sdu' becomes
'dm-5'
Nov 27 11:05:05 SERVER udev[4954]: configured rule in
'/etc/udev/rules.d/40-local.rules' at line 6 applied, 'sdt' becomes
'dm-4'
Nov 27 11:05:05 SERVER udev[4954]: creating device node '/dev/dm-4'
Nov 27 11:05:05 SERVER udev[4957]: creating device node '/dev/dm-5'
Nov 27 11:05:05 SERVER udev[4929]: creating device node '/dev/sdm'
Nov 27 11:06:03 SERVER udev[24273]: configured rule in
'/etc/udev/rules.d/40-multipath.rules' at line 3 applied, added
symlink 'mpath/%c' <30>Nov 27 11:06:03 udev[24273]: configured rule in
'/etc/udev/rules.d/40-multipath.rules' at line 3 applied, 'dm-2'
becomes '%k'
Nov 27 11:06:03 SERVER udev[24273]: creating device node '/dev/dm-2'
Nov 27 11:06:03 SERVER udev[24320]: configured rule in
'/etc/udev/rules.d/40-multipath.rules' at line 3 applied, added
symlink 'mpath/%c' <30>Nov 27 11:06:03 udev[24320]: configured rule in
'/etc/udev/rules.d/40-multipath.rules' at line 3 applied, 'dm-3'
becomes '%k'
Nov 27 11:06:03 SERVER udev[24320]: creating device node '/dev/dm-3'
Nov 27 11:06:03 SERVER udev[24455]: configured rule in
'/etc/udev/rules.d/40-multipath.rules' at line 3 applied, added
symlink 'mpath/%c' <30>Nov 27 11:06:03 udev[24455]: configured rule in
'/etc/udev/rules.d/40-multipath.rules' at line 3 applied, 'dm-5'
becomes '%k'
Nov 27 11:06:03 SERVER udev[24453]: configured rule in
'/etc/udev/rules.d/40-multipath.rules' at line 3 applied, added
symlink 'mpath/%c' <30>Nov 27 11:06:03 udev[24453]: configured rule in
'/etc/udev/rules.d/40-multipath.rules' at line 3 applied, 'dm-4'
becomes '%k'
Nov 27 11:06:03 SERVER udev[24455]: creating device node '/dev/dm-5'
Nov 27 11:06:03 SERVER udev[24453]: creating device node '/dev/dm-4'
Nov 27 11:06:03 SERVER udev[24464]: configured rule in
'/etc/udev/rules.d/40-multipath.rules' at line 3 applied, 'dm-6'
becomes '%k'
Nov 27 11:06:03 SERVER udev[24464]: creating device node '/dev/dm-6'


########## Udev rules ##################################

[root@SERVER ~]# cat /etc/udev/rules.d/40-local.rules
#
# LUN re-ordering fix
#
KERNEL="sd*", BUS="scsi", PROGRAM="/sbin/scsi_id",
RESULT="360060e8005441c000000441c0000000f", NAME="dm-2"
KERNEL="sd*", BUS="scsi", PROGRAM="/sbin/scsi_id",
RESULT="360060e8005441c000000441c0000001f", NAME="dm-3"
KERNEL="sd*", BUS="scsi", PROGRAM="/sbin/scsi_id",
RESULT="360060e8005441c000000441c0000002f", NAME="dm-4"
KERNEL="sd*", BUS="scsi", PROGRAM="/sbin/scsi_id",
RESULT="360060e8005441c000000441c0000003f", NAME="dm-5"
KERNEL="sd*", BUS="scsi", PROGRAM="/sbin/scsi_id",
RESULT="360060e8005441c000000441c0000004f", NAME="dm-6"

#
# /oracle
#
KERNEL="sd*", BUS="scsi", PROGRAM="/sbin/scsi_id",
RESULT="360060e8005441c000000441c00000704", NAME="mapper/orabin"

################## Multipath udev rules
############################################################

[root@SERVER ~]# cat /etc/udev/rules.d/40-multipath.rules
# multipath wants the devmaps presented as meaninglful device names
# so name them after their devmap name
KERNEL="dm-[0-9]*", PROGRAM="/sbin/mpath_get_name %M %m", RESULT="?*",
NAME="%k", SYMLINK="mpath/%c"
KERNEL="dm-[0-9]*", PROGRAM="/sbin/kpartx_get_name %M %m",
RESULT="?*", NAME="%k", SYMLINK="mpath/%c"


############## Created devices ###################

[root@SERVER ~]# ls -l /dev/mpath
total 0
lrwxrwxrwx  1 root root 7 Nov 27 11:06 TR00DATA01 -> ../dm-2
lrwxrwxrwx  1 root root 7 Nov 27 11:06 TR00FRA01 -> ../dm-3
lrwxrwxrwx  1 root root 7 Nov 27 11:06 TR01DATA01 -> ../dm-5
lrwxrwxrwx  1 root root 7 Nov 27 11:06 TROCR101 -> ../dm-6
lrwxrwxrwx  1 root root 7 Nov 27 11:06 TROCR201 -> ../dm-4


############### multipath.conf ###########

[root@SERVERrules.d]# grep -v ^# /etc/multipath.conf | grep -v ^$
defaults {
        polling_interval        5
        path_grouping_policy    multibus
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        user_friendly_names     no
}
devnode_blacklist {
        wwid  360060e8005441c000000441c00001059
        wwid  360060e8005441c000000441c00000725
        wwid  360060e8005441c000000441c0000091e
        wwid  36005076b060890800fc5ab8099ad80c2
        wwid  360060e8005441c000000441c00000038
        wwid  360060e8005441c000000441c00000707
        wwid  36005076b060890800fc5ab8099ad80c2
        wwid 360060e8005441c000000441c0000000f
        wwid 360060e8005441c000000441c0000001f
        wwid 360060e8005441c000000441c0000002f
        wwid 360060e8005441c000000441c0000003f
        wwid 360060e8005441c000000441c0000004f
        wwid 360060e8005441c000000441c00000704
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
}
multipaths {
        multipath {
                wwid                    360060e8005441c000000441c00000131
                #alias                  yellow
                alias                   TROCR201
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
                rr_weight               priorities
                no_path_retry           5
                uid                     200
                gid                     57267
                mode                    0660
        }
        multipath {
                wwid                    360060e8005441c000000441c00000127
                #alias                  red
                alias                   TROCR101
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
                rr_weight               priorities
                no_path_retry           5
                uid                     200
                gid                     57267
                mode                    0660
        }
        multipath {
                wwid                    360060e8015259e000001259e00003500
                #alias                  white
                alias                   TR01DATA01
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
                rr_weight               priorities
                no_path_retry           5
                uid                     200
                gid                     57267
                mode                    0660
        }
        multipath {
                wwid                    360060e8005441c000000441c0000001a
                #alias                  blue
                alias                   TR00FRA01
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
                rr_weight               priorities
                no_path_retry           5
                uid                     200
                gid                     57267
                mode                    0660
        }
        multipath {
                wwid                    360060e8005441c000000441c00000706
                #alias                  orange
                alias                   TR00DATA01
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                immediate
                rr_weight               priorities
                no_path_retry           5
                uid                     200
                gid                     57267
                mode                    0660
        }
}
devices {
  device {
               vendor                  "HITACHI"
               product                 "DF.*"
               path_grouping_policy    group_by_prio
               prio_callout            "/sbin/mpath_prio_hds_modular %d"
               path_checker            "readsector0"
               getuid_callout          "/sbin/scsi_id -g -u -s"
               failback                immediate
       }
}
verbosity 6
[root@SERVERrules.d]#

TIA,

lupin
