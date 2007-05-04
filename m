From: Neil Brown <neilb@suse.de>
Subject: Re: + kcopyd-use-mutex-instead-of-semaphore.patch added
	to -mm tree
Date: Fri, 4 May 2007 16:25:09 +1000
Message-ID: <17978.53701.832765.808256@notabene.brown>
References: <200705040552.l445q3lu030085@shell0.pdx.osdl.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from akpm@linux-foundation.org on Thursday May 3
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: akpm@linux-foundation.org
Cc: dm-devel@redhat.com, matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org
List-Id: dm-devel.ids


Should be
  Cc: dm-devel@redhat.com

Maybe there should be a Cc: line in the top of each file??

Thanks,
NeilBrown


On Thursday May 3, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Kcopyd: use mutex instead of semaphore
> has been added to the -mm tree.  Its filename is
>      kcopyd-use-mutex-instead-of-semaphore.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: Kcopyd: use mutex instead of semaphore
> From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> 
> Kcopyd uses a semaphore as mutex.  Use the mutex API instead of the (binary)
> semaphore,
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> Cc: Neil Brown <neilb@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/md/kcopyd.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff -puN drivers/md/kcopyd.c~kcopyd-use-mutex-instead-of-semaphore drivers/md/kcopyd.c
> --- a/drivers/md/kcopyd.c~kcopyd-use-mutex-instead-of-semaphore
> +++ a/drivers/md/kcopyd.c
> @@ -198,7 +198,7 @@ struct kcopyd_job {
>  	 * These fields are only used if the job has been split
>  	 * into more manageable parts.
>  	 */
> -	struct semaphore lock;
> +	struct mutex lock;
>  	atomic_t sub_jobs;
>  	sector_t progress;
>  };
> @@ -459,7 +459,7 @@ static void segment_complete(int read_er
>  	sector_t count = 0;
>  	struct kcopyd_job *job = (struct kcopyd_job *) context;
>  
> -	down(&job->lock);
> +	mutex_lock(&job->lock);
>  
>  	/* update the error */
>  	if (read_err)
> @@ -483,7 +483,7 @@ static void segment_complete(int read_er
>  			job->progress += count;
>  		}
>  	}
> -	up(&job->lock);
> +	mutex_unlock(&job->lock);
>  
>  	if (count) {
>  		int i;
> @@ -565,7 +565,7 @@ int kcopyd_copy(struct kcopyd_client *kc
>  		dispatch_job(job);
>  
>  	else {
> -		init_MUTEX(&job->lock);
> +		mutex_init(&job->lock);
>  		job->progress = 0;
>  		split_job(job);
>  	}
> _
> 
> Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are
> 
> origin.patch
> include-kern_-constant-in-printk-calls-in-mm-slabc.patch
> srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
> power-management-use-mutexes-instead-of-semaphores.patch
> sysdev-use-mutex-instead-of-semaphore.patch
> git-dvb.patch
> use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
> qla1280-use-dma_64bit_mask-instead-of-0ull.patch
> use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
> use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
> use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch
> use-mutex-instead-of-semaphore-in-rocketport-driver.patch
> use-mutex-instead-of-semaphore-in-tpm-driver.patch
> use-mutex-instead-of-semaphore-in-hdaps-driver.patch
> use-mutex-instead-of-semaphore-for-misc-char-devices.patch
> fix-spinlock-usage-in-hysdn_log_close.patch
> use-mutex-instead-of-semaphore-in-capi-20-interface.patch
> use-mutex-instead-of-semaphore-in-virtual-console-driver.patch
> kcopyd-use-mutex-instead-of-semaphore.patch
> pvrusb2-use-mutex-instead-of-semaphore.patch
> scx200-use-mutex-instead-of-semaphore.patch
