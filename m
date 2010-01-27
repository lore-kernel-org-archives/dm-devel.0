From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-flakey target refreshed for 2.6.33
Date: Wed, 27 Jan 2010 19:40:27 +0000
Message-ID: <20100127194027.GJ5478@agk-dp.fab.redhat.com>
References: <20100126192050.GA5550@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100126192050.GA5550@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Josef Bacik <josef@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jan 26, 2010 at 02:20:51PM -0500, Josef Bacik wrote:
> -changed SECTOR_FORMAT to "%llu"

We also cast the parameter to 'unsigned long long' to match when displaying
sectors.

> -changed DMERR to printk (for some reason DMERR was failing and I have no idea

We moved the target name ('flakey: ') inside the macro instead of having to
write it in every message - so it needed #define DM_MSG_PREFIX.

I've made these changes and they'll appear at
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
next time I sync up.

> with an fs without having to do crazy things like rip out cables, so if it could
> be included in mainline that would be helpful.  Thanks,
 
Well the main thing I'm missing is a Documentation file and a patch header.
This shouldn't be hard to write - any volunteers?  Kconfig should get a few
more words too.

It still needs a review for adherence to the latest dm standards, but that should
be really quick, given how small it is.

Alasdair
