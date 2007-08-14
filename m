From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] [153/2many] MAINTAINERS - DEVICE-MAPPER (LVM)
Date: Tue, 14 Aug 2007 12:48:46 +0200
Message-ID: <46C1888E.4060501@redhat.com>
References: <46bff986.szARdClTcYqQa8So%joe@perches.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46bff986.szARdClTcYqQa8So%joe@perches.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: joe@perches.com
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
List-Id: dm-devel.ids

joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ea991f0..36a7d25 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1472,6 +1472,7 @@ P:	Alasdair Kergon
>  L:	dm-devel@redhat.com
>  W:	http://sources.redhat.com/dm
>  S:	Maintained
> +F:	drivers/md/dm*

File pattern should be:

F:	drivers/md/dm*
F:	drivers/md/kcopyd*
F:	include/linux/device-mapper.h
F:	include/linux/dm-ioctl.h
F:	Documentation/device-mapper/

--
mbroz@redhat.com
