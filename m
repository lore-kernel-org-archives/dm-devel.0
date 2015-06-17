From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/4] dm stats: support precise timestamps
Date: Tue, 16 Jun 2015 21:43:24 -0400
Message-ID: <20150617014324.GA30214@redhat.com>
References: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1506091721180.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<20150616153345.GA1069@redhat.com>
	<alpine.LRH.2.02.1506161523430.30788@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1506161523430.30788@file01.intranet.prod.int.rdu2.redhat.com>
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

On Tue, Jun 16, 2015 at 03:27:48PM -0400, Mikulas Patocka wrote:
> 
> 
> On Tue, 16 Jun 2015, Vivek Goyal wrote:
> 
> > On Tue, Jun 09, 2015 at 05:21:39PM -0400, Mikulas Patocka wrote:
> > 
> > [..]
> > >  Messages
> > >  ========
> > >  
> > > -    @stats_create <range> <step> [<program_id> [<aux_data>]]
> > > +    @stats_create <range> <step>
> > > +    		[<number_of_optional_arguments> <optional_arguments>...]
> > > +		[<program_id> [<aux_data>]]
> > >  
> > >  	Create a new region and return the region_id.
> > >  
> > > @@ -48,6 +54,17 @@ Messages
> > >  	  "/<number_of_areas>" - the range is subdivided into the specified
> > >  				 number of areas.
> > >  
> > > +	<number_of_optional_arguments>
> > > +	  The number of optional arguments
> > > +
> > > +	<optional_arguments>
> > > +	  The following optional arguments are supported
> > > +	  precise_timestamps - use precise timer with nanosecond resolution
> > > +	  	instead of the "jiffies" variable.  When this argument is
> > > +		used, the resulting times are in nanoseconds instead of
> > > +		milliseconds.  Precise timestamps are a little bit slower
> > > +		to obtain than jiffies-based timestamps.
> > > +
> > 
> > Instead of "precise_timestams" will it make sense to call it
> > "nanosecond_timestamps" or "ns_timestamps".
> > 
> > 
> > >  	<program_id>
> > >  	  An optional parameter.  A name that uniquely identifies
> > >  	  the userspace owner of the range.  This groups ranges together
> > 
> > We are adding these new parameters/arguments in between existing parameters.
> > Will it break any of the existing scritps. Will it make sense to add these
> > new parameters at the end. It is more intuitive.
> 
> It could break someone who uses number as program_id - but there is no 
> program on Linux with name that is a pure number.
> 

There does not seem to be any restriction that program_id has to be
a valid program name. It could be any string. I used a program id
of 25 and it works.

[root@tiger ~]# dmsetup message docker-docker--pool 0 @stats_create - /1
25
0

[root@tiger ~]# dmsetup message docker-docker--pool 0 @stats_create - /2
30
1

[root@tiger ~]# dmsetup message docker-docker--pool 0 @stats_list 25
0: 0+585465856 585465856 25 -

[root@tiger ~]# dmsetup message docker-docker--pool 0 @stats_list
0: 0+585465856 585465856 25 -
1: 0+585465856 292732928 30 -

May be we can introduce a new message to handle this new number of
arguments syntax. Say "stats_create_v2". That way existing programs
will not be broken, if any.


> We can't add it at the end because program_id and aux_data are already 
> optional arguments.
> 
> > Also, I was wondering that why do we need to introduce this notion of
> > number of optional arguments. Can't we just introduce another optional
> > parameter [ns_timestamps]. That feels little simpler.
> 
> Then, it will clash with program_id "ns_timestamps". Device mapper uses 
> this "number of optional arguments" notation at other places, so I used it 
> too,

BTW, I have a very stupid question. This probably stems from the fact that
I don't know enough about dm argument parsing. 

Why can't I pass the argument in same format as command line. So how
about.

@stats_create [program_id=<program_id>] [aux_data=<aux_data>]

That way we know what arguments are coming. There is no guessing and 
handling optional parameters is easy too.

Thanks
Vivek
