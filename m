From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: -mm merge plans for 2.6.21 --
	md-dm-reduce-stack-usage-with-stacked-block-devices.patch
Date: Sat, 10 Feb 2007 22:35:13 +0000
Message-ID: <20070210223513.GA7201@agk.surrey.redhat.com>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	<20070210095858.GA8145@osiris.boeblingen.de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070210095858.GA8145@osiris.boeblingen.de.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Feb 10, 2007 at 10:58:58AM +0100, Heiko Carstens wrote:
> Alasdair, is dm already fixed or is there any chance that it will
> ever get fixed?

I still expect us to get this changed within the next few months.  We've
dealt with the changes necessary to the crypt target for this.  The final
problem remaining is the core dm bio splitting code, and there's a related
locking problem in that code to tackle at the same time.

Alasdair
-- 
agk@redhat.com
