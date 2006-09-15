From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: RE: [Bugme-new] [Bug 7158] New: Out of memory happen
	insnapshot
Date: Fri, 15 Sep 2006 21:09:38 +0100
Message-ID: <20060915200938.GT13859@agk.surrey.redhat.com>
References: <200609150325.k8F3Petg003696@mail.thecus.com>
	<200609150656.k8F6ulbs006442@mail.thecus.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200609150656.k8F6ulbs006442@mail.thecus.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kevin Cheng <kevin_cheng@thecus.com>
Cc: 'Andrew Morton' <akpm@osdl.org>, 'device-mapper development' <dm-devel@redhat.com>, "'bugme-daemon@kernel-bugs.osdl.org'" <bugme-daemon@bugzilla.kernel.org>
List-Id: dm-devel.ids

I notice that the 'dmsetup table' output does not correspond to the information
you gave at the beginning of the bug.  (Different volume sizes - 16.5GB not
22GB - and different chunk size - 64KB not 8KB.)

Does that 'dmsetup status' output correspond to the time the system reached OOM
and tie in with the slabinfo you provided?

If not, please can you try to get fresh data from the time of the failure?
(both slabinfo and 'dmsetup status' taken at approximately the same time when
the system is in (or close to) OOM; it's OK to take 'dmsetup info' and 'dmsetup
table' earlier in the test as they won't change during it)

Alasdair
-- 
agk@redhat.com
