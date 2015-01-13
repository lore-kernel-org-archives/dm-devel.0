From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 3/6] libmultipath: add overrides section to
 multipath.conf
Date: Tue, 13 Jan 2015 01:01:58 +0100
Message-ID: <20150113010158.00006883@localhost>
References: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
	<1416377859-15073-4-git-send-email-bmarzins@redhat.com>
	<CABr-GndVm5ct_E7UoF86no5b36k8MpLU4KD5pYtO=h1NiT4LGQ@mail.gmail.com>
	<20150112001525.0000473f@localhost>
	<CABr-Gnc_3KwO9THMcHW2Yam=QdzK=cJaFxrbevAS-ATOxuJoXw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gnc_3KwO9THMcHW2Yam=QdzK=cJaFxrbevAS-ATOxuJoXw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

Hello Christophe,

Christophe Varoqui wrote:
> Hi,
> 
> the precedence chain is :
> 
> multipaths > user-specified per-device > default per-device > default
> 
> The issue adressed by Ben's patch would not be solved by your suggestion,
> as far as I can see. The proposed override section is just a way not repeat
> a per-device in each multipath (insane) or device (tedious) section.

care to explain why setting the precedence to

multipaths > user-specified per-device > default > default per-device

would not fix the issue?

Lets assume the following default device and user configuration:

.vendor        = "COMPELNT",
.product       = "Compellent Vol",
.pgpolicy      = MULTIBUS,
.pgfailback    = -FAILBACK_IMMEDIATE
.no_path_retry = NO_PATH_RETRY_QUEUE,
.checker_name  = TUR

defaults {
	no_path_retry fail
}

devices {
        device {
                vendor "COMPELNT"
                product "Compellent Vol"
		path_grouping_policy "group_by_prio"
	}
}

multipaths {
	multipath {
		wwid 1234
		failback 15
	}
}

The default section should change no_path_retry from "queue" to "fail".
The device section should change path_grouping_policy from "multibus"
to "group_by_prio" for "COMPELNT/Compellent Vol".
The multipath section should change failback from "immediate" to 15
for wwid 1234.
The path_checker would still be "tur".

Is this not what the "overrides" patch intended?

Sebastian
