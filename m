From: Tore Anderson <tore@linpro.no>
Subject: Re: Round Robin vs Active/Passive
Date: Fri, 23 May 2008 11:42:35 +0200
Message-ID: <4836918B.8090909@linpro.no>
References: <ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com>	<ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>	<483468AD.7@linpro.no>
	<000301c8bbe5$4f1091d0$cf42e3c1@pitagora.it>	<20080523071654.GB380@pentland.suse.de>	<4836798F.4060100@linpro.no>
	<20080523085521.GC380@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080523085521.GC380@pentland.suse.de>
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

Hi,

* Hannes Reinecke

> In moving the assignment to another controller you will have a more
> efficient I/O throughput, as in general the internal link between those
> two controller isn't the fastest. So you really want to move the
> LUN to that controller which should handle the I/O.

Yes.  But the EMC will take care of moving the volume where it gets the
most I/O on its own (they call it "implicit trespass"), no
host-initiated volume movement is necessary.  I'll elaborate on why I
believe this to be better (especially in clustered environments):

Consider a simple dual-fabric topology, which controller A connected to
fabric A and controller B connected to fabric B.  Ten nodes share one
volume, which by default are owned by controller A.  They all generate
about the same amount of I/O.

  +-----------[ Switch - Fabric A ]
  |            |    |     |    |
Ctrl A         |    |     |    |
              N1   N2   [..]  N10
Ctrl B         |    |     |    |
  |            |    |     |    |
  +-----------[ Switch - Fabric B ]

Normally all traffic to the volume are passed through fabric A to
controller A, while fabric B and controller B are completely idle.

Now, say that the patch cord between N10 and Fabric A breaks.  In the
situation when there's no host-initiated volume, N10 will start using
the path through fabric B through the passive controller with a slight
performance impact, while the CLARiiON will leave the volume on
controller A since it can tell that that's where 90% of the I/O is
coming in anyway.

If the hosts all will move the volume ("explicit trespass") whenever
they see fit, in the above scenario N10 would move the volume to
controller B, making 90% of all I/O come in the wrong way.  Depending on
the failback settings one of N1-9 would move it back to controller A
later, and until the broken patch cord was fixed the volume would keep
moving back and forth between controllers - not exactly optimal.

At least that's how I _think_ it would work, and that's why I don't use
the ALUA bits.  I'd appreciate your comments on whether or not this
makes sense or not...

Note that in the case of an error that redirects all I/O to the passive
controller (for example if N10 was the only node using the volume, or
the switch in fabric A failed), the volume would still get moved to
controller B (even though the hosts aren't able to do this themselves),
because of the "implicit trespass"-functionality.  The only drawback
that I can see of relying on this is that the I/O will pass through the
passive controller for some minutes instead of being transferred
immediately, which isn't really a problem as the performance degradation
is very slight, at least not on the CX3;  I'm having problems measuring
it at all.

> (Remember, the original EMC failover couldn't even handle I/O on
> the non-active controller ...)

Yes, PNR mode sucked.  I'm really glad the new CLARiiONs support ALUA,
now I don't need a Symmetrix anymore.  :-)

> Well, the big advantage of the ALUA support in the EMC is that even the
> secondary path will function, albeit slower. Hence you wouldn't get
> the I/O errors during boot anymore.

Ah, yes, I am aware of this.  That is how the HDS AMS that was discussed
earlier in the thread works too, though I'm not sure if that is actually
ALUA or some HDS-specific implementation that does basically the same thing.

I understood that Domenico asked if this is functionally equivalent to
the new ALUA mode on the CLARiiONs, not if the old PNR mode was
equivalent to ALUA, which is what I think is maybe how you understood
it?  If so I agree with you - those two are indeed completely different.

Regards,
-- 
Tore Anderson
