From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH RFC] dm snapshot: shared exception store
Date: Fri, 15 Aug 2008 17:17:35 +0900
Message-ID: <20080815171801N.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.64.0808111740520.14722@hs20-bc2-1.build.redhat.com>
	<20080812083440U.fujita.tomonori@lab.ntt.co.jp>
	<200808131714.09311.phillips@phunq.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200808131714.09311.phillips@phunq.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: phillips@phunq.net, dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Wed, 13 Aug 2008 17:14:08 -0700
Daniel Phillips <phillips@phunq.net> wrote:

> requests.  I could take care of designing and implementing a kernel
> interface between your port and the rest of ddsnapd that does such
> things as respond to control messages and generate block delta
> lists.

As I said at the first submission, I plan to add such features to the
new dm-snapshot code. Then we can have simple user-space code that
focus on the replication. A daemon program requests delta from the
kernel, and sends it to another daemon program on the remote
server. The daemon on the remote server asks the kernel to apply
delta.

The advantage of this approach, the above replication program can work
with any snapshot implementation, which could live in dm or file
systems like btrfs. File systems could implement the snapshot features
more efficiently than dm.

My question related with this issue is, any chance to modify
Zumastor's ddsnapd in a such way. Well, I guess, it would be better to
ask on Zumastor mailing list.
