From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] dm-snapshot: poor copy-on-write performance due to I/O reordering
Date: Wed, 17 Sep 2008 17:47:50 +0200
Message-ID: <E1KfzFv-00041e-8A@be1.7eggert.dyndns.org>
References: <bd0gX-4ma-13@gated-at.bofh.it>
Reply-To: 7eggert@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754744AbYIQPjR@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kazuo Ito <ito.kazuo@oss.ntt.co.jp>, dm-devel@redhat.com, jblunck@suse.de, kjamieson@bycast.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Kazuo Ito <ito.kazuo@oss.ntt.co.jp> wrote:

> Write throughput to LVM snapshot origin volume is an order
> of magnitude slower than those to LV without snapshots or
> snapshot target volumes, especially in the case of sequential
> writes with O_SYNC on.
> 
> The following patch originally written by Kevin Jamieson and
> Jan Blunck and slightly modified for the current RCs by myself
> tries to improve the performance by modifying the behaviour
> of kcopyd, so that it pushes back an I/O job to the head of
> the job queue instead of the tail as process_jobs() currently
> does when it has to wait for free pages. This way, write
> requests aren't shuffled to cause extra seeks.

Did you check for starvation problems, too?
