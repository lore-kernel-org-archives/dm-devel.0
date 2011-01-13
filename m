From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] Documentation: dm-crypt: update cryptsetup homepage
Date: Thu, 13 Jan 2011 23:10:22 +0100
Message-ID: <4D2F784E.9080103@redhat.com>
References: <1294956113-6630-1-git-send-email-andrea.gelmini@gelma.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1294956113-6630-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-doc-owner@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-doc@vger.kernel.org, "Randy Dunlap (maintainer:DOCUMENTATION)" <rdunlap@xenotime.net>, "Thomas Weber (commit_signer:1/3=33%)" <weber@corscience.de>, "Mike Frysinger (commit_signer:1/3=33%)" <vapier.adi@gmail.com>, "Jiri Kosina (commit_signer:1/3=33%)" <jkosina@suse.cz>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, open list <linux-kernel@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 01/13/2011 11:01 PM, Andrea Gelmini wrote:
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  Documentation/device-mapper/dm-crypt.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
> index 59293ac..6b5c42d 100644
> --- a/Documentation/device-mapper/dm-crypt.txt
> +++ b/Documentation/device-mapper/dm-crypt.txt
> @@ -41,7 +41,7 @@ Example scripts
>  ===============
>  LUKS (Linux Unified Key Setup) is now the preferred way to set up disk
>  encryption with dm-crypt using the 'cryptsetup' utility, see
> -http://clemens.endorphin.org/cryptography
> +http://code.google.com/p/cryptsetup/

yes, that's the upstream page for cryptsetup/LUKS now, I will probably add some
page describing dm-crypt kernel target there too.

Acked-by: Milan Broz <mbroz@redhat.com>

Milan
