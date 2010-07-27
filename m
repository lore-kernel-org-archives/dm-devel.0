From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1.5/2] dm-stripe: optimize sector division
Date: Tue, 27 Jul 2010 19:10:36 -0400
Message-ID: <20100727231036.GA5563@redhat.com>
References: <Pine.LNX.4.64.1007271737310.14765@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007271738500.14765@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007271811220.21698@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007271811220.21698@hs20-bc2-1.build.redhat.com>
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

On Tue, Jul 27 2010 at  6:12pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Optimize sector division
> 
> Optimize sector division --- if the number of stripes is a power of two,
> we don't have to do expensive division and can do shift and mask instead.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

(Tested and)

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
