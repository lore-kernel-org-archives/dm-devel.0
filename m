From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-bufio: avoid a possible __vmalloc deadlock
Date: Mon, 8 Apr 2013 11:00:06 +0100
Message-ID: <20130408100006.GB21248@debian>
References: <Pine.LNX.4.64.1304051547370.18568@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304051547370.18568@file.rdu.redhat.com>
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
Cc: Mike <mikeandmore@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Apr 05, 2013 at 03:57:50PM -0400, Mikulas Patocka wrote:
> Hi
> 
> This patch avoids a possible deadlock in dm-bufio. (it could happen only 
> with large block size, at most PAGE_SIZE << MAX_ORDER (typically 8MiB).

Does anything currently use such large block sizes? (dm-thin and
dm-cache stick to 4k blocks).

- Joe
