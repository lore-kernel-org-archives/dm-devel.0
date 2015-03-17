From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] dm-verity: Add error handling modes for
	corrupted blocks
Date: Tue, 17 Mar 2015 10:23:34 +0000
Message-ID: <20150317102334.GA35360@google.com>
References: <20150316155559.GA32397@google.com>
	<CABqD9hak_3uhczdpj70WDH9A2FfgT69zdvV8+xDH8omFEhPvSA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABqD9hak_3uhczdpj70WDH9A2FfgT69zdvV8+xDH8omFEhPvSA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Will Drewry <wad@chromium.org>
Cc: Mandeep Baines <msb@chromium.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 16, 2015 at 05:13:10PM -0500, Will Drewry wrote:
> > +       if (v->corrupted_errs >= DM_VERITY_MAX_CORRUPTED_ERRS)
> > +               goto out;
> > +
> > +       ++v->corrupted_errs;
> > +
> 
> The conditional and increment should be moved below the DMERR_LIMIT().
> Otherwise, no logging will occur in non-logging modes.

This only limits the maximum number of logged errors, but until it's reached,
it does log them in all modes.

> This would be a change from how the default "eio" mode behaves today.

The only difference is that it will stop logging after reaching the maximum.

> > +       DMERR_LIMIT("%s: %s block %llu is corrupted", v->data_dev->name,
> > +               type_str, block);
> 
> Perhaps it'd make sense to consider whether to use DMERR_LIMIT or not
> depending on if the mode is logging.  Otherwise you may get weird
> interactions from having two different limits.

My intention was initially to use DMERR_LIMIT to handle error bursts, but you
are correct, it's not needed. I'll change this to DMERR in v2.

> >                         v->hash_failed = 1;
> 
> Should the dm status reflect the failure even if logging mode isn't
> returning EIOs? I think it makes sense still, but it might be good to
> note that it is intentionally kept this way.

Yes, I think it makes sense. We should be able to check the device status and
see if there have been corrupted blocks even in logging mode. I will move this
to the error handling function and add a note about it.

Sami
