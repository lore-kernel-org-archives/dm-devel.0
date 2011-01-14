From: Tejun Heo <tj@kernel.org>
Subject: Re: linux-next - WARNING: at fs/block_dev.c:824
	bd_link_disk_holder+0x92/0x1ac()
Date: Fri, 14 Jan 2011 19:23:40 +0100
Message-ID: <AANLkTinj49yFOhomPuAO-X5GU6wM0yi4jDZyer63RnjJ__11555.6497978561$1295029534$gmane$org@mail.gmail.com>
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
	<20110114175942.GK31800@thunk.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110114175942.GK31800@thunk.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, NeilBrown <neilb@suse.de>, Milan Broz <mbroz@redhat.com>, Karel Zak <kzak@redhat.com>, device-mapper
List-Id: dm-devel.ids

Hello, Ted.

On Fri, Jan 14, 2011 at 6:59 PM, Ted Ts'o <tytso@mit.edu> wrote:
> Yes, agreed. =A0My point was that if we have a better system, we could
> migrate blkid and other users to new interface, and maybe in a few
> years, we can deprecate that interface. =A0So we do have to maintain
> them for at least the medium term, but that shouldn't stop us from
> divising a better interface, and then gradually migrating systems to
> use that newer and better interface.

Oh yeah, fully agreed there and the implementation at the block layer
isn't even gonna be difficult.  Just a single attribute which contains
a string which can be specified at the time of claiming.  We probably
can introduce a new interface where the @holder is always a string the
content of which should uniquely identify the holder in human/machine
readable form and add a few helpers to format those strings so that
the same type of usages use consistently formatted strings.  For
nested devices, kdev should do.  For filesystems, the mount point
maybe (it should be something which identifies it absolutely)?  For
specific programs (cd burner, whatnot), pid and so on.

The only question is, would that be actually necessary?  By now, we
already have mostly working reverse mapping for most things which
matter through blkid, fs information, fd listing under proc and so on.
 They sure are ugly and probably unreliable at times but is it
pressing enough to introduce new interface and migrate things over or
would we be just creating churns?  I don't really know how these
things look from userland so am genuinely unsure what the answer is.

Thanks.

-- =

tejun
