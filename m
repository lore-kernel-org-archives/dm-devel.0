From: sda@rosenergo.com
Subject: multipathd is not detect restored fc-path
Date: Sat, 15 Jul 2006 12:13:19 +0400
Message-ID: <20060715081319.GA13955@matador.rosenergo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
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

	Hello!

	I have multipathing configuration with path_grouping_policy = failover with two fibre channel simultaneous connections (active and standby). If I break active connection, multipathd detect this and switch data transfer to standby. But later, then connection restored, multipathd is not detect this fact automatically, command "multipath -l" show than old fibre channel remain failed. Multipathd will see that old channel is OK only if I manually remap paths with "multipath" command. This is not good, because if after then the first path broken and restored the second path fail too, conection to SAN will be completely unable to work. I suppose this is because of unproper configuration of multipathing.

	Explain me, please, that is cause of this trouble and how I may correct it.

  This is my configuration:
	- disk storage - ds4800
	- hba - two Emulex Corporation LP952 Fibre Channel Host Adapter
	- OS - rhel as 4 update 3
	- multipath toolkit source - device-mapper-multipath-0.4.5-12.0.RHEL4.i386.rpm
	- multipathd config:

defaults {
        multipath_tool  "/sbin/multipath -v0"
        udev_dir        /dev
        polling_interval 10
        default_selector        "round-robin 0"
        default_path_grouping_policy    failover
        default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
        default_prio_callout    "/bin/true"
        default_features        "0"
        rr_wmin_io              100
        failback                immediate
        user_friendly_names     yes
}


multipaths {
        multipath {
                wwid                    3600a0b8000115280000040b9448f8cea
                alias                   mp03
                path_grouping_policy    failover
                path_selector           "round-robin 0"
                failback                immediate
        }
        multipath {
                wwid                    3600a0b8000115280000040cd448f8d1e
                alias                   mp04
                path_grouping_policy    failover
                path_selector           "round-robin 0"
                failback                immediate
        }
}
devices {
  device {
    vendor      "IBM"
    product     "1815      FAStT"
    path_grouping_policy failover
    path_checker  tur
  }

}


	Thanks,
	Dmitry Sedov, NP ATS.
