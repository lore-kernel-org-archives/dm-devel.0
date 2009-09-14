From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: recent bdi changes result in WARN_ON on luksClose / dm
Date: Mon, 14 Sep 2009 14:27:57 +0200
Message-ID: <20090914122757.GA29613@Chamillionaire.breakpoint.cc>
References: <20090912111928.GA8013@Chamillionaire.breakpoint.cc>
 <20090912195212.GF14984@kernel.dk>
 <20090912195839.GG14984@kernel.dk>
 <20090913091337.GA21969@Chamillionaire.breakpoint.cc>
 <20090913175717.GO14984@kernel.dk>
 <20090914090533.GU14984@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755403AbZINM2B@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090914090533.GU14984@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

* Jens Axboe | 2009-09-14 11:05:33 [+0200]:

>I think the safest option is to ensure that we just move these entries
>to our default bdi, which doesn't go away. This should fix the warning,
>can you test whether it works as well?
Yep, I don't see anything with this patch. Thanks.

Sebastian
