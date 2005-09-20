From: Ray Stell <stellr@cns.vt.edu>
Subject: Re: blacklisted paths?
Date: Tue, 20 Sep 2005 08:01:53 -0400
Message-ID: <20050920120153.GA25978@locust.cns.vt.edu>
References: <20050919211649.GA24756@locust.cns.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050919211649.GA24756@locust.cns.vt.edu>
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

On Mon, 19 Sep 2005 16:07:18 -070, Mike Anderson wrote:
>Well I do not have a good explanation why the blacklisting is not more
>consistent, but can you send your /etc/multipath.conf. I might suspect
>that a devnode_blacklist regular expression maybe matching resulting in
>blacklisting when it should not.

Thanks for looking at this problem:

# cat /etc/multipath.conf
# Blacklist all devices by default. Remove this to enable multipathing
# on the default devices.
##
## This is a template multipath-tools configuration file
## Uncomment the lines relevent to your environment
##
defaults {
        multipath_tool  "/sbin/multipath -v0"
        udev_dir        /dev
        polling_interval 10
        default_selector        "round-robin 0"
        default_path_grouping_policy    multibus
        default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
        default_prio_callout    "/bin/true"
        default_features        "0"
        rr_wmin_io              100
        failback                immediate
}
devnode_blacklist {
        devnode "hd*"
        devnode "fd*"
        devnode "ram*"
        devnode "md*"
}
devices {
        device {
                vendor                  "IBM     "
                product                 "2105            "
                path_grouping_policy    multibus
                path_checker            tur
        }
}
============================================================
Ray Stell  stellr@vt.edu  (540) 231-4109  Tempus fugit  28^D
