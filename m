From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-integrity: correctly calculate the size of
	metadata area
Date: Tue, 7 May 2019 14:49:34 -0400
Message-ID: <20190507184934.GA24320@redhat.com>
References: <alpine.LRH.2.02.1905071358500.26614@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1905071358500.26614@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Tue, May 07 2019 at  2:28pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> When we use separate devices for data and metadata, dm-integrity would
> incorrectly calculate the size of the metadata device as if it had
> 512-byte block size - and it would refuse activation with larger block
> size and smaller metadata device.
> 
> This patch fixes it so that it takes actual block size into account.
> 
> It fixes https://gitlab.com/cryptsetup/cryptsetup/issues/450
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org	# v4.19+
> Fixes: 356d9d52e122 ("dm integrity: allow separate metadata device")

Applied, and I rebased your bitmap patches ontop of it.
