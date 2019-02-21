From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-switch: use struct_size() in kzalloc()
Date: Thu, 21 Feb 2019 10:40:47 -0500
Message-ID: <20190221154047.GB2906@redhat.com>
References: <20190108160233.GA20222@embeddedor>
 <a4f967fe-f9c2-88d9-868e-a9c176df04d1@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a4f967fe-f9c2-88d9-868e-a9c176df04d1@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Feb 21 2019 at 10:27am -0500,
Gustavo A. R. Silva <gustavo@embeddedor.com> wrote:

> Hi all,
> 
> Friendly ping:
> 
> Who can take this?

I've picked it up for 5.1:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.1&id=042f96ad4c5a369307df2a840fd943a4b080c3d1

Thanks,
Mike
