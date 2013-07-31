From: Kumar amit mehta <gmate.amit@gmail.com>
Subject: Re: [PATCH] dm-lc.c: Audit return values of functions
 invoked in module init routine
Date: Tue, 30 Jul 2013 22:53:45 -0400
Message-ID: <20130731025345.GA25441@gmail.com>
References: <1375212580-6934-1-git-send-email-gmate.amit@gmail.com>
	<51F8C650.4080200@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <51F8C650.4080200@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jul 31, 2013 at 05:09:52PM +0900, Akira Hayakawa wrote:
> What if registering lc_mgr_target failed
> after registering lc_target succeeded?
> I think we should unregister the lc_target in this case.
> Am I wrong?

You are correct. I'll make the changes.

> Looking for some code samples,
> dm-snap.c and dm-thin.c have more than two targets to register
> like dm-lc does.
> 
> Below is a code fragment from dm-snap.c .
> It treats each failure in registering targets
> independently with different labels.
> 
> // dm-snap.c
> bad_exception_cache:
>         exit_origin_hash();
> bad_origin_hash:
>         dm_unregister_target(&merge_target);
> bad_register_merge_target:
>         dm_unregister_target(&origin_target);
> bad_register_origin_target:
>         dm_unregister_target(&snapshot_target);
> bad_register_snapshot_target:
>         dm_exception_store_exit();
> 
>         return r;

Thank you for your feedback and the pointers, I'll resend the patch.

!!amit
