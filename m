From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Multipathing hints request
Date: Fri, 22 Jul 2005 11:58:28 +0200
Message-ID: <20050722095828.GA13294@averon.dyndns.org>
References: <20050721143110.GD4240@pan.dimdi.de>
	<1121970687.19015.78.camel@zezette>
	<20050722083722.GJ4240@pan.dimdi.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050722083722.GJ4240@pan.dimdi.de>
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

> 
> multipaths {
>         multipath {
>                 wwid                    360060160200161a037f90d75dfca84f7
>                 alias                   416L3
>                 path_grouping_policy    failover
>                 path_selector           "round-robin 0"
>                 features                "0"
>                 hardware_handler        "1 emc"
>         }
> }
> 
hardware_handler and fetures params must be in the devices {} section, not in multipaths {}.

Also, pgpolicy is best set to group_by_serial with Clariion hw.
You'll see it produce same grouping than failover in your case.

Regards,
cvaroqui
