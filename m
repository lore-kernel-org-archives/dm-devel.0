From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: [PATCH] fix segfault when lvm.conf is truncated.
Date: Tue, 05 Feb 2013 09:24:42 +0100
Message-ID: <5110C1CA.1020002@gmail.com>
References: <1359537319-14106-1-git-send-email-dmzhang@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1359537319-14106-1-git-send-email-dmzhang@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: dongmao zhang <dmzhang@suse.com>
List-Id: dm-devel.ids

Dne 30.1.2013 10:15, dongmao zhang napsal(a):
> When /etc/lvm/lvm.conf is truncated at the first '"' of a line, all LVM
> utilities crash with a segfault.
>
> The segfault only seems to occur if the last character is the first '"'
> (double quote) of a line. If you truncate it at any other point, lvm detects the
> error and report parse error
>
> lvm.conf ends like this.
>
> root#hexdump -C lvm.conf|tail
> 00000220  69 72 20 3d 20 22 2f 64  65 76 22 0a 0a 0a 20 20  |ir = "/dev"...  |
> 00000230  20 20 23 20 41 6e 20 61  72 72 61 79 20 6f 66 20  |  # An array of |
> 00000240  64 69 72 65 63 74 6f 72  69 65 73 20 74 68 61 74  |directories that|
> 00000250  20 63 6f 6e 74 61 69 6e  20 74 68 65 20 64 65 76  | contain the dev|
> 00000260  69 63 65 20 6e 6f 64 65  73 20 79 6f 75 20 77 69  |ice nodes you wi|
> 00000270  73 68 0a 20 20 20 20 23  20 74 6f 20 75 73 65 20  |sh.    # to use |
> 00000280  77 69 74 68 20 4c 56 4d  32 2e 0a 20 20 20 20 73  |with LVM2..  s|
> 00000290  63 61 6e 20 3d 20 5b 20  22 2f 78 22 2c 0a 20 20  |can = [ "/x",.  |
> 000002a0  20 20 20 20 20 20 20 20  20 20 20 22              | "|
>
> The fix is check p->tb and p->te in function _dup_tok. If in
> this situation, the len would be less than zero.
>
> Signed-off-by: dongmao zhang <dmzhang@suse.com>
> ---
>   libdm/libdm-config.c |    7 ++++++-
>   1 files changed, 6 insertions(+), 1 deletions(-)

Thanks for report.
Updated version committed upstream:

https://www.redhat.com/archives/lvm-devel/2013-February/msg00014.html

Zdenek
