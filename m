From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: multipath-tools multipath.conf.synthetic
Date: Tue, 08 Mar 2011 09:57:20 +0000
Message-ID: <4D75FD80.2030600@redhat.com>
References: <20110307184204.25414.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000505020704030303060501"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110307184204.25414.qmail@sourceware.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: dm-cvs@sourceware.org, bmarzins@sourceware.org
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000505020704030303060501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 03/07/2011 06:42 PM, bmarzins@sourceware.org wrote:
> CVSROOT:	/cvs/dm
> Module name:	multipath-tools
> Branch: 	RHEL5_FC6
> Changes by:	bmarzins@sourceware.org	2011-03-07 18:42:03
> 
> Modified files:
> 	.              : multipath.conf.synthetic 
> 
> Log message:
> 	Forgot to remove /bin/true reference from multipath.conf.synthetic. Removing.
> 	Not applicable upstream.
> 
> Patches:
> http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.synthetic.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.6&r2=1.11.2.7
> 
> --- multipath-tools/multipath.conf.synthetic	2008/09/08 22:01:19	1.11.2.6
> +++ multipath-tools/multipath.conf.synthetic	2011/03/07 18:42:03	1.11.2.7
> @@ -8,7 +8,7 @@
>  #	selector		"round-robin 0"
>  #	path_grouping_policy	multibus
>  #	getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
> -#	prio_callout		/bin/true
> +#	prio_callout		none
>  #	path_checker		readsector0
>  #	rr_min_io		100
>  #	max_fds			8192

Thanks Ben, I think we should also remove the reference from
multipath/multipath.conf.redhat as this is the default /etc/multipath.conf on
Red Hat systems and users blindly un-commenting the example may create problems
(e.g. boot from SAN fails) - patch attached.

#defaults {
#	udev_dir		/dev
#	polling_interval 	10
#	selector		"round-robin 0"
#	path_grouping_policy	multibus
#	getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
#	prio_callout		/bin/true
#	path_checker		readsector0
#	rr_min_io		100
#	max_fds			8192
#	rr_weight		priorities
#	failback		immediate
#	no_path_retry		fail
#	user_friendly_names	yes
#}

Regards,
Bryn.

--------------000505020704030303060501
Content-Type: text/plain;
	name="multipath-tools-drop-bin-true-prio-callout.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="multipath-tools-drop-bin-true-prio-callout.patch"

diff -up multipath-tools/multipath/multipath.conf.redhat.orig multipath-tools/multipath/multipath.conf.redhat
--- multipath-tools/multipath/multipath.conf.redhat.orig	2011-03-08 09:55:59.000000000 +0000
+++ multipath-tools/multipath/multipath.conf.redhat	2011-03-08 09:56:06.000000000 +0000
@@ -25,7 +25,7 @@ defaults {
 #	selector		"round-robin 0"
 #	path_grouping_policy	multibus
 #	getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
-#	prio_callout		/bin/true
+#	prio_callout		none
 #	path_checker		readsector0
 #	rr_min_io		100
 #	rr_weight		priorities

--------------000505020704030303060501
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000505020704030303060501--
