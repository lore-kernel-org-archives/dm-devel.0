From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1 of 2]: DM RAID: Move
	'sectors_per_dev'	calculation
Date: Wed, 4 Jul 2012 02:18:32 +0100
Message-ID: <20120704011832.GF22022@agk-dp.fab.redhat.com>
References: <1340701060.19015.27.camel@f16>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1340701060.19015.27.camel@f16>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jun 26, 2012 at 03:57:40AM -0500, Jon Brassow wrote:
> dm-raid:  Move sectors_per_dev calculation later in the device creation process
 
There's an obvious conflict here: split_io has gone!

Please rebase these patches to come *after* the patches already in linux-next.

  http://people.redhat.com/agk/patches/linux/editing/series.html
  as far as the NEXT_PATCHES_END marker.

Thanks,
Alasdair
