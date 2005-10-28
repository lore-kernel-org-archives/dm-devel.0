From: Josef Whiter <jwhiter@redhat.com>
Subject: Re: Multipathing using device mapper howto?
Date: Fri, 28 Oct 2005 16:36:20 -0400
Message-ID: <43628BC4.5010909@redhat.com>
References: <43628C96.2090605@trilegiant.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43628C96.2090605@trilegiant.com>
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

Bruen, Mark wrote:

> I'm just beginning to look at device mapper to multipath SAN luns. 
> I've been searching for some time and can't find a simple reference on 
> how to create the multipathed devices from the same luns presented to 
> two or more HBA paths. Is there a source for that information?
> Thanks.
>    -Mark
>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

I don't know of any external sources, but the quick and dirty way is to 
first fdisk your /dev/sd devices, and then edit your /etc/multipath.conf 
file and comment out hte lines

devnode_blacklist {
        devnode "*"
}

and then uncomment out the lines

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

Then reboot, and it should work.  You're devices should show up in 
/dev/dm-#, then all you want to do is do a kpartx -a on /dev/dm-# and it 
will create a new /dev/dm-#+1 for the partitions (ie if my disk was 
/dev/dm-0 and i had one partition, and i ran kpartx -a i would get 
/dev/dm-1.  its equivalent of /dev/sda and /dev/sda1).  Thank you,

Josef

-- 
Josef Whiter, RHCE
Global Support Services
Red Hat, Inc.
919-754-3700 x44429
