From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: kpartx compile error
Date: Mon, 9 May 2005 18:27:21 +0100
Message-ID: <20050509172721.GG20004@agk.surrey.redhat.com>
References: <427E04CB.1040309@meteorete.homelinux.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <427E04CB.1040309@meteorete.homelinux.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sun, May 08, 2005 at 02:23:39PM +0200, Dott. Ing. Colombo Marco wrote:
> Hi... there is a compile error in kpartx of multipath tools with kernel
> 2.6.12-rc4

> /usr/include/linux/loop.h:88:2: #error "Wrong dev_t in loop.h"

See the architecture-specific patches in the Fedora SRPMs e.g.

  http://download.fedora.redhat.com/pub/fedora/linux/core/test/3.91/SRPMS/device-mapper-multipath-0.4.4-0.pre8.0.src.rpm

Alasdair
-- 
agk@redhat.com
