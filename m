From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: Re: DM configuration
Date: Mon, 10 Oct 2005 16:14:46 +0200
Message-ID: <OFDE9C3BC9.965B6B5B-ONC1257096.004D9E82-C1257096.004E3EE8@de.ibm.com>
References: <1128725810.20114.15.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1128725810.20114.15.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Generally I think the shorter keywords make sense and I wouldn't mind if 
their're gone
as long as the old ones stay around. The same would apply to the 
no_path_retry
keyword. I think the features keyword should still be accepted for 
compatibility 
reasons. The difficult part there would be what to do if someone uses 
both...

Regards,
Stefan Bader

SW Linux on zSeries Development & Services
Stefan.Bader@de.ibm.com
----------------------------------------------------------------------------------
  When all other means of communication fail, try words.

dm-devel-bounces@redhat.com wrote on 08.10.2005 00:56:50:

> 
> > > diff -rup git/libmultipath/config.h 
retry-multipathd/libmultipath/config.h
> > > --- git/libmultipath/config.h   2005-09-28 12:32:02.000000000 -0400
> > > +++ retry-multipathd/libmultipath/config.h   2005-10-05 18:37:
> 33.000000000 -0400
> > > @@ -33,6 +33,7 @@ struct mpentry {
> > >     int pgpolicy;
> > >     int pgfailback;
> > >     int rr_weight;
> > > +   int no_path_retry;
> > > 
> > >     char * wwid;
> > >     char * selector;
> > > @@ -56,6 +57,7 @@ struct config {
> > >     int pgfailback;
> > >     int remove;
> > >     int rr_weight;
> > > +   int default_no_path_retry;
> > > 
> > the "default_" prefix can be avoided here and in the dictionnary, as 
the
> > default{} block says it all.
> > 
> Speaking of which ...
> 
> Does someone care if I deprecate all "default_foo" in favor of "foo" in
> the default{} dictionnary and 'struct config' ?
> 
> I'll keep the old keyword around, for compat, but undocumented.
> 
> Keywords concerned are :
> 
>         "default_selector"
>         "default_path_grouping_policy"
>         "default_getuid_callout"
>         "default_prio_callout"
>         "default_features"
>         "default_path_checker"
> 
> Regards,
> cvaroqui
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
