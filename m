From: Mike Snitzer <snitzer@redhat.com>
Subject: please fetch new git-based DM 'for-next' branch [was:
 Re: [git pull] device-mapper changes for 3.11]
Date: Fri, 16 Aug 2013 17:18:10 -0400
Message-ID: <20130816211810.GA8668@redhat.com>
References: <20130711013448.GD32399@agk-dp.fab.redhat.com>
	<20130711162040.8a82cb97a6c647c4f61f919b@canb.auug.org.au>
	<20130711135522.GN8530@agk-dp.fab.redhat.com>
	<20130712110303.06095e7b41c49c35bcd61fab@canb.auug.org.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130712110303.06095e7b41c49c35bcd61fab@canb.auug.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 11 2013 at  9:03pm -0400,
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Alasdair,
> 
> On Thu, 11 Jul 2013 14:55:22 +0100 Alasdair G Kergon <agk@redhat.com> wrote:
> >
> > On Thu, Jul 11, 2013 at 04:20:40PM +1000, Stephen Rothwell wrote:
> > > Alistair, is there some reason that you cannot maintain some relatively
> > > stable git tree for me to fetch (instead of the quilt series).  
> > 
> > Well Mike Snitzer is becoming a joint maintainer and this also requires
> > changes to the workflow so watch this space.
> 
> OK, noted.

Hi Stephen,

To access all future DM changes for linux-next, please switch from
Alasdair's quilt tree to using the 'for-next' branch of the DM git repo:

git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git

Thanks,
Mike
