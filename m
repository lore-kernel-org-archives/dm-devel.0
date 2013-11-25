From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache invalidate_cblocks range parsing
Date: Mon, 25 Nov 2013 10:00:02 +0000
Message-ID: <20131125100002.GB10831@debian>
References: <33A0129EBFD46748804DE81B354CA1B21C0532E5@SACEXCMBX06-PRD.hq.netapp.com>
	<20131125095018.GA10831@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131125095018.GA10831@debian>
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

On Mon, Nov 25, 2013 at 09:50:19AM +0000, Joe Thornber wrote:
> On Sun, Nov 24, 2013 at 02:25:33AM +0000, Mears, Morgan wrote:
> > If one specifies a cblock range in the dm-cache invalidate_cblocks message
> > (commit 65790ff919e2e07ccb4457415c11075b245d643b), the final cblock in the 
> > range does not get invalidated.  For example, after:
> > 
> > 	dmsetup message cache 0 invalidate_cblocks 10-11
> > 
> > cblock 11 will still be in the cache.  The reason is the (begin != end)
> > check in process_invalidation_request() (dm-cache-target.c); were it to
> > change to (begin <= end), the final block would be treated like the rest.
> > 
> > However, parse_cblock_range() relies on the current behavior for the single
> > block case; if the change above were applied, an extra block would be
> > invalidated for each single-block invalidation request.
> > 
> > So: is the current behavior intentional?
> 
> Yes.

Documented in code, but I think Documentation/device-mapper/cache.txt should also say this.

/*                                                                                                                               
 * Defines a range of cblocks, begin to (end - 1) are in the range.  end is                                                      
 * the one-past-the-end value.                                                                                                   
 */

See 

https://github.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/tests/cache/invalidate_cblocks_tests.rb

for example uses.
