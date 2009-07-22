From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Multipath path ready but not active
Date: Wed, 22 Jul 2009 12:33:31 -0700
Message-ID: <1248291211.9724.17.camel@chandra-ubuntu>
References: <6E9F6DF8BB260247A551EB65F5D86EDC90B59749@shandy.Beer.Town>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6E9F6DF8BB260247A551EB65F5D86EDC90B59749@shandy.Beer.Town>
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


On Wed, 2009-07-22 at 13:34 -0500, Jim Lester wrote:
> We were doing some testing today with SLES, multipathing and iSCSI. During the test we fail
> our port on the storage controller which causes the target to move to a new port. The iSCSI
> initiator on the SLES box comes back just fine, but multipath doesn't re-activate the path,
> causing IO to hold. 
> 
> mpatha (36000d3100003d5000000000000000013) dm-7 COMPELNT,Compellent Vol
> [size=30G][features=1 queue_if_no_path][hwhandler=0]
> \_ round-robin 0 [prio=1][enabled]
>  \_ 5:0:0:5 sdm 8:192 [failed][ready]
> 
> If we run 'multipath' from the command line the path becomes active again and everything resumes.
> The failback parameter isn't set, so it should be doing the default behavior of immediate, but 
> even when we set it, it didn't work correctly. 

default is "manual"

you mean to say you have set "failback" to "immediate" and it still
didn't recover ?

Can you confirm if multipathd was running when you had the failback ?
> 
> Below is our multipath.conf file as well as all the version involved. Does anybody have any input?
> 
> defaults {
>         user_friendly_names             yes
>         path_grouping_policy            multibus
> }
> 
> blacklist {
>         devnode         "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>         devnode         "^hd[a-z][[0-9]*]"
>         vendor          "*"
> }
> 
> blacklist_exceptions {
>         vendor  "COMPELNT"
> }
> 
> devices {
>         device {
>                 vendor                          COMPELNT
>                 product                         "Compellent Vol"
>                 path_checker                    tur
>                 polling_interval                10
>                 no_path_retry                   queue
>         }
> }
> 
> 
> Linux manns 2.6.16.60-0.21-smp #1 SMP Tue May 6 12:41:02 UTC 2008 x86_64 x86_64 x86_64 GNU/Linux
> multipath-tools v0.4.8 (08/02, 2007)
> iscsid version 2.0-868
> 
> ---
> Jim Lester | Linux/Mac Product Specialist
> Jim.Lester@Compellent.com
> (o) 952.294.2802
> (c) 763.218.6012
> Compellent Technologies | www.compellent.com
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
