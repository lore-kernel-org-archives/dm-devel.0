From: Alexander Benaguev <zul@sigmatrans.ru>
Subject: multipath device won't assemble
Date: Wed, 21 Mar 2007 14:43:31 +0300
Message-ID: <46011A63.5010102@sigmatrans.ru>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

hi list. I'm working with fastt storage and experience some problems with multipath-tools. as you
can see bellow, multapath can't create mpath0, but mpath1 successful created. I can't understand
why. googling around two days without any result. help me, please;(

alexander
info-------------------------------------------------------------------------------------------------
OS: CentOS 4.92
kernel: 2.6.18-1.2747.el5xen
multipath.conf (default):
defaults {
        user_friendly_names yes
}
defaults {
        udev_dir                /dev
        polling_interval        10
        selector                "round-robin 0"
        path_grouping_policy    multibus
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            /bin/true
        path_checker            readsector0
        rr_min_io               1000
        rr_weight               priorities
        failback                immediate
        no_path_retry           fail
        user_friendly_name      yes
}

multipath -v3 output:
mpath0: pgfailback = -2 (config file default)
mpath0: pgpolicy = multibus (config file default)
mpath0: selector = round-robin 0 (internal default)
mpath0: features = 0 (internal default)
mpath0: hwhandler = 0 (internal default)
mpath0: rr_weight = 2 (config file default)
mpath0: minio = 1000 (config file default)
mpath0: no_path_retry = -1 (config file default)
pg_timeout = NONE (internal default)
mpath0: set ACT_CREATE (map does not exist)
mpath0: domap (0) failure for create/reload map

dmesg output:
device-mapper: table: 253:5: multipath: error getting device
device-mapper: ioctl: error adding target to table
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGARpi4DJ/LCkjclMRAnHOAKCUEwV8STX7lMTMISg2ReFqMIejngCcDy9O
DAgCHTj4cgkQDOqWE1cyczA=
=53zF
-----END PGP SIGNATURE-----
