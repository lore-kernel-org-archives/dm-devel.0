From: "Kees Hoekzema" <kees-UraKqTVSIh7k1uMJSBkQmQ@public.gmane.org>
Subject: RE: Reducing amount of logmessages openiscsi/multipath [with md3000i]
Date: Wed, 20 Aug 2008 12:57:24 +0200
Message-ID: <004d01c902b3$878658a0$969309e0$@net>
References: <005b01c901fd$37683660$a638a320$@net> <48AB00C5.8050604@cs.wisc.edu> <20080819211221.GC22302@mars.virtualiron.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <20080819211221.GC22302-1Bc+8x0lmyuevV9vXuyE+laTQe2KTcn/@public.gmane.org>
Content-Language: nl
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: 'device-mapper development' <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids




> -----Original Message-----
> He wants the RDAC hw handler and its path checker (rdac). The MD3000i
> is an
> LSI re-branded box and is the same as the IBM DS3300.
> 
> >
> > You also want to make sure that you are using the md3000i hw handler
> or
> > scsh_dh_module if you are not already. The dm-devel guys can help you
> out.
> 
> Here is the multipath.conf he should be using for MD3000i (or for the
> DS3300
> but will need to modify the vendor/model entry)
> 
>         # Note: The same as the IBM DS3300
>         #
>         device {
>                 vendor                  "DELL"
>                 product                 "MD3000i"
>                 product_blacklist       "Universal Xport"
>                 features                "1 queue_if_no_path"
>                 path_grouping_policy    group_by_prio
>                 hardware_handler        "1 rdac"
>                 path_checker            rdac
>                 prio                    "rdac"
>                 failback                immediate
>         }
> 
> 

This fixed the problem, although a simple flush was not enough to activate
the changes, so it took a bit longer to get the result I wanted. In the end
I saw that it was still using the direction path_checker and noticed that
you cannot change the 'path_checker' on the fly with just a multipath -F /
-v 2, but that a reload of the modules was needed.

$ multipath -ll
webdata (36001ec9000d163110000067f484e260c) dm-0 DELL    ,MD3000i
[size=2.0T][features=0][hwhandler=1 rdac]
\_ round-robin 0 [prio=1000][active]
 \_ 0:0:0:0 sda 8:0   [active][ready]
\_ round-robin 0 [prio=1][enabled]
 \_ 1:0:0:0 sdb 8:16  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:0 sdc 8:32  [active][ghost]
 \_ 3:0:0:0 sdd 8:48  [active][ghost]

That is the output of multipath now, and no more spam in my syslog or dmesg.

(The different priorities you see are because the second path (with a prio
of 1) is a longer path through 1 more switch, so I'd rather not give it a
high priority, and if the '1000' path fails, it just uses the '1' path.)

A big thanks to everyone who directed me on the right path ;)

-kees
