From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scripts/checkpatch.pl: Change long line
 warning to 105 chars
Date: Fri, 18 Dec 2009 09:31:19 -0800
Message-ID: <1261157479.24328.25.camel@Joe-Laptop.home>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
	<Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	<24653.1261110557@localhost>
	<1261113144.13734.317.camel@Joe-Laptop.home>
	<m3iqc41h83.fsf@intrepid.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3iqc41h83.fsf@intrepid.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Paul Mundt <lethal@linux-sh.org>, Mikulas Patocka <mpatocka@redhat.com>, Andy Whitcroft <apw@canonical.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, 2009-12-18 at 15:37 +0100, Krzysztof Halasa wrote:
> > Add 80 character long line STRICT test
> Not sure what do you mean.

CHK messages are only printed when --strict is on the command line

> This makes perfect sense, at least until shown otherwise (though being
> a warning instead of an error means it's ok to trigger in perfectly
> valid code).

It's a CHK, only printed with --strict.
