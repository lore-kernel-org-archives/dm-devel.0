From: Dmitry Yusupov <dmitry_yus@yahoo.com>
Subject: Re: open-iscsi + dm-multipath
Date: Tue, 22 Mar 2005 07:52:01 -0800
Message-ID: <1111506721.10650.9.camel@mylaptop>
References: <1110657791.16560.11.camel@mylaptop>
	<20050322151309.GB17219@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050322151309.GB17219@averon.dyndns.org>
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

On Tue, 2005-03-22 at 16:13 +0100, Christophe Varoqui wrote:
> On Sat, Mar 12, 2005 at 12:03:11PM -0800, Dmitry Yusupov wrote:
> > Hi Guys!
> > 
> > had anyone tried to setup open-iscsi with dm-multipath yet?
> > I think it should work out of the box, but would be cool if someone will
> > double check on that.
> > 
> > PS: www.open-iscsi.org is a new cool project which features some
> > noticeable performance improvements for soft-based iSCSI Initiator plus
> > other number of exciting abilities such as independent transport and
> > better user-space vs. kernel split. Read more on project's web page.
> > 
> Hello,
> 
> Does your log.[ch] implementation works around syslog blocking behaviour in memory contention situation ?

yep syslog sucks.
as of now, our logger still based on syslog. its missing some stuff.
There is another logger which proved to work under memory pressure -
ha_logd from HA project. if I will have time, I'll merge some stuff from
ha_logd to log.[ch].

> If so, I would like to fetch it in multipath-tools, with your agreement.
> Also, if you have better ideas on the subject, I'm interested in reading them :)

so, try ha_logd. Also I saw in your code mlockall() right after
syslog(). Could you explain why we need it? I think just one call at the
beginning phase should be enough unless you fork?

> Regards,
> cvaroqui
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
