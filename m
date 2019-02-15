From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm thin: Fix bug wrt FUA request
	completion
Date: Thu, 14 Feb 2019 19:10:55 -0500
Message-ID: <20190215001054.GA17160@redhat.com>
References: <20190214232138.25667-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190214232138.25667-1-ntsironis@arrikto.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Feb 14 2019 at  6:21pm -0500,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> When provisioning a new data block for a virtual block, either because
> the block was previously unallocated or because we are breaking sharing,
> if the whole block of data is being overwritten the bio that triggered
> the provisioning is issued immediately, skipping copying or zeroing of
> the data block.
> 
> When this bio completes the new mapping is inserted in to the pool's
> metadata by process_prepared_mapping(), where the bio completion is
> signaled to the upper layers.
> 
> This completion is signaled without first committing the metadata. If
> the bio in question has the REQ_FUA flag set and the system crashes
> right after its completion and before the next metadata commit, then the
> write is lost despite the REQ_FUA flag requiring that I/O completion for
> this request is only signaled after the data has been committed to
> non-volatile storage.
> 
> Fix this by deferring the completion of overwrite bios, with the REQ_FUA
> flag set, after the metadata has been committed.
> 
> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
> ---
>  drivers/md/dm-thin.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 50 insertions(+), 5 deletions(-)
> 
> Changes in v2:
>   - Add missing bio_list_init() in pool_create()
> 
> v1: https://www.redhat.com/archives/dm-devel/2019-February/msg00064.html

Thanks a lot for your fix.  Amazing this was missed until now.

I staged your fix in linux-next and will be sending it to Linus
tomorrow (you'll note I tweaked the subject and header very slightly):

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.0&id=4ae280b4ee3463fa57bbe6eede26b97daff8a0f1

Thanks again,
Mike
