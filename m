From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: fix nvme test
Date: Mon, 26 Feb 2018 15:50:40 -0500
Message-ID: <20180226205039.GA13722@redhat.com>
References: <alpine.LRH.2.02.1802261522141.5096@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1802261522141.5096@file01.intranet.prod.int.rdu2.redhat.com>
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

On Mon, Feb 26 2018 at  3:22pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> The strncmp function should compare 4 bytes.

Ah yeap, thanks.

> But I'm wondering what's the purpose of this test at all? bio-based 
> interface doesn't support partial completions for any device - so why do 
> we need special code path just for nvme?

request-based does support partial completions, it is the underlying
devices that matter here, not the upper layer DM device type.

The rationale for this atomic operation requirement is mainly historic:
previously DM_TYPE_NVME_BIO_BASED was (ab)using blk_steal_bios() to
retry a request that failed with a retryable error (as part of a hook
that never was allowed to be introduced to the NVMe request completion
code-path).  For that model it was important that the underlying device
not partially complete its request; because on retry all of the bios
were getting stolen from the request and resubmitted in their entirety
back to the upper layer bio-based device (multipath in my historic
case).

Now that DM_TYPE_NVME_BIO_BASED isn't making use of blk_steal_bios() we
_could_ relax this constraint but I'd prefer to have the option of
using blk_steal_bios() in the future.

> and why can't we use it for other block devices?

I'm not exactly sure about what you mean by "it" but I'll assume you
mean: why can't we use direct_make_request() for other devices?  I've
purposely constrained DM_TYPE_NVME_BIO_BASED to mean we have a target
that is an immutable singleton that is only layered on an NVMe device.
I know this case to currently be uniquely suited for use with
direct_make_request(): no splitting can occur and no partial completion
is used by the underlying driver (the latter less important than the
former).

Mike
