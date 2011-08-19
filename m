From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: convert dm-thin to use dm-bufio
Date: Fri, 19 Aug 2011 15:11:42 +0100
Message-ID: <20110819141142.GF32643@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
	<20110816091600.GA4284@ubuntu>
	<Pine.LNX.4.64.1108161755510.15859@hs20-bc2-1.build.redhat.com>
	<20110817082656.GA3267@ubuntu>
	<Pine.LNX.4.64.1108181830050.7668@hs20-bc2-1.build.redhat.com>
	<20110819070435.GA32300@redhat.com> <20110819091106.GA3193@ubuntu>
	<20110819094604.GA1059@redhat.com> <20110819102215.GA5069@ubuntu>
	<20110819134921.GB1335@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110819134921.GB1335@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Joe Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 19, 2011 at 09:49:21AM -0400, Mike Snitzer wrote:
> On Fri, Aug 19 2011 at  6:22am -0400,
> Joe Thornber <thornber@redhat.com> wrote:
> > Assuming agk doesn't decide to switch over to a kmemcache.  Remember
> > bm used to allocate via kmalloc or pages like bufio.
> Indeed.
  
The basic requirement is to know accurately how much memory is being used
by the module (and ultimately per-pool device) as I can imagine cases 
where it's using a significant proportion of the system's memory.

I doubt kmemcache would be a satisfactory solution for bufio, but there
are other ways to meet this requirement, such as exporting this
information in /sys.  Initally just a global figure for the module, but
evenutally reported per-device (with dm-core support and new target
callbacks).

Alasdair
