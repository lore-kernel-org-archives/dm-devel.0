From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 0/3] sysfs representation of stacked devices
	(dm/md)
Date: Sat, 18 Feb 2006 19:53:47 +0000
Message-ID: <20060218195347.GU12169@agk.surrey.redhat.com>
References: <43F60F31.1030507@ce.jp.nec.com>
	<20060217194249.GO12169@agk.surrey.redhat.com>
	<43F6769C.5010505@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43F6769C.5010505@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Feb 17, 2006 at 08:21:32PM -0500, Jun'ichi Nomura wrote:
> Speaking about the efficiency, 'dmsetup ls --tree' works well.
> However, I haven't yet found a efficient way to implement
> 'dmsetup info --tree -o inverted dm-0', for example.
 
Indeed - but what needs this that doesn't also need to scan
everything?    mount?

Alasdair
-- 
agk@redhat.com
