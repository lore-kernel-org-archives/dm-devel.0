From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 3/6] libmultipath: add overrides section to
 multipath.conf
Date: Tue, 13 Jan 2015 11:08:08 -0600
Message-ID: <20150113170808.GZ30600@ask-08.lab.msp.redhat.com>
References: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
	<1416377859-15073-4-git-send-email-bmarzins@redhat.com>
	<CABr-GndVm5ct_E7UoF86no5b36k8MpLU4KD5pYtO=h1NiT4LGQ@mail.gmail.com>
	<20150112001525.0000473f@localhost>
	<CABr-Gnc_3KwO9THMcHW2Yam=QdzK=cJaFxrbevAS-ATOxuJoXw@mail.gmail.com>
	<20150113010158.00006883@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150113010158.00006883@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 13, 2015 at 01:01:58AM +0100, Sebastian Herbszt wrote:
> Hello Christophe,
> 
> Christophe Varoqui wrote:
> > Hi,
> > 
> > the precedence chain is :
> > 
> > multipaths > user-specified per-device > default per-device > default
> > 
> > The issue adressed by Ben's patch would not be solved by your suggestion,
> > as far as I can see. The proposed override section is just a way not repeat
> > a per-device in each multipath (insane) or device (tedious) section.
> 
> care to explain why setting the precedence to
> 
> multipaths > user-specified per-device > default > default per-device
> 
> would not fix the issue?

I don't think the issue is that it wouldn't solve my problem.  The issue
is that it isn't as simple as it looks, and causes a large impact to
existing users.

First off, I assume you mean

multipaths > user per-device > user default > builtin per-device >
builtin default

What happens when users modify a builtin device configuration.  Does the
whole device configuration move up in presidence, or only the user
modified parts?  If the whole device does, This will cause lots of
unexpected effects.  If not, there will often be two devices sections
controlling a multipath device along with two defaults sections, making
the configuration output that much harder to read (I admit that the
overrides section is basically a second devices section, but I assume
that this feature will be rarely used. My original all_devs patch had
the benefit that it adjusted all the device configurations directly, so
users sill just needed to look in three sections to understand their
configuration, instead of five with your method)

Also, adding a new section doesn't impact existing user configurations
or user's existing understanding of how the multipath tools work.  Your
solution would cause a lot of broken configurations and relearning. This
last point is my biggest objection.  If we were starting from scratch
your method would have probably made configuration enough more
inituitive to justify the extra work of dealing with and displaying the
two extra configuration sections. As it stands, I don't think it adds
enough benefit to be worth the pain.

-Ben

> 
> Lets assume the following default device and user configuration:
> 
> .vendor        = "COMPELNT",
> .product       = "Compellent Vol",
> .pgpolicy      = MULTIBUS,
> .pgfailback    = -FAILBACK_IMMEDIATE
> .no_path_retry = NO_PATH_RETRY_QUEUE,
> .checker_name  = TUR
> 
> defaults {
> 	no_path_retry fail
> }
> 
> devices {
>         device {
>                 vendor "COMPELNT"
>                 product "Compellent Vol"
> 		path_grouping_policy "group_by_prio"
> 	}
> }
> 
> multipaths {
> 	multipath {
> 		wwid 1234
> 		failback 15
> 	}
> }
> 
> The default section should change no_path_retry from "queue" to "fail".
> The device section should change path_grouping_policy from "multibus"
> to "group_by_prio" for "COMPELNT/Compellent Vol".
> The multipath section should change failback from "immediate" to 15
> for wwid 1234.
> The path_checker would still be "tur".
> 
> Is this not what the "overrides" patch intended?
> 
> Sebastian
