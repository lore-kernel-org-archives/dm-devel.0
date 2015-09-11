From: Joe Thornber <thornber@redhat.com>
Subject: Re: Severe performance degradation for dm-cache mq since
 c86c3070
Date: Fri, 11 Sep 2015 13:58:00 +0100
Message-ID: <20150911125759.GA8137@rh-vpn>
References: <CABYiri_eRp7wzhTXCmDm4HUB3ZMsPUZxsS65-29c5o+RoWOX6w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABYiri_eRp7wzhTXCmDm4HUB3ZMsPUZxsS65-29c5o+RoWOX6w@mail.gmail.com>
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
Cc: heinzm@redhat.com, ejt@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 10, 2015 at 05:39:20PM +0300, Andrey Korolyov wrote:
> - dm-fio-3.10.txt and dm-fio-4.2.txt are showing results for 3.10/mq
> and 4.2/smq tests correspondingly, one can see a dramatic difference
> for an excessive bandwidth drop.

I've been trying your fio workload this morning on my system.  I do
see a regression in performance for the mq policy, but smq is faster
for me:

  - old version of mq - 636 seconds
  - current version of mq - 820 seconds
  - current version of smq - 585 seconds

This was running a smaller test than you with only 2G per thread.

Have you tried playing with the migration_threshold tunable?  With
random IO such as this we really want the cache to initially populate
the cache but then do no churning.  Could you give me the status line
for the caches once you've run the tests please?  This would tell me
how many blocks are being demoted.

- Joe
