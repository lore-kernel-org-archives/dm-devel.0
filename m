From: Jamie Bainbridge <jbainbri@redhat.com>
Subject: Re: Bug 999761 - Review NetApp path_checker and features
 for RHEL5 mpath
Date: Wed, 4 Sep 2013 03:23:40 -0400 (EDT)
Message-ID: <1109366671.9231767.1378279420548.JavaMail.root@redhat.com>
References: <1038339233.8389724.1378165932561.JavaMail.root@redhat.com>
	<5225A33F.80805@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5225A33F.80805@netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin George <marting@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Thanks Martin.

So it just seems the documentation in multipath.conf.defaults is outdated.

I've closed my previous bug, and logged a new bug with a patch for the docs:

 Bug 1004179 - Documented NetApp device in multipath.conf.defaults is outdated
 https://bugzilla.redhat.com/show_bug.cgi?id=1004179

Regards,
Jamie Bainbridge
Red Hat Asia Pacific

----- Original Message -----
> From: "Martin George" <marting@netapp.com>
> To: "Jamie Bainbridge" <jbainbri@redhat.com>
> Cc: "device-mapper development" <dm-devel@redhat.com>
> Sent: Tuesday, 3 September, 2013 6:52:15 PM
> Subject: Re: [dm-devel] Bug 999761 - Review NetApp path_checker and features for RHEL5 mpath
> 
> On 9/3/2013 5:22 AM, Jamie Bainbridge wrote:
> > Hi all,
> >
> > I was wondering if I could get a response on this bug?
> >
> >   Bug 999761 - Review NetApp path_checker and features for RHEL5 mpath
> >   https://bugzilla.redhat.com/show_bug.cgi?id=999761
> >
> > In Bug 799842 NetApp requested that we change the default path_checker for
> > NETAPP devices in RHEL 6.3 from directio to tur.
> >
> > * Would we consider changing the default hwtable in RHEL5, considering it's
> > in Production 2?
> >
> > * Given NetApp reference the async tur improvements from Bug 760852 as part
> > of their decision to use tur, is tur suitable for current RHEL5, or should
> > we stick with directio?
> >
> > * If tur is suitable for current RHEL5, should we change the default RHEL5
> > hwtable to use tur?
> >
> > In Bug 799842 Comment 10 NetApp also requested we change the default
> > features for NETAPP devices in RHEL 6.3 from "1 queue_if_no_path" to "3
> > queue_if_no_path pg_init_retries 50".
> >
> > * pg_init_retries has been in RHEL5 since 5.2, is pg_init_retries suitable
> > for current RHEL5 also? (this seems to be an easy "yes")
> >
> > * If pg_init_retries is suitable for current RHEL5, should we change the
> > default RHEL5 hwtable to use pg_init_retries?
> >
> 
> On newer RHEL5 kernels like RHEL 5.9, the above changes (i.e. 'tur' path
> checker & enabling pg_init_retries) have already made it to the hwtable
> for NetApp LUNs - addressed in device-mapper-multipath-0.4.7-51.el5.
> 
> -Martin
> 
