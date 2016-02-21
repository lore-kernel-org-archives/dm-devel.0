From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v5 0/3] init: add support to directly boot to a mapped
	device
Date: Sun, 21 Feb 2016 22:08:40 +0000
Message-ID: <20160221220839.GD16166@agk-dp.fab.redhat.com>
References: <1455992032-14594-1-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455992032-14594-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>, Shaohua Li <shli@kernel.org>, Dan Ehrenberg <dehrenberg@chromium.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Chen Yu <yu.c.chen@intel.com>, Vishnu Pratap Singh <vishnu.ps@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Will Drewry <wad@chromium.org>, David Zeuthen <zeuthen@google.com>
List-Id: dm-devel.ids

On Sat, Feb 20, 2016 at 10:13:49AM -0800, Kees Cook wrote:
> This is a resurrection of a patch series from a few years back, first
> brought to the dm maintainers in 2010. It creates a way to define dm
> devices on the kernel command line for systems that do not use an
> initramfs, or otherwise need a dm running before init starts.
> 
> This has been used by Chrome OS for several years, and now by Brillo
> (and likely Android soon).
> 
> The last version was v4:
> https://patchwork.kernel.org/patch/104860/
> https://patchwork.kernel.org/patch/104861/
 
Inconsistencies in the terminology here can be sorted out during review,
and I see that you've taken on board some of my review comments from
2010, but what are your responses to the rest of them?

Alasdair
