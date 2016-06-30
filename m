From: Ming Lin <mlin@kernel.org>
Subject: Re: NVMeoF multi-path setup
Date: Thu, 30 Jun 2016 15:19:08 -0700
Message-ID: <CAF1ivSa_JnTXLCVaLQ9v92KbUuvKRR8zPZsrc-7XL=5zZEMdhQ@mail.gmail.com>
References: <CAF1ivSbe+NboO+nbiWfEijHFJPd-AgNa=4AvWT24-HjH8A_izw@mail.gmail.com>
	<1467323858.15863.3.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467323858.15863.3.camel@ssi>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

On Thu, Jun 30, 2016 at 2:57 PM, Ming Lin <mlin@kernel.org> wrote:
>
> There are two problems:
>
> 1. there is no "/block/" in the path
>
> /sys/devices/virtual/nvme-fabrics/block/nvme0/nvme0n1

Typo, the path is:
/sys/devices/virtual/nvme-fabrics/ctl/nvme0/nvme0n1

>
> 2. nvme was blacklisted.
