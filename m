From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-cache suspend semantics
Date: Wed, 19 Aug 2015 19:42:05 +0100
Message-ID: <20150819184204.GC18567@agk-dp.fab.redhat.com>
References: <CAM2wQBsvnY+eBMxEFRy07f=16XnYmcdVQOewo-DWBseSnqAR9g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAM2wQBsvnY+eBMxEFRy07f=16XnYmcdVQOewo-DWBseSnqAR9g@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thanos Makatos <thanos.makatos@onapp.com>
Cc: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>, thornber@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Aug 19, 2015 at 12:26:20PM +0100, Thanos Makatos wrote:
> I'd like to know whether it is possible for a cache target for which
> there are dirty blocks to continue writing back dirty data after it
> has been suspended. Can this happen?

A suspended device-mapper device must not generate any I/O to the
devices underneath it while it is suspended.

Alasdair
