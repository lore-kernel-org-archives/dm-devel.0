From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: creating partition mappings with different delimiters
Date: Tue, 4 Apr 2006 10:46:12 -0400
Message-ID: <20060404144612.GJ5783@vienna.egenera.com>
References: <1144081162.3111.32.camel@gator.sc.steeleye.com>
	<1144097506.3111.81.camel@gator.sc.steeleye.com>
	<44319246.6040008@free.fr>
	<20060404132417.GH5783@vienna.egenera.com>
	<1144157784.3111.60.camel@gator.sc.steeleye.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1144157784.3111.60.camel@gator.sc.steeleye.com>
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

Rumor has it that on Tue, Apr 04, 2006 at 09:36:23AM -0400 Eddie Williams said:
> On Tue, 2006-04-04 at 09:24 -0400, Philip R. Auld wrote:
> > Hi,
> > 
> > Rumor has it that on Mon, Apr 03, 2006 at 11:23:18PM +0200 Christophe Varoqui said:
> > > I'm inclined to leave it that way, if not only to discourage people to 
> > > partition multipathed devices :)
> > > 
> > 
> > Why do you want to discourage partitioning multipath devices? That
> > seems to me to be a requirement. 
> 
> It seems to me that volume managers, aka LVM or the like, is where folks
> should be heading and the faster we can move them in that direction the
> better.  The volume managers provide so much more flexibility than
> partitions.
> 

Maybe so. But they also add another layer of complexity for
booting. I'd like the steps between me and a successful boot 
to be as complex as required but no more so.

Cheers,

Phil



> Eddie
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Software Architect                            165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
