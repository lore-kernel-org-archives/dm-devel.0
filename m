From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm kcopyd: Increase sub-job size to 512KiB
Date: Mon, 15 Jul 2019 14:22:21 -0400
Message-ID: <20190715182221.GB15315@redhat.com>
References: <20190603134017.9323-1-ntsironis@arrikto.com>
	<b6cdb071-f8d3-7c09-c938-71689ceb1c95@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <b6cdb071-f8d3-7c09-c938-71689ceb1c95@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Fri, Jul 12 2019 at  9:45am -0400,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> Hi Mike,
> 
> A kind reminder about this patch. Do you require any changes or will you
> merge it as is?

I think we need changes to expose knob(s) to tune this value on a global
_and_ device level via sysfs.  E.g.:

1) dm_mod module param for global
2) but also allow a per-device override, like:
   echo 512 > /sys/block/dm-X/dm/kcopyd_subjob_size

1 is super easy and is a start.  Layering in 2 is a bit more involved.

In hindsight (given how risk-averse I am on changing the default) I
should've kept the default 128 but allowed override with modparam
dm_mod.kcopyd_subjob_size=1024

Would this be an OK first step?

If so, we're still in the 5.3 merge window, I'll see what I can do.

Thanks,
Mike
