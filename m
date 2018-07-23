From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Is thin provisioning still experimental?
Date: Mon, 23 Jul 2018 10:07:34 -0400
Message-ID: <20180723140734.GB28984@redhat.com>
References: <CAN-y+EK612pGsJTH-zO=FU0DpcFJxKfEHuDNs+6ufE6we9aK+g@mail.gmail.com>
	<20180723140053.GA28984@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180723140053.GA28984@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Drew Hastings <dhastings@crucialwebhost.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jul 23 2018 at 10:00am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Jul 23 2018 at  1:06am -0400,
> Drew Hastings <dhastings@crucialwebhost.com> wrote:
> 
> >    I love all of the work you guys do @dm-devel . Thanks for taking the time
> >    to read this.
> >    I would like to use thin provisioning targets in production, but it's hard
> >    to ignore the warning in the documentation. It seems like, with an
> >    understanding of how thin provisioning works, it should be safe to use.
> 
> It is stale.  I just committed this update that'll go upstream for the
> 4.19 merge window, see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.19&id=f88a3f746ff0047c92e8312646247b08264daf35
> 
> >    If the metadata and data device for the thin pool have enough space and
> >    are both error free, the kernel has plenty of free RAM, block sizes are
> >    set large enough to never run into performance issues (64 MiB), all of the
> >    underlying hardware is redundant on high performance NVME (no worries of
> >    fragmentation of data volume)... is it still unsafe for production? If so,
> >    can you shed some light on why that is?
> 
> It is safe.  You do just want to make sure to not run out of space.  We
> now handle that event favorably but it is best to tempt fate.

I meant: "... but it is best to _not_ tempt fate."
