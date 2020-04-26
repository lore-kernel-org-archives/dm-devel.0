From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: Re: [PATCH 0/2] Historical Service Time Path Selector
Date: Sun, 26 Apr 2020 16:00:17 -0400
Message-ID: <855zdm2f1q.fsf@collabora.com>
References: <20200416211336.2423618-1-krisman@collabora.com>
        <20200423205947.GA13657@lobo>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200423205947.GA13657@lobo> (Mike Snitzer's message of "Thu, 23
        Apr 2020 16:59:47 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, khazhy@google.com, kernel@collabora.com
List-Id: dm-devel.ids

Mike Snitzer <snitzer@redhat.com> writes:

>
> Looks like you've put a lot of time to this and I'd be happy to help
> you get this to land upstream.
>
> But... (you knew there'd be at least one "but" right? ;) I'm not
> liking making this path selector request-based specific.  All other
> selectors up to this point are request-based vs bio-based agnostic.
>
> Would you be open to dropping patch 1/2 and replacing it with
> something like the following patch?
>
> Then you'd pass 'u64 start_time_ns' into the path_selector_type's
> .end_io (and possibly .start_io).

I think it is fine.

Kind of a MD newbie question, but if I understand correctly,
dm_start_time_ns_from_clone is only for bio based multipath, and we just
pass req->io_start_time directly on request based multipath, right?  If
I understand the code correctly, start_io_acct is only called for the
bio level DM.

I will update the patches, do a quick round of tests with BIO based and
send a v2.

Thanks a lot,

-- 
Gabriel Krisman Bertazi
