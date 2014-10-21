From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: rr_min_io vs rr_min_io_rq on 6.5
Date: Tue, 21 Oct 2014 16:00:03 -0500
Message-ID: <20141021210003.GP10973@ask-08.lab.msp.redhat.com>
References: <CBD76F19A3EEF14686BFFB30222C123C1FFB1182@MX106CL02.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CBD76F19A3EEF14686BFFB30222C123C1FFB1182@MX106CL02.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Tue, Oct 21, 2014 at 08:03:09AM +0000, Vaknin, Rami wrote:
>    Hi,
> 
>     
> 
>    I'm working on 6.5 running with 2.6.32-431.el6.x86_64, my multipath.conf
>    if configured with both rr_min_io and rr_min_io_rq, running 64k 100% write
>    load to my storage system using 8 paths over FC ("queue-length" policy).
> 
>     
> 
>    I found [1] that rr_min_io is deprecated in favor of rr_min_io_rq, but
>    playing with these values show that different rr_min_io_rq have no
>    influence on performance in my env, however, different values of rr_min_io
>    have huge influence on the average latency I get for the same iops.
> 
>     
> 
>    Am I missing something?

I'm not sure what you're seeing. As long as your dm_multipath modules is
at least version 1.1.0, you should be using rr_min_io_rq, and with that
kernel, it definitely should be.  You can check by rmmod and modprobing
the dm_multipath module and checking /var/log/messages. You should see a
line like

kernel: device-mapper: multipath: version 1.6.0 loaded

You can also check exactly what changing rr_min_io and rr_min_io_rq is
doing.  All they do is set the number of IOs to send down a path before
switching.  They do this by changing the value in the table you pass to
device-mapper.  You can see that table by running

# dmsetup table <devname>

You will see something like this

# dmsetup table mpathaa
0 204800 multipath 0 0 3 1 round-robin 0 1 1 8:112 5 round-robin 0 1 1
8:144 5 round-robin 0 1 1 8:128 5

this "round-robin 0 1 1 8:112 5" is the setup of a single path group
with one path.  If this was a multibus device with all paths in one
pathgroup, it would look like

# dmsetup table mpathaa
0 204800 multipath 0 0 1 1 round-robin 0 3 1 8:112 5 8:144 5 8:128 5

After each device major:minor, there is number (5 in this case). That's
the number of IOs to send to this path before switching.  If multipath
is using rr_min_io, then this will be whatever you set rr_min_io to. If
multipath is using rr_min_io_rq this will be whatever you set
rr_min_io_rq to.  In my case, I was running these commands on a RHEL-6.3
machine, with rr_min_io_rq set to 5 (just to make it stand out from all
the 1s in table for this example. Not because it gives me better
performance)

try this and let me know what you see.

-Ben

> 
>     
> 
>     
> 
>    [1]
>    https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/DM_Multipath/MPIO_Overview.html
> 
>     
> 
>    device-mapper-libs-1.02.79-8.el6.x86_64
> 
>    device-mapper-event-libs-1.02.79-8.el6.x86_64
> 
>    device-mapper-persistent-data-0.2.8-2.el6.x86_64
> 
>    device-mapper-1.02.79-8.el6.x86_64
> 
>    device-mapper-event-1.02.79-8.el6.x86_64
> 
>    device-mapper-multipath-libs-0.4.9-72.el6_5.3.x86_64
> 
>    device-mapper-multipath-0.4.9-72.el6_5.3.x86_64
> 
>     

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
