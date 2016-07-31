From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: Pillar/Axiom supports
	failback=immediate
Date: Sun, 31 Jul 2016 02:02:41 +0200
Message-ID: <4527a2e7-83b8-7c19-041d-a01fdb5cd684@gmail.com>
References: <<1469913348-9350-1-git-send-email-xose.vazquez@gmail.com>
	<e46f78fd-b5cd-4498-a96e-d30b6a58d0d3@default>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e46f78fd-b5cd-4498-a96e-d30b6a58d0d3@default>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Srinivas Ramani <srinivas.ramani@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/31/2016 01:18 AM, Srinivas Ramani wrote:

Pillar/Axiom and "Oracle FS" configs look the same.

>                 .vendor        = "^Pillar(  )?$",
>                 .product       = "^Axiom"
>                 .getuid        = DEFAULT_GETUID,
>                 .features      = DEFAULT_FEATURES,
>                 .hwhandler     = DEFAULT_HWHANDLER,
>                 .selector      = DEFAULT_SELECTOR,
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .pgfailback    = FAILBACK_UNDEF, <<<<<-----------

Why pgfailback is FAILBACK_UNDEF(manual)?, when in your
/etc/multipath.conf template it's "immediate".

> Auto-generated template from Oracle FS Path Manager 4.0:
>         vendor                "^Pillar(  )?$"
>         product               "^Axiom"
>         path_grouping_policy  group_by_prio
>         prio                  oraclefspm
>         path_checker          oraclefspm
>         failback              immediate          <<<<<-----------
>         path_selector         "round-robin 0"
> 
> Template from Axiom Path Manager 3.1 for RHEL-6.1:
>         vendor               "Pillar"
>         product              "*"
>         path_grouping_policy group_by_prio
>         prio                 pillarapm
>         path_checker         pillarapm
>         failback             immediate          <<<<<-----------
>         no_path_retry        60
>         dev_loss_tmo         60
>         fast_io_fail_tmo     30

Thank you.
