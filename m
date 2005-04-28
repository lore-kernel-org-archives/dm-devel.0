From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: what's up with pp_balance_units?
Date: Fri, 29 Apr 2005 00:40:51 +0200
Message-ID: <1114728052.10504.12.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321A959@SRMANNING.eng.emc.com>
	<1114720580.10504.7.camel@zezette>
	<20050428.175252.71083259.k-ueda@kde.biglobe.ne.jp@kde.biglobe.ne.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050428.175252.71083259.k-ueda@kde.biglobe.ne.jp@kde.biglobe.ne.jp>
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

You need to recheck with 0.4.5-pre1, as it is now allowed and encouraged
to have (null) prio callouts. Does that look good ?

        if (mask & DI_PRIO) {
                select_getprio(pp);

                if (!pp->getprio) {
                        pp->priority = 1;
                } else if (apply_format(pp->getprio, &buff[0], pp)) {
                        condlog(0, "error formatting prio callout
command");
                        pp->priority = -1;
                } else if (execute_program(buff, prio, 16)) {
                        condlog(0, "error calling out %s", buff);
                        pp->priority = -1;
                } else
                        pp->priority = atoi(prio);

                condlog(3, "prio = %u", pp->priority);
        }



struct path -> priority is now an "int", thanks for the report.

Regards,
cvaroqui

On jeu, 2005-04-28 at 17:52 -0400, k-ueda@ct.jp.nec.com wrote:
> Hi,
> 
> On Thu, 28 Apr 2005 22:36:20 +0200, christophe varoqui wrote:
> > It's not default because its code path is badly inefficient.
> 
> How about "don't use callout, and set same priority for all path"
> by defualt?  It's more efficient, I think.
> 
> And, I found a possible bug that pp->priority is defined as 
> "unsigned int" while it's used like "int".
> But, if you fix this bug, "/bin/false" doesn't work as callout
> because it always fails.
> So I think it will fit your policy to add a feature of
> "do not use callout" and use it by default.
> 
> 
> Bug in multipath-tools-0.4.4
> ============================
> If priority callout is "/bin/false", in devinfo(), execute_program()
> returns non-zero, since "/bin/false" exits by 1 even if "/bin/false"
> terminate normally.  So, pp->priority is set by "-1".
> 
> ---------------------------------------------------------------------
> libmultipath/discovery.c:477:
> 
>         /*
>          * get path prio
>          */
>         if (mask & DI_PRIO) {
>                 select_getprio(pp);
> 
>                 if (apply_format(pp->getprio, &buff[0], pp)) {
>                         condlog(0, "error formatting prio callout command");
>                         pp->priority = -1;
>                 } else if (execute_program(buff, prio, 16)) {
>                         condlog(0, "error calling out %s", buff);
>                         pp->priority = -1;
>                 } else
>                         pp->priority = atoi(prio);
> 
>                 condlog(3, "prio = %u", pp->priority);
>         }
> ---------------------------------------------------------------------
> 
> In coalesce_paths(), if "priority" of "struct path" is less than "0",
> the multipath which include the path isn't mapped.
> But this "if check" is always false even if it is set by "-1", since
> "priority" of "struct path" is declared with "unsigned int".
> Should it be declared with "int"?
> 
> ---------------------------------------------------------------
> multipath/main.c:713:
>                 if (pp1->priority < 0)
>                         mpp->action = ACT_NOTHING;
> 
> multipath/main.c:738:
>                         if (pp2->priority < 0)
>                                 mpp->action = ACT_NOTHING;
> ---------------------------------------------------------------
> 
> Regards,
> Ky (Kiyoshi Ueda)
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
