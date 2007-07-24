From: Trevor Astrope <astrope@tabbweb.com>
Subject: Re: Re: Problem with Multipath on Hitachi DF600F (Stefan
	Bader)
Date: Tue, 24 Jul 2007 13:19:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0707241313290.23147@jimi.tabbweb.com>
References: <C67364BD62907640A033D1F4094CA7B708E7D0DB@UKSPKEVS101.corp.hds.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C67364BD62907640A033D1F4094CA7B708E7D0DB@UKSPKEVS101.corp.hds.com>
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

Thanks. I installed pp_hds_modular v2.00 and updated multipath.conf to use 
the queue_if_no_path option.

I'm not using Qlogic hba's, but Emulex LPe11000-S instead. Could this be 
part of the problem?

Btw, multipath -ll reported the failed path as back online before the 
second controller on the DF600 was taken offline. We also have a Solaris 9 
machine running storage foundation with dmp connected to the df600 and it 
didn't have any issues. The sf dmp took longer to detect the path was back 
online, so we waited longer for it to enable the path before taking the 
second controller offline.

On Tue, 24 Jul 2007, Matthias Rudolph wrote:

>
> Sometimes it happens that both pathes to a SAN LUN are not available for
> a short time. Because it is not possible to enable any timeouts inside
> the HBA driver (QLogic) you have to handle this situation a layer above.
> You can do it with the DM Multipath feature "queue_if_no_path".
>
> I have upgraded the HDS prioritizer to version 2.00. You will find all
> the stuff on:
>
> http://homepage.mac.com/i_am_fable/FileSharing36.html
>
> Regards
>
> Matthias Rudolph
> Country Support Germany
> HITACHI DATA SYSTEMS
> matthias.rudolph@hds.com
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
