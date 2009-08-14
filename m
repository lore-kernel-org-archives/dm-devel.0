From: Stefan Upietz <upietz@phil-fak.uni-duesseldorf.de>
Subject: multipathd not doing fallback
Date: Fri, 14 Aug 2009 18:02:16 +0200
Message-ID: <4A858A88.3020508@phil-fak.uni-duesseldorf.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010301080608010806000204"
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

This is a multi-part message in MIME format.
--------------010301080608010806000204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

hello list,

i'm running multipath-tools on a debian server with a hp msa1500cs san
attached via 2 qlogic hbas and 2 fc-switches.

i configured /etc/multipath.conf according to hp recommendations,
and when i deactivate a remote port on the switch, multipath -ll
displays correctly that one path is down, it's marked as failed/faulty
and the other path takes over.
however: when i bring the remote port back up, multipathd tries to
reinstate the former path via say /dev/sdi, but the path is in the
system now as /dev/sdh. so, despite multipath -ll showing the right
(new) path to the target (ie sdh), multipathd (as i saw via multipathd
-d -v3) still probes the old path (ie sdi)! unsurprisingly, multipath
never falls back unless i reconfigure/ reload by hand.
is this expected behaviour?
when i'm _not_ running multipathd, everything (failover, fallback) works
fine, but it's of course not so easy to manage.

i've attached my multipath.conf.

any help appreciated!

thanks in advance,

upietz

--------------010301080608010806000204
Content-Type: text/plain;
 name="multipath.conf"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="multipath.conf"

defaults {
	udev_dir	/dev
	polling_interval 1
	selector	"round-robin 0"
	path_grouping_policy	failover
	getuid_callout	"/lib/udev/scsi_id -g -u -d /dev/%n"
	path_checker	directio
	failback	immediate
        no_path_retry  queue
	user_friendly_names yes
}

blacklist {
    wwid "3600508b3009550f0a97f516c8b510007"
    wwid "3600508b3009550f0a34f525719730007"
    wwid "3600508b3009550f0abff52be59050008"
    wwid "3600508b3009550f0af0a29932adb000b"
    wwid "3600508b3009550f05dd54fce94460009"
    wwid "3600508b3009550f0a4b07de4c4460009"
    wwid "3600508b3009550f0a78855bd8021000a"

	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
	devnode "^hd[a-z][[0-9]*]"
	devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
}

multipaths {
	multipath {
	        wwid            3600508b3009550f01a803f0d2ca70009 
		alias		test
	}
}

devices {
	device {
        vendor                  "HP"
        product                 "MSA VOLUME*"
        getuid_callout          "/lib/udev/scsi_id -g -u -d /dev/%n"
        prio_callout            "/sbin/mpath_prio_alua /dev/%n"
        hardware_handler        "0"
        path_selector           "round-robin 0"
        path_grouping_policy    failover
        failback                immediate
        rr_weight               uniform
        no_path_retry           fail
        rr_min_io               100
        path_checker            tur
	}
}

--------------010301080608010806000204
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010301080608010806000204--
