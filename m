From: Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.36-rc7
Date: Thu, 07 Oct 2010 21:28:07 +0200
Message-ID: <4CAE1F47.3050105@kernel.org>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, just.for.lkml@googlemail.com, herbert@gondor.hengli.com.au, hch@infradead.org, neilb@suse.de, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello, Linus.

On 10/06/2010 11:45 PM, Linus Torvalds wrote:
> So I decided to break my a-week-is-eight-days rut, and actually
> release -rc7 after a proper seven-day week instead. Wo-oo!
> 
> And yes, that's probably as exciting as it gets, which is just fine by
> me. This should be the last -rc, I'm not seeing any reason to keep
> delaying a real release. There was still more changes to
> drivers/gpu/drm than I really would have hoped for, but they all look
> harmless and good. Famous last words.

I'm afraid there is a possibly workqueue related deadlock under high
memory pressure.  It happens on dm-crypt + md raid1 configuration.
I'm not yet sure whether this is caused by workqueue failing to kick
rescuers under memory pressure or the shared workqueue is making an
already existing problem more visible and in the process of setting up
an environment to reproduce the problem.

 http://thread.gmane.org/gmane.comp.file-systems.xfs.general/34922/focus=1044784

Thanks.

-- 
tejun
