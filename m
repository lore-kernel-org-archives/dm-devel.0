From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: checkerloop checks too many devices
Date: Tue, 3 May 2005 14:52:01 -0500
Message-ID: <20050503195201.GC5323@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

It seems that checkerloop isn't just checking the your multipathed devices.
It's checking all your devices.  Wouldn't it be more sensible to find out which
devices make up part of a multipathed device, and only check those?

Currently, when I start up multipathd, I getting this printed out:

Unknown switch: (null)
multipath v0.4.4 (16/04, 2005)
Usage: /sbin/multipath  [-v level] [-d] [-l] [-S]
                        [-p failover|multibus|group_by_serial|group_by_prio]
                        [device]

        -v level        verbosty level
           0                    no output
           1                    print created devmap names only
           2                    default verbosity
           3                    print debug information
        -d              dry run, do not create or update devmaps
        -l              list the current multipath topology
        -F              flush all multipath device maps
        -p policy       force all maps to specified policy :
           failover             1 path per priority group
           multibus             all paths in 1 priority group
           group_by_serial      1 priority group per serial
           group_by_prio        1 priority group per priority lvl
           group_by_node_name   1 priority group per target node

        device          limit scope to the device's multipath
                        (udev-style $DEVNAME reference, eg /dev/sdb
                        or major:minor or a device map name)

because checkerloop is trying to check the status of /dev/hda, which is not
multipathed.

-Ben
