From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: md: dm-verity: aggregate crypto API calls
Date: Wed, 25 Oct 2017 11:19:17 -0400
Message-ID: <20171025151916.GA28274@redhat.com>
References: <1508921899-24801-1-git-send-email-yael.chemla@foss.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1508921899-24801-1-git-send-email-yael.chemla@foss.arm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yael Chemla <yael.chemla@foss.arm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 25 2017 at  4:58am -0400,
Yael Chemla <yael.chemla@foss.arm.com> wrote:

> Current implementation makes multiple crypto API calls for a single
> block, forcing underlying crypto tfm implementation to "stop & go",
> leading to under utilization of CPU (e.g. SIMD state saves) or HW
> engines. To fix it unify calls to crypto init/update/final into a digest
> call with a single sg which contains multiple buffers.
> 
> This also opens the way later on to parallelizing the work on different
> blocks.
> 
> Tested on physical Arm 32 and x86_64 and virtual ARM 64.
> 
> Performance numbers were not changed.

OK, but what about CPU utilization?  Was it reduced?

Thanks,
Mike
