From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [SUMMARY] My EMC CX300 and multipath-tools setup
Date: Sun, 18 Sep 2005 02:27:14 +0200
Message-ID: <1127003234.6268.13.camel@zezette>
References: <432A7177.2090309@theorematica.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <432A7177.2090309@theorematica.it>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nicola Murino <n.murino@theorematica.it>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Thanks for the summary.
Happy to see you were busy during my vacation :)

On ven, 2005-09-16 at 09:17 +0200, Nicola Murino wrote:

> my mutipath-tools configuration file is the following:
> 
> grep -v "#" /etc/multipath.conf
> defaults {
>         multipath_tool  "/sbin/multipath -v0"

This keyword is obsolete, leave it out.
I'll make that explicit in the templates upstream.

>         udev_dir        /dev
>         polling_interval 5
>         default_selector        "round-robin 0"
>         default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
>         default_prio_callout    "/bin/true"

Try to comment out that line, as you don't use a prioritizer anyway.
Your PG switching spam may come from that ... please report about that.

>         failback        immediate
> }
> multipaths {
> 
>         multipath {
>                 wwid                    3600601608c901200ccfe543f4053d911
>                 alias                   200Gb

'b' is commonly used for bits, 'B' for bytes.

Anyway, I guess you search for problems naming your LU after their
size ... sizes change, and are not garanteed to stay unique.

>                 path_grouping_policy    failover
>                 path_checker            readsector0

define as a default ?

>                 path_selector           "round-robin 0"
>                 failback                immediate

redundant with the defaults ... harmless but confusing.

>         }
> }
> 
> multipathd start at boot time
> 
> rc-update add multipathd default

> some tests:
> 
> 1) one path failure
> 
> /var/log/messages
> 
> Sep 14 19:33:21 nodob multipathd: 8:96: emc_clariion_checker: query command indicates error
> Sep 14 19:33:21 nodob multipathd: checker failed path 8:96 in map 300Gb
> Sep 14 19:33:21 nodob multipathd: 8:112: emc_clariion_checker: query command indicates error
> Sep 14 19:33:21 nodob multipathd: checker failed path 8:112 in map 200Gb
> Sep 14 19:33:21 nodob multipathd: 8:128: emc_clariion_checker: query command indicates error
> Sep 14 19:33:21 nodob multipathd: checker failed path 8:128 in map 3600601608c901200a8b8972f4053d911
> Sep 14 19:33:21 nodob multipathd: 8:144: emc_clariion_checker: query command indicates error
> Sep 14 19:33:21 nodob multipathd: checker failed path 8:144 in map 3600601608c901200bc7680294053d911
> Sep 14 19:33:21 nodob multipathd: 8:160: emc_clariion_checker: query command indicates error
> Sep 14 19:33:21 nodob multipathd: checker failed path 8:160 in map 5Gb
> Sep 14 19:33:21 nodob multipathd: remove sdg path checker
> Sep 14 19:33:21 nodob multipathd: remove sdh path checker
> Sep 14 19:33:21 nodob multipathd: remove sdi path checker
> Sep 14 19:33:21 nodob multipathd: remove sdj path checker
> Sep 14 19:33:21 nodob multipathd: remove sdk path checker
> Sep 14 19:33:22 nodob multipathd: 8:160: mark as failed
> Sep 14 19:33:43 nodob multipathd: 300Gb: switch to path group #1
> Sep 14 19:33:43 nodob multipathd: 3600601608c901200a8b8972f4053d911: switch to path group #1
> Sep 14 19:33:43 nodob multipathd: 3600601608c901200bc7680294053d911: switch to path group #1
> Sep 14 19:33:43 nodob multipathd: 5Gb: switch to path group #1
> Sep 14 19:33:43 nodob multipathd: 8:96: mark as failed
> Sep 14 19:33:43 nodob multipathd: 8:128: mark as failed
> Sep 14 19:33:43 nodob multipathd: 8:144: mark as failed
> Sep 14 19:33:43 nodob multipathd: 8:160: mark as failed
> 
> 

> I can write to the storage without problem
> 
> 2) the failed path turn up
> 

> I read and write without problem
> 
> every few seconds I have the following messages in /var/log/messages
> 
> Sep 14 19:36:58 nodob multipathd: 300Gb: switch to path group #1
> Sep 14 19:36:58 nodob multipathd: 200Gb: switch to path group #2
> Sep 14 19:36:58 nodob multipathd: 3600601608c901200a8b8972f4053d911: switch to path group #1
> Sep 14 19:36:58 nodob multipathd: 3600601608c901200bc7680294053d911: switch to path group #1
> Sep 14 19:36:58 nodob multipathd: 5Gb: switch to path group #1
> 
> 
> Cristophe is ok?
> 
One time would be ok.
Looping switches are harmless, but strange anyway.
As suggested earlier, try commenting out the prioritizer configlet.

> 3) other path failure
> 

> 4) reboot with one path failed:
> 

> 5) the failed path return up
> 

> 6) If I set multibus instead of failover in multipath.conf I have read-only filesystem after a path failure
> 
> Conclusion
> 
> For me multipath-tools on EMC CX300 works fine, there are only issue if i try multibus instead of failover, but I don't need multibus
> 
> thanks for multipath-tools,
> 
your welcome,
-- 
christophe varoqui <christophe.varoqui@free.fr>
