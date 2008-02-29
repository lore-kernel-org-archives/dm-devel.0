From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in
	dm-crypt
Date: Fri, 29 Feb 2008 18:46:49 +0000
Message-ID: <20080229184649.GJ1788@agk.fab.redhat.com>
References: <200802281924.03996.rrs@researchut.com>
	<20080228232048.51e28c1d.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080228232048.51e28c1d.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ritesh Raj Sarraf <rrs@researchut.com>
Cc: linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

On Thu, Feb 28, 2008 at 11:20:48PM -0800, Andrew Morton wrote:
> On Thu, 28 Feb 2008 19:24:03 +0530 Ritesh Raj Sarraf <rrs@researchut.com> wrote:
> > Kernel: 2.6.24
> > Distribution: Debian Testing/Unstable
> > Tainted: Yes (nvidia proprietary drivers)

Any chance you can try to reproduce it upstream e.g. in 2.6.25-rc3?

There have been significant changes in this area of the code.

Alasdair
-- 
agk@redhat.com
