From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Re: [PATCH][multipath-tools] discovery.c set hwe
	pointer for bus type ccw
Date: Fri, 3 Feb 2006 09:45:17 +0100
Message-ID: <20060203084517.GA5410@pundit>
References: <OFFD0A28A6.4D76571F-ONC1257109.004DBE99-C1257109.0052476D@de.ibm.com>
	<20060202161906.GA11415@pundit> <43E3030F.6060600@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43E3030F.6060600@suse.de>
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

On Fri, Feb 03, 2006 at 08:15:27AM +0100, Hannes Reinecke wrote:
> Christophe Varoqui wrote:
> >> I tried to use the current git tree version of the multipath-tools in a 
> >> Linux on zSeries environment with DASD devices. The tool multipath seemed 
> >> to
> >> recognize the disks correctly, but ignored the device specific 
> >> configuration
> >> in my multipath.conf.
> >>
> > Good to see there is some testing happening there.
> > Next major distro release is approaching and not many seem to care to bullet proof the next release ...
> > 
> Well, real-life testing is about to begin.
> Just because there are no queries / bugs doesn't necessarily mean no-one
> uses it. Sometimes it can also mean that there are, well, no bugs.
> 
Inch'allah :)

I'd just appreciate more feedback to help decide when to release 0.4.7.
For one thing, is there any features still missing for this round ?

Regards,
cvaroqui
