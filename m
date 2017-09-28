From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: Fix memory leak in crypt_ctr_cipher_old()
Date: Thu, 28 Sep 2017 12:22:37 -0400
Message-ID: <20170928162237.GA18989@redhat.com>
References: <20170927122857.19227-1-jeffy.chen@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170927122857.19227-1-jeffy.chen@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeffy Chen <jeffy.chen@rock-chips.com>
Cc: linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 27 2017 at  8:28am -0400,
Jeffy Chen <jeffy.chen@rock-chips.com> wrote:

> Fix memory leak of cipher_api.
> 
> Fixes: 33d2f09fcb35 (dm crypt: introduce new format of cipher with "capi:" prefix)
> Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>

Thanks, I've picked this up and it'll go upstream in my next pull
request for 4.14-rc
