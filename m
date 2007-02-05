From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Changes hwtable.c to Support New Pillar Hardware
Date: Mon, 05 Feb 2007 23:51:44 +0100
Message-ID: <1170715904.20348.6.camel@localhost.localdomain>
References: <35D744B011AD9A4A86B5962E85181C781091B776@caex02.trans.corp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <35D744B011AD9A4A86B5962E85181C781091B776@caex02.trans.corp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Srinivas Ramani <sramani@pillardata.com>
Cc: dm-devel@redhat.com, dmo@osdl.org, lmb@suse.de
List-Id: dm-devel.ids


> 
> I am submitting code changes to support  the 
> new Pillar  Axiom 300 and Axiom 550 arrays .
> I request the following change to hwtable.c file .
> This change has been tested at Pillar Data Systems  on RHEL 4 and 5
> beta.
> If you have any comments or  suggestions please let me know.
> 
>  
> 
> /*
> 
>        * Pillar Data controller family
> 
>        *
> 
>        * Maintainer : Srinivasan Ramani
> 
>        * Mail : sramani@pillardata.com
> 
>        */
> 
>       {
> 
>             .vendor        = "Pillar",
> 
>             .product       = "*",
> 
Extended regexp here. Can we settle on "Axiom.*" ?

>             .getuid        = DEFAULT_GETUID,
> 
>             .getprio       = "mpath_prio_alua %n",

I'm wondering : "%d" or "/dev/%n" should work as mpath_prio_alua
parameter. Does "%n" does too ?

Regards,
cvaroqui
