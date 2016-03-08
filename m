From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath performance patches
Date: Tue, 8 Mar 2016 09:48:42 -0500
Message-ID: <20160308144842.GA13283@redhat.com>
References: <56DE81B5.80001@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56DE81B5.80001@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 08 2016 at  2:39am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> Hi Mike,
> 
> to picking up an old topic, what's the status of your performance
> patches for dm-multipath?
> 
> I've started looking a branch 'devel3', and was wondering if these
> are the latest patches available.
> Or would you have newer?

The 'devel3' was just a temporary branch I was using during
development.  I've since staged all the changes in linux-next via
linux-dm.git's 'for-next' branch:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next

If you could test this 'for-next' and report back I'd appreciate it.
It'd build my confidence in pushing these changes once the 4.6 merge
window opens.

That said, these changes have held up to Junichi's test suite.  WHich
I've now staged here (until I get around to porting them over to
device-mapper-test-suite): https://github.com/snitm/mptest

As for code review, please have a good look at this commit:
   b3c39bf1d dm mpath: convert from spinlock to RCU for most locking

If you find anything feel free to share an incremental fix and I'll get
it reviewed/staged.

(Junichi I'd welcome your review of all these request-based DM core and
multipath changes too)

Thanks,
Mike
