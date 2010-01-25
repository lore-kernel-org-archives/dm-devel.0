From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: partitioning multipath device
Date: Mon, 25 Jan 2010 12:32:25 +0000
Message-ID: <1264422745.8461.5559.camel@localhost>
References: <20100122192935.GC31538@mtholyoke.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100122192935.GC31538@mtholyoke.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Fri, 2010-01-22 at 14:29 -0500, Ron Peterson wrote:
> The multipath-tools FAQ has the following to say about partitioning
> multipath devices.
> 
> >From http://christophe.varoqui.free.fr/faq.html
> 
> > 6. How do I partition my multipathed devices
> > Partition a constituant path instead. And reload the map through multipath(8)
> 
> I take this to mean, for example, that one should partition /dev/sdX,
> rather than the corresponding coalesced /dev/mapper/... device, correct?
> 
> My question is: why?  Paritioning the /dev/mapper device appears to
> work.  Is there an operational difference?  I've always done this
> exactly as advised, but I know someone who didn't, and we're wondering
> if it matters.

It doesn't actually matter too much. If you're partitioning before
assembling maps then you may as well do it on a path. The common
partitioning tools should do the right thing if you point them at the
multipath device too though (although you may need to arrange for kpartx
to get run again, or run it manually to refresh).

Regards,
Bryn.
