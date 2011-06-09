From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-kcopyd: optionally zero an area instead
	of copying
Date: Thu, 9 Jun 2011 11:04:30 +0100
Message-ID: <20110609100429.GE3152@ubuntu>
References: <Pine.LNX.4.64.1106081753570.7811@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106081753570.7811@hs20-bc2-1.build.redhat.com>
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

On Wed, Jun 08, 2011 at 05:55:37PM -0400, Mikulas Patocka wrote:
> Hi
> 
> This patch introduces an option to kcopyd to zero requested area instead 
> of copying. I think Joe may need something like this in his snapshot 
> store.

Could we have another function please, rather than overloading the
existing entry point?

i.e.,

int dm_kcopyd_zero(struct dm_kcopyd_client *kc,
		   unsigned num_dests, struct dm_io_region *dests,
		   unsigned flags, dm_kcopyd_notify_fn fn, void *context);

Thanks,

- Joe
