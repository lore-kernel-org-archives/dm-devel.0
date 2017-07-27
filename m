From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-integrity: count failures
Date: Thu, 27 Jul 2017 11:49:33 -0400
Message-ID: <20170727154933.GA6876@redhat.com>
References: <alpine.LRH.2.02.1707211158450.31337@file01.intranet.prod.int.rdu2.redhat.com>
	<547cd6c7-4920-c750-cfb8-40a3492380c9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <547cd6c7-4920-c750-cfb8-40a3492380c9@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 27 2017 at  9:10am -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> On 07/21/2017 06:00 PM, Mikulas Patocka wrote:
> > This is a patch to count errors in dm-integrity - as Jon suggested.
> > 
> > This patch changes dm-integrity so that it counts the number of checksum
> > failures and reports the counter in the status line.
> 
> Please increase minor target version when adding such table/status feature.

OK, I bumped the version from 1.0.0 to 1.1.0 and pushed to linux-next
for 4.14 inclusion.

Thanks,
Mike
