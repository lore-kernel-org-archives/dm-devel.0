From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: default value for rr_min_io too high?
Date: Sun, 22 Jan 2006 17:43:24 +0000
Message-ID: <20060122174324.GC4280@agk.surrey.redhat.com>
References: <43CEB625.9000503@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43CEB625.9000503@netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Wed, Jan 18, 2006 at 04:41:57PM -0500, David Wysochanski wrote:
> I'm wondering where the value of 1000 came from, and

Thin air.

> whether that's really a good default.
 
Unlikely.

That's why we made it configurable - to make it easy to try out
different values and use whatever you find best.

Alasdair
-- 
agk@redhat.com
