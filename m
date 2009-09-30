From: John Brier <jbrier@redhat.com>
Subject: Re: Question regarding failback option in multipath.conf
Date: Wed, 30 Sep 2009 15:07:52 -0400
Message-ID: <4AC3AC88.9020404@redhat.com>
References: <5A70833B-9208-470E-88B7-7C351EED2122@aclue.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5A70833B-9208-470E-88B7-7C351EED2122@aclue.com>
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

On 09/30/2009 12:41 PM, Eli Klein wrote:
> I'm running into an issue where the failback option in multipath.conf is
> being ignored. I've tried to set this to a value > 0 to cause dm to
> pause before reinstating a recovered path, but it reinstates the path
> immediately. The same is true when setting the value to "manual", the
> path is reinstated immediately. The delay is most useful when a ethernet
> switch has failed or rebooted. During the boot of the switch, the
> interface comes up and drops again multiple times. I'd love to be able
> to introduce a delay before DM marks the path as reinstated after a
> recovery. This would save me the hassle of running into I/O errors (and
> occasional filesystem RO) as the path bounces while the switch is booting.
>
> Thanks in advance for any help or suggestions!
>
> -Eli
>
> I've included my multipath.conf as well as output from multipath -ll below:
>
> multipath.conf:
>
> blacklist {
> devnode "sda$"
> # devnode "*"
> }
>
> ## By default, devices with vendor = "IBM" and product = "S/390.*" are
> ## blacklisted. To enable mulitpathing on these devies, uncomment the
> ## following lines.
> #blacklist_exceptions {
> # device {
> # vendor "IBM"
> # product "S/390.*"
> # }
> #}
>
> ## Use user friendly names, instead of using WWIDs as names.
> defaults {
> user_friendly_names yes
> }
> ##
> ## Here is an example of how to configure some standard options.
> ##
> #
> defaults {
> udev_dir /dev
> polling_interval 10
> selector "round-robin 0"
> path_grouping_policy multibus
> getuid_callout "/sbin/scsi_id -g -u -s /block/%n"
> prio_callout /bin/true
> path_checker readsector0
> rr_min_io 10
> rr_weight priorities
> failback 120
> features "1 queue_if_no_path"
> no_path_retry 1
> user_friendly_name yes
> }

It looks like you have two defaults {} sections. Is that allowed? 
Maybe multipath is only picking up the first one? I'd remove the first 
one/comment out and put user_friendly_names yes in the second one.

Also I think multipath -v3 -d will show you what settings would be 
applied so you don't have to test the behavior by cycling your 
ethernet switch.

For example on one of my systems multipath -v3 shows
mpath1: pgfailback = -2 (controller setting)


After you have it configured right run multipath -v3 without the -d 
(dry run)

Can someone confirm if pgfailback from multipath -v3 output indicates 
the current setting of failback that multipath is using?

John Brier
