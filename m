From: Philipp Niemann <niemann@dimdi.de>
Subject: Re: Multipathing hints request
Date: Fri, 22 Jul 2005 14:09:55 +0200
Message-ID: <20050722120955.GL4240@pan.dimdi.de>
References: <20050721143110.GD4240@pan.dimdi.de>
	<1121970687.19015.78.camel@zezette>
	<20050722083722.GJ4240@pan.dimdi.de>
	<20050722095828.GA13294@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050722095828.GA13294@averon.dyndns.org>
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

Well, almost at it.

On Fri, 22.07.2005-11:58:28 +0200, Christophe Varoqui wrote:
> hardware_handler and features params must be in the devices {} section, not in multipaths {}.

I changed the settings in /etc/multipath.conf again, as you advised.
Here is it:

# Begin of /etc/multipath.conf
defaults {
        multipath_tool  "/sbin/multipath -v 0 -S"
        udev_dir        /dev
        polling_interval 10
        default_selector        "round-robin 0"
        default_path_grouping_policy    failover
        default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
        default_prio_callout    "/bin/false"
        default_features        "0"
}
multipaths {
        multipath {
                wwid                    360060160200161a037f90d75dfca84f7
                alias                   416L3
                path_grouping_policy    failover
                path_selector           "round-robin 0"
        }
}
devices {
        device {
                vendor                  "DGC     "
                product                 "RAID 5          "
                path_grouping_policy    group_by_serial
                getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
                path_checker            emc_clariion
                path_selector           "round-robin 0"
                features                "0"
                hardware_handler        "1 emc"
        }
}
# End of /etc/multipath.conf

I figured out that the vendor value must be exactly 8 characters long.

> Also, pgpolicy is best set to group_by_serial with Clariion hw.
> You'll see it produce same grouping than failover in your case.

Hm, doesn't look the same here. It again leaves me with only one
priority group. So I stick to failover for now.

What different features are available? I just managed to freeze my
network conn (at least, haven't checked the host yet) by adding "1
queue_if_no_path" as used with the compaq entry in the examples.

I didn't manage to get failover to work, yet. Am I correct in assuming
that the multipathd daemon is only needed for path recovery? Because I
have problems getting that one to react to signals properly.

Right, gonna check what happend to the machine.
CU,
Philipp
-- 
Philipp Niemann                                       DIMDI
Abteilung D / AG D4
Peripherie / UNIX-Systembetreuer     Waisenhausgasse 36-38a
Tel. : 0221/4724-281                            50676 Koeln
