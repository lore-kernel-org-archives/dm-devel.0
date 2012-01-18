From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: parted issue/question
Date: Wed, 18 Jan 2012 00:38:02 +0000
Message-ID: <20120118003802.GA11769@agk-dp.fab.redhat.com>
References: <4F13ADB3.5070806@redhat.com> <87lip6t157.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87lip6t157.fsf@rho.meyering.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jim Meyering <jim@meyering.net>, Joey Boggs <jboggs@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Try
  blkdev --flushbufs
after any cmd that writes to a dev to see if that makes any difference.

Alasdair
