From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: open-iscsi + dm-multipath
Date: Tue, 22 Mar 2005 17:11:06 +0100
Message-ID: <20050322161106.GA17885@averon.dyndns.org>
References: <1110657791.16560.11.camel@mylaptop>
	<20050322151309.GB17219@averon.dyndns.org>
	<1111506721.10650.9.camel@mylaptop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1111506721.10650.9.camel@mylaptop>
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

> > 
> > Does your log.[ch] implementation works around syslog blocking behaviour in memory contention situation ?
> 
> yep syslog sucks.
> as of now, our logger still based on syslog. its missing some stuff.
> There is another logger which proved to work under memory pressure -
> ha_logd from HA project. if I will have time, I'll merge some stuff from
> ha_logd to log.[ch].
> 
> > If so, I would like to fetch it in multipath-tools, with your agreement.
> > Also, if you have better ideas on the subject, I'm interested in reading them :)
> 
> so, try ha_logd. Also I saw in your code mlockall() right after
> syslog(). Could you explain why we need it? I think just one call at the
> beginning phase should be enough unless you fork?
> 
I looked that code, but there are a number of non-trivial dependencies to remove to make the code self-contained and generic : glib.h and cl_*.h come to mind.

Also note that klibc doesn't implement IPC, so ha_logd would not fit your goals as-is.

Regards,
cvaroqui
