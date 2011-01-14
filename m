From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824
 bd_link_disk_holder+0x92/0x1ac()
Date: Fri, 14 Jan 2011 12:59:42 -0500
Message-ID: <20110114175942.GK31800@thunk.org>
References: <20110113132637.GH16523@nb.net.home>
 <20110113133722.GG30719@htj.dyndns.org>
 <4D2F04FF.1070309@redhat.com>
 <20110113141107.GI30719@htj.dyndns.org>
 <4D2F0B6A.6010201@redhat.com>
 <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
 <656A2F9B-4E1C-44AA-80CB-9E3428E26CDE@mit.edu>
 <20110114071858.7eee145c@notabene.brown>
 <20110113204145.GC31800@thunk.org>
 <20110114162022.GC978@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110114162022.GC978@htj.dyndns.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: NeilBrown <neilb@suse.de>, Milan Broz <mbroz@redhat.com>, Karel Zak <kzak@redhat.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

On Fri, Jan 14, 2011 at 05:20:22PM +0100, Tejun Heo wrote:
> 
> Hmmm... that's already possible with the existing holders symlinks,
> right?  As Kay said in another message, I don't think we can do
> anything about the symlinks at this point.  It already has userland
> users, so we'll have to maintain them and there's no reason to create
> something else for the same functionality.

Yes, agreed.  My point was that if we have a better system, we could
migrate blkid and other users to new interface, and maybe in a few
years, we can deprecate that interface.  So we do have to maintain
them for at least the medium term, but that shouldn't stop us from
divising a better interface, and then gradually migrating systems to
use that newer and better interface.

						- Ted
