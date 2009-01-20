From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller
	v1.10.0: Introduction
Date: Tue, 20 Jan 2009 15:04:31 +0000
Message-ID: <20090120150431.GF9859@agk.fab.redhat.com>
References: <20090120.141022.193708059.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090120.141022.193708059.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

By the way, you'll notice I've combined the three messages into a single
patch: there seems little point applying the documentation as a separate
patch.

  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-add-ioband.patch

When sending revisions, either send a fresh patch that is a drop-in
replacement for what I have included, or alternatively send a patch to
be applied after what I have got.  (The second way helps people on the
list see what you are changing without needing to perform their own
diffs, and I'll simply fold it into the patch I have.)

Alasdair
-- 
agk@redhat.com
