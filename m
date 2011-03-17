From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] dm-throttle: new device mapper target to
 throttle reads and writes
Date: Thu, 17 Mar 2011 09:15:42 -0400
Message-ID: <20110317131542.GA32392@redhat.com>
References: <AANLkTimzzG6QvYD7V3M31J0U+jbB9GRXskzuw3aGhhCx@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <AANLkTimzzG6QvYD7V3M31J0U+jbB9GRXskzuw3aGhhCx@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Juerg Haefliger <juergh@gmail.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Mar 17, 2011 at 12:01:06PM +0100, Juerg Haefliger wrote:
> > > FWIW, I am now playing with a RFC patch to implement device throttle mechanism
> > > on request queue instead of device mapper target and see how does it go. I am
> > > targetting to get the throtting limits from cgroups.
> > >
> > > The idea is to hook into __make_request and (ultimately dm_request) and
> > > subject incoming bios on request queue to throttling policy first before
> > > they are passed down to elevator.
> > >
> > > If it works, it should get rid of the requirement of configuring a device
> > > mapper target for throttling. At this point of time nothing is working and I
> > > am still figuring out how to put various pieces together.
> >
> > Ok, waiting for where that goes then.
> 
> Is my understanding correct that dm-throttle has been abandoned in
> favor of the cgroups IO throttle controller?

Yes. Now throttling mechanism has been implemented in block layer which
is usable with the help of IO controller. So there is no need of a device
mapper target.

Thanks
Vivek
