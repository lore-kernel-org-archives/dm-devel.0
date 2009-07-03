From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: Re: Unstable isci path and confusing logging
Date: Fri, 3 Jul 2009 13:23:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907031323100.12539@e-smith.charlieb.ott.istop.com>
References: <Pine.LNX.4.64.0906251344350.4229@e-smith.charlieb.ott.istop.com>
	<Pine.LNX.4.64.0907031226000.12539@e-smith.charlieb.ott.istop.com>
	<Pine.LNX.4.64.0907031312050.12539@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0907031312050.12539@e-smith.charlieb.ott.istop.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


In case it is relevant, here is my device configuration.

devices {
     device {
         vendor                  "SUN"
         product                 "LCSM100_I"
         getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
         prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
         features                "0"
         hardware_handler        "1 rdac"
         path_grouping_policy    group_by_prio
         failback                immediate
         rr_weight               uniform
         no_path_retry           queue
         rr_min_io               1000
         path_checker            rdac
     }
}
