From: Tony Lapointe <tony.lapointe@connexim.ca>
Subject: multipath-tools with STK FLEXLINE 380
Date: Thu, 16 Nov 2006 13:03:38 -0500
Message-ID: <1163700218.11483.24.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
Cc: daniel.milani@connexim.ca
List-Id: dm-devel.ids

Hi list,

we're trying to get multipath working on a server (which run SLES 10)
connected to a STK FLEXLINE 380 SAN. This SAN has AVT (Auto Volume
Transfer) activated and we have two LUNs exported to the server, which
one on a different preferred path (one on controller A and the other on
controller B).

Since the SAN has AVT activated and that we are using preferred path,
i'm guessing that we have to use group_by_prio policy with the
mpath_prio_tpc callout program.

I can see that mpath_prio_tpc get the right priority :

# mpath_prio_tpc /dev/sda
3
# mpath_prio_tpc /dev/sdb
0
# mpath_prio_tpc /dev/sdd
0
# mpath_prio_tpc /dev/sde
3

and then if i issue "fdisk -l" on /dev/sda and /dev/sde, each LUN stay
on his preferred controller on the SAN.

The problem is when i start multipath, it will not coalesces the paths
together.

Here's my multipath.conf :

defaults {
        udev_dir        /dev
        polling_interval 10


        path_grouping_policy    group_by_prio
        getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"


        prio_callout    "/sbin/mpath_prio_tpc /dev/%n"
        path_checker    tur

        rr_weight       priorities

        failback        immediate

#       user_friendly_names yes

}
blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z][[0-9]*]"
        devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
        device {
                vendor "STK"
                product "Universal Xport"
        }
}

multipaths {

        multipath {
                wwid                   3600a0b8000119c20000002a445338779
                alias                  test1
        }

        multipath {
                wwid                   3600a0b8000119c20000002a945338e7f
                alias                  test2
        }

}


and here's the relevant error part of the output of "multipath -v3" :

...
test1: set ACT_CREATE (map does not exist)
test1: domap (0) failure for create/reload map
...
test2: set ACT_CREATE (map does not exist)
test2: domap (0) failure for create/reload map
...


Am i missing something or multipath-tools just can't work on
STK FLEXLINE 380 with AVT enabled?


Thanks a lot for your time! 


-- 
#################################################
#                                               #
# Tony Lapointe @ Connexim                      #
# Administrateur Systeme # System Administrator #
# RHCE # LPI                                    #
# phone -> 1-514-879-5951                       #
# page -> 1-514-851-2560                        #
# email -> tony.lapointe@connexim.ca            #
# epager -> 5148512560@pager.mobility.com       #
#                                               #
#################################################
#                                               #
# # mount --bind /bin/su /bin/login             #
#                                               #
#################################################
