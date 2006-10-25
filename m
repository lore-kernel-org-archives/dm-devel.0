From: "Haripriya S" <sharipriya@novell.com>
Subject: Re: dm-snapshot scalability - chained delta
	snapshots approach
Date: Wed, 25 Oct 2006 06:09:22 -0600
Message-ID: <453FA29D.A648.00B6.0@novell.com>
References: <44DA246B020000B60000BD22@lucius.provo.novell.com>
	<44DB5BDD020000B60000BD96@lucius.provo.novell.com>
	<44DB5C21.F25D.00B6.0@novell.com> <451A5915.F25D.00B6.0@novell.com>
	<20060927091700.GA6314@X40.redhat.com>
	<62b0912f0610231016r23585c34y6308cb3540ed926c@mail.gmail.com>
	<20061024095200.GE4729@hasse.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061024095200.GE4729@hasse.suse.de>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

  
>>> Jan Blunck <jblunck@suse.de> 10/24/06 3:22 PM >>> 
On Mon, Oct 23, Molle Bestefich wrote:

> > >Although that includes a complete redesign of the exception store
code.
> > 
> > Especially when you say stuff like that :- ).
> > 

> The chained- snapshots approach needs that too.

 In the chained snapshots, the only addition is a way to tell if an
exception 
 is to be preserved or can be written over. So for every disk-exception
an 
additional field is required (Alasdair also recently suggested that we
could use 
a bitmap to save space). So I would say this is not a major
re-architecture of 
the disk exception structures but a simple (but incompatible) format
change.

> > >The throughput issues should be addressed by only
> > >writing to one exception store.
> > 
> > Wouldn't this make debugging more complex, and further add to
> > the difficulty of snapshot resizing?

> Resizing? Nope, you only need to resize the exception store thats it.
Resizing
> the chained- snapshots approach is complex however: in the worst case
you have
> to move the exception stores to get enough free space.

I agree that there is work to be done while resizing. It seems simple
to code 
though and can be done similar to a snapshot delete. If a snapshot is
being 
resized, and will lose exception data, then we need to move the
exception 
and data to the first snapshot after this snapshot in the write chain
which has 
space to hold that data. Yes, data move is involved here. btw I
couldn't figure out 
how resize will work with the common exception store approach. Can you

please explain that in detail ?

Thanks and Regards,
Haripriya
