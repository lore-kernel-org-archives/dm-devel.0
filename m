From: "Sebastian Herbszt" <herbszt@gmx.de>
Subject: Re: [PATCH 16/18] multipath-tools: Use ALUA for HP 3PAR
Date: Sun, 31 Jul 2016 00:14:51 +0200
Message-ID: <trinity-e6c25fb4-7664-4f5d-9885-5aba45504689-1469916891284@3capp-gmx-bs13>
References: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>,
	<1469838506-15689-16-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469838506-15689-16-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Xose Vazquez Perez wrote:
> Original patch from Hannes Reinecke <hare@suse.de>:
> 
> .vendor = "3PARdata",
> .product = "VV",
> .features = DEFAULT_FEATURES,
> - .hwhandler = DEFAULT_HWHANDLER,
> - .pgpolicy = MULTIBUS,
> - .pgfailback = FAILBACK_UNDEF,
> + .hwhandler = "1 alua",
> + .pgpolicy = GROUP_BY_PRIO,
> + .pgfailback = -FAILBACK_IMMEDIATE,
> .rr_weight = RR_WEIGHT_NONE,
> - .no_path_retry = NO_PATH_RETRY_UNDEF,
> - .checker_name = DEFAULT_CHECKER,
> - .prio_name = DEFAULT_PRIO,
> + .no_path_retry = 18,
> + .checker_name = TUR,
> + .prio_name = PRIO_ALUA,
> .prio_args = NULL,
> 
> Sebastian was not convinced with this change, full thread: https://marc.info/?t=146175638600002
> But there is no automatic way to change .pgpolicy from MULTIBUS to GROUP_BY_PRIO.
> So we should stick to latest manufacturer's recommendations:

So 'retain_attached_hw_handler' suggested by Hannes doesn't work?

Sebastian
