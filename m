From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm: Don't install merge function if
	not	needed
Date: Tue, 21 Jun 2011 21:24:24 +0100
Message-ID: <20110621202424.GK19996@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1106211604110.22545@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106211604110.22545@hs20-bc2-1.build.redhat.com>
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
List-Id: dm-devel.ids

On Tue, Jun 21, 2011 at 04:08:52PM -0400, Mikulas Patocka wrote:
> possible, because the merge function must be obeyed.

The merge function is only a hint, albeit a strong hint - not a hard
requirement.  (Otherwise we're back to the ideas of block-layer
reservations/cancellations and limitations on suspend which we didn't
want to implement.)

If you are still seeing a problem with md in this respect, please could
you post the details for us to discuss?

Alasdair
