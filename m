From: malahal@us.ibm.com
Subject: Re: About using multipath in SLES 10
Date: Mon, 28 Jan 2008 11:30:45 -0800
Message-ID: <20080128193045.GA17995@us.ibm.com>
References: <479DF5C8.6050909@Voltaire.COM> <20080128163651.GB17040@us.ibm.com>
	<39C75744D164D948A170E9792AF8E7CA110B92@exil.voltaire.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <39C75744D164D948A170E9792AF8E7CA110B92@exil.voltaire.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Erez Zilber [erezz@voltaire.com] wrote:
> And another question:
>  
> I've added the following entry to multipath.conf:
>  
>         multipath {
>                 wwid    3600c0ff000d508d7def2894702000000
>                 alias   red
>         }
>  
> which should represent the following device:
>  
> 3600c0ff000d508d7def2894702000000dm-1 DotHill,R/Evo 2730-2R
> [size=82G][features=0][hwhandler=0]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 16:0:0:0 sdc 8:32  [failed][faulty]
> \_ round-robin 0 [prio=0][active]
>  \_ 17:0:0:0 sdd 8:48  [active][undef] 
>  
> Where should I see "red"? Is it under /dev somewhere?

If it worked, it should be /dev/mapper/red, but I have a suspicion that it
didn't work for you based on your above 'multipath -l' output.

Thanks, Malahal.
