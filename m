From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [RFC] New interface for dm-io to handle timed requests
Date: Wed, 15 Mar 2006 16:33:56 +0100
Message-ID: <OFA18B9D5F.C030F341-ONC1257132.00548304-C1257132.005565B1@de.ibm.com>
References: <4417244E.5080707@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4417244E.5080707@cs.wisc.edu>
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

dm-devel-bounces@redhat.com wrote on 14.03.2006 21:15:10:

> Stefan Bader wrote:
> > The ideal solution would be to have an interface in the block layer 
that 
> > allows us to cancel any submitted requests. But since such a change 
will 
> > take quite a lot discussions and work, we want to emulate such a 
> > behavior in the dm core for now.
> > 
> 
> The scsi people and some block people have been talking about moving 
> more error handling functionality into the block layer for a while and 
> it is slowing moving that way. It could probably be done faster if 
> people did not concentrate on one subsystem :)
> 

It is not that much about error handling. More about policy. If the
subsystem decides that io took enough time or maybe it just doesn't
want to go on (could be a force umount...) it would be nice to be
able to stop lower level drivers from doing error recovery. Thus
the idea of stopping a submitted request.

The changes to the core now shall fake this as long as there isn't
such a functionality in the kernel with an interface that can handle
this.

> Maybe you should post to lkml and linux-scsi and get some responses from 

> them before adding it to dm core. If a post already went out to those 
> list my fault for missing it.
> 
No it didn't. I guess lkml is a good point. I am not sure about 
linux-scsi.
As it is not related specifically to scsi...

Stefan Bader

SW Linux on zSeries Development & Services
Stefan.Bader@de.ibm.com
----------------------------------------------------------------------------------
  When all other means of communication fail, try words.
