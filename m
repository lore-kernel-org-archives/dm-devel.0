From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] dm-stripe: discard support
Date: Tue, 27 Jul 2010 18:39:25 -0400
Message-ID: <20100727223925.GA2007@redhat.com>
References: <Pine.LNX.4.64.1007271737310.14765@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007271738500.14765@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007271738500.14765@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Jul 27 2010 at  5:42pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> A simplified discard support.
> 
> Note --- it is untested (I tested only non-discard requests). Mike, please 
> test.

Looks good.  My test cases work as expected.  I added some DMDEBUG to
help debugging (will send as a separate patch in case we'd prefer to
drop it).

I've rebased it to work with a 'for-2.6.36' block change and the latest
discard patches that Alasdair recently queued.

I'll post v2 of your 2nd patch shortly.

Thanks,
Mike
