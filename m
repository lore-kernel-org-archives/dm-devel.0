From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Re: DM configuration
Date: Sat, 08 Oct 2005 00:56:50 +0200
Message-ID: <1128725810.20114.15.camel@zezette>
References: <3456F611E9329441B12FBB24447B3FA002C73E05@bgeexc01.asiapacific.cpqcorp.net>
	<20051005134505.GB6195@free.fr>
	<20051006.131418.71083514.k-ueda@ct.jp.nec.com>
	<1128718450.18441.21.camel@zezette>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1128718450.18441.21.camel@zezette>
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


> > diff -rup git/libmultipath/config.h retry-multipathd/libmultipath/config.h
> > --- git/libmultipath/config.h	2005-09-28 12:32:02.000000000 -0400
> > +++ retry-multipathd/libmultipath/config.h	2005-10-05 18:37:33.000000000 -0400
> > @@ -33,6 +33,7 @@ struct mpentry {
> >  	int pgpolicy;
> >  	int pgfailback;
> >  	int rr_weight;
> > +	int no_path_retry;
> >  
> >  	char * wwid;
> >  	char * selector;
> > @@ -56,6 +57,7 @@ struct config {
> >  	int pgfailback;
> >  	int remove;
> >  	int rr_weight;
> > +	int default_no_path_retry;
> >  
> the "default_" prefix can be avoided here and in the dictionnary, as the
> default{} block says it all.
> 
Speaking of which ...

Does someone care if I deprecate all "default_foo" in favor of "foo" in
the default{} dictionnary and 'struct config' ?

I'll keep the old keyword around, for compat, but undocumented.

Keywords concerned are :

        "default_selector"
        "default_path_grouping_policy"
        "default_getuid_callout"
        "default_prio_callout"
        "default_features"
        "default_path_checker"

Regards,
cvaroqui
