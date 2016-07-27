From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: What license is multipath-tools under
Date: Thu, 28 Jul 2016 00:19:47 +0200
Message-ID: <26bf809d-9e9e-b4ae-9110-a67819246907@gmail.com>
References: <1469616127.6204.9.camel@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469616127.6204.9.camel@debian.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: rrs@debian.org, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/27/2016 12:42 PM, Ritesh Raj Sarraf wrote:

> I just ran some compliance tools on multipath and the results weren't very
> appealing in regard to licensing and copyright information.
> 
> The standard COPYING file mentions LGPL v2.
> On the other hand, the majority of the source code has no license mentioned in
> its header. Some that do have, mention it as GPLv2, and some as GPLv2+

"No copyright" or "UNKNOWN" files should be covered by COPYING licence(LGPL v2).
Except:

kpartx/
It comes from partx(util-linux), and these files are under "GPL v2" or
"GPL v2 or later". Independent binary.


libmultipath/prioritizers/ontap.c
It's "GPL v2". But it's a plugin. ???


libmultipath/checkers/cciss_tur.c
Source says "GPL v2 or later", and:
/*
 *  This program originally derived from and inspired by
 *  Christophe Varoqui's tur.c, part of libchecker.
 */
At libmultipath/checkers/tur.c there is no licence, but it's derived from src/sg_turs.c
from sg3_utils. And this one is under "GPL v2 or later". But it's a plugin. ???


libmultipath/memory.c
libmultipath/memory.h
libmultipath/parser.c
libmultipath/parser.h
libmultipath/vector.c
libmultipath/vector.h
These comes from keepalived, and they are under "GPL v2 or later".


libmultipath/version.h:
"GPL v2 or later".


libmultipath/file.c
libmultipath/alias.c
Source says:
/*
 * significant parts of this file were taken from iscsi-bindings.c of the
 * linux-iscsi project.
And they are under "GPL v2 or later".


libmultipath/uevent.c
libmultipath/sysfs.c
These come from udev, and they are "GPL v2".


GPL code can not be mixed with LGPL code. So I guess libmultipath/ files are "GPL v2" ???


multipath/main.c
Under "GPL v2 or later". It's linked with libmultipath.so and libmpathcmd.so.
