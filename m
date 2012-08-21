From: Milan Broz <mbroz@redhat.com>
Subject: Re: [RFC PATCH 00/20] dm-crypt: parallel processing
Date: Tue, 21 Aug 2012 11:37:43 +0200
Message-ID: <503356E7.4080604@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1345477953.git.mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids


On 08/21/2012 11:08 AM, Milan Broz wrote:
> Hello,
> 
> I promised to Mikulas that I will post remaining of his dm-crypt parallel
> processing patchset (plus some related changes) with some comments.
> 
> The problem:
> 
> The current implementation (using per cpu struct) always use encryption
> on the same CPU which submitted IO.
> 
> With very fast storage (usually SSD or MD RAID0) one CPU core can
> be limiting and the throughput of encrypted disk is worse in
> comparison with underlying storage.
> 
> Idea here is to distribute encryption to other CPU cores/CPUs.
> 
> (Side effect of patches is nice clean up dmcrypt code. :)

Better adding cc to Tejun here, I still think there are several things
which perhaps should be done through kernel wq...

(I would prefer to use kernel wq as well btw.)

Milan

> 
> Mikulas Patocka (20):
>   dm-crypt: remove per-cpu structure
>   dm-crypt: use unbound workqueue for request processing
>   dm-crypt: remove completion restart
>   dm-crypt: use encryption threads
>   dm-crypt: Unify spinlock
>   dm-crypt: Introduce an option that sets the number of threads.
>   dm-crypt: don't use write queue
>   dm-crypt: simplify io queue
>   dm-crypt: unify io_queue and crypt_queue
>   dm-crypt: don't allocate pages for a partial request.
>   dm-crypt: avoid deadlock in mempools
>   dm-crypt: simplify cc_pending
>   dm-crypt merge convert_context and dm_crypt_io
>   dm-crypt: move error handling to crypt_convert.
>   dm-crypt: remove io_pending field
>   dm-crypt: small changes
>   dm-crypt: move temporary values to stack
>   dm-crypt: offload writes to thread
>   dm-crypt: retain write ordering
>   dm-crypt: sort writes
> 
>  drivers/md/dm-crypt.c |  838 +++++++++++++++++++++++++++----------------------
>  1 file changed, 464 insertions(+), 374 deletions(-)
> 
> 
> My notes:
> 
> I extensively tested this (on top of 3.6.0-rc2) and while I like
> simplification and the main logic (if we have enough power why
> not use other CPUs) I see several problems here.
> 
> 1) The implementation is not much useful on modern CPUs with hw accelerated
> AES (with AES-NI even one core can saturate very fast storage).
> (Some optimized crypto behaves similar, like twofish optimized modules.)
> 
> 2) The patchset targets linear access pattern mainly and one
> process generating IOs. (With more processes/CPUs generating IOs
> you get parallel processing even with current code.)
> 
> I can see significant improvement (~30%) for linear read
> (if not using AES-NI) and if underlying storage is zero target
> (ideal situation removing scheduler from the stack).
> 
> For random access pattern (and more IO producers) I cannot find
> reliable improvement except ideal zero target case (where improvement
> is always >30%). For more producers it doesn't help at all.
> I tested RAID0 over SATA disks and very fast SSD on quad core cpu,
> dmcrypt running with 1, 3 or 4 threads (and with cfq and noop scheduler)
> using fio threaded test with 1 or 4 threads.
> 
> Notes to implementation:
> 
> 1) Last two patches (19/20) provides sorting of IO requests, this
> logically should be done in IO scheduler.
> 
> I don't think this should be in dmcrypt, if scheduler doesn't work
> properly, it should be fixed or tuned for crypt access pattern.
> 
> 2) Could be kernel workqueue used/fixed here instead? Basically all it needs
> is to prefer submitting CPU, if it is busy just move work to another CPU.
> 
> 3) It doesn't honour CPU hotplugging. Number of CPU is determined
> in crypt constructor. If hotplugging is used for CPU power saving,
> it will not work properly.
> 
> 4) With debugging options on, everything is extremely slower
> (Perhaps bug in some debug option, I just noticed this on Fedora
> rawhide with all debug on.)
> 
> 
> I posted it mainly because I think this should move forward,
> whatever direction...
> 
> Milan
