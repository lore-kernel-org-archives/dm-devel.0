From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: failover does not work with rdac device handler
Date: Fri, 26 Jun 2009 10:42:51 -0700
Message-ID: <1246038171.14164.19.camel@chandra-ubuntu>
References: <4A424F9E.1050403@meteo.uni-koeln.de>
	<1245977789.14164.15.camel@chandra-ubuntu>
	<4A4493CB.6040009@meteo.uni-koeln.de>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A4493CB.6040009@meteo.uni-koeln.de>
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


On Fri, 2009-06-26 at 11:24 +0200, Mario Mech wrote:
> Chandra Seetharaman schrieb:
> > On Wed, 2009-06-24 at 18:09 +0200, Mario Mech wrote:
> >> Hi,
> >>
> >> I need help with a similar or even the same issue as in the thread mentioned in the Subject 
> >> (https://www.redhat.com/archives/dm-devel/2008-October/msg00130.html).
> > 
> > My bad. I had some issues during debug and never got back to it.
> > 
> > Will send couple of patches by tomorrow to fix this problem.
> >  
> 
> That sounds great.
> 
> >> At the moment I'd like to avoid building the multipath package by myself with the patch provided in the afore mentioned thread.
> > 
> > The changes are in kernel code.
> >> Do you have any ideas? Or is a different problem I have.
> > 
> > It is the same problem and I am afraid that you do not have a way out.
> > 
> > May be next version of RHEL might add your device to rdac_dev_list (if
> > you could do that that would fix the problem).
> > 
> 
> I assume it's only building new kernel modules for my running 2.6.18-128.1.14.el5. That shouldn't be a big deal.

Yes. MD3000i is already in mainline code, you can just cut-n-paste that
entry for rdac_dev_list, compile the module and you are good to do.

chandra
> 
> >> Every help is appreciated.
> >>
> >> All best
> >>
> >> Mario
> >>
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 
> 
