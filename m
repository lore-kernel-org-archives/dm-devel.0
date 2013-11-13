From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache fs corruption
Date: Wed, 13 Nov 2013 13:10:23 +0000
Message-ID: <20131113131022.GA13882@debian>
References: <CALwk7=z+Xc8Xrcw5jo8DtKwT9KS2gQMumtaHTws0w4+VDs2NwQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALwk7=z+Xc8Xrcw5jo8DtKwT9KS2gQMumtaHTws0w4+VDs2NwQ@mail.gmail.com>
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

On Wed, Nov 13, 2013 at 12:24:03PM +0200, Vladimir Smolensky wrote:
> Hello,
> I've been testing dm-cache for use with static web content.
> It appears that, when using big cache ~3TB(+20TB origin dev) dm-cache
> device corrupts the filesystem after block eviction starts to happen.
> If I set smaller cache size - single 480GB ssd(again with 20TB origin dev),
> the dm-cache dev works just fine.

Hi Vladmimir,

Sorry you've been having trouble, and thanks for taking the time to
report.  I'll see if I can scrape together enough disks to reproduce
the problem, and get back to you.

- Joe
