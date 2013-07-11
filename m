From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [git pull] device-mapper changes for 3.11
Date: Thu, 11 Jul 2013 14:55:22 +0100
Message-ID: <20130711135522.GN8530@agk-dp.fab.redhat.com>
References: <20130711013448.GD32399@agk-dp.fab.redhat.com> <20130711162040.8a82cb97a6c647c4f61f919b@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130711162040.8a82cb97a6c647c4f61f919b@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alasdair G Kergon <agk@redhat.com>, Yann Droneaud <ydroneaud@opteya.com>, Mike Snitzer <snitzer@redhat.com>, Robin Dong <sanbai@taobao.com>, linux-kernel@vger.kernel.org, Jim Ramsay <jim_ramsay@dell.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Rob Herring <robherring2@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Milan Broz <gmazyland@gmail.com>, Guenter Roeck <linux@roeck-us.net>
List-Id: dm-devel.ids

On Thu, Jul 11, 2013 at 04:20:40PM +1000, Stephen Rothwell wrote:
> Alistair, is there some reason that you cannot maintain some relatively
> stable git tree for me to fetch (instead of the quilt series).  

Well Mike Snitzer is becoming a joint maintainer and this also requires
changes to the workflow so watch this space.

> Also,
> there is not real reason to keep rebasing this stuff (especially just
> before sending it to Linus).
 
Most of the time the patches are decoupled from the rest of the tree
and the final linux-next kernel is the same regardless of where the
quilt tree is attached.  I maintain a single sequence of patches 
where the ones ready for upstream float up to the top and the
linux-next export is a by-product and not the primary output.

Anyway, like I say, we'll be changing things during the next couple of
cycles and we'll bear your suggestions in mind.

Alasdair
