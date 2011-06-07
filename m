From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
 structure
Date: Tue, 7 Jun 2011 13:50:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106071321300.8279@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
	<20110601095106.GA3718@ubuntu>
	<Pine.LNX.4.64.1106021536240.31532@hs20-bc2-1.build.redhat.com>
	<20110603110111.GA4969@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110603110111.GA4969@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Joe Thornber <thornber@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Fri, 3 Jun 2011, Joe Thornber wrote:

> On Thu, Jun 02, 2011 at 03:55:16PM -0400, Mikulas Patocka wrote:
> > > iv) you haven't explained how the sys admin works out the correct
> > > throttle value.
> > 
> > There is no "correct" value. The "correct" value depends on how important 
> > is copying itself v.s. other i/o.
> 
> So who is going to set this?  Do you really have no advice for them
> beyond 'there is no correct value'?

I did some tests. I did some random and sequential I/O on the same disk 
while mirror was resynchronizing. The result is this:

random read:
mirror throttle / IOs per second
100%	94
75%	113
50%	127
25%	145
idle	160

sequential read:
mirror throttle / throughput MB/s
100%	104
75%	118
50%	122
25%	127
idle	134

Mikulas
