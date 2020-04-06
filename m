From: Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RESEND PATCH 00/11] Integrity Policy Enforcement LSM (IPE)
Date: Mon, 6 Apr 2020 11:59:10 -0700
Message-ID: <20200406185910.GA77950@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20200406181045.1024164-1-deven.desai@linux.microsoft.com>
 <CAG48ez3JV-tzjRLdcys6Fz9LKYaB1h-1GaeAzkUYtY1RgxsB6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez3JV-tzjRLdcys6Fz9LKYaB1h-1GaeAzkUYtY1RgxsB6g@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: agk@redhat.com, Jens Axboe <axboe@kernel.dk>, snitzer@redhat.com, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, tyhicks@linux.microsoft.com, Pavel Tatashin <pasha.tatashin@soleen.com>, Sasha Levin <sashal@kernel.org>, jaskarankhurana@linux.microsoft.com, nramas@linux.microsoft.com, mdsakib@linux.microsoft.com
List-Id: dm-devel.ids

On Mon, Apr 06, 2020 at 08:50:46PM +0200, Jann Horn wrote:
> On Mon, Apr 6, 2020 at 8:10 PM <deven.desai@linux.microsoft.com> wrote:
> > Overview:
> > ------------------------------------
> > IPE is a Linux Security Module, which allows for a configurable
> > policy to enforce integrity requirements on the whole system. It
> > attempts to solve the issue of Code Integrity: that any code being
> > executed (or files being read), are identical to the version that
> > was built by a trusted source.
> 
> Where's patch 02/11? lore at
> https://lore.kernel.org/linux-security-module/20200406183619.GA77626@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net/T/#t
> has everything other than that patch.

It looks like it's over majordomo's character limit by 7489 characters.
I'll have to repost with this patch broken up. Apologies.

- Deven
