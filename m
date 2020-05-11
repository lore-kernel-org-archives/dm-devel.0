From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: Re: [PATCH v4 0/2] Historical Service Time Path Selector
Date: Mon, 11 May 2020 14:46:21 -0400
Message-ID: <85blmul37m.fsf@collabora.com>
References: <20200511163910.3778467-1-krisman@collabora.com>
        <20200511170235.GA7719@redhat.com> <85ftc6l7lb.fsf@collabora.com>
        <20200511173155.GA7892@redhat.com> <20200511184143.GA8274@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200511184143.GA8274@redhat.com> (Mike Snitzer's message of
        "Mon, 11 May 2020 14:41:43 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, song@kernel.org, breeves@redhat.com, mpatocka@redhat.com, khazhy@google.com, kernel@collabora.com
List-Id: dm-devel.ids

Mike Snitzer <snitzer@redhat.com> writes:

> OK, that concall's issue had nothing to do with needing higher
> resolution time (was about IOPs realized with requested-based vs
> bio-based).
>
> Reality is, DM won't need anything higher resolution than jiffies until
> block core's interfaces require something other than jiffies
> (e.g. generic_end_io_acct).
>
> So feel free to proceed with the conditional time fetch solution you
> were going to run with (prior to my previous mail asking you to hold
> off).
>
> Sorry for the noise.  Thanks,
> Mike

No problem, thanks for the information.  I get started on it.


-- 
Gabriel Krisman Bertazi
