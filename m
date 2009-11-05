From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: possible regression by the barrier patch in
	2.6.30-rc2
Date: Thu, 5 Nov 2009 02:04:02 +0000
Message-ID: <20091105020402.GP13375@agk-dp.fab.redhat.com>
References: <49E80C1E.1040905@ct.jp.nec.com>
	<20090417132252.GA7843@agk.fab.redhat.com>
	<49EBF994.90801@ct.jp.nec.com>
	<Pine.LNX.4.64.0904200217230.22707@hs20-bc2-1.build.redhat.com>
	<20091028152139.GP25303@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0911042042350.22545@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911042042350.22545@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 04, 2009 at 08:53:23PM -0500, Mikulas Patocka wrote:
> On Wed, 28 Oct 2009, Alasdair G Kergon wrote:
> > This can be either a "suspend with flush" OR the
> > flush could have been issued prior to the suspend (and any decent database
> > would have done that).
 
> I'm somehow starting to think that "flush" suspend is not needed at all 
> and all suspends may be "noflush". 

Indeed - that was what my email was trying to say - 'decent database' is
the one you describe, which waits properly, and the only reason for 'flush
suspend' is backwards compatibility with our previous releases to support
poorly-written software (which quite probably doesn't exist).

Alasdair
