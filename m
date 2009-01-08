From: Ray Van Dolson <rvandolson@esri.com>
Subject: Re: multipathd: sdc: readsector0 checker reports path is
	down
Date: Thu, 8 Jan 2009 12:10:09 -0800
Message-ID: <20090108201007.GA8423@esri.com>
References: <20090108193137.GA3953@esri.com>
	<1231444732.9047.27.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1231444732.9047.27.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 08, 2009 at 11:58:52AM -0800, Chandra Seetharaman wrote:
> 
> 
> On Thu, 2009-01-08 at 11:31 -0800, Ray Van Dolson wrote:
> > I'm still getting the hang of iSCSI and multipath, so bear with me if
> > this is a FAQ that I've missed...
> > 
> > I have a host attaching to an MD3000i via iSCSI/dm-multipath that is
> > working but showing a lot of the following errors in syslog:
> > 
> >   multipathd: sdc: readsector0 checker reports path is down
> you should be using the rdac path checker. In addition to that you
> should be using rdac hardware handler and tpc priority checker.
> 
> If you have and entry for your MD3000i in /etc/multipath.conf, replace
> it with this. If not add this
> -------------------
> devices {
>         device {
>                 vendor                  "DELL"
>                 product                 "MD3000i"
>                 hardware_handler        "1 rdac"
>                 path_checker            rdac
>                 failback                immediate
>                 path_grouping_policy    group_by_prio
>                 no_path_retry           queue
>                 prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
>         }
> }
> ---------------------
> 
> After this change you have to do:
> - multipath -F
> - service multipathd restart
> 
> Let me know how it goes.

This appears to have done the trick.  So, I guess the default path
checker is readsector0 and rdac is another method -- I imagine it
directly talks to my MD3000i to determine path status?

> > 
> > My initial impression is that sdc is likely the "passive" path (for
> > failover) whereas sdd is my active path:
> 
> yes.

Thanks much!

Ray
