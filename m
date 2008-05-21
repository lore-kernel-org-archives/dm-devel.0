From: Tore Anderson <tore@linpro.no>
Subject: Re: Round Robin vs Active/Passive
Date: Wed, 21 May 2008 23:01:28 +0200
Message-ID: <48348DA8.2010803@linpro.no>
References: <8a6b34b03e0524aa66c862534fee9b7a@www3.mail.volny.cz><18484.2693.62883.535755@notabene.brown>	<ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com><ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>	<483468AD.7@linpro.no>
	<ABFD05FF09D13E4883B757E75603624D011E95FF@ex-sea1.vistocorp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ABFD05FF09D13E4883B757E75603624D011E95FF@ex-sea1.vistocorp.com>
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
Cc: Michael Denney <mdenney@visto.com>
List-Id: dm-devel.ids

Hi,

* Craig Simpson

> Amazing Info, thanks!

Glad I could help.

> Changed my Defaults to this:
> 
> defaults {
>         udev_dir                /dev
>         polling_interval        10
>         selector                "round-robin 0"
>         path_grouping_policy    group_by_prio
>         getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>         prio_callout            /sbin/mpath_prio_hds_modular
>         path_checker            readsector0
>         rr_min_io               100
>         rr_weight               priorities
>         failback                immediate
>         no_path_retry           fail
>         user_friendly_name      yes
> }

You need

  prio_callout "/sbin/mpath_prio_hds_modular /dev/%n"

for the priority to be determined correctly.

Anyway I'm a bit surprised that you need to specify these things, the
AMS series do have a entry in hwtable.c in multipath-tools 0.4.8 at
least.  Running an old version maybe?  They don't differ much from what
you have there, though.

> So figure I don't need to include anything in my aliases, since the
> defaults are set.

You figure correctly.

> Did a multipathd -k
> And a reconfigure

You also need to actually reload the multipath maps in the kernel, by
invoking e.g. "multipath -v2".

> But when doing a multipath -l Not sure if it looks correct:
> 
> asm01 (1HITACHI_D60090910032) dm-6 HITACHI,DF600F
> [size=32G][features=0][hwhandler=0]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 0:0:1:32 sdm 8:192 [active][undef]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 0:0:0:32 sdb 8:16  [active][undef]

You need to use "multipath -ll" (two l's) for it to show you the
priority, but it looks like multipathd have everything figured out:

> Also a multipathd> show topology
> 
> reload: asm01  (1HITACHI_D60090910032) dm-6  HITACHI,DF600F
> [size=32G ][features=0       ][hwhandler=0        ]
> \_ round-robin 0 [prio=1][enabled]
>  \_ 0:0:1:32 sdm 8:192 [active][ready]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 0:0:0:32 sdb 8:16  [active][ready]

It's a bit strange that it actually is able to determine the priority,
considering that you have the prio_callout set incorrectly in your
defaults section.

I suspect that the default values from hwtable.c comes into play and
overrides your settings anyway.  You can check this by running "show
config" from inside "multipathd -k" - if you have a device section for
your vendor HITACHI, product DF.* there that might be what's going on.

> Looks like I have [enabled] [enabled] ...
> But it should be [active] [enabled]

Have you sent any I/O to the device after the configuration change?  The
PG doesn't transition from enabled to active before some regular I/O has
been sent there.  Just reading some data from it should suffice.

Regards,
-- 
Tore Anderson
