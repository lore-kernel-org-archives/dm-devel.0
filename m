From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: How to properly benchmark dm-cache
Date: Fri, 1 Sep 2017 11:58:30 -0400
Message-ID: <20170901155829.GA17442@redhat.com>
References: <A4C6B4012E4D254597FE91E8CF2C135D01063C9714@EXMAIL1.taec.toshiba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <A4C6B4012E4D254597FE91E8CF2C135D01063C9714@EXMAIL1.taec.toshiba.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Remington Brasga <Remington.Brasga@taec.toshiba.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 31 2017 at  5:29pm -0400,
Remington Brasga <Remington.Brasga@taec.toshiba.com> wrote:

>    Hi, I'm trying to benchmark dm-cache, but I'm having trouble getting the
>    benchmark to show positive results. I've tried TPC-B, TPC-C, TPC-H, SQL,
>    and a handful of other, but I think because they are simulations they
>    don't generate the `hot spots' required to promote blocks to the cache.
> 
>    I know it's easy to show results using FIO with a specific configuration,
>    but I was hoping to use a real benchmark like the ones I've tried.
> 
>    Does anyone have a good set of benchmarks that shows positive results?

Hi Remi,

Which kernel are you testing?

I know Sanjay Rao (cc'd) has done various dm-cache testing with an OLTP
workload against an Oracle DB and that he has seen very solid results
with the latest dm-cache.

I'm not sure if he, or others, tried any of the TPC variants but
hopefully Sanjay can respond with where/how he got dm-cache to respond
well to his tests.

Mike
