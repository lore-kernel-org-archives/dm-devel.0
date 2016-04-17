From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm cache metadata: fix cmd_read_lock acquiring write lock
Date: Sun, 17 Apr 2016 11:23:43 -0400
Message-ID: <20160417152343.GA26731@redhat.com>
References: <1460871429-22523-1-git-send-email-f.fallen45@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460871429-22523-1-git-send-email-f.fallen45@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Ahmed Samy <f.fallen45@gmail.com>
Cc: dm-devel@redhat.com, stable@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Apr 17 2016 at  1:37P -0400,
Ahmed Samy <f.fallen45@gmail.com> wrote:

> commit 9567366fefdd ("dm cache metadata: fix READ_LOCK macros and cleanup WRITE_LOCK macros")
> seemed to use down_write instead of down_read in cmd_read_lock(), yet
> releasing it with up_read() in READ_UNLOCK.  Fix it.
> 
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ahmed Samy <f.fallen45@gmail.com>

Ugh, very frustrating -- I must've looked at this code 3 different times
to try to make sure I didn't have a thinko.  And strangely sparse didn't
catch this locking bug (from cut-n-paste).

Anyway, thanks... I'll see if I can get this to Linus ASAP.

Mike
