From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 1/3] init: Export name_to_dev_t and mark it const
Date: Wed, 18 Mar 2015 17:28:43 -0400
Message-ID: <20150318212842.GA17483@redhat.com>
References: <1423610451-22600-1-git-send-email-dehrenberg@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1423610451-22600-1-git-send-email-dehrenberg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Ehrenberg <dehrenberg@chromium.org>
Cc: viro@zeniv.linux.org.uk, agk@redhat.com, grundler@chromium.org, gwendal@chromium.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, ebiederm@xmission.com
List-Id: dm-devel.ids

On Tue, Feb 10 2015 at  6:20pm -0500,
Dan Ehrenberg <dehrenberg@chromium.org> wrote:

> name_to_dev_t is useful in other pieces of code to initialize rootfs.
> In the case of dm, the code is sometimes built in a module and other
> times used to construct the rootfs; therefore it must be exported
> as a symbol.
> 
> Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>

I'm going to pick these changes up and stage them in linux-dm.git's
'for-next' for Linux 4.1.

Al and/or others, if you have any objections to the simple
name_to_dev_t() changes in the first 2 patches of this set please
shout.

Thanks,
Mike
