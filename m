From: Chandra Seetharaman <sekharan-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] Re: multipathd: sdc: readsector0 checker reports path is down
Date: Thu, 08 Jan 2009 12:48:36 -0800
Message-ID: <1231447716.9047.29.camel@chandra-ubuntu>
References: <20090108193137.GA3953@esri.com> <1231444732.9047.27.camel@chandra-ubuntu>  <20090108201007.GA8423@esri.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <20090108201007.GA8423-v48TKWNzwFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: dm-devel.ids



On Thu, 2009-01-08 at 12:10 -0800, Ray Van Dolson wrote:
> On Thu, Jan 08, 2009 at 11:58:52AM -0800, Chandra Seetharaman wrote:
> > 
> > 
> > On Thu, 2009-01-08 at 11:31 -0800, Ray Van Dolson wrote:
> > > I'm still getting the hang of iSCSI and multipath, so bear with me if
> > > this is a FAQ that I've missed...
> > > 
> > > I have a host attaching to an MD3000i via iSCSI/dm-multipath that is
> > > working but showing a lot of the following errors in syslog:
> > > 
> > >   multipathd: sdc: readsector0 checker reports path is down
> > you should be using the rdac path checker. In addition to that you
> > should be using rdac hardware handler and tpc priority checker.
> > 
> > If you have and entry for your MD3000i in /etc/multipath.conf, replace
> > it with this. If not add this
> > -------------------
> > devices {
> >         device {
> >                 vendor                  "DELL"
> >                 product                 "MD3000i"
> >                 hardware_handler        "1 rdac"
> >                 path_checker            rdac
> >                 failback                immediate
> >                 path_grouping_policy    group_by_prio
> >                 no_path_retry           queue
> >                 prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
> >         }
> > }
> > ---------------------
> > 
> > After this change you have to do:
> > - multipath -F
> > - service multipathd restart
> > 
> > Let me know how it goes.
> 
> This appears to have done the trick.  So, I guess the default path
> checker is readsector0 and rdac is another method -- I imagine it
> directly talks to my MD3000i to determine path status?

Yes, it sends a C9 inquiry to the storage controller and determines the
state.
> 
> > > 
> > > My initial impression is that sdc is likely the "passive" path (for
> > > failover) whereas sdd is my active path:
> > 
> > yes.
> 
> Thanks much!
> 
> Ray
> 
> --
> dm-devel mailing list
> dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> https://www.redhat.com/mailman/listinfo/dm-devel
