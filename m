From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-thin: Fix deadlock with unknown device id
Date: Thu, 4 Aug 2011 11:55:17 -0400
Message-ID: <20110804155516.GA4303@redhat.com>
References: <Pine.LNX.4.64.1108041134590.29961@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108041134590.29961@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Edward Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

On Thu, Aug 04 2011 at 11:35am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> dm-thin: Fix deadlock with unknown device id
> 
> If dm-thin device is created with unknown device id, the code calls
> dm_put(pool_md) twice. As a consequence, the reference count underflows
> and causes deadlock on device removal.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

My fault.  Thanks Mikulas.
