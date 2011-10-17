From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-bufio
Date: Mon, 17 Oct 2011 17:43:53 +0100
Message-ID: <20111017164353.GC14913@ubuntu>
References: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
	<20111017112904.GH13963@ubuntu>
	<Pine.LNX.4.64.1110171223010.21071@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110171223010.21071@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 17, 2011 at 12:24:00PM -0400, Mikulas Patocka wrote:
> On Mon, 17 Oct 2011, Joe Thornber wrote:
> 
> > On Fri, Oct 14, 2011 at 03:14:34PM -0400, Mikulas Patocka wrote:
> > > Hi
> > > 
> > > This is a patch for dm-bufio.
> > 
> > I've merged all I'm going to at this point and pushed to thin-dev.
> 
> I think Alasdair currently holds the master version of this code. Or is it 
> you? If we had three versions of the same code and don't know which one is 
> the master, then there is a problem.

I consider my tree to be the master of thin-provisioning, and will be
very annoyed if anything gets pushed to linux-next that hasn't been
sent to me first.  dm-bufio is yours to maintain in the long term -
I'm just taking an interest because it's blocking acceptance of my
code.
