From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] dm-userspace: use ring buffer instead
	of	system call
Date: Thu, 14 Dec 2006 19:36:15 +0900
Message-ID: <20061214193615W.fujita.tomonori@lab.ntt.co.jp>
References: <m3lklj2u81.fsf@guaranine.beaverton.ibm.com>
	<20061208095939I.fujita.tomonori@lab.ntt.co.jp>
	<m3y7pi1fhx.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m3y7pi1fhx.fsf@guaranine.beaverton.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Dan Smith <danms@us.ibm.com>
Subject: Re: [dm-devel] [PATCH 1/2] dm-userspace: use ring buffer instead	of	system call
Date: Fri, 08 Dec 2006 09:09:30 -0800

> FT> Of course I'm interested. Please post a patch. I still have some
> FT> other stuff that I want to do for dmu.
> 
> Patch included below.
> 
> I've also posted my full source tree so that you can see the library
> interface (tools/cowd/libdmu/dmu.{c,h}):
> 
>   http://static.danplanet.com/hg/dm-userspace.ring
> 
> I would really like to get some feedback about the library interface.

Thanks a lot. I'll do later. But before that, one non-technical
comment.


> diff --git a/include/linux/dm-userspace.h b/include/linux/dm-userspace.h
> new file mode 100644
> index 0000000..a4a6ea3
> --- /dev/null
> +++ b/include/linux/dm-userspace.h
> @@ -0,0 +1,134 @@
> +/*
> + * Copyright (C) International Business Machines Corp., 2006
> + * Author: Dan Smith <danms@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; under version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */

include/linux/dm-userspace.h is included by libdevmapper. So does it 
need to be released under LGPL, doesn't it?
