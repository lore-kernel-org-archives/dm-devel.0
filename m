From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-thin: optimize power of two block size
Date: Mon, 18 Jun 2012 17:35:37 +0100
Message-ID: <20120618163536.GA3640@ubuntu>
References: <Pine.LNX.4.64.1206181003170.22564@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1206181003170.22564@file.rdu.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 18, 2012 at 10:09:56AM -0400, Mikulas Patocka wrote:
> Hi
> 
> This patch should be applied after 
> dm-thin-support-for-non-power-of-2-pool-blocksize.patch. It optimizes 
> power-of-two blocksize.

I'm going to nack this unless you can provide a benchmark that shows
it measurably improves performance for some architecture somewhere.
And a real benchmark, with io going through all the devices, not just
a micro benchmark of the 'if' in a tight loop.

- Joe
