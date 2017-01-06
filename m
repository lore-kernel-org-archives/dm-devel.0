From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: drivers/md/dm-mpath.c:478: suspicious code ?
Date: Fri, 6 Jan 2017 15:08:55 -0500
Message-ID: <20170106200855.GA15627@redhat.com>
References: <VI1PR08MB10227DFB2600B24201D3209D9C630@VI1PR08MB1022.eurprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <VI1PR08MB10227DFB2600B24201D3209D9C630@VI1PR08MB1022.eurprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Binderman <dcb314@hotmail.com>
Cc: "agk@redhat.com" <agk@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "shli@kernel.org" <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Fri, Jan 06 2017 at 12:52pm -0500,
David Binderman <dcb314@hotmail.com> wrote:

> Hello there,
> 
> drivers/md/dm-mpath.c:478:19: warning: decrement of a boolean expression [-Wbool-operation]
> 
> Source code is
> 
>    } while (bypassed--);
> 
> Suggest code rework. Maybe a boolean / int type mixup ?

Yeah, should be cleaned up.

Thanks for reporting this.
