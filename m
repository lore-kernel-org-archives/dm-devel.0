From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: max_sectors_kb limitations with VDO and dm-thin
Date: Wed, 24 Apr 2019 15:45:30 -0400
Message-ID: <20190424194529.GA14367@redhat.com>
References: <CAFTvtQ=HnGB2bw8heFR5rL=5K9FOAXbbyK65pqzO0MMFV3CEiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAFTvtQ=HnGB2bw8heFR5rL=5K9FOAXbbyK65pqzO0MMFV3CEiQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryan Norwood <ryan.p.norwood@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Apr 19 2019 at 10:40am -0400,
Ryan Norwood <ryan.p.norwood@gmail.com> wrote:

>    We have been using dm-thin layered above VDO and have noticed that our
>    performance is not optimal for large sequential writes as max_sectors_kb
>    and max_hw_sectors_kb for all thin devices are set to 4k due to the VDO
>    layer beneath.
>    This effectively eliminates the performance optimizations for sequential
>    writes to skip both zeroing and COW overhead when a write fully overlaps a
>    thin chunk as all bios are split into 4k which always be less than the 64k
>    thin chunk minimum.
>    Is this known behavior? Is there any way around this issue?

Are you creating the thin-pool to use a 4K thinp blocksize?  If not,
I'll have to look to see why the block core's block limits stacking
would impose these limits of the underlying data device.

>    We are using RHEL 7.5 with kernel 3.10.0-862.20.2.el7.x86_64.

OK, please let me know what the thin-pool's blocksize is.

Thanks,
Mike
