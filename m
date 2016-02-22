From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v5 0/3] init: add support to directly boot to a mapped device
Date: Mon, 22 Feb 2016 10:55:11 -0800
Message-ID: <CAGXu5jJ9nUdE8u8a3EYR5uS_zOLEkmQn3M0Nsm9bkxBmMxpC9Q@mail.gmail.com>
References: <1455992032-14594-1-git-send-email-keescook@chromium.org>
	<20160221220839.GD16166@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160221220839.GD16166@agk-dp.fab.redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>, Shaohua Li <shli@kernel.org>, Dan Ehrenberg <dehrenberg@chromium.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Chen Yu <yu.c.chen@intel.com>, Vishnu Pratap Singh <vishnu.ps@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, Will Drewry <wad@chromium.org>, David Zeuthen <zeuthen@google.com>
List-Id: dm-devel.ids

On Sun, Feb 21, 2016 at 2:08 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Sat, Feb 20, 2016 at 10:13:49AM -0800, Kees Cook wrote:
>> This is a resurrection of a patch series from a few years back, first
>> brought to the dm maintainers in 2010. It creates a way to define dm
>> devices on the kernel command line for systems that do not use an
>> initramfs, or otherwise need a dm running before init starts.
>>
>> This has been used by Chrome OS for several years, and now by Brillo
>> (and likely Android soon).
>>
>> The last version was v4:
>> https://patchwork.kernel.org/patch/104860/
>> https://patchwork.kernel.org/patch/104861/
>
> Inconsistencies in the terminology here can be sorted out during review,
> and I see that you've taken on board some of my review comments from
> 2010, but what are your responses to the rest of them?

Ah, sorry, the threads I could find were incomplete, so I wasn't able
to find those comments that were made to Will's 2010 submission. In
some of the cleanups I did I was very confused about "target" vs
"table", and tried to fix that. Regardless, I'm open to fixing
whatever is needed. :)

Thanks for looking at this again!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
