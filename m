From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-devel] dm-crypt error when CONFIG_CRYPTO_AUTHENC is disabled
Date: Mon, 23 Sep 2019 11:46:55 +0200
Message-ID: <f820c3e8-8538-ac95-9303-eeee77c903ee@gmail.com>
References: <20190920154434.GA923@gandi.net>
 <20190920173707.GA21143@redhat.com>
 <13e25b01-f344-ea1d-8f6c-9d0a60eb1e0f@gmail.com>
 <20190920212746.GA22061@redhat.com> <20190920214758.GA162854@gmail.com>
 <20190923082016.GA913@gandi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190923082016.GA913@gandi.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thibaut Sautereau <thibaut.sautereau@clip-os.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 23/09/2019 10:20, Thibaut Sautereau wrote:
> 
> On top of that, there's no hint in kernel logs about a particular
> algorithm, feature or Kconfig option that could be missing. Do we really
> expect people simply tuning their kernel configuration to go and read
> the source code to ensure they are not breaking their system?

AFAIK all standard Linux kernels in distros have these options enabled,
so it works out of the box.

So it is the opposite view - if you are setting your kernel options,
you need to dig much deeper...

I can perhaps add some hint to userspace if this is detectable from errno though.

Milan
