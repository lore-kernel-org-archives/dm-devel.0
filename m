From: Dmitry Yusupov <dmitry_yus@yahoo.com>
Subject: Re: open-iscsi + dm-multipath
Date: Tue, 22 Mar 2005 21:37:50 -0800
Message-ID: <1111556270.11858.13.camel@mylaptop>
References: <1110657791.16560.11.camel@mylaptop>
	<20050322151309.GB17219@averon.dyndns.org>
	<1111506721.10650.9.camel@mylaptop>
	<20050322161106.GA17885@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050322161106.GA17885@averon.dyndns.org>
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

On Tue, 2005-03-22 at 17:11 +0100, Christophe Varoqui wrote:
> > > 
> > > Does your log.[ch] implementation works around syslog blocking behaviour in memory contention situation ?
> > 
> > yep syslog sucks.
> > as of now, our logger still based on syslog. its missing some stuff.
> > There is another logger which proved to work under memory pressure -
> > ha_logd from HA project. if I will have time, I'll merge some stuff from
> > ha_logd to log.[ch].
> > 
> > > If so, I would like to fetch it in multipath-tools, with your agreement.
> > > Also, if you have better ideas on the subject, I'm interested in reading them :)
> > 
> > so, try ha_logd. Also I saw in your code mlockall() right after
> > syslog(). Could you explain why we need it? I think just one call at the
> > beginning phase should be enough unless you fork?
> > 
> I looked that code, but there are a number of non-trivial dependencies to remove to make the code self-contained and generic : glib.h and cl_*.h come to mind.

yep. life is not fair...

> Also note that klibc doesn't implement IPC, so ha_logd would not fit your goals as-is.

i'm thinking about utilizing NETLINK protocol. In open-iscsi we using it
to implement protocol level IPC.

We can try to come up with ipc-based log implementation which will be
based on ha_logd and will be generic enough for both dm-multipath and
open-iscsi.

Dima

> 
> Regards,
> cvaroqui
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
