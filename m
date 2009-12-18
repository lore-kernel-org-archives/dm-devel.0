From: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] scripts/checkpatch.pl: Change long line
	warning to 105 chars
Date: Fri, 18 Dec 2009 14:57:12 +0900
Message-ID: <20091218055712.GA4186@linux-sh.org>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
	<Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	<24653.1261110557@localhost>
	<1261113144.13734.317.camel@Joe-Laptop.home>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1261113144.13734.317.camel@Joe-Laptop.home>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Perches <joe@perches.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Andy Whitcroft <apw@canonical.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>
List-Id: dm-devel.ids

On Thu, Dec 17, 2009 at 09:12:24PM -0800, Joe Perches wrote:
> On Thu, 2009-12-17 at 23:29 -0500, Valdis.Kletnieks@vt.edu wrote:
> > Yeah, but I respectfully submit that if the regexp '^\t{6}' matches a non-
> > continuation line, it's probably in its rights to whinge. 
> > 	grep -r -P '^\t{7:}(?!(.*,$|.*\);$))' . | more
> > produces a whole lot of "this can't end well" output.
> 
> I think this is a good test to add to checkpatch.
> 
> Add 105 character long line WARN test
> Add 80 character long line STRICT test
> Add 6+ leading indent tabs test, consider restructuring
> 
This looks like a reasonable compromise.
