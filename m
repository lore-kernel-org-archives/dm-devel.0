From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: creating partition mappings with different delimiters
Date: Tue, 4 Apr 2006 14:58:44 -0400
Message-ID: <20060404185844.GL5783@vienna.egenera.com>
References: <1144081162.3111.32.camel@gator.sc.steeleye.com>
	<1144097506.3111.81.camel@gator.sc.steeleye.com>
	<44319246.6040008@free.fr>
	<20060404132417.GH5783@vienna.egenera.com>
	<1144157784.3111.60.camel@gator.sc.steeleye.com>
	<20060404144612.GJ5783@vienna.egenera.com>
	<4432B1BD.3080709@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4432B1BD.3080709@free.fr>
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


Hi Christophe,

Rumor has it that on Tue, Apr 04, 2006 at 07:49:49PM +0200 Christophe Varoqui said:
> 
> >>It seems to me that volume managers, aka LVM or the like, is where folks
> >>should be heading and the faster we can move them in that direction the
> >>better.  The volume managers provide so much more flexibility than
> >>partitions.
> >>
> >>    
> >
> >Maybe so. But they also add another layer of complexity for
> >booting. I'd like the steps between me and a successful boot 
> >to be as complex as required but no more so.
> >
> >  
> True, just as the whole SAN is just another layer layer of complexity 
> for booting and swaping : zoning and selective storage presentation 
> errors are common, not to mention software shortcomings.
> 
> System on SAN is just a bit more risky. Not doing it also cuts down on 
> the main use for partitions.
> 

That's exactly what I need. My servers are diskless and have system 
on SAN (by way of virtualized SCSI). I'm hoping to move to using 
dm-multipath in the future. But will need to make it work as
painlessly (and transparently) as possible for the root disk right 
out of the box. 

The SAN based root disk is part of what allows for stateless blades.
But it's not good to lose the only path the your root disk :)


Cheers,

Phil


> Big data volumes can be handled just fine by storage arrays internal 
> volume managers.
> 
> My opinions, anyway.
> So subject to frequent oscillations ;)
> 
> Regards,
> cvaroqui
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Software Architect                            165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
