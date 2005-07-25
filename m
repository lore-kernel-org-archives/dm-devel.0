From: niemann@dimdi.de (Philipp Niemann)
Subject: Re: Multipathing hints request
Date: Mon, 25 Jul 2005 15:02:56 +0200
Message-ID: <20050725130256.GO4240@pan.dimdi.de>
References: <20050721143110.GD4240@pan.dimdi.de>
	<1121970687.19015.78.camel@zezette>
	<20050722083722.GJ4240@pan.dimdi.de>
	<20050722095828.GA13294@averon.dyndns.org>
	<20050722120955.GL4240@pan.dimdi.de>
	<20050724200238.GJ8005@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050724200238.GJ8005@marowsky-bree.de>
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

Jo!
A very happy me shouts out thanks to all the list. Special thanks to
Lars who gave the final hint:

On Sun, 24.07.2005-22:02:38 +0200, Lars Marowsky-Bree wrote:
> On 2005-07-22T14:09:55, Philipp Niemann <niemann@dimdi.de> wrote:
> > 
[snip]
> >                 hardware_handler        "1 emc"
> >         }
> 
> For the Clariion 4500, you need to set the hardware_handler to
> 	"3 emc 1 0"
> 
> (The trespass command to transfer ownership of a LU from one
> Service-Processor to the other is different from the FC4500 to the EMC
> CX series. I've got to admit I've not tested the FC4500 yet, though.)
> 
> You also want the pp_emc callout from the newer multipath-tools
> package and use that as the priority callout, and group by priority.

Actually I am using 'hardware_handler "3 emc 1 1"' in my config file now.
Without the reservation bit honouring the failover didn't work. I also
upgraded to multipath-tools-0.4.4 to get the pp_emc thingy.

That gives me a configuration where I can trespass LUNs on the Array via
the Management Suite and get them switched back by my linux box.
The other way works too, so that a write operation on a SAN Filesystem
continues to write even if I pull out the active cable. When I plug it
back in place after some time, the system even switches back to the
default path. Wow! Only scratch in the surface is that the devices come
back in with new names, so former sde becomes sdo. Maybe persistent
bindings might help.

I got somewhat scared as the system issues _lots_ of IO Errors. But a
filesystem check after IO Operation finished gave no problems
whatsoever. So I guess it worked alright.

Thanks again for your support,
Philipp
-- 
Philipp Niemann                                       DIMDI
Abteilung D / AG D4
Peripherie / UNIX-Systembetreuer     Waisenhausgasse 36-38a
Tel. : 0221/4724-281                            50676 Koeln
