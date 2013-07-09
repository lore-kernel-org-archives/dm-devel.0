From: Joe Thornber <thornber@redhat.com>
Subject: Re: test needed for a dm-bufio patch
Date: Tue, 9 Jul 2013 18:00:49 +0100
Message-ID: <20130709170048.GA25314@debian>
References: <alpine.LRH.2.02.1307021747280.2229@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1307021747280.2229@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Jul 02, 2013 at 05:51:50PM -0400, Mikulas Patocka wrote:
> Hi Joe
>
> Could you please try this patch
> http://people.redhat.com/agk/patches/linux/editing/dm-bufio-submit-writes-outside-lock.patch
> and test if it generates some regressions for dm-thin?

Hi Mikulas,

I've run a couple of cache tests and don't see any regressions.
performance is similar.  I'll include it in my tree since it seems to
be a good thing.

- Joe
