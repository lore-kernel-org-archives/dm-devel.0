From: Karel Zak <kzak@redhat.com>
Subject: Re: [patch 2/2] util-linux: resizepart: Utility to
	resize a partition
Date: Mon, 13 Aug 2012 22:20:32 +0200
Message-ID: <20120813202032.GA20252@x2.net.home>
References: <20120709213418.799759100@redhat.com>
	<20120709213559.918409313@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120709213559.918409313@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: axboe@kernel.dk, util-linux@vger.kernel.org, psusi@ubuntu.com, linux-kernel@vger.kernel.org, maxim.patlasov@gmail.com, dm-devel@redhat.com, vgoyal@redhat.comi
List-Id: dm-devel.ids

On Mon, Jul 09, 2012 at 05:34:20PM -0400, vgoyal@redhat.com wrote:
> A simple user space utility to resize an existing partition. It tries to read
> the start of partiton from sysfs.

Applied with some changes -- will be in the next release util-linux 2.22-rc2

Thanks!

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
