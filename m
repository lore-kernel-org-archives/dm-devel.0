From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/2] dm clone: Minor fixes
Date: Thu, 12 Sep 2019 09:33:40 -0400
Message-ID: <20190912133339.GA5709@redhat.com>
References: <20190912121137.26567-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190912121137.26567-1-ntsironis@arrikto.com>
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
Cc: vkoukis@arrikto.com, dm-devel@redhat.com, agk@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

On Thu, Sep 12 2019 at  8:11am -0400,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> Hi Mike,
> 
> I examined the diff between v3 of dm-clone and the staged version and it
> looks fine.
> 
> This patch set includes some minor fixes to fold in:
> 
>   - Rename 'md' to 'cmd' also in dm-clone-metadata.h, to be consistent
>     with the changes in dm-clone-metadata.c
> 
>   - Explicitly include the header file for kvmalloc(). This is not
>     strictly required, as the header file is included indirectly by
>     other header files, but I think it's safer to include it anyway.

I've folded these in via rebase.

Thanks,
Mike
