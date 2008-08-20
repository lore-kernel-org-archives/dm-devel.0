From: Konrad Rzeszutek <konrad-/HHyZTb1IPUUqSzUVP1SBw@public.gmane.org>
Subject: Re: Reducing amount of logmessages openiscsi/multipath [with md3000i]
Date: Wed, 20 Aug 2008 09:47:04 -0400
Message-ID: <20080820134704.GA9595@mars.virtualiron.com>
References: <005b01c901fd$37683660$a638a320$@net> <48AB00C5.8050604@cs.wisc.edu> <20080819211221.GC22302@mars.virtualiron.com> <004d01c902b3$878658a0$969309e0$@net>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <004d01c902b3$878658a0$969309e0$@net>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: 'device-mapper development' <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids


On Wed, Aug 20, 2008 at 12:57:24PM +0200, Kees Hoekzema wrote:
> 
> 
> 
> > -----Original Message-----
> > He wants the RDAC hw handler and its path checker (rdac). The MD3000i
> > is an
> > LSI re-branded box and is the same as the IBM DS3300.
> > 
> > >
> > > You also want to make sure that you are using the md3000i hw handler
> > or
> > > scsh_dh_module if you are not already. The dm-devel guys can help you
> > out.
> > 
> > Here is the multipath.conf he should be using for MD3000i (or for the
> > DS3300
> > but will need to modify the vendor/model entry)
> > 
> >         # Note: The same as the IBM DS3300
> >         #
> >         device {
> >                 vendor                  "DELL"
> >                 product                 "MD3000i"
> >                 product_blacklist       "Universal Xport"
> >                 features                "1 queue_if_no_path"
> >                 path_grouping_policy    group_by_prio
> >                 hardware_handler        "1 rdac"
> >                 path_checker            rdac
> >                 prio                    "rdac"
> >                 failback                immediate
> >         }
> > 
> > 
> 
> This fixed the problem, although a simple flush was not enough to activate

Glad to hear that.

> the changes, so it took a bit longer to get the result I wanted. In the end
> I saw that it was still using the direction path_checker and noticed that
> you cannot change the 'path_checker' on the fly with just a multipath -F /
> -v 2, but that a reload of the modules was needed.

Ohh, you could also do: multipathd -k'reconfigure'
