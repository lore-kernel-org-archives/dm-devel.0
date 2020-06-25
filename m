From: Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>
Subject: Re: [RFC] Reed-Solomon Code: Update no_eras to the actual number of
 errors
Date: Thu, 25 Jun 2020 16:15:17 +0300
Message-ID: <20200625131517.GD1036@mail-personal>
References: <20200625041141.8053-1-aiden.leong@aibsd.com>
 <202006242231.E17DAB2@keescook>
 <5f4008d5-1ddd-443e-9190-a8565746698d.aiden.leong@aibsd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5f4008d5-1ddd-443e-9190-a8565746698d.aiden.leong@aibsd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aiden Leong <aiden.leong@aibsd.com>
Cc: Kees Cook <keescook@chromium.org>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Thomas Gleixner <tglx@linutronix.de>, YueHaibing <yuehaibing@huawei.com>, dm-devel <dm-devel@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-Id: dm-devel.ids

Hi, 

On 2020-06-25 14:46:11, Aiden Leong wrote:
>
>BTW: I do believe these functions should be split into a function family. It's really hard to call them correctly and hard to debug as well.

I don't think the functions should be split up. Most probably it is the
documentation that should be improved :) But, I do agree that it is not
that easy to call the functions correctly.

Best,
Ferdinand

-- 
Ferdinand Blomqvist
ferdinand.blomqvist[at]gmail.com
GPG key: 9EFB 7A2C 0432 4EC5 32BA FA61 CFE9 4164 93E8 B9E4
