From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Re: blacklisted paths?
Date: Tue, 20 Sep 2005 08:36:44 -0700
Message-ID: <20050920153644.GA20698@us.ibm.com>
References: <20050919211649.GA24756@locust.cns.vt.edu>
	<20050920120153.GA25978@locust.cns.vt.edu>
	<20050920151151.GA3518@locust.cns.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050920151151.GA3518@locust.cns.vt.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Ray Stell <stellr@cns.vt.edu> wrote:
> On Tue, Sep 20, 2005 at 08:01:53AM -0400, Ray Stell wrote:
> > devnode_blacklist {
> >         devnode "hd*"
> >         devnode "fd*"
> >         devnode "ram*"
> >         devnode "md*"
> > }
> 
> I removed the * chars from this block it mapped all the paths.  

Good to see that they are all mapped now. You may want to switch to using
"^" to match beginning of line and also use the multiple match / single
line regular expression.

Here is an example of what I am running. I believe it is close to the
/etc/multipath.conf example file.

devnode_blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z][0-9]*"
        devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
}

-andmike
--
Michael Anderson
andmike@us.ibm.com
