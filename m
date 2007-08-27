From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: dm-rdac not working?
Date: Mon, 27 Aug 2007 13:08:48 -0700
Message-ID: <1188245328.9504.41.camel@linuxchandra>
References: <46D2E298.1020702@linpro.no>
	<1188236026.9504.10.camel@linuxchandra>  <46D3188A.3090405@linpro.no>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46D3188A.3090405@linpro.no>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tore Anderson <tore@linpro.no>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2007-08-27 at 20:31 +0200, Tore Anderson wrote:
> * Chandra Seetharaman
> 
> > What version of multipath tools are you using ?
> 
>    0.4.7.
> 
> > Can you attach your multipath.conf file. You should be using the rdac
> > path checker instead of the tur path checker.
> 
>    Hmm, this was added in 0.4.8...  What's the difference between the
>   rdac path checker and the tur checker?  Anyway, it appears to me that

tur checker just sends a test unit ready to see if the path is good.
Whereas rdac sends a c9 page inquiry and determines the state of the
path.

>   the problem here is with the kernel hardware handler, not in the
>   userspace path checker, wouldn't you agree?  The hardware handler is
>   invoked unpon pg init as expected, but fails to do its job.

That is true. But, I am wondering if what you have is based on the LSI
Engenio based controller (and hence the controller does not understand
the MODE_SELECT command).

What mode do you have your storage device configured in ? rdac or AVT ?

BTW, rdac path checker would show [ghost] instead of [ready] for the
passive path.

> 
> > Can you attach the o/p of "multipath -ll"
> 
> mysql (3600a0b80002984ae0000179c46a68843)
> [size=20 GB][features=1 queue_if_no_path][hwhandler=1 rdac]
> \_ round-robin 0 [prio=0][enabled]
>   \_ 3:0:0:1 sdd 8:48  [active][ready]
>   \_ 4:0:0:1 sdh 8:112 [active][ready]
> \_ round-robin 0 [prio=6][active]
>   \_ 3:0:1:1 sdg 8:96  [active][ready]
>   \_ 4:0:1:1 sdj 8:144 [active][ready]

Where did you get mpath_prio_rdac from ?

In 0.4.7 you could use mpath_prio_tpc instead (it behaves exactly as
mpath_prio_rdac in 0.4.8).

Can you apply the attached debug patch, repeat your test and send me the
log.

Thanks,

chandra
<snip>
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
