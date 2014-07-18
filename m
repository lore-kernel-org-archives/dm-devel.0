From: John Utz <John.Utz@wdc.com>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Fri, 18 Jul 2014 17:04:15 +0000
Message-ID: <8A51900D08212F40B3DE22453052F69839C46EC0@wdscexmb02>
References: <1387353155-7271-1-git-send-email-hare@suse.de>
	<20131218140858.GC17730@redhat.com> <52B1B046.3040301@suse.de>
	<1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<20140718000411.GB337@redhat.com>
	<8A51900D08212F40B3DE22453052F69839C46AF4@wdscexmb02>
	<20140718021806.GA1143@redhat.com>
	<8A51900D08212F40B3DE22453052F69839C46B5B@wdscexmb02>
	<53C8B757.2000904@suse.de>,<20140718143855.GA4762@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140718143855.GA4762@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Response below.....
________________________________________
From: Mike Snitzer [snitzer@redhat.com]
Sent: Friday, July 18, 2014 7:38 AM
To: Hannes Reinecke
Cc: John Utz; dm-devel@redhat.com
Subject: Re: dm-multipath: Accept failed paths for multipath maps

On Fri, Jul 18 2014 at  1:57am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 07/18/2014 05:31 AM, John Utz wrote:
> >Thankyou very much for the exhaustive answer! I forwarded on to my
> > project peers because i don't think any of us where aware of the
> > existing infrastructure.
> >
> >Of course, said infrastructure would have to be taught about ZAC,
> > but it seems like it would be a nice place to start testing from....
> >
> ZAC is a different beast altogether; I've posted an initial set of
> patches a while back on linux-scsi.
> But I don't think multipath needs to be changed for that.
> Other areas of device-mapper most certainly do.

Pretty sure John is working on a new ZAC-oriented DM target.

YUP.

Per Ted T'so's suggestion several months ago, the goal is to create a new DM target that implements the ZAC/ZBC command set and the SMR write pointer architecture so that FSfolksen can try their hand at porting their stuff to it. 

It's in the very early stages so there is nothing to show yet, but development is ongoing. There are a few unknowns about how to surface some specific behaviors (new verbs and errors, particularly errors with sense codes that return a write pointer) but i have not gotten far enuf along in development to be able to construct succint and specific questions on the topic so that will have to wait for a bit.

Comments and questions welcome.

tnx!

johnu
