From: <yael.chemla@foss.arm.com>
Subject: Re: md: dm-verity: aggregate crypto API calls
Date: Thu, 14 Dec 2017 09:54:24 +0200
Message-ID: <008101d374b0$c4b5ef00$4e21cd00$@foss.arm.com>
References: <1508921899-24801-1-git-send-email-yael.chemla@foss.arm.com>
	<20171025151916.GA28274@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171025151916.GA28274@redhat.com>
Content-Language: en-il
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'Mike Snitzer' <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

we are trying to be able to parallalize the handling of blocks, this patch is a precursor to that effort.
currently this patch does not change CPU utiliztion but we wanted to veritfy there is no objection to the direction first, hence sending the patch.

Thanks,
 Yael

-----Original Message-----
From: Mike Snitzer [mailto:snitzer@redhat.com] 
Sent: Wednesday, 25 October 2017 18:19
To: Yael Chemla <yael.chemla@foss.arm.com>
Cc: dm-devel@redhat.com
Subject: Re: md: dm-verity: aggregate crypto API calls

On Wed, Oct 25 2017 at  4:58am -0400,
Yael Chemla <yael.chemla@foss.arm.com> wrote:

> Current implementation makes multiple crypto API calls for a single 
> block, forcing underlying crypto tfm implementation to "stop & go", 
> leading to under utilization of CPU (e.g. SIMD state saves) or HW 
> engines. To fix it unify calls to crypto init/update/final into a 
> digest call with a single sg which contains multiple buffers.
> 
> This also opens the way later on to parallelizing the work on 
> different blocks.
> 
> Tested on physical Arm 32 and x86_64 and virtual ARM 64.
> 
> Performance numbers were not changed.

OK, but what about CPU utilization?  Was it reduced?

Thanks,
Mike
