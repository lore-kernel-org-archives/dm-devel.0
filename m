From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [multipath-tools][PATCH] two small fixes
Date: Fri, 30 Sep 2005 16:16:34 +0200
Message-ID: <OF487CD56F.3D816B45-ONC125708C.004DA374-C125708C.004E5ECD@de.ibm.com>
References: <20050930122702.GB29806@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050930122702.GB29806@free.fr>
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

> >
> ok,
> btw, you forgot structs.c:alloc_path()

Oops. Sorry.
 
> > 
> > 2. The status information from path selectors that apply to paths are 
> > repeated for
> >         each path.
> > 
> > 
> Can you explain this with some example ... I fail to see the logic :/

For dmsetup status:

ess15-5320: 0 6835968 multipath 1 0 0 1 1 A 0 2 1 8:0 A 0 x 8:16 A 0 x
                                                ^

The 1 after the number of paths means the path selector will write 1 
additional piece of information
after the default output of each path. (e.g. <device> <state> <failcount> 
<something>)
The current code expects these data only once after all paths have been 
written but it has to skip
these data for every path. The round-robin slector doesn't use any data 
per path so the current
logic work but as soon as it is used you would fail to get the current 
state.

Stefan

SW Linux on zSeries Development & Services
Stefan.Bader@de.ibm.com
----------------------------------------------------------------------------------
  When all other means of communication fail, try words.
