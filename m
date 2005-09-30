From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFT/RFC 2/4] add dm_scsi helpers
Date: Fri, 30 Sep 2005 15:01:36 -0500
Message-ID: <433D99A0.50505@cs.wisc.edu>
References: <1128109336.24395.23.camel@max>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1128109336.24395.23.camel@max>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Mike Christie wrote:
> I took this function from the cleanup I am doing in the
> scsi layer. Unfortunately that work needs some things
> fleshed out so I do not know when it will ever be merged.
> For now so that dm can move forward I put only what we need
> in dm-hw-handler.c and when the scsi-ml work gets
> finished I hope we can merge the two or most likely add a
> wrapper around the scsi function since we need mempools for
> some of our structs.
> 

oh yeah that reminds me, does anyone know if we will ever need very 
large requests? A meg, or a couple of megs, or something that cannot be 
handled with a kmalloc. Just wondering becuase for the scsi stuff we 
need iovec/bvec/scatterlist support which I am working on.
