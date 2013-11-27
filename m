From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache invalidate_cblocks range parsing
Date: Wed, 27 Nov 2013 12:12:32 +0000
Message-ID: <20131127121231.GA18478@debian>
References: <33A0129EBFD46748804DE81B354CA1B21C0532E5@SACEXCMBX06-PRD.hq.netapp.com>
	<20131125224618.GG27771@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131125224618.GG27771@agk-dp.fab.redhat.com>
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

On Mon, Nov 25, 2013 at 10:46:18PM +0000, Alasdair G Kergon wrote:
> On Sun, Nov 24, 2013 at 02:25:33AM +0000, Mears, Morgan wrote:
> > 	dmsetup message cache 0 invalidate_cblocks 10-11
> > cblock 11 will still be in the cache.  
> 
> I think that should be changed.

It's fine as it is.  Besides, this interface is for machine use.
Changing will involve changing the test suite, and era tools.  Go and
find something worthwhile to do rather than generating more work for
those who actually write something.

- Joe
