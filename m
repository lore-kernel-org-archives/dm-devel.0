From: malahal@us.ibm.com
Subject: Re: About using multipath in SLES 10
Date: Mon, 28 Jan 2008 08:36:51 -0800
Message-ID: <20080128163651.GB17040@us.ibm.com>
References: <479DF5C8.6050909@Voltaire.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <479DF5C8.6050909@Voltaire.COM>
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
> Hi,
> 
> I guess that I'm missing something:
> 
> I started /etc/init.d/multipathd on SLES 10 sp1 and now I see the
> following devices:
> 
> 3600c0ff000d508d7def2894702000000dm-1 DotHill,R/Evo 2730-2R
> [size=82G][features=0][hwhandler=0]
> \_ round-robin 0 [prio=1][active]
>  \_ 16:0:0:0 sdc 8:32  [active][ready]
> \_ round-robin 0 [prio=1][enabled]
>  \_ 17:0:0:0 sdd 8:48  [active][ready]
> 
> I understand that sdc & sdd are mapped to dm-1. However, I don't
> understand how to use dm-1. For example, I can't run INQUIRY on it:
> 
> seed1:~ # sg_inq /dev/dm-1
> Both SCSI INQUIRY and fetching ATA information failed on /dev/dm-1

All things that work on /dev/sdc may not work on /dev/dm-1. You should
use /dev/sdc instead of /dev/dm-1 for those cases. You should be able to
use /dev/dm-1 for normal I/O (like dd, mounting etc.)

Thanks, Malahal.
