From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v6 0/3] dm: boot a mapped device without
	an	initramfs
Date: Thu, 4 May 2017 13:14:52 +0100
Message-ID: <20170504121452.GF4943@agk-dp.fab.redhat.com>
References: <20170418164240.18079-1-enric.balletbo@collabora.com>
	<CAGXu5jLD+0POz1sopyZNNqDAiq2MZ5ZYdjs43jX5OnWxkZt1Lg@mail.gmail.com>
	<CAFqH_51YLoYrNcw+Fb99LbSY63wVWg+MW7nBYQqWjV6qfOAmNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAFqH_51YLoYrNcw+Fb99LbSY63wVWg+MW7nBYQqWjV6qfOAmNQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Enric Balletbo Serra <eballetbo@gmail.com>
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, David Zeuthen <zeuthen@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, Guenter Roeck <groeck@google.com>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, May 04, 2017 at 01:18:41PM +0200, Enric Balletbo Serra wrote:
> I'm wondering if a command line like this would be acceptable.

1) Make sure the implementation continues to support backslash quoting
so that any characters you introduce with special meanings (comma,
semi-colon, double-quote in that example) can still be used if required.

2) "none" is of course a valid uuid:)  More comma-separation or
re-ordering, perhaps?
 
3) Whatever final format is agreed here should be supported by dmsetup
as well, so you can both supply the format to dmsetup and ask dmsetup
to display your existing devices in this format.  Choose a format
that makes this easy.

Alasdair
