From: Martin Wilck <mwilck@suse.com>
Subject: Re: [lvm-devel] master - multipathd: fix fd leak when
 iscsi device logs in
Date: Mon, 13 Jul 2020 12:27:43 +0200
Message-ID: <b572a8bbf63b1bde9a2ec53cb909468cfc61cbaf.camel@suse.com>
References: <6eb10725-456f-de68-e927-1f5a9771c16c@huawei.com>
	<86d8307c-1747-2254-4f87-fac36f0d51ca@redhat.com>
	<0d26c9f6-4379-f201-a9a5-839bddef3f25@huawei.com>
	<92db2c49d0ddbbc385c6a14ef3d99a54457b908e.camel@suse.com>
	<b482dfdb-a40b-e523-1dcc-d37ddc4fc399@redhat.com>
	<fa7df2b4c81f9420f12c1e8a5d74b8c42cf45543.camel@suse.com>
	<f1284ab7-8897-805c-d62e-f6cadb6158ca@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f1284ab7-8897-805c-d62e-f6cadb6158ca@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, lixiaokeng <lixiaokeng@huawei.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 2020-07-13 at 12:13 +0200, Zdenek Kabelac wrote:
> Dne 13. 07. 20 v 12:08 Martin Wilck napsal(a):
> > 
> > Ben has already added support for dm_hold_control_dev() in
> > libmultipath
> > (e24d8b1 ("libmutipath: don't close fd on dm_lib_release")). But
> > this
> > doesn't protect us from calling _open_control() simultaneously in
> > separate code paths, as Lixiaokeng has pointed out.
> > 
> > I don't see how it would, as dm_hold_control_dev() also just
> > changes
> > a static variable.
> 
> Here I'm not familiar with  multipath codebase (more a question for
> Ben 
> likely), but is 'dm_hold...()' being used in non-threaded way - i.e.
> in 
> dmeventd these functions are called  before/after threads are
> finished - so 
> there would be no way 2 threads may call this function in parallel ?

Yes, it's called via pthread_once().

@Lixiaokeng, that would suggest a simpler solution to your fd leak
problem than what I posted before. You'd just need to apply Ben's patch
"libmutipath: don't close fd on dm_lib_release" submitted March
24th.

Contrary to what I said before, this patch is NOT merged yet. The commit id e24d8b1 was from my "upstream-queue" branch only 
(https://github.com/openSUSE/multipath-tools/tree/upstream-queue)

Could you try with that patch (and without mine sent previously)?

Martin
