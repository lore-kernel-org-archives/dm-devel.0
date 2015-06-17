From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/4] dm stats: support precise timestamps
Date: Wed, 17 Jun 2015 09:20:33 -0400
Message-ID: <20150617132033.GA3303@redhat.com>
References: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1506091721180.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<20150616153345.GA1069@redhat.com>
	<alpine.LRH.2.02.1506161523430.30788@file01.intranet.prod.int.rdu2.redhat.com>
	<20150617014324.GA30214@redhat.com>
	<alpine.LRH.2.02.1506170908070.15768@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1506170908070.15768@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Laurence Oberman <loberman@redhat.com>, Tao Ma <boyu.mt@taobao.com>, Robin Dong <sanbai@alibaba-inc.com>, dm-devel@redhat.com, Coly Li <colyli@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 17, 2015 at 09:17:40AM -0400, Mikulas Patocka wrote:

[..]
> > > > >  	<program_id>
> > > > >  	  An optional parameter.  A name that uniquely identifies
> > > > >  	  the userspace owner of the range.  This groups ranges together
> > > > 
> > > > We are adding these new parameters/arguments in between existing parameters.
> > > > Will it break any of the existing scritps. Will it make sense to add these
> > > > new parameters at the end. It is more intuitive.
> > > 
> > > It could break someone who uses number as program_id - but there is no 
> > > program on Linux with name that is a pure number.
> > > 
> > 
> > There does not seem to be any restriction that program_id has to be
> > a valid program name. It could be any string. I used a program id
> > of 25 and it works.
> 
> The purpose of program_id is that different programs don't step over each 
> other's statistics. Your program should use the program name as program_id 
> to make sure that it doesn't collide.

I think it would be reasonable use "pid" as program_id when different
instance of same program want to keep track of different regions of
disk.

Thanks
Vivek
