From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Fw: dm-mirror/kmirrord oops
Date: Wed, 29 Jun 2005 23:32:33 +0100
Message-ID: <20050629223233.GD27078@agk.surrey.redhat.com>
References: <20050627004827.12a389e0.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050627004827.12a389e0.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Cyril Chaboisseau <cyril.chaboisseau@free.fr>
Cc: Andrew Morton <akpm@osdl.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jun 27, 2005 at 12:48:27AM -0700, Andrew Morton wrote:
> Unable to handle kernel paging request at ffffc2000015c128 RIP: 
> <ffffffff802964a8>{core_in_sync+8}

Do the following patches help?

  ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/00011.patch
  ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/00012.patch
  ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/00013.patch

[12 and 13 are already included in -mm; Jon Brassow is working on a cleaner fix]

Alasdair
-- 
agk@redhat.com
