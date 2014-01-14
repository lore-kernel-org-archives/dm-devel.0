From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-log-userspace: Allow mark requests to piggyback
 on flush requests
Date: Mon, 13 Jan 2014 21:59:37 -0500
Message-ID: <20140114025937.GA5816@redhat.com>
References: <1389666600.12232.2.camel@f16>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1389666600.12232.2.camel@f16>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, dmzhang@suse.de
List-Id: dm-devel.ids

On Mon, Jan 13 2014 at  9:30pm -0500,
Jonathan Brassow <jbrassow@redhat.com> wrote:

> dm-log-userspace: Allow mark requests to piggyback on flush requests
> 
> In the cluster evironment, cluster write has poor performance.
> Because userspace_flush has to contact userspace program(cmirrord)
> in clear/mark/flush request. But both mark and flush requests
> require cmirrord to circle message to all the cluster nodes in each
> flush call.  This behave is realy slow. So the idea is merging
> mark and flush request together to reduce the kernel-userspace-kernel
> time.  Allow a new directive, "integrated_flush" that can be used to
> instruct the kernel log code to combine flush and mark requests when
> directed by userspace.  Additionlly, flush requests are performed
> lazily when only clear requests exist.
> 
> Signed-off-by: dongmao zhang <dmzhang@suse.com>
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Hey Jon,

Thanks for following through with this.  Should it be attributed to
dongmao as the author?
