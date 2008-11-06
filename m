From: malahal@us.ibm.com
Subject: Re: RFC: Patch to dm-raid1 to allow error type in
	status output - even when !errors_handled
Date: Thu, 6 Nov 2008 10:50:48 -0800
Message-ID: <20081106185048.GC10469@us.ibm.com>
References: <1225994398.29143.3.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1225994398.29143.3.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

The patch looks fine, but instead of having this in the mirror target,
how about a separate target that handles this? I believe, reads and
writes are not distinguished with this patch, in other words
applications (like pvmove) doesn't know the write failures until it
actually checks your error status bits.

As I said, how about a failure target that accepts only read failure,
only write failure, maybe all kinds of failures. Pvmove can use
'ignore failures' target on top of a PV while moving to ignore any read
failures from it.

--Malahal.

Jonathan Brassow [jbrassow@redhat.com] wrote:
> I have not compiled or tested this patch at this point... just looking
> for feedback.
> 
>  brassow
> 
> Device-mapper mirrors are allowed to either handle or ignore
> device errors/failures.  In some cases, it is desirable to
> ignore errors.  For example, when using 'pvmove' to move data
> off of a failing device, we just want to get all the data we
> can and not stop for failures.
> 
> Currently, when failures are ignored, they are completely ignored.
> They are not recorded and have no affect on the mirror.  I think
> it would be more beneficial to at least record the information -
> even though no action is taken.  This way, the status output could
> indicate that a problem occurred.  Since the status output is
> backwards compatible with older programs, those older programs
> would simply ignore the new information.  Newer or updated programs,
> on the other hand, would be able to see that something had happened
> - even if they didn't want to take action.  (Imagine copying off
> data from a failing drive.  You may want to copy all that you can
> without stopping for failures, but you still want to know if some
> regions didn't get copied properly.)
> 
> The way to do this is to move the 'errors_handled' check after the
> error accounting in fail_mirror (but before action is taken to
> change the primary mirror, etc.).  The error accounting is done by
> incrementing 'error_count' and setting 'error_type'.  Since these
> variables can now have non-zero value, even when not handling
> errors, we must couple a check for 'errors_handled' in the places
> where 'error_count' is checked - specifically, 'choose_mirror',
> 'default_ok', and 'do_reads'.
> 
> We handle 'choose_mirror' a little bit more cleverly than just
> mitigating the 'error_count' with a check for 'errors_handled'.
> In this case, if the region is in sync, we still try to find
> a mirror that has not failed (just in case we would read stale
> data); but if there is no other option, we can still give the
> default mirror if we are ignoring errors.
> 
> 
> Index: linux-2.6/drivers/md/dm-raid1.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-raid1.c
> +++ linux-2.6/drivers/md/dm-raid1.c
> @@ -197,9 +197,6 @@ static void fail_mirror(struct mirror *m
>  	struct mirror_set *ms = m->ms;
>  	struct mirror *new;
> 
> -	if (!errors_handled(ms))
> -		return;
> -
>  	/*
>  	 * error_count is used for nothing more than a
>  	 * simple way to tell if a device has encountered
> @@ -210,6 +207,9 @@ static void fail_mirror(struct mirror *m
>  	if (test_and_set_bit(error_type, &m->error_type))
>  		return;
> 
> +	if (!errors_handled(ms))
> +		return;
> +
>  	if (m != get_default_mirror(ms))
>  		goto out;
> 
> @@ -369,14 +369,15 @@ static struct mirror *choose_mirror(stru
>  			m += ms->nr_mirrors;
>  	} while (m != get_default_mirror(ms));
> 
> -	return NULL;
> +	return (errors_handled(ms)) ? NULL : m;
>  }
> 
>  static int default_ok(struct mirror *m)
>  {
>  	struct mirror *default_mirror = get_default_mirror(m->ms);
> 
> -	return !atomic_read(&default_mirror->error_count);
> +	return !errors_handled(m->ms) ||
> +		!atomic_read(&default_mirror->error_count);
>  }
> 
>  static int mirror_available(struct mirror_set *ms, struct bio *bio)
> @@ -483,7 +484,8 @@ static void do_reads(struct mirror_set *
>  		 */
>  		if (likely(region_in_sync(ms, region, 1)))
>  			m = choose_mirror(ms, bio->bi_sector);
> -		else if (m && atomic_read(&m->error_count))
> +		else if (m && errors_handled(ms) &&
> +			 atomic_read(&m->error_count))
>  			m = NULL;
> 
>  		if (likely(m))
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
