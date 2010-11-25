From: Milan Broz <mbroz@redhat.com>
Subject: Re: data corruption with stex (Promise HW-Raid) driver and device-mapper
Date: Thu, 25 Nov 2010 10:57:04 +0100
Message-ID: <4CEE32F0.4030302@redhat.com>
References: <85ABFDC4641C4847BA6088F2982EFD8F049D4273@nonamew.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <85ABFDC4641C4847BA6088F2982EFD8F049D4273@nonamew.ptu.promise.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ed Lin - PTU <ed.lin@promise.com>
Cc: Dan Carpenter <error27@gmail.com>, Markus Schulz <msc@antzsystem.de>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 11/16/2010 02:35 AM, Ed Lin - PTU wrote:
> The stex driver sets sg_tablesize as 32 (for st_yel it's 38) in the probe
> entry. It seems that this value was overridden by the system if using
> dm/lvm, for unknown reason. The driver received requests with more
> sg items than registered. Sg item number could be as high as 64. This
> is completely unexpected. The firmware could not handle such
> requests, and error occurred.

Device-mapper respects hw restrictions, so it must be bug somewhere.

Please cc dm-devel if you think that problem is there.

Milan
