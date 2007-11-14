From: Michael Vallaly <vaio@nolatency.com>
Subject: DM-Multipath path failure questions..
Date: Wed, 14 Nov 2007 00:07:43 -0600
Message-ID: <20071114000743.3b2d36a5.vaio@nolatency.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

I am currently using the dm-multipather (multipath-tools) to allow high-availability / increased capacity to our Equallogic iSCSI SAN. I was wondering if anyone had come across a way to re-instantiate a failed path / paths from a multipath target, when the backend device (iscsi initiator) goes away. 

All goes well until we have a lengthy network hiccup or non-recoverable iSCSI error in which case the multipather seems to get wedged. The path seems to get stuck in a [active][faulty] state and the backend block device (sdX) actually gets removed from the system. I have tried reconnecting the iSCSI session, after this happens, and get a new (different IE: sdg vs. sdf) backend block level device, but the multipather never picks it up / never resumes IO operations, and I generally have then to power cycle the box.

We have anywhere from 2 to 4 iSCSI sessions open per multipath target, but even one path failing seems to cause the whole multipath to die. I am hoping there is a way to continue on after a path failure, rather than the power cycle. I have tried multipath-tools 0.4.6/0.4.7/0.4.8, and almost every permutation of the configuration I can think of. Maybe I am missing something quite obvious.  

Working Multipather
<snip>
mpath89 (36090a0281051367df57194d2a37392d5) dm-4 EQLOGIC ,100E-00       
[size=300G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=2][active]
 \_ 5:0:0:0  sdf 8:80  [active][ready]
 \_ 6:0:0:0  sdg 8:96  [active][ready]
</snip>

Wedged Multipather (when a iSCSI session terminates) (All IO queues indefinitely)
<snip>
mpath94 (36090a0180087e6045673743d3c01401c) dm-10 ,
[size=600G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=0][enabled]
 \_ #:#:#:#  -   #:#   [active][faulty]
</snip>

Our multipath.conf looks like this: 
<snip>
defaults {
        udev_dir                /dev
        polling_interval        10
        selector                "round-robin 0"
        path_grouping_policy    multibus
        getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
        #prio_callout            /bin/true
        #path_checker            readsector0
        path_checker            directio
        rr_min_io               100
        rr_weight               priorities
        failback                immediate
        no_path_retry           fail
        #user_friendly_names     no
        user_friendly_names     yes
}

blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|sda)[0-9]*"
        devnode "^hd[a-z][[0-9]*]"
        devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
}


devices {
        device {
                vendor                  "EQLOGIC"
                product                 "100E-00"
                path_grouping_policy    multibus
                getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
                #path_checker            directio
                path_checker            readsector0
                path_selector           "round-robin 0"
                ##hardware_handler        "0"
                failback                immediate
                rr_weight               priorities
                no_path_retry           queue
                #no_path_retry           fail
                rr_min_io               100
                product_blacklist       LUN_Z
        }
}

</snip>

Thanks for your help.

- Mike Vallaly
